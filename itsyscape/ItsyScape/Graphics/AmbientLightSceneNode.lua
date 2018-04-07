--------------------------------------------------------------------------------
-- ItsyScape/Graphics/AmbientLightSceneNode.lua
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

AmbientLightSceneNode = Class(LightSceneNode)

function AmbientLightSceneNode:new()
	LightSceneNode.new(self)

	self.previousAmbience = false
	self.ambience = 0
end

function AmbientLightSceneNode:getAmbience()
	return self.ambience
end

function AmbientLightSceneNode:setAmbience(value)
	self.ambience = value or self.ambience
end

function AmbientLightSceneNode:toLight(delta)
	local result = LightSceneNode.toLight(self, delta)

	local previousAmbience = self.previousAmbience or self.ambience
	local ambience = previousAmbience * delta + self.ambience * (1 - delta)

	result:setAmbience(ambience)

	return result
end

function AmbientLightSceneNode:tick()
	LightSceneNode.tick(self)

	self.previousAmbience = self.ambience
end

return AmbientLightSceneNode
