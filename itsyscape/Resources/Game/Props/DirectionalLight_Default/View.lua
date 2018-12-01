--------------------------------------------------------------------------------
-- Resources/Game/Props/DirectionalLight_Default/View.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Vector = require "ItsyScape.Common.Math.Vector"
local LightView = require "Resources.Game.Props.Common.LightView"
local DirectionalLightSceneNode = require "ItsyScape.Graphics.DirectionalLightSceneNode"

local DirectionalLight = Class(LightView)

function DirectionalLight:getNodeType()
	return DirectionalLightSceneNode
end

function DirectionalLight:tick()
	LightView.tick(self)

	local state = self:getProp():getState()
	self:getLight():setDirection(Vector(unpack(state.direction)):getNormal())
end

return DirectionalLight
