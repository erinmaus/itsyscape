--------------------------------------------------------------------------------
-- ItsyScape/Game/ActionCommand/Bar.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Color = require "ItsyScape.Graphics.Color"
local Component = require "ItsyScape.Game.ActionCommands.Component"

local Bar = Class(Component)
Bar.TYPE = "bar"

function Bar:new()
	Component.new(self)

	self.currentValue = 0
	self.maximumValue = 1

	self.foregroundColor = Color(0, 1, 0)
	self.backgroundColor = Color(0, 0, 0)
end

function Bar:setValue(currentValue, maximumValue)
	self:setCurrentValue(currentValue)
	self:setMaximumValue(maximumValue)
end

function Bar:setCurrentValue(value)
	self.currentValue = value
end

function Bar:setMaximumValue(value)
	self.maximumValue = value
end

function Bar:getRatio()
	if self.maximumValue == 0 then
		if self.currentValue <= 0 then
			return 0
		else
			return 1
		end
	end

	return math.clamp(self.currentValue / self.maximumValue)
end

function Bar:setForegroundColor(value)
	self.foregroundColor = value
end

function Bar:getForegroundColor()
	return self.foregroundColor
end

function Bar:setBackgroundColor(value)
	self.backgroundColor = value
end

function Bar:getBackgroundColor()
	return self.backgroundColor
end

function Bar:serialize(t)
	Component.serialize(self, t)

	t.currentValue = self.currentValue
	t.maximumValue = self.maximumValue
	t.ratio = self:getRatio()
	t.foregroundColor = { self.foregroundColor:get() }
	t.backgroundColor = { self.backgroundColor:get() }
end

return Bar
