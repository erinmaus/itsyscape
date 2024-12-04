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
				water:getMaterial():setReflectionPower(1.0)

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
				end

				water:setParent(self.waterParent)
				water:getMaterial():setTextures(self.texture)
				--water:onWillRender(_onWillRender)

				table.insert(self.waters, water)
			end)
		end
	end
end

function EndlessWater:tick()
	PropView.tick(self)

	local state = self:getProp():getState()
	local _, layer = self:getProp():getPosition()
	local windDirection, windSpeed, windPattern = self:getGameView():getWind(layer)

	for _, water in ipairs(self.waters) do
		local material = water:getMaterial()

		if state.whirlpool and state.whirlpool.hasWhirlpool then
			material:setShader(EndlessWater.WHIRLPOOL_SHADER)

			for k, v in pairs(EndlessWater.WHIRLPOOL_PROPS) do
				local prop = state.whirlpool[v]
				if prop and shader:hasUniform(k) then
					material:send(material.UNIFORM_FLOAT, k, prop)
				end
			end

			material:send(material.UNIFORM_FLOAT, "scape_WhirlpoolHoleColor", { EndlessWater.HOLE_COLOR:get() })
			material:send(material.UNIFORM_FLOAT, "scape_WhirlpoolFoamColor", { EndlessWater.FOAM_COLOR:get() })
		else
			material:setShader(EndlessWater.WATER_SHADER)
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
		material:send(material.UNIFORM_FLOAT, "scape_WallHackWindow", 2.0, 2.0, 2.0, 2.0)
		material:send(material.UNIFORM_FLOAT, "scape_WallHackAlpha", 0.0)
	end
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
end

return EndlessWater
