--------------------------------------------------------------------------------
-- ItsyScape/Game/Score.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Color = require "ItsyScape.Graphics.Color"

-- Represents a score.
local Score = Class()

function Score:new(t)
	self:set(t)
end

function Score:set(t)
	t = t or {}
	self.text = t.text or self.text or false
	self.icon = t.icon or self.icon or false
	self.currentValue = t.current or self.currentValue or 0
	self.precision = t.precision or self.precision or 3
end

function Score:get()
	return {
		text = self.text,
		icon = self.icon,
		current = self.currentValue,
		precision = self.precision
	}
end

return Score
