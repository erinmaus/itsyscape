--------------------------------------------------------------------------------
-- Resources/Game/Effects/Power_Nirvana/Effect.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Curve = require "ItsyScape.Game.Curve"
local InfiniteInventoryStateProvider = require "ItsyScape.Game.InfiniteInventoryStateProvider"
local Effect = require "ItsyScape.Peep.Effect"

-- Provides infinite runes.
local Nirvana = Class(Effect)
Nirvana.DURATION = 30

function Nirvana:new(activator)
	Effect.new(self)

	local level = activator:getState():count(
		"Skill",
		"Wisdom",
		{ ['skill-as-level'] = true })
end

function Nirvana:enchant(peep)
	Effect.enchant(self, peep)

	self.runes = InfiniteInventoryStateProvider(peep)
	self.runes:add("AirRune")
	self.runes:add("EarthRune")
	self.runes:add("WaterRune")
	self.runes:add("FireRune")

	peep:getState():addProvider("Item", self.runes)
end

function Nirvana:sizzle()
	self:getPeep():getState():removeProvider("Item", self.runes)

	Effect.sizzle(self)
end

function Nirvana:getBuffType()
	return Effect.BUFF_TYPE_POSITIVE
end

return Nirvana
