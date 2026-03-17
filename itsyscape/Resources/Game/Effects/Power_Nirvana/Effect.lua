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
local ZealPoke = require "ItsyScape.Game.ZealPoke"
local InfiniteInventoryStateProvider = require "ItsyScape.Game.InfiniteInventoryStateProvider"
local Effect = require "ItsyScape.Peep.Effect"
local ZealEffect = require "ItsyScape.Peep.Effects.ZealEffect"

-- Provides infinite runes.
local Nirvana = Class(ZealEffect)
Nirvana.DURATION = 30
Nirvana.EXTRA_ZEAL = 0.25

function Nirvana:new(activator)
	ZealEffect.new(self)

	local level = activator:getState():count(
		"Skill",
		"Wisdom",
		{ ['skill-as-level'] = true })
end

function Nirvana:modifyZealEvent(zealPoke, peep)
	if zealPoke:getType() == ZealPoke.TYPE_CAST_SPELL then
		print("yooooo----")
		zealPoke:forcePositive()
		zealPoke:addMultiplier(self.EXTRA_ZEAL)
		print("what----", zealPoke:getEffectiveZeal())
	end
end

function Nirvana:enchant(peep)
	ZealEffect.enchant(self, peep)

	self.runes = InfiniteInventoryStateProvider(peep)
	self.runes:add("AirRune")
	self.runes:add("EarthRune")
	self.runes:add("WaterRune")
	self.runes:add("FireRune")

	peep:getState():addProvider("Item", self.runes)
end

function Nirvana:sizzle()
	self:getPeep():getState():removeProvider("Item", self.runes)

	ZealEffect.sizzle(self)
end

function Nirvana:getBuffType()
	return Effect.BUFF_TYPE_POSITIVE
end

return Nirvana
