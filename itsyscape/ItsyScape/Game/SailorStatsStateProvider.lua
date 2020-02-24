--------------------------------------------------------------------------------
-- ItsyScape/Game/SailorStatsStateProvider.lua
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

local SailorStatsStateProvider = Class(StateProvider)

function SailorStatsStateProvider:new(peep, stats)
	self.stats = stats or false
	self.peep = peep
end

function SailorStatsStateProvider:getPriority()
	return State.PRIORITY_IMMEDIATE
end

function SailorStatsStateProvider:has(name, count, flags)
	return count <= self:count(name, flags)
end

function SailorStatsStateProvider:take(name, count, flags)
	Log.error("Trying to take XP from skill '%s'; not allowed!", name)
	return false
end

function SailorStatsStateProvider:give(name, count, flags)
	Log.warn(
		"Trying to give XP in skill '%s' to Sailor '%s; not allowed!",
		name,
		self.peep:getName())

	return false
end

function SailorStatsStateProvider:count(name, flags)
	if not self.stats then
		return 0
	end

	if self.stats:hasSkill("Sailing") then
		local skill = self.stats:getSkill("Sailing")
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

return SailorStatsStateProvider
