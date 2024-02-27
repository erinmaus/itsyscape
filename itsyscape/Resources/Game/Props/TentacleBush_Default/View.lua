--------------------------------------------------------------------------------
-- Resources/Game/Props/TentacleBush_Default/View.lua
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
local ShaderResource = require "ItsyScape.Graphics.ShaderResource"
local SimpleStaticView = require "Resources.Game.Props.Common.SimpleStaticView"
local NoiseBuilder = require "ItsyScape.Game.Skills.Antilogika.NoiseBuilder"

local Bush = Class(SimpleStaticView)

Bush.COLORS = {
	Color.fromHexString("c83737"),
	Color.fromHexString("8dd35f")
}

function Bush:getTextureFilename()
	return "Resources/Game/Props/TentacleBush_Default/Texture.png"
end

function Bush:getModelFilename()
	return "Resources/Game/Props/TentacleBush_Default/Model.lstatic", "Bush"
end

function Bush:load()
	SimpleStaticView.load(self)

	local resources = self:getResources()

	local offset = love.math.random()
	resources:queue(
		ShaderResource,
		"Resources/Shaders/StaticGuts",
		function(shader)
			self.decoration:getMaterial():setShader(shader)

			self.decoration:onWillRender(function(renderer)
				local shader = renderer:getCurrentShader()
				if shader:hasUniform("scape_Offset") then
					shader:send("scape_Offset", offset)
				end
			end)
		end)
end

function Bush:tick()
	SimpleStaticView.tick(self)

	local position = self:getProp():getPosition() / Vector(8)
	local value = math.abs(NoiseBuilder.TILE:sample3D(position.x, position.y, position.z))
	local index = math.floor((value * 10) % #Bush.COLORS + 1)
	self.decoration:getMaterial():setColor(Bush.COLORS[index])

	local transform = self.decoration:getTransform()
	local rotation = Quaternion.fromAxisAngle(Vector.UNIT_Y, math.pi * value * 2)
	local scale = Vector(1 + value * 0.5)
	transform:setLocalRotation(rotation)
	transform:setLocalScale(scale)

	self.decoration:tick()
end

return Bush
