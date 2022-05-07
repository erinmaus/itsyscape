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
local NAmbientLightSceneNode = require "nbunny.optimaus.scenenode.ambientlightscenenode"

local AmbientLightSceneNode = Class(LightSceneNode)

function AmbientLightSceneNode:new()
	LightSceneNode.new(self, NAmbientLightSceneNode)
end

function AmbientLightSceneNode:getAmbience()
	return self:getHandle():getCurrentAmbience()
end

function AmbientLightSceneNode:setAmbience(value)
	self:getHandle():setCurrentAmbience(value)
end

function AmbientLightSceneNode:getPreviousAmbience()
	return self:getHandle():getPreviousAmbience()
end

function AmbientLightSceneNode:setPreviousAmbience(value)
	self:getHandle():setPreviousAmbience(value)
end

function AmbientLightSceneNode:toLight(delta)
	local result = LightSceneNode.toLight(self, delta)

	local currentAmbience = self:getAmbience()
	local previousAmbience = self:getPreviousAmbience()
	local ambience = previousAmbience * delta + currentAmbience * (1 - delta)

	result:setAmbience(ambience)

	return result
end

function AmbientLightSceneNode:fromLight(light)
	LightSceneNode.fromLight(self, light)

	self:setAmbience(light:getAmbience())
end

return AmbientLightSceneNode
