--------------------------------------------------------------------------------
-- ItsyScape/Peep/Cortexes/PrayerDrainCortex.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

local Class = require "ItsyScape.Common.Class"
local Utility = require "ItsyScape.Game.Utility"
local Cortex = require "ItsyScape.Peep.Cortex"
local PrayerCombatEffect = require "ItsyScape.Peep.Effects.PrayerCombatEffect"
local CombatStatusBehavior = require "ItsyScape.Peep.Behaviors.CombatStatusBehavior"

local PrayerDrainCortex = Class(Cortex)

function PrayerDrainCortex:new()
	Cortex.new(self)

	self:require(CombatStatusBehavior)
	self.ticks = {}
end

function PrayerDrainCortex:removePeep(peep)
	Cortex.removePeep(self, peep)

	self.ticks[peep] = nil
end

function PrayerDrainCortex:update()
	local game = self:getDirector():getGameInstance()
	local delta = game:getDelta()

	for peep in self:iterate() do
		local drain = 0
		do
			for effect in peep:getEffects(PrayerCombatEffect) do
				drain = drain + effect:getDrain()
			end
		end

		local faithLevel = peep:getState():count(
			"Skill",
			"Faith",
			{ ['skill-as-level'] = true })
		if faithLevel then
			drain = drain + (self.ticks[peep] or 0)
			local resistance
			do
				local bonuses = Utility.Peep.getEquipmentBonuses(peep)
				resistance = math.max(60 + (bonuses['Prayer'] * game:getTicks() * (faithLevel / 10)), 0)
			end

			local status = peep:getBehavior(CombatStatusBehavior)
			if status then
				while drain > resistance do
					drain = drain - resistance

					status.currentPrayer = math.max(status.currentPrayer - 1, 0)
				end
			end

			self.ticks[peep] = drain
		end
	end
end

return PrayerDrainCortex
