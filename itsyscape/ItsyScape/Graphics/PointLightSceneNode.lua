--------------------------------------------------------------------------------
-- ItsyScape/Graphics/PointLightSceneNode.lua
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
local NPointLightSceneNode = require "nbunny.optimaus.scenenode.pointlightscenenode"

local PointLightSceneNode = Class(LightSceneNode)

function PointLightSceneNode:new()
	LightSceneNode.new(self, NPointLightSceneNode)
end

function PointLightSceneNode:getAttenuation()
	return self:getHandle():getCurrentAttenuation()
end

function PointLightSceneNode:setAttenuation(value)
	self:getHandle():setCurrentAttenuation(value)
end

function PointLightSceneNode:getPreviousAttenuation()
	return self:getHandle():getPreviousAttenuation()
end

function PointLightSceneNode:setPreviousAttenuation(value)
	self:getHandle():setPreviousAttenuation(value)
end

function PointLightSceneNode:toLight(delta)
	local result = LightSceneNode.toLight(self, delta)
	local x, y, z = self:getTransform():getGlobalDeltaTransform(delta):transformPoint(0, 0, 0)

	local previousAttenutation = self:getPreviousAttenuation()
	local currentAttenuation = self:getAttenuation()
	local attenuation = currentAttenuation * (1 - delta) + previousAttenutation * delta
	result:setAttenuation(attenuation)
	result:setPosition(Vector(x, y, z))
	result:setPoint()

	return result
end

function PointLightSceneNode:fromLight(light)
	LightSceneNode.fromLight(self, light)
	self:setAttenuation(light:getAttenuation())
end

return PointLightSceneNode
