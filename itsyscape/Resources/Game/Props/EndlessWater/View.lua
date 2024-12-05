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
local Color = require "ItsyScape.Graphics.Color"
local PostProcessPass = require "ItsyScape.Graphics.PostProcessPass"
local PropView = require "ItsyScape.Graphics.PropView"
local Renderer = require "ItsyScape.Graphics.Renderer"
local SceneNode = require "ItsyScape.Graphics.SceneNode"
local ShaderResource = require "ItsyScape.Graphics.ShaderResource"
local TextureResource = require "ItsyScape.Graphics.TextureResource"
local ThirdPersonCamera = require "ItsyScape.Graphics.ThirdPersonCamera"
local WaterMeshSceneNode = require "ItsyScape.Graphics.WaterMeshSceneNode"
local WaterMesh = require "ItsyScape.World.WaterMesh"

local EndlessWater = Class(PropView)
EndlessWater.SHADER = ShaderResource()
do
	EndlessWater.SHADER:loadFromFile("Resources/Shaders/WhirlpoolWater")
end

EndlessWater.HOLE_COLOR = Color.fromHexString("87cdde")
EndlessWater.FOAM_COLOR = Color.fromHexString("ffffff")

-- Size of map sector, in terms of unit (1 unit = cell size)
EndlessWater.SIZE = 64

-- Width and height of the water in the negative and positive dimensions.
-- Basically goes from -W .. +W, and -H .. +H.
EndlessWater.WIDTH  = 1
EndlessWater.HEIGHT = 1

EndlessWater.CANVAS_CELL_SIZE = 32

EndlessWater.WHIRLPOOL_PROPS = {
	["scape_WhirlpoolCenter"] = "center",
	["scape_WhirlpoolRadius"] = "radius",
	["scape_WhirlpoolHoleRadius"] = "holeRadius",
	["scape_WhirlpoolRings"] = "rings",
	["scape_WhirlpoolRotationSpeed"] = "rotationSpeed",
	["scape_WhirlpoolHoleSpeed"] = "holeSpeed"
}

EndlessWater.PASS_ID = 1

function EndlessWater:new(prop, gameView)
	PropView.new(self, prop, gameView)

	self.shaderCache = PostProcessPass(gameView:getRenderer(), 0)
	self.shaderCache:load(gameView:getResourceManager())
	self.waterShader = self.shaderCache:loadPostProcessShader("BumpWater")
	self.shipShader = self.shaderCache:loadPostProcessShader("BumpShip")

	self.masks = {}
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

	self.waters = {}
	for i = -EndlessWater.WIDTH, EndlessWater.WIDTH do
		for j = -EndlessWater.HEIGHT, EndlessWater.HEIGHT do
			local water = WaterMeshSceneNode()

			local translation = Vector(
				(i * EndlessWater.SIZE) * 2,
				0,
				(j * EndlessWater.SIZE) * 2)
			water:getTransform():setLocalTranslation(translation)

			water:getMaterial():setIsReflectiveOrRefractive(true)
			water:getMaterial():setReflectionPower(1.0)
			water:getMaterial():setOutlineThreshold(-1.0)
			water:getMaterial():setShader(EndlessWater.SHADER)
			water:setParent(self.waterParent)

			table.insert(self.waters, water)
		end
	end

	resources:queueEvent(function()
		self.waterMesh = WaterMesh(EndlessWater.SIZE * 2, EndlessWater.SIZE * 2, 8)
		for _, water in ipairs(self.waters) do
			water:setMesh(self.waterMesh)
			water:getMaterial():setTextures(self.texture)
		end
	end)

	local width = EndlessWater.WIDTH * 2 + 1
	width = width * EndlessWater.SIZE * 2 * self.CANVAS_CELL_SIZE

	local height = EndlessWater.HEIGHT * 2 + 1
	height = height * EndlessWater.SIZE * 2 * self.CANVAS_CELL_SIZE

	self.shadowCanvas = love.graphics.newCanvas(width, height, { format = "rgba16f" })
	self.shadowCanvas:setFilter("linear", "linear")

	self.maskCanvas = love.graphics.newCanvas(width, height)
	self.maskCanvas:setFilter("linear", "linear")

	self.bumpCanvas = love.graphics.newCanvas(width, height, { format = "rgba16f" })
	self.bumpCanvas:setFilter("linear", "linear")
end

function EndlessWater:tick()
	PropView.tick(self)

	local state = self:getProp():getState()
	local _, layer = self:getProp():getPosition()
	local windDirection, windSpeed, windPattern = self:getGameView():getWind(layer)

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

			material:send(material.UNIFORM_FLOAT, "scape_WhirlpoolHoleColor", { EndlessWater.HOLE_COLOR:get() })
			material:send(material.UNIFORM_FLOAT, "scape_WhirlpoolFoamColor", { EndlessWater.FOAM_COLOR:get() })
			material:send(material.UNIFORM_FLOAT, "scape_WhirlpoolAlpha", 1.0)
		else
			material:send(material.UNIFORM_FLOAT, "scape_WhirlpoolAlpha", 0.0)
		end

		if state.ocean and state.ocean.hasOcean then
			water:setYOffset(state.ocean.offset)
			water:setPositionTimeScale(state.ocean.positionTimeScale)
			water:setTextureTimeScale(unpack(state.ocean.textureTimeScale))
		end

		material:send(material.UNIFORM_FLOAT, "scape_BumpForce", 0)
		material:send(material.UNIFORM_FLOAT, "scape_WindDirection", windDirection:get())
		material:send(material.UNIFORM_FLOAT, "scape_WindSpeed", windSpeed)
		material:send(material.UNIFORM_FLOAT, "scape_WindPattern", windPattern:get())
		material:send(material.UNIFORM_FLOAT, "scape_WindMaxDistance", state.ocean.offset)
		material:send(material.UNIFORM_FLOAT, "scape_WindSpeedMultiplier", state.ocean.windSpeedMultiplier)
		material:send(material.UNIFORM_FLOAT, "scape_WindPatternMultiplier", state.ocean.windPatternMultiplier)
		material:send(material.UNIFORM_FLOAT, "scape_Time", math.lerp(self.previousTime or self.currentTime or 0, self.currentTime or 0, _APP:getPreviousFrameDelta()))
	end
end

function EndlessWater:makeShipMesh(shipState, size)
	local MESH_FORMAT = {
		{ "VertexPosition", "float", 3 },
		{ "VertexTexture", "float", 2 }
	}

	local MESH_DATA = {
		{ 0, 0, 0, 0, 0 },
		{ size.z, 0, 0, 1, 0 },
		{ size.z, 0, size.x, 1, 1 },

		{ size.z, 0, size.x, 1, 1 },
		{ 0, 0, size.x, 0, 1 },
		{ 0, 0, 0, 0, 0 }
	}


	local mesh = love.graphics.newMesh(MESH_FORMAT, MESH_DATA, "triangles", "static")
	mesh:setAttributeEnabled("VertexPosition", true)
	mesh:setAttributeEnabled("VertexTexture", true)

	return mesh
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
		local mask = shipState.mask

		local maskImage = mask and self.masks[mask]
		maskImage = maskImage or love.graphics.newImage(string.format("Resources/Game/Props/EndlessWater/Masks/%s.png", mask))

		local shadowImage = mask and self.shadows[mask]
		shadowImage = shadowImage or love.graphics.newImage(string.format("Resources/Game/Props/EndlessWater/Shadows/%s.png", mask))

		local currentSize = Vector(unpack(shipState.size))

		local mesh
		local previousShip = previousShips and previousShips[shipState.id]
		if not previousShip or previousShip.size ~= currentSize then
			if previousShip and previousShip.mesh then
				previousShip.mesh:release()
			end

			mesh = self:makeShipMesh(shipState, currentSize)
		else
			mesh = previousShip.mesh
		end

		local currentShip = {
			mask = maskImage,
			shadow = shadowImage,
			mesh = mesh,
			state = shipState,
			size = currentSize
		}

		self.currentShips[shipState.id] = currentShip
	end

	love.graphics.push("all")
	do
		love.graphics.setCanvas({ self.shadowCanvas, self.maskCanvas, depth = true })
		love.graphics.clear(0, 0, 0, 1)

		local currentTranslation = self.waterParent:getTransform():getLocalTranslation()

		local projection = love.math.newTransform()
		projection:ortho(
			currentTranslation.x,
			currentTranslation.x + (EndlessWater.WIDTH * 2 + 1) * 2,
			currentTranslation.y,
			currentTranslation.y + (EndlessWater.HEIGHT * 2 + 1) * 2,
			-(state.ocean and state.ocean.offset * 2 or 32),
			(state.ocean and state.ocean.offset * 2 or 32))

		local view = love.math.newTransform()
		view:rotate(0, 0, 1, math.pi / 2)

		self.shaderCache:bindShader(
			self.waterShader,
			"scape_ViewMatrix", view,
			"scape_ProjectionMatrix", projection)

		love.graphics.setDepthMode("lequal", true)
		for _, water in ipairs(self.waters) do
			self.shaderCache:bindShader(
				self.waterShader,
				"scape_WorldMatrix", water:getTransform():getLocalTransform())

			love.graphics.draw(self.waterMesh:getMesh())
		end

		self.shaderCache:bindShader(
			self.shipShader,
			"scape_ViewMatrix", view,
			"scape_ProjectionMatrix", projection)

		love.graphics.setDepthMode("gequal", true)
		local worldTransform = love.math.newTransform()
		for _, currentShip in pairs(self.currentShips) do
			local position = Vector(unpack(currentShip.state.position))
			local rotation = Quaternion(unpack(currentShip.state.rotation))
			local scale = Vector(unpack(currentShip.state.scale))
			local origin = Vector(unpack(currentShip.state.origin))

			worldTransform:reset()
			worldTransform:translate(origin:get())
			worldTransform:translate(position:get())
			worldTransform:scale(scale:get())
			worldTransform:applyQuaternion(rotation:get())
			worldTransform:translate((-origin):get())

			self.shaderCache:bindShader(
				self.shipShader,
				"scape_WorldMatrix", worldTransform,
				"scape_ShadowTexture", currentShip.shadow,
				"scape_MaskTexture", currentShip.mask)

			love.graphics.draw(currentShip.mesh)
		end
	end
	love.graphics.pop()
end

function EndlessWater:update(delta)
	PropView.update(self, delta)

	local camera = self:getGameView():getRenderer():getCamera()
	local position = camera:getPosition()

	local i = math.floor(position.x / (EndlessWater.SIZE * 2))
	local j = math.floor(position.z / (EndlessWater.SIZE * 2))
	local x = i * (EndlessWater.SIZE * 2)
	local z = j * (EndlessWater.SIZE * 2)

	self.waterParent:getTransform():setLocalTranslation(Vector(x, 0, z))
	self.waterParent:tick(1)

	self:updateShips(delta)
end

return EndlessWater
