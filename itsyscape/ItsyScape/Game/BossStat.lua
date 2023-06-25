--------------------------------------------------------------------------------
-- ItsyScape/Game/BossStat.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Color = require "ItsyScape.Graphics.Color"

-- Represents the constant physical characteristics of an NPC, player, etc.
local BossStat = Class()

function BossStat:new(t)
	self.inColor = Color(0, 1, 0, 1)
	self.outColor = Color(1, 0, 0, 1)

	self:set(t)
end

function BossStat:set(t)
	t = t or {}
	self.inColor = Color(unpack(t.inColor or { self.inColor:get() }))
	self.outColor = Color(unpack(t.outColor or { self.outColor:get() }))
	self.text = t.text or self.text or false
	self.icon = t.icon or self.icon or false
	self.currentValue = t.current or self.currentValue or 0
	self.maxValue = t.max or self.maxValue or 1
	self.currentValueLabel = ""
	self.isBoolean = t.isBoolean or self.isBoolean or false
	self.isValue = t.isValue or self.isValue or false
	self.peep = t.peep or false
end

function BossStat:getPeep()
	return self.peep or nil
end

function BossStat:get()
	return {
		inColor = { self.inColor:get() },
		outColor = { self.outColor:get() },
		text = self.text,
		label = self.currentValueLabel,
		icon = self.icon,
		current = self.currentValue,
		max = self.maxValue,
		isBoolean = self.isBoolean,
		isValue = self.isValue
	}
end

return BossStat
