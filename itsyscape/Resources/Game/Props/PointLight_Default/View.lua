--------------------------------------------------------------------------------
-- Resources/Game/Props/PointLight_Default/View.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local LightView = require "Resources.Game.Props.Common.LightView"
local PointLightSceneNode = require "ItsyScape.Graphics.PointLightSceneNode"

local PointLight = Class(LightView)

function PointLight:getNodeType()
	return PointLightSceneNode
end

function PointLight:tick()
	LightView.tick(self)

	local state = self:getProp():getState()
	self:getLight():setAttenuation(state.attenuation)
end

return PointLight
