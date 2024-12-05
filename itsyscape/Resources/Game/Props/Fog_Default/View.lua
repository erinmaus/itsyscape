--------------------------------------------------------------------------------
-- Resources/Game/Props/Fog_Default/View.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Color = require "ItsyScape.Graphics.Color"
local PropView = require "ItsyScape.Graphics.PropView"
local FogSceneNode = require "ItsyScape.Graphics.FogSceneNode"

local Fog = Class(PropView)

function Fog:load()
	PropView.load(self)

	local root = self:getRoot()

	self.fog = FogSceneNode()
	self.fog:setParent(root)
end

function Fog:tick()
	PropView.tick(self)

	local state = self:getProp():getState()
	self.fog:setColor(Color(unpack(state.color or {})))
	self.fog:setFarDistance((state.distance and state.distance.far) or 0)
	self.fog:setNearDistance((state.distance and state.distance.near) or 0)

	if state.followTarget then
		self.fog:setFollowMode(FogSceneNode.FOLLOW_MODE_TARGET)
	elseif state.followEye then
		self.fog:setFollowMode(FogSceneNode.FOLLOW_MODE_EYE)
	elseif state.followSelf then
		self.fog:setFollowMode(FogSceneNode.FOLLOW_MODE_SELF)
	end
end

return Fog
