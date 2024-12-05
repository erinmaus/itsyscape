--------------------------------------------------------------------------------
-- Resources/Game/Props/AmbientLight_Default/View.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local LightView = require "Resources.Game.Props.Common.LightView"
local AmbientLightSceneNode = require "ItsyScape.Graphics.AmbientLightSceneNode"

local AmbientLight = Class(LightView)

function AmbientLight:getNodeType()
	return AmbientLightSceneNode
end

function AmbientLight:tick()
	LightView.tick(self)

	local state = self:getProp():getState()
	self:getLight():setAmbience(state.ambience or 1)
end

return AmbientLight
