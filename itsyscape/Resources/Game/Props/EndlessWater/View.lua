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
local MathCommon = require "ItsyScape.Common.Math.Common"
local Vector = require "ItsyScape.Common.Math.Vector"
local Quaternion = require "ItsyScape.Common.Math.Quaternion"
local Transform = require "ItsyScape.Common.Math.Transform"
local RPCState = require "ItsyScape.Game.RPC.State"
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
EndlessWater.WIDTH  = 2
EndlessWater.HEIGHT = 2

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
		scape_TextureScale = { "float", 2, 2 }
	}
})

EndlessWater.VIEW_TRANSFORM = Quaternion.fromAxisAngle(Vector.UNIT_X, -math.pi / 2)

function EndlessWater:new(prop, gameView)
	PropView.new(self, prop, gameView)

	self.shaderCache = PostProcessPass(gameView:getRenderer(), 0)
	self.shaderCache:load(gameView:getResourceManager())
	self.waterShader = self.shaderCache:loadPostProcessShader("BumpWater")
	self.shipShader = self.shaderCache:loadPostProcessShader("BumpShip")

	self.masks = {}
	self.maskBounds = {}
	self.shadows = {}

	self.previousShips = {}
	self.currentShips = {}
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
		waterMaterial = DecorationMaterial(Resource.readLua("Resources/Game/Water/DarkFoamyWater1/Material.lua")):replace(self.EXTENDED_MATERIAL)
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

do
	local previousAmbientColor = Color()
	local currentAmbientColor = Color()
	local waterRimColor = Color()
	local defaultColor = { 1, 1, 1 }

	function EndlessWater:tick()
		PropView.tick(self)

		local state = self:getProp():getState()
		local _, layer = self:getProp():getPosition()
		local windDirection, windSpeed, windPattern = self:getGameView():getWind(layer)

		local currentSkyProperties, previousSkyProperties = self:getGameView():getSkyProperties(layer)
		if not (currentSkyProperties and previousSkyProperties) then
			waterRimColor:from(1, 1, 1, 1)
		else
			previousAmbientColor:from(unpack(previousSkyProperties.currentAmbientColor or defaultColor, 1, 3))
			currentAmbientColor:from(unpack(currentSkyProperties.currentAmbientColor or defaultColor, 1, 3))
			previousAmbientColor:lerp(currentAmbientColor, _APP:getPreviousFrameDelta(), waterRimColor)
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
			material:send(material.UNIFORM_FLOAT, "scape_WindMaxDistance", state.ocean and state.ocean.offset or 0)
			material:send(material.UNIFORM_FLOAT, "scape_WindSpeedMultiplier", state.ocean and state.ocean.windSpeedMultiplier or 0)
			material:send(material.UNIFORM_FLOAT, "scape_WindPatternMultiplier", state.ocean and state.ocean.windPatternMultiplier or 0)
			material:send(material.UNIFORM_FLOAT, "scape_Time", math.lerp(self.previousTime or self.currentTime or 0, self.currentTime or 0, _APP:getPreviousFrameDelta()))

			material:send(material.UNIFORM_TEXTURE, "scape_BumpTexture", self.bumpCanvas)
			material:send(material.UNIFORM_TEXTURE, "scape_MaskTexture", self.shipCanvas)
		end
	end
end

do
	local currentPosition = Vector()
	local currentRotation = Quaternion()
	local currentScale = Vector()
	local currentOrigin = Vector()
	local previousPosition = Vector()
	local previousRotation = Quaternion()
	local previousScale = Vector()
	local previousOrigin = Vector()
	local position = Vector()
	local rotation = Quaternion()
	local scale = Vector()
	local origin = Vector()
	local realSize = Vector()
	local adjustedSize = Vector()
	local scaledSize = Vector()
	local maskOffset = Vector()
	local windDirectionUniform = {}
	local windPatternUniform = {}

	local projectionTransform = love.math.newTransform()
	local viewTransform = love.math.newTransform()
	local projectionViewTransform = love.math.newTransform()
	local worldTransform = love.math.newTransform()

	function EndlessWater:updateShips(delta)
		if not self.waterMesh then
			return
		end

		local state = self:getProp():getState()
		local shipsState = state.ships

		if not shipsState then
			return
		end

		self.previousShips = RPCState.merge(self.currentShips, self.previousShips)

		for _, shipState in pairs(self.currentShips) do
			shipState.visited = false
		end

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

			local currentShip = self.currentShips[shipState.id]
			if not currentShip then
				currentShip = {}
				self.currentShips[shipState.id] = currentShip
			end

			currentShip.mask = shipState.mask
			currentShip.state = RPCState.merge(shipState, currentShip.state)
			currentShip.visited = true
		end

		for id, shipState in pairs(self.currentShips) do
			if not shipState.visited then
				self.currentShips[id] = nil
			end
		end

		love.graphics.push("all")
		do
			love.graphics.setCanvas({ self.shipCanvas, depth = true })
			love.graphics.clear(0, 0, 0, 1)

			local currentTranslation = self.waterParent:getTransform():getLocalTranslation()

			local width = (EndlessWater.WIDTH * 2 - 0.5) * EndlessWater.SIZE * EndlessWater.CELL_SIZE
			local height = (EndlessWater.HEIGHT * 2 - 0.5) * EndlessWater.SIZE * EndlessWater.CELL_SIZE

			MathCommon.makeOrthoTransform(
				currentTranslation.x - width / 2,
				currentTranslation.x + width / 2 ,
				currentTranslation.z - height / 2,
				currentTranslation.z + height / 2,
				-(state.ocean and state.ocean.offset * 2 or 32),
				(state.ocean and state.ocean.offset * 2 or 32),
				projectionTransform)

			MathCommon.makeRotationTransform(EndlessWater.VIEW_TRANSFORM, viewTransform)

			projectionViewTransform:reset()
			projectionViewTransform:apply(projectionTransform)
			projectionViewTransform:apply(viewTransform)

			local _, layer = self:getProp():getPosition()
			local windDirection, windSpeed, windPattern = self:getGameView():getWind(layer)
			windDirectionUniform[1], windDirectionUniform[2], windDirectionUniform[3] = windDirection:get()
			windPatternUniform[1], windPatternUniform[2], windPatternUniform[3] = windPattern:get()

			self.shaderCache:bindShader(
				self.waterShader,
				"scape_ViewMatrix", viewTransform,
				"scape_ProjectionMatrix", projectionTransform,
				"scape_BumpForce", 0,
				"scape_WindDirection", windDirectionUniform,
				"scape_WindSpeed", windSpeed,
				"scape_WindPattern", windPatternUniform,
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
				material:send(material.UNIFORM_FLOAT, "scape_BumpProjectionViewMatrix", Transform.getMatrix(projectionViewTransform))
			end

			self.shaderCache:bindShader(
				self.shipShader,
				"scape_ViewMatrix", viewTransform,
				"scape_ProjectionMatrix", projectionTransform)

			love.graphics.setDepthMode("lequal", true)
			local worldTransform = love.math.newTransform()
			for _, currentShip in pairs(self.currentShips) do
				local previousShip = self.previousShips[currentShip.state.id] or self.currentShips[currentShip.state.id]

				local meshResource = self.masks[currentShip.mask]
				local mesh = meshResource and meshResource:getResource():getMesh("hull.exterior")			
				if mesh then
					local meshBounds = self.maskBounds[currentShip.mask]
					meshBounds.max:subtract(meshBounds.min, realSize)
					realSize:add(maskOffset:from(EndlessWater.MASK_SIZE_OFFSET, 0, EndlessWater.MASK_SIZE_OFFSET), adjustedSize)

					currentPosition:from(unpack(currentShip.state.position))
					currentRotation:from(unpack(currentShip.state.rotation))
					currentScale:from(unpack(currentShip.state.scale))
					currentOrigin:from(unpack(currentShip.state.origin))
					previousPosition:from(unpack(previousShip.state.position))
					previousRotation:from(unpack(previousShip.state.rotation))
					previousScale:from(unpack(previousShip.state.scale))
					previousOrigin:from(unpack(previousShip.state.origin))

					local frameDelta = _APP:getPreviousFrameDelta()
					previousPosition:lerp(currentPosition, frameDelta, position)
					previousRotation:slerp(currentRotation, frameDelta, rotation)
					previousScale:lerp(currentScale, frameDelta, scale)
					previousOrigin:lerp(currentOrigin, frameDelta, origin)

					scale:product(adjustedSize:divide(realSize, scaledSize), scale)
					position:add(origin, position)

					MathCommon.makeTransform(position, rotation, scale, nil, worldTransform)

					self.shaderCache:bindShader(
						self.shipShader,
						"scape_WorldMatrix", worldTransform)

					love.graphics.draw(mesh)
				end
			end
		end

		love.graphics.pop()
	end
end

do
	local translation = Vector()
	function EndlessWater:update(delta)
		PropView.update(self, delta)

		local camera = self:getGameView():getRenderer():getCamera()
		local position = camera:getPosition()

		local i = math.floor(position.x / (EndlessWater.SIZE * EndlessWater.CELL_SIZE))
		local j = math.floor(position.z / (EndlessWater.SIZE * EndlessWater.CELL_SIZE))
		local x = i * (EndlessWater.SIZE * EndlessWater.CELL_SIZE)
		local z = j * (EndlessWater.SIZE * EndlessWater.CELL_SIZE)

		self.waterParent:getTransform():setLocalTranslation(translation:from(x, 0, z))

		self:updateShips(delta)
	end
end

return EndlessWater
