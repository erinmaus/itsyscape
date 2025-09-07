--------------------------------------------------------------------------------
-- Resources/Game/Props/EndlessWater/View.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Vector = require "ItsyScape.Common.Math.Vector"
local Quaternion = require "ItsyScape.Common.Math.Quaternion"
local Transform = require "ItsyScape.Common.Math.Transform"
local Color = require "ItsyScape.Graphics.Color"
local DecorationMaterial = require "ItsyScape.Graphics.DecorationMaterial"
local PostProcessPass = require "ItsyScape.Graphics.PostProcessPass"
local PropView = require "ItsyScape.Graphics.PropView"
local Renderer = require "ItsyScape.Graphics.Renderer"
local Resource = require "ItsyScape.Graphics.Resource"
local SceneNode = require "ItsyScape.Graphics.SceneNode"
local ShaderResource = require "ItsyScape.Graphics.ShaderResource"
local StaticMeshResource = require "ItsyScape.Graphics.StaticMeshResource"
local TextureResource = require "ItsyScape.Graphics.TextureResource"
local ThirdPersonCamera = require "ItsyScape.Graphics.ThirdPersonCamera"
local WaterMeshSceneNode = require "ItsyScape.Graphics.WaterMeshSceneNode"
local WaterMesh = require "ItsyScape.World.WaterMesh"

local EndlessWater = Class(PropView)

-- Size of map sector, in terms of unit (1 unit = cell size)
EndlessWater.SIZE = 64
EndlessWater.CELL_SIZE = 2

-- Width and height of the water in the negative and positive dimensions.
-- Basically goes from -W .. +W, and -H .. +H.
EndlessWater.WIDTH  = 1
EndlessWater.HEIGHT = 1

EndlessWater.CANVAS_CELL_SIZE = 8
EndlessWater.CANVAS_WIDTH = 128
EndlessWater.CANVAS_HEIGHT = 128
EndlessWater.MASK_SIZE_OFFSET = 8

EndlessWater.WHIRLPOOL_PROPS = {
	["scape_WhirlpoolCenter"] = "center",
	["scape_WhirlpoolRadius"] = "radius",
	["scape_WhirlpoolHoleRadius"] = "holeRadius",
	["scape_WhirlpoolRings"] = "rings",
	["scape_WhirlpoolRotationSpeed"] = "rotationSpeed",
	["scape_WhirlpoolHoleSpeed"] = "holeSpeed"
}

EndlessWater.PASS_ID = 1

EndlessWater.EXTENDED_MATERIAL = DecorationMaterial({
	shader = "Resources/Shaders/WhirlpoolWater",

	uniforms = {
		scape_TextureScale = { "float", 4, 4 }
	}
})

function EndlessWater:new(prop, gameView)
	PropView.new(self, prop, gameView)

	self.shaderCache = PostProcessPass(gameView:getRenderer(), 0)
	self.shaderCache:load(gameView:getResourceManager())
	self.waterShader = self.shaderCache:loadPostProcessShader("BumpWater")
	self.shipShader = self.shaderCache:loadPostProcessShader("BumpShip")

	self.masks = {}
	self.maskBounds = {}
	self.shadows = {}
end

function EndlessWater:load()
	PropView.load(self)

	local resources = self:getResources()

	self.waterParent = SceneNode()
	self.waterParent:setParent(self:getRoot())

	resources:queue(
		TextureResource,
		"Resources/Game/Water/LightFoamyWater1/Texture.png",
		function(texture)
			self.texture = texture
		end)

	local waterMaterial
	resources:queueEvent(function()
		waterMaterial = DecorationMaterial(Resource.readLua("Resources/Game/Water/LightFoamyWater1/Material.lua")):replace(self.EXTENDED_MATERIAL)
	end)

	self.waters = {}
	for i = -EndlessWater.WIDTH, EndlessWater.WIDTH do
		for j = -EndlessWater.HEIGHT, EndlessWater.HEIGHT do
			local water = WaterMeshSceneNode()

			local translation = Vector(
				(i * EndlessWater.SIZE) * EndlessWater.CELL_SIZE,
				0,
				(j * EndlessWater.SIZE) * EndlessWater.CELL_SIZE)
			water:getTransform():setLocalTranslation(translation)

			water:getMaterial():setOutlineThreshold(-1.0)
			water:getMaterial():setShader(EndlessWater.SHADER)
			water:setParent(self.waterParent)

			table.insert(self.waters, water)
		end
	end

	resources:queueEvent(function()
		self.waterMesh = WaterMesh(EndlessWater.SIZE * EndlessWater.CELL_SIZE, EndlessWater.SIZE * EndlessWater.CELL_SIZE, 8)

		for _, water in ipairs(self.waters) do
			water:setMesh(self.waterMesh)
			waterMaterial:apply(water, self:getResources())
		end
	end)
	
	local width = EndlessWater.WIDTH * EndlessWater.CELL_SIZE + 1
	width = width * EndlessWater.SIZE * EndlessWater.CELL_SIZE * self.CANVAS_CELL_SIZE
	width = math.floor(width)

	local height = EndlessWater.HEIGHT * EndlessWater.CELL_SIZE + 1
	height = height * EndlessWater.SIZE * EndlessWater.CELL_SIZE * self.CANVAS_CELL_SIZE
	height = math.floor(height)

	self.shipCanvas = love.graphics.newCanvas(width, height)
	self.shipCanvas:setFilter("linear", "linear")

	self.bumpCanvas = love.graphics.newCanvas(width, height, { format = "rgba16f" })
	self.bumpCanvas:setFilter("linear", "linear")
end

function EndlessWater:tick()
	PropView.tick(self)

	local state = self:getProp():getState()
	local _, layer = self:getProp():getPosition()
	local windDirection, windSpeed, windPattern = self:getGameView():getWind(layer)

	local waterRimColor

	local currentSkyProperties, previousSkyProperties = self:getGameView():getSkyProperties(layer)
	if not (currentSkyProperties and previousSkyProperties) then
		waterRimColor = Color(1, 1, 1, 1)
	else
		local previousAmbientColor = Color(unpack(previousSkyProperties.currentAmbientColor or { 1, 1, 1 }, 1, 3))
		local currentAmbientColor = Color(unpack(currentSkyProperties.currentAmbientColor or { 1, 1, 1 }, 1, 3))

		waterRimColor = previousAmbientColor:lerp(currentAmbientColor, _APP:getPreviousFrameDelta())
	end

	self.previousTime = self.currentTime
	self.currentTime = state.time or 0

	for _, water in ipairs(self.waters) do
		local material = water:getMaterial()

		if state.whirlpool and state.whirlpool.hasWhirlpool then
			for k, v in pairs(EndlessWater.WHIRLPOOL_PROPS) do
				local prop = state.whirlpool[v]
				if prop and shader:hasUniform(k) then
					material:send(material.UNIFORM_FLOAT, k, prop)
				end
			end

			material:send(material.UNIFORM_FLOAT, "scape_WhirlpoolAlpha", 1.0)
		else
			material:send(material.UNIFORM_FLOAT, "scape_WhirlpoolAlpha", 0.0)
		end

		if state.ocean and state.ocean.hasOcean then
			water:setYOffset(state.ocean.offset)
			water:setPositionTimeScale(state.ocean.positionTimeScale)
			water:setTextureTimeScale(unpack(state.ocean.textureTimeScale))
		end

		material:send(material.UNIFORM_FLOAT, "scape_SkyColor", waterRimColor:get())
		material:send(material.UNIFORM_FLOAT, "scape_BumpForce", 0)
		material:send(material.UNIFORM_FLOAT, "scape_WindDirection", windDirection:get())
		material:send(material.UNIFORM_FLOAT, "scape_WindSpeed", windSpeed)
		material:send(material.UNIFORM_FLOAT, "scape_WindPattern", windPattern:get())
		material:send(material.UNIFORM_FLOAT, "scape_WindMaxDistance", state.ocean.offset)
		material:send(material.UNIFORM_FLOAT, "scape_WindSpeedMultiplier", state.ocean.windSpeedMultiplier)
		material:send(material.UNIFORM_FLOAT, "scape_WindPatternMultiplier", state.ocean.windPatternMultiplier)
		material:send(material.UNIFORM_FLOAT, "scape_Time", math.lerp(self.previousTime or self.currentTime or 0, self.currentTime or 0, _APP:getPreviousFrameDelta()))

		material:send(material.UNIFORM_TEXTURE, "scape_BumpTexture", self.bumpCanvas)
		material:send(material.UNIFORM_TEXTURE, "scape_MaskTexture", self.shipCanvas)
	end
end

function EndlessWater:updateShips(delta)
	if not self.waterMesh then
		return
	end

	local state = self:getProp():getState()
	local shipsState = state.ships

	if not shipsState then
		return
	end

	self.previousShips = self.currentShips
	self.currentShips = {}

	for _, shipState in ipairs(shipsState) do
		local previousShip = previousShips and previousShips[shipState.id]

		local mask = shipState.mask
		if not previousShip or previousShip.mask ~= mask then
			local maskMesh = self.masks[mask]
			if maskMesh == nil then
				self.masks[mask] = false

				self:getResources():queue(
					StaticMeshResource,
					string.format("Resources/Game/SailingItems/Hull_%s/Model.lstatic", mask),
					function(mesh)
						self.masks[mask] = mesh

						local min, max = mesh:getResource():computeBounds("hull.exterior")
						self.maskBounds[mask] = { min = min, max = max }
					end)
			end
		end

		local currentShip = {
			mask = shipState.mask,
			state = shipState
		}

		self.currentShips[shipState.id] = currentShip
	end

	love.graphics.push("all")
	do
		love.graphics.setCanvas({ self.shipCanvas, depth = true })
		love.graphics.clear(0, 0, 0, 1)

		local currentTranslation = self.waterParent:getTransform():getLocalTranslation()

		local projection = love.math.newTransform()
		projection:ortho(
			currentTranslation.x - EndlessWater.SIZE * 2,
			currentTranslation.x + (EndlessWater.WIDTH * 2) * EndlessWater.SIZE * 2,
			currentTranslation.z - EndlessWater.SIZE * 2,
			currentTranslation.z + (EndlessWater.HEIGHT * 2) * EndlessWater.SIZE * 2,
			-(state.ocean and state.ocean.offset * 2 or 32),
			(state.ocean and state.ocean.offset * 2 or 32))

		local view = love.math.newTransform()
		view:rotate(1, 0, 0, -math.pi / 2)

		local projectionView = projection * view

		local _, layer = self:getProp():getPosition()
		local windDirection, windSpeed, windPattern = self:getGameView():getWind(layer)

		self.shaderCache:bindShader(
			self.waterShader,
			"scape_ViewMatrix", view,
			"scape_ProjectionMatrix", projection,
			"scape_BumpForce", 0,
			"scape_WindDirection", { windDirection:get() },
			"scape_WindSpeed", windSpeed,
			"scape_WindPattern", { windPattern:get() },
			"scape_WindMaxDistance", state.ocean.offset,
			"scape_WindSpeedMultiplier", state.ocean.windSpeedMultiplier,
			"scape_WindPatternMultiplier", state.ocean.windPatternMultiplier,
			"scape_Time", math.lerp(self.previousTime or self.currentTime or 0, self.currentTime or 0, _APP:getPreviousFrameDelta()),
			"scape_YOffset", state.ocean and state.ocean.offset or 0)

		love.graphics.setDepthMode("lequal", true)
		for _, water in ipairs(self.waters) do
			self.shaderCache:bindShader(
				self.waterShader,
				"scape_WorldMatrix", water:getTransform():getGlobalTransform())

			love.graphics.draw(self.waterMesh:getMesh())

			local material = water:getMaterial()
			material:send(material.UNIFORM_FLOAT, "scape_BumpProjectionViewMatrix", Transform.getMatrix(projectionView))
		end

		self.shaderCache:bindShader(
			self.shipShader,
			"scape_ViewMatrix", view,
			"scape_ProjectionMatrix", projection)

		love.graphics.setDepthMode("lequal", true)
		local worldTransform = love.math.newTransform()
		for _, currentShip in pairs(self.currentShips) do
			local previousShip = self.previousShips and self.previousShips[currentShip.state.id]
			previousShip = previousShip or self.currentShips[currentShip.state.id]

			local meshResource = self.masks[currentShip.mask]
			local mesh = meshResource and meshResource:getResource():getMesh("hull.exterior")			
			if mesh then
				local meshBounds = self.maskBounds[currentShip.mask]
				local realSize = meshBounds.max - meshBounds.min
				local adjustedSize = realSize + Vector(EndlessWater.MASK_SIZE_OFFSET, 0, EndlessWater.MASK_SIZE_OFFSET)

				local currentPosition = Vector(unpack(currentShip.state.position))
				local currentRotation = Quaternion(unpack(currentShip.state.rotation))
				local currentScale = Vector(unpack(currentShip.state.scale))
				local currentOrigin = Vector(unpack(currentShip.state.origin))
				local previousPosition = Vector(unpack(previousShip.state.position))
				local previousRotation = Quaternion(unpack(previousShip.state.rotation))
				local previousScale = Vector(unpack(previousShip.state.scale))
				local previousOrigin = Vector(unpack(previousShip.state.origin))

				local frameDelta = _APP:getPreviousFrameDelta()
				local position = previousPosition:lerp(currentPosition, frameDelta)
				local rotation = previousRotation:slerp(currentRotation, frameDelta)
				local scale = previousScale:lerp(currentScale, frameDelta)
				local origin = previousOrigin:lerp(currentOrigin, frameDelta)
				scale = scale * (adjustedSize / realSize)

				worldTransform:reset()
				worldTransform:translate((position + origin):get())
				worldTransform:scale(scale:get())
				worldTransform:applyQuaternion(rotation:get())

				self.shaderCache:bindShader(
					self.shipShader,
					"scape_WorldMatrix", worldTransform)

				love.graphics.draw(mesh)
			end
		end
	end

	love.graphics.pop()
end

function EndlessWater:update(delta)
	PropView.update(self, delta)

	local camera = self:getGameView():getRenderer():getCamera()
	local position = camera:getPosition()

	local i = math.floor(position.x / (EndlessWater.SIZE * EndlessWater.CELL_SIZE))
	local j = math.floor(position.z / (EndlessWater.SIZE * EndlessWater.CELL_SIZE))
	local x = (i + 0.5) * (EndlessWater.SIZE * EndlessWater.CELL_SIZE)
	local z = (j + 0.5) * (EndlessWater.SIZE * EndlessWater.CELL_SIZE)

	self.waterParent:getTransform():setLocalTranslation(Vector(position.x, 0, position.z))

	self:updateShips(delta)
end

return EndlessWater
