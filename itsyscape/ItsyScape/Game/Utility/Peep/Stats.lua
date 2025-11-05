--------------------------------------------------------------------------------
-- ItsyScape/Game/Utility/Peep/Stats.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local PlayerStatsStateProvider = require "ItsyScape.Game.PlayerStatsStateProvider"
local Utility = require "ItsyScape.Game.Utility"
local PeepStats = require "ItsyScape.Game.Stats"
local CombatStatusBehavior = require "ItsyScape.Peep.Behaviors.CombatStatusBehavior"
local StatsBehavior = require "ItsyScape.Peep.Behaviors.StatsBehavior"

local Stats = {}

function Stats.onAssign(max, self, director)
	local stats = self:getBehavior(StatsBehavior)
	if stats then
		stats.stats = PeepStats(self:getName(), director:getGameDB(), max)
		stats.stats:getSkill("Constitution").onLevelUp:register(function(skill, oldLevel)
			local difference = math.max(skill:getBaseLevel() - oldLevel, 0)

			local combat = self:getBehavior(CombatStatusBehavior)
			if combat then
				combat.maximumHitpoints = combat.maximumHitpoints + difference
				combat.currentHitpoints = combat.currentHitpoints + difference
			end
		end)
		stats.stats:getSkill("Faith").onLevelUp:register(function(skill, oldLevel)
			local difference = math.max(skill:getBaseLevel() - oldLevel, 0)

			local combat = self:getBehavior(CombatStatusBehavior)
			if combat then
				combat.maximumPrayer = combat.maximumPrayer + difference
				combat.currentPrayer = combat.currentPrayer + difference
			end
		end)
	end
end

function Stats:onReady(director)
	local stats = self:getBehavior(StatsBehavior)
	if stats and stats.stats then
		stats = stats.stats
		local function setStats(records)
			for i = 1, #records do
				local skill = records[i]:get("Skill").name
				local xp = records[i]:get("Value")

				if stats:hasSkill(skill) then
					stats:getSkill(skill):setXP(xp)
				else
					Log.warn("Skill %s not found on Peep %s.", skill, self:getName())
				end
			end
		end

		local gameDB = director:getGameDB()
		local resource = Utility.Peep.getResource(self)
		local mapObject = Utility.Peep.getMapObject(self)

		if resource then
			setStats(gameDB:getRecords("PeepStat", { Resource = resource }))
		end

		if mapObject then
			setStats(gameDB:getRecords("PeepStat", { Resource = mapObject }))
		end
	end

	Log.info("%s combat level: %d (%d [from tier = %d, from hitpoints = %d] XP)", self:getName(), Utility.Combat.getCombatLevel(self), Utility.Combat.getCombatXP(self))

	self:getState():addProvider("Skill", PlayerStatsStateProvider(self))
end

function Stats:onFinalize(director)
	local combat = self:getBehavior(CombatStatusBehavior)
	local stats = self:getBehavior(StatsBehavior)
	if combat and stats and stats.stats then
		stats = stats.stats

		combat.maximumHitpoints = math.max(stats:getSkill("Constitution"):getWorkingLevel(), combat.maximumHitpoints)
		combat.currentHitpoints = math.max(stats:getSkill("Constitution"):getWorkingLevel(), combat.currentHitpoints)
		combat.maximumPrayer = math.max(stats:getSkill("Faith"):getWorkingLevel(), combat.maximumPrayer)
		combat.currentPrayer = math.max(stats:getSkill("Faith"):getWorkingLevel(), combat.currentPrayer)
	end
end

return Stats