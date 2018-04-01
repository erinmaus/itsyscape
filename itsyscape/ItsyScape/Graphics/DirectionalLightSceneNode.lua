--------------------------------------------------------------------------------
-- ItsyScape/Graphics/DirectionalLightSceneNode.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
-------------------------------------------------------------------------------

local Class = require "ItsyScape.Common.Class"
local Vector = require "ItsyScape.Common.Math.Vector"
local LightSceneNode = require "ItsyScape.Graphics.LightSceneNode"

DirectionalLightSceneNode = Class(LightSceneNode)

function DirectionalLightSceneNode:new()
	LightSceneNode.new(self)

	self.previousDirection = false
	self.direction = Vector(1, 0, 1):getNormal()
end

function DirectionalLightSceneNode:getDirection()
	return self.direction
end

function DirectionalLightSceneNode:setDirection(value)
	self.direction = value or self.direction
end

function DirectionalLightSceneNode:toLight(delta)
	local result = LightSceneNode.toLight(self, delta)

	local previousDirection = self.previousDirection or self.direction
	result:setDirectional()
	result:setPosition(previousDirection:lerp(self.direction, delta))

	return result
end

function DirectionalLightSceneNode:tick()
	LightSceneNode.tick(self)

	self.previousDirection = self.direction
end

return DirectionalLightSceneNode
