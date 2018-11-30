--------------------------------------------------------------------------------
-- Resources/Game/Effects/WeakPrayerRestorationEffect.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Effect = require "ItsyScape.Peep.Effect"
local StatsBehavior = require "ItsyScape.Peep.Behaviors.StatsBehavior"
local CombatStatusBehavior = require "ItsyScape.Peep.Behaviors.CombatStatusBehavior"

-- Restores prayer by 1% (rounded up) per second.
--
-- Can boost prayer points up to 10% (rounded up) above maximum points.
local WeakPrayerRestorationEffect = Class(Effect)
WeakPrayerRestorationEffect.DURATION = 120

function WeakPrayerRestorationEffect:new(...)
	Effect.new(self, ...)

	self.tick = 0
end

function WeakPrayerRestorationEffect:update(delta)
	Effect.update(self, delta)

	self.tick = self.tick - delta
	if self.tick <= 0 then
		local peep = self:getPeep()
		local stats = peep:getBehavior(StatsBehavior)
		if stats and stats.stats then
			stats = stats.stats

			local faithSkill = stats:getSkill("Faith")
			local faithLevel = faithSkill:getWorkingLevel()
			local prayerRestoration = faithLevel / 100

			local combat = peep:getBehavior(CombatStatusBehavior)
			if combat then
				local maxBoost = math.max(math.floor(faithLevel * 1.1 + 0.5), 2)
				local restoration = math.floor(math.max(prayerRestoration + 0.5, 1))
				combat.currentPrayer = combat.currentPrayer + restoration
				combat.currentPrayer = math.min(maxBoost, combat.currentPrayer)
			end

			local secondsToNextTick = math.max(1 / prayerRestoration, 1)
			self.tick = secondsToNextTick
		else
			peep:removeEffect(self)
		end
	end
end

return WeakPrayerRestorationEffect
