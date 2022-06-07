--------------------------------------------------------------------------------
-- ItsyScape/Graphics/DirectionalLightSceneNode.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Vector = require "ItsyScape.Common.Math.Vector"
local LightSceneNode = require "ItsyScape.Graphics.LightSceneNode"
local NDirectionalLightSceneNode = require "nbunny.optimaus.scenenode.directionallightscenenode"

local DirectionalLightSceneNode = Class(LightSceneNode)

function DirectionalLightSceneNode:new()
	LightSceneNode.new(self, NDirectionalLightSceneNode)
end

function DirectionalLightSceneNode:getDirection()
	return Vector(self:getHandle():getCurrentDirection())
end

function DirectionalLightSceneNode:setDirection(value)
	self:getHandle():setCurrentDirection(value:getNormal():get())
end

function DirectionalLightSceneNode:getPreviousDirection()
	return Vector(self:getHandle():getPreviousDirection())
end

function DirectionalLightSceneNode:setPreviousDirection(value)
	self:getHandle():setPreviousDirection(value:getNormal():get())
end

function DirectionalLightSceneNode:toLight(delta)
	local result = LightSceneNode.toLight(self, delta)

	local previousDirection = self:getPreviousDirection()
	local currentDirection = self:getDirection()
	result:setPosition(previousDirection:lerp(currentDirection, delta))

	return result
end

function DirectionalLightSceneNode:tick()
	LightSceneNode.tick(self)

	self.previousDirection = self.direction
end

return DirectionalLightSceneNode
