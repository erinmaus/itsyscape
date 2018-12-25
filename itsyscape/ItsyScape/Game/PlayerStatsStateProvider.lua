--------------------------------------------------------------------------------
-- ItsyScape/Game/PlayerStatsStateProvider.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local State = require "ItsyScape.Game.State"
local StateProvider = require "ItsyScape.Game.StateProvider"
local StatsBehavior = require "ItsyScape.Peep.Behaviors.StatsBehavior"

local PlayerStatsStateProvider = Class(StateProvider)

function PlayerStatsStateProvider:new(peep)
	local stats = peep:getBehavior(StatsBehavior)
	if stats and stats.stats then
		self.stats = stats.stats
	else
		self.stats = false
	end

	self.peep = peep
end

-- To be honest there should only be one PlayerStatsStateProvider...
function PlayerStatsStateProvider:getPriority()
	return State.PRIORITY_IMMEDIATE
end

function PlayerStatsStateProvider:has(name, count, flags)
	return count <= self:count(name, flags)
end

function PlayerStatsStateProvider:take(name, count, flags)
	Log.error("trying to take XP from skill '%s'; not allowed!", name)
	return false
end

function PlayerStatsStateProvider:give(name, count, flags)
	if not self.stats then
		return false
	end

	if self.stats:hasSkill(name) then
		local skill = self.stats:getSkill(name)
		skill:addXP(count)

		return true
	end

	return false
end

function PlayerStatsStateProvider:count(name, flags)
	if not self.stats then
		return 0
	end

	if self.stats:hasSkill(name) then
		local skill = self.stats:getSkill(name)
		if skill then
			if flags['skill-unboosted'] then
				if flags['skill-as-level'] then
					return skill:getBaseLevel()
				else
					return skill:getXP()
				end
			else
				if flags['skill-as-level'] then
					return skill:getWorkingLevel()
				else
					return skill:getWorkingXP()
				end
			end
		end
	end

	return 0
end

return PlayerStatsStateProvider
