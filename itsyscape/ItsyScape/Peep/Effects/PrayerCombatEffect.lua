--------------------------------------------------------------------------------
-- ItsyScape/Peep/Effects/PrayerCombatEffect.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local CombatEffect = require "ItsyScape.Peep.Effects.CombatEffect"
local CombatStatusBehavior = require "ItsyScape.Peep.Behaviors.CombatStatusBehavior"

local PrayerCombatEffect = Class(CombatEffect)

function PrayerCombatEffect:enchant(peep)
	CombatEffect.enchant(self, peep)

	local gameDB = peep:getDirector():getGameDB()
	local prayer = gameDB:getRecord("Prayer", {
		Resource = self:getResource()
	})

	if prayer then
		self.drain = prayer:get("Drain")
	end
end

function PrayerCombatEffect:getDrain()
	return self.drain or 0
end

function PrayerCombatEffect:update(delta)
	CombatEffect.update(self, delta)

	local peep = self:getPeep()
	if peep then
		local status = peep:getBehavior(CombatStatusBehavior)
		if not status or status.currentPrayer <= 0 then
			peep:removeEffect(self)
		end
	end
end

return PrayerCombatEffect
