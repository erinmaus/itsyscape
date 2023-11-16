--------------------------------------------------------------------------------
-- ItsyScape/Peep/Cortexes/StatDrainCortex.lua
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
local StatsBehavior = require "ItsyScape.Peep.Behaviors.StatsBehavior"

local StatDrainCortex = Class(Cortex)
StatDrainCortex.TIME_TO_DRAIN_IN_SECS = 60

function StatDrainCortex:new()
	Cortex.new(self)

	self:require(StatsBehavior)

	self.nextDrain = StatDrainCortex.TIME_TO_DRAIN_IN_SECS
end

function StatDrainCortex:update()
	local game = self:getDirector():getGameInstance()
	local delta = game:getDelta()

	self.nextDrain = self.nextDrain - delta
	while self.nextDrain <= 0 do
		self.nextDrain = self.nextDrain + StatDrainCortex.TIME_TO_DRAIN_IN_SECS

		for peep in self:iterate() do
			local stats = peep:getBehavior(StatsBehavior)
			stats = stats and stats.stats

			for stat in stats:iterate() do
				local levelBoost = stat:getLevelBoost()

				if levelBoost > 0 then
					levelBoost = levelBoost - 1
				elseif levelBoost < 0 then
					levelBoost = levelBoost + 1
				end

				stat:setLevelBoost(levelBoost)
			end
		end
	end
end

return StatDrainCortex
