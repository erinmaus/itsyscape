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

local FogSceneNode = Class(LightSceneNode)
FogSceneNode.FOLLOW_MODE_EYE    = 1
FogSceneNode.FOLLOW_MODE_TARGET = 2

function FogSceneNode:new()
	LightSceneNode.new(self)

	self.nearDistance = 0
	self.farDistance = 100
	self.followMode = FogSceneNode.FOLLOW_MODE_EYE
end

function FogSceneNode:getNearDistance()
	return self.nearDistance
end

function FogSceneNode:setNearDistance(value)
	self.nearDistance = value or self.nearDistance
end

function FogSceneNode:getFarDistance()
	return self.farDistance
end

function FogSceneNode:setFarDistance(value)
	self.farDistance = value or self.farDistance
end

function FogSceneNode:setAttenuation(value)
	self.attenuation = value or self.attenuation
end

function FogSceneNode:getFollowMode()
	return self.followMode
end

function FogSceneNode:setFollowMode(value)
	self.followMode = value or self.followMode
end

function FogSceneNode:toLight(delta)
	local result = LightSceneNode.toLight(self, delta)
	local x, y, z = self:getTransform():getGlobalDeltaTransform(delta):transformPoint(0, 0, 0)

	delta = 1 - delta
	local previousNearDistance = self.previousNearDistance or self.nearDistance
	local nearDistance = self.nearDistance * (1 - delta) + previousNearDistance * delta
	local previousFarDistance = self.previousFarDistance or self.farDistance
	local farDistance = self.farDistance * (1 - delta) + previousFarDistance * delta

	result:setAttenuation(farDistance)
	result:setPosition(Vector(0, 0, nearDistance))

	return result
end

function FogSceneNode:tick()
	LightSceneNode.tick(self)

	self.previousNearDistance = self.nearDistance
	self.previousFarDistance = self.farDistance
end

return FogSceneNode
