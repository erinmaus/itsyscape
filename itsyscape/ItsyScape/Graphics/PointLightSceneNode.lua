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

local PointLightSceneNode = Class(LightSceneNode)

function PointLightSceneNode:new()
	LightSceneNode.new(self)

	self.attenuation = 1
end

function PointLightSceneNode:getAttenuation()
	return self.attenuation
end

function PointLightSceneNode:setAttenuation(value)
	self.attenuation = value or self.attenuation
end

function PointLightSceneNode:toLight(delta)
	local result = LightSceneNode.toLight(self, delta)
	local x, y, z = self:getTransform():getGlobalDeltaTransform(delta):transformPoint(0, 0, 0)

	local previousAttenutation = self.previousAttenutation or self.attenuation
	local attenuation = self.attenuation * (1 - delta) + previousAttenutation * delta
	result:setAttenuation(attenuation)
	result:setPosition(Vector(x, y, z))

	return result
end

function PointLightSceneNode:tick()
	LightSceneNode.tick(self)

	self.previousAttenutation = self.attenuation
end

return PointLightSceneNode
