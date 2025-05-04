--------------------------------------------------------------------------------
-- Resources/Peeps/Props/Monitor.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Vector = require "ItsyScape.Common.Math.Vector"
local Utility = require "ItsyScape.Game.Utility"
local Color = require "ItsyScape.Graphics.Color"
local TVBehavior = require "ItsyScape.Peep.Behaviors.TVBehavior"
local PositionBehavior = require "ItsyScape.Peep.Behaviors.PositionBehavior"
local SizeBehavior = require "ItsyScape.Peep.Behaviors.SizeBehavior"
local BlockingProp = require "Resources.Game.Peeps.Props.BlockingProp"

local Monitor = Class(BlockingProp)
Monitor.TOGGLE_ON_TIME = 1
Monitor.TOGGLE_OFF_TIME = 9

function Monitor:new(resource, name, ...)
	BlockingProp.new(self, resource, 'TV', ...)

	self.time = 0
	self.isOn = false
end

function Monitor:update(...)
	BlockingProp.update(self, ...)

	local game = self:getDirector():getGameInstance()
	self.time = self.time + game:getDelta()
	if self.isOn and self.time > self.TOGGLE_OFF_TIME then
		self.time = 0
		self.isOn = false
	elseif not self.isOn and self.time > self.TOGGLE_ON_TIME then
		self.time = 0
		self.isOn = true
	end
end

function Monitor:getPropState()
	return {
		isOn = self.isOn
	}
end

return Monitor
