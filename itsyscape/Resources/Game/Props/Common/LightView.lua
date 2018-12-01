--------------------------------------------------------------------------------
-- Resources/Game/Props/Common/LightView.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Vector = require "ItsyScape.Common.Math.Vector"
local Color = require "ItsyScape.Graphics.Color"
local PropView = require "ItsyScape.Graphics.PropView"

local LightView = Class(PropView)

function LightView:getNodeType()
	return Class.ABSTRACT()
end

function LightView:getLight()
	return self.light
end

function LightView:load()
	PropView.load(self)

	local root = self:getRoot()

	local NodeType = self:getNodeType()

	self.light = NodeType()
	self.light:setParent(root)
end

function LightView:tick()
	PropView.tick(self)

	local state = self:getProp():getState()
	self.light:setColor(Color(unpack(state.color)))
	self.light:setIsGlobal(state.global)
end

return LightView
