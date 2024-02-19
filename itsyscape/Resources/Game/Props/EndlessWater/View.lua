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
local Color = require "ItsyScape.Graphics.Color"
local PropView = require "ItsyScape.Graphics.PropView"
local SceneNode = require "ItsyScape.Graphics.SceneNode"
local ShaderResource = require "ItsyScape.Graphics.ShaderResource"
local TextureResource = require "ItsyScape.Graphics.TextureResource"
local WaterMeshSceneNode = require "ItsyScape.Graphics.WaterMeshSceneNode"

local EndlessWater = Class(PropView)
EndlessWater.WHIRLPOOL_SHADER = ShaderResource()
EndlessWater.WATER_SHADER = ShaderResource()
do
	EndlessWater.WHIRLPOOL_SHADER:loadFromFile("Resources/Shaders/WhirlpoolWater")
	EndlessWater.WATER_SHADER:loadFromFile("Resources/Shaders/Water")
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

				local function _onWillRender(renderer, delta)
					local shader = renderer:getCurrentShader()
					local state = self:getProp():getState()

					for k, v in pairs(EndlessWater.WHIRLPOOL_PROPS) do
						local prop = state.whirlpool[v]
						if prop and shader:hasUniform(k) then
							shader:send(k, prop)
						end
					end

					if shader:hasUniform("scape_WhirlpoolHoleColor") then
						shader:send("scape_WhirlpoolHoleColor", { EndlessWater.HOLE_COLOR:get() })
					end

					if shader:hasUniform("scape_WhirlpoolFoamColor") then
						shader:send("scape_WhirlpoolFoamColor", { EndlessWater.FOAM_COLOR:get() })
					end

					water:setYOffset(state.ocean.offset)
					water:setPositionTimeScale(state.ocean.positionTimeScale)
					water:setTextureTimeScale(unpack(state.ocean.textureTimeScale))
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
		if state.whirlpool.hasWhirlpool then
			water:getMaterial():setShader(EndlessWater.WHIRLPOOL_SHADER)
		else
			water:getMaterial():setShader(EndlessWater.WATER_SHADER)
		end
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
