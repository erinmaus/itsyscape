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
local PropView = require "ItsyScape.Graphics.PropView"
local Renderer = require "ItsyScape.Graphics.Renderer"
local SceneNode = require "ItsyScape.Graphics.SceneNode"
local ShaderResource = require "ItsyScape.Graphics.ShaderResource"
local TextureResource = require "ItsyScape.Graphics.TextureResource"
local ThirdPersonCamera = require "ItsyScape.Graphics.ThirdPersonCamera"
local WaterMeshSceneNode = require "ItsyScape.Graphics.WaterMeshSceneNode"

local EndlessWater = Class(PropView)
EndlessWater.WHIRLPOOL_SHADER = ShaderResource()
EndlessWater.WATER_SHADER = ShaderResource()
do
	EndlessWater.WHIRLPOOL_SHADER:loadFromFile("Resources/Shaders/ReflectiveWater")
	EndlessWater.WATER_SHADER:loadFromFile("Resources/Shaders/ReflectiveWater")
end

EndlessWater.HOLE_COLOR = Color.fromHexString("87cdde")
EndlessWater.FOAM_COLOR = Color.fromHexString("ffffff")

EndlessWater.REFLECTION_WIDTH = 1024
EndlessWater.REFLECTION_HEIGHT = 1024
EndlessWater.CUBE_MAP_COUNT = 6

EndlessWater.CUBE_MAP_NORMALS = {
	Vector(1, 0, 0):keep(),
	Vector(-1, 0, 0):keep(),
	Vector(0, 1, 0):keep(),
	Vector(0, -1, 0):keep(),
	Vector(0, 0, 1):keep(),
	Vector(0, 0, -1):keep(),
}

EndlessWater.CUBE_MAP_ROTATION = {
	Quaternion.Y_270,
	Quaternion.Y_90,
	Quaternion.X_270,
	Quaternion.X_90,
	Quaternion.IDENTITY,
	Quaternion.Y_180
}

EndlessWater.CUBE_MAP_FOV = math.rad(90)

-- Size of map sector, in terms of unit (1 unit = cell size)
EndlessWater.SIZE = 64

-- Width and height of the water in the negative and positive dimensions.
-- Basically goes from -W .. +W, and -H .. +H.
EndlessWater.WIDTH  = 1
EndlessWater.HEIGHT = 1

EndlessWater.WHIRLPOOL_PROPS = {
	["scape_WhirlpoolCenter"] = "center",
	["scape_WhirlpoolRadius"] = "radius",
	["scape_WhirlpoolHoleRadius"] = "holeRadius",
	["scape_WhirlpoolRings"] = "rings",
	["scape_WhirlpoolRotationSpeed"] = "rotationSpeed",
	["scape_WhirlpoolHoleSpeed"] = "holeSpeed"
}

function EndlessWater:new(prop, gameView)
	PropView.new(self, prop, gameView)
end

function EndlessWater:load()
	PropView.load(self)

	local resources = self:getResources()

	self.waterParent = SceneNode()
	self.waterParent:setParent(self:getRoot())

	self.camera = ThirdPersonCamera()
	self.renderer = Renderer({ shadows = false })
	self.renderer:setCamera(self.camera)

	self.reflectionCanvas = love.graphics.newCanvas(
		self.REFLECTION_WIDTH,
		self.REFLECTION_HEIGHT,
		{ type = "cube" })

	self.reflectionDepthCanvas = love.graphics.newCanvas(
		self.REFLECTION_WIDTH,
		self.REFLECTION_HEIGHT,
		{ type = "cube", format = "r32f" })

	self.skyboxCanvas = love.graphics.newCanvas(
		self.REFLECTION_WIDTH,
		self.REFLECTION_HEIGHT,
		{ type = "cube" })

	resources:queue(
		TextureResource,
		"Resources/Game/Water/LightFoamyWater1/Texture.png",
		function(texture)
			self.texture = texture
		end)

	self.waters = {}
	for i = -EndlessWater.WIDTH, EndlessWater.WIDTH do
		for j = -EndlessWater.HEIGHT, EndlessWater.HEIGHT do
			resources:queueEvent(function()
				local water = WaterMeshSceneNode()
				water:generate(
					nil,
					i * EndlessWater.SIZE,
					j * EndlessWater.SIZE,
					EndlessWater.SIZE,
					EndlessWater.SIZE,
					1.5,
					8)
				water:getMaterial():setIsReflectiveOrRefractive(true)
				water:getMaterial():setRatioIndexOfRefraction(1.33)
				water:getMaterial():setRefractionPower(0.5)

				local function _onWillRender(renderer, delta)
					local shader = renderer:getCurrentShader()
					local state = self:getProp():getState()

					if state.whirlpool then
						for k, v in pairs(EndlessWater.WHIRLPOOL_PROPS) do
							local prop = state.whirlpool[v]
							if prop and shader:hasUniform(k) then
								shader:send(k, prop)
							end
						end
					end

					-- if shader:hasUniform("scape_DepthTexture") then
					-- 	shader:send("scape_DepthTexture", self:getGameView():getRenderer():getOutputBuffer():getDepthStencil())
					-- end

					-- if shader:hasUniform("scape_ReflectionMap") then
					-- 	shader:send("scape_ReflectionMap", self.reflectionCanvas)
					-- end

					-- if shader:hasUniform("scape_ReflectionDepthMap") then
					-- 	shader:send("scape_ReflectionDepthMap", self.reflectionDepthCanvas)
					-- end

					-- if shader:hasUniform("scape_SkyboxMap") then
					-- 	shader:send("scape_SkyboxMap", self.skyboxCanvas)
					-- end

					if shader:hasUniform("scape_WhirlpoolHoleColor") then
						shader:send("scape_WhirlpoolHoleColor", { EndlessWater.HOLE_COLOR:get() })
					end

					if shader:hasUniform("scape_WhirlpoolFoamColor") then
						shader:send("scape_WhirlpoolFoamColor", { EndlessWater.FOAM_COLOR:get() })
					end

					if state.ocean and state.ocean.hasOcean then
						water:setYOffset(state.ocean.offset)
						water:setPositionTimeScale(state.ocean.positionTimeScale)
						water:setTextureTimeScale(unpack(state.ocean.textureTimeScale))
					end
				end

				water:setParent(self.waterParent)
				water:getMaterial():setTextures(self.texture)
				water:onWillRender(_onWillRender)

				table.insert(self.waters, water)
			end)
		end
	end
end

function EndlessWater:tick()
	PropView.tick(self)

	local state = self:getProp():getState()
	for _, water in ipairs(self.waters) do
		if state.whirlpool and state.whirlpool.hasWhirlpool then
			water:getMaterial():setShader(EndlessWater.WHIRLPOOL_SHADER)
		else
			water:getMaterial():setShader(EndlessWater.WATER_SHADER)
		end
	end
end

function EndlessWater:updateCamera(index)
	self.camera:setFieldOfView(EndlessWater.CUBE_MAP_FOV)
	self.camera:setWidth(EndlessWater.REFLECTION_WIDTH)
	self.camera:setHeight(EndlessWater.REFLECTION_HEIGHT)
	self.camera:setVerticalRotation(-math.pi / 2)
	self.camera:setHorizontalRotation(math.pi)
	self.camera:setDistance(0)
	self.camera:setPosition(self:getGameView():getCamera():getEye())
	self.camera:setRotation(EndlessWater.CUBE_MAP_ROTATION[index])

	local x, y, z = self.camera:getRotation():getEulerXYZ()
	print(">>> euler", index, math.deg(x), math.deg(y), math.deg(z))
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

	-- local delta = _APP:getFrameDelta()

	-- self.waterParent:setParent(nil)
	-- love.graphics.push("all")
	-- do
	-- 	for i = 1, EndlessWater.CUBE_MAP_COUNT do
	-- 		self:updateCamera(i)

	-- 		if self:getGameView():drawSkyboxTo(
	-- 			delta,
	-- 			self.renderer,
	-- 			EndlessWater.REFLECTION_WIDTH,
	-- 			EndlessWater.REFLECTION_HEIGHT)
	-- 		then
	-- 			love.graphics.setCanvas(self.skyboxCanvas, i)
	-- 			love.graphics.clear(0, 0, 0, 0)
	-- 			love.graphics.draw(self.renderer:getOutputBuffer():getColor())
	-- 		end
	-- 	end

	-- 	for i = 1, EndlessWater.CUBE_MAP_COUNT do
	-- 		self:updateCamera(i)

	-- 		self:getGameView():drawWorldTo(
	-- 			delta,
	-- 			self.renderer,
	-- 			EndlessWater.REFLECTION_WIDTH,
	-- 			EndlessWater.REFLECTION_HEIGHT)

	-- 		love.graphics.setCanvas(self.reflectionCanvas, i)
	-- 		love.graphics.clear(0, 0, 0, 0)
	-- 		love.graphics.draw(self.renderer:getOutputBuffer():getColor())

	-- 		love.graphics.setCanvas(self.reflectionDepthCanvas, i)
	-- 		love.graphics.clear(0, 0, 0, 0)
	-- 		love.graphics.draw(self.renderer:getOutputBuffer():getDepthStencil())
	-- 	end
	-- end
	-- love.graphics.pop()

	-- self.waterParent:setParent(self:getRoot())
end

return EndlessWater
