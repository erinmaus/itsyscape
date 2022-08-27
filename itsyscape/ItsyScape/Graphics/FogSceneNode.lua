--------------------------------------------------------------------------------
-- ItsyScape/Graphics/FogSceneNode.lua
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
local NFogSceneNode = require "nbunny.optimaus.scenenode.fogscenenode"

local FogSceneNode = Class(LightSceneNode)
FogSceneNode.FOLLOW_MODE_EYE    = 0
FogSceneNode.FOLLOW_MODE_TARGET = 1
FogSceneNode.FOLLOW_MODE_SELF   = 2

function FogSceneNode:new()
	LightSceneNode.new(self, NFogSceneNode)
end

function FogSceneNode:getNearDistance()
	return self:getHandle():getCurrentNearDistance()
end

function FogSceneNode:setNearDistance(value)
	self:getHandle():setCurrentNearDistance(value)
end

function FogSceneNode:getPreviousNearDistance()
	return self:getHandle():getPreviousNearDistance()
end

function FogSceneNode:setPreviousNearDistance(value)
	self:getHandle():setPreviousNearDistance(value)
end

function FogSceneNode:getFarDistance()
	return self:getHandle():getCurrentFarDistance()
end

function FogSceneNode:setFarDistance(value)
	self:getHandle():setCurrentFarDistance(value)
end

function FogSceneNode:getPreviousFarDistance()
	return self:getHandle():getPreviousFarDistance()
end

function FogSceneNode:setPreviousFarDistance(value)
	self:getHandle():setPreviousFarDistance(value)
end

function FogSceneNode:getFollowMode()
	self:getHandle():getFollowMode()
end

function FogSceneNode:setFollowMode(value)
	self:getHandle():setFollowMode(value)
end

function FogSceneNode:toLight(delta)
	local result = LightSceneNode.toLight(self, delta)
	local x, y, z = self:getTransform():getGlobalDeltaTransform(delta):transformPoint(0, 0, 0)

	delta = 1 - delta
	local previousNearDistance = self:getPreviousNearDistance()
	local nearDistance = self:getCurrentNearDistance() * (1 - delta) + previousNearDistance * delta
	local previousFarDistance = self:getPreviousFarDistance()
	local farDistance = self:getFarDistance() * (1 - delta) + previousFarDistance * delta

	result:setAttenuation(farDistance)
	result:setPosition(Vector(0, 0, nearDistance))

	return result
end

return FogSceneNode
