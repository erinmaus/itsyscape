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
		local waterMesh = WaterMesh(EndlessWater.SIZE * 2, EndlessWater.SIZE * 2, 8)
		for _, water in ipairs(self.waters) do
			water:setMesh(waterMesh)
			water:getMaterial():setTextures(self.texture)
		end
	end)
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

	--print("... (fe) time, offset", state.time, state.ocean.offset)
	--print("... (fe) pattern", windPattern:get())
	--print("... (fe) ocean pattern", unpack(state.ocean.windPatternMultiplier))
	--print("... (fe) ocean/wind speed", state.ocean.windSpeedMultiplier, windSpeed)
	--print("... (fe) dir", windDirection:get())
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
