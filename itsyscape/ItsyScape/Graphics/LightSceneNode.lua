--------------------------------------------------------------------------------
-- ItsyScape/Graphics/LightSceneNode.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local SceneNode = require "ItsyScape.Graphics.SceneNode"
local Color = require "ItsyScape.Graphics.Color"
local Light = require "ItsyScape.Graphics.Light"

-- Basic light Scene Node.
local LightSceneNode = Class(SceneNode)

function LightSceneNode:new()
	SceneNode.new(self)

	self.previousColor = false
	self.color = Color(1, 1, 1)
	self.isGlobal = false
end

-- Gets if the light is global.
--
-- Global lights are always used to light an object (e.g., forward rendering).
function LightSceneNode:getIsGlobal()
	return self.isGlobal
end

-- Sets if the light is global. See LightSceneNode.getIsGlobal.
--
-- The default value is false.
function LightSceneNode:setIsGlobal(value)
	if not value then
		self.isGlobal = false
	else
		self.isGlobal = true
	end
end

-- Gets the color of the light.
--
-- The default light color is { 1, 1, 1 }. Alpha is ignored.
function LightSceneNode:getColor()
	return self.color
end

-- Sets the color of the light.
--
-- Does nothing if value is falsey.
function LightSceneNode:setColor(value)
	self.color = value or self.color
end

-- Converts the LightSceneNode to a Light object.
function LightSceneNode:toLight(delta)
	local result = Light()

	local previousColor = self.previousColor or self.color
	local color = previousColor:lerp(self.color, delta)
	result:setColor(color)

	return result
end

function LightSceneNode:tick()
	SceneNode.tick(self)

	self.previousColor = self.color
end

return LightSceneNode
