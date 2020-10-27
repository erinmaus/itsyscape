--------------------------------------------------------------------------------
-- Resources/Game/Effects/UnholySacrifice.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Vector = require "ItsyScape.Common.Math.Vector"
local Equipment = require "ItsyScape.Game.Equipment"
local Utility = require "ItsyScape.Game.Utility"
local Effect = require "ItsyScape.Peep.Effect"
local StatsBehavior = require "ItsyScape.Peep.Behaviors.StatsBehavior"
local CombatStatusBehavior = require "ItsyScape.Peep.Behaviors.CombatStatusBehavior"

-- Restores prayer by 1% of Necromancy level (rounded up) per 5 seconds.
--
-- Can boost prayer points up to 20% (rounded up) above maximum points.
local UnholySacrifice = Class(Effect)
UnholySacrifice.DURATION = math.huge
UnholySacrifice.TICK = 5

function UnholySacrifice:new(...)
	Effect.new(self, ...)

	self.tick = 0
end

function UnholySacrifice:getBuffType()
	return Effect.BUFF_TYPE_POSITIVE
end

function UnholySacrifice:update(delta)
	Effect.update(self, delta)

	local peep = self:getPeep()

	local weapon = Utility.Peep.getEquippedItem(peep, Equipment.PLAYER_SLOT_RIGHT_HAND) or
		Utility.Peep.getEquippedItem(peep, Equipment.PLAYER_SLOT_TWO_HANDED)
	local pocket = Utility.Peep.getEquippedItem(peep, Equipment.PLAYER_SLOT_POCKET)
	local hasUnholySacrificialKnife = weapon and weapon:getID() == "UnholySacrificialKnife"
	local hasCreepyDoll = pocket and pocket:getID() == "CreepyDoll"
	if not hasUnholySacrificialKnife and not hasCreepyDoll then
		peep:removeEffect(self)
		return
	end

	self.tick = self.tick - delta
	if self.tick <= 0 then
		local stats = peep:getBehavior(StatsBehavior)
		if stats and stats.stats then
			stats = stats.stats

			local faithSkill = stats:getSkill("Necromancy")
			local faithLevel = faithSkill:getWorkingLevel()
			local prayerRestoration = faithLevel / 100

			local combat = peep:getBehavior(CombatStatusBehavior)
			if combat then
				local maxBoost = math.max(math.floor(faithLevel * 1.2 + 0.5), 2)
				local restoration = math.floor(math.max(prayerRestoration + 0.5, 1))
				combat.currentPrayer = combat.currentPrayer + restoration
				combat.currentPrayer = math.min(maxBoost, combat.currentPrayer)
			end

			local secondsToNextTick = math.max(UnholySacrifice.TICK / prayerRestoration, 1)
			self.tick = secondsToNextTick
		end

		local stage = peep:getDirector():getGameInstance():getStage()
		stage:fireProjectile("UnholySacrifice", peep, Vector.ZERO)
	end
end

return UnholySacrifice
