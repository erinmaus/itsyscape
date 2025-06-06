--------------------------------------------------------------------------------
-- ItsyScape/UI/PlayerStatsController.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Curve = require "ItsyScape.Game.Curve"
local Utility = require "ItsyScape.Game.Utility"
local Mapp = require "ItsyScape.GameDB.Mapp"
local Controller = require "ItsyScape.UI.Controller"
local StatsBehavior = require "ItsyScape.Peep.Behaviors.StatsBehavior"

local PlayerStatsController = Class(Controller)

PlayerStatsController.SKILLS_SORT_ORDER = {
	"Constitution",
	"Magic",
	"Wisdom",
	"Attack",
	"Strength",
	"Archery",
	"Dexterity",
	"Defense",
	"Faith",
	"Mining",
	"Woodcutting",
	"Fishing",
	"Foraging",
	"Smithing",
	"Crafting",
	"Cooking",
	"Engineering",
	"Firemaking",
	"Sailing",
	"Antilogika",
	"Necromancy"
}

local function _sortSkills(a, b)
	local aIndex, bIndex

	for i, skill in ipairs(PlayerStatsController.SKILLS_SORT_ORDER) do
		if a.id == skill then
			aIndex = i
		end

		if b.id == skill then
			bIndex = i
		end
	end

	return aIndex < bIndex
end

function PlayerStatsController:new(peep, director)
	Controller.new(self, peep, director)
end

function PlayerStatsController:poke(actionID, actionIndex, e)
	if actionID == "open" then
		self:openSkillGuide(e)
	else
		Controller.poke(self, actionID, actionIndex, e)
	end
end

function PlayerStatsController:pull()
	local stats = self:getPeep():getBehavior(StatsBehavior)

	local gameDB = self:getDirector():getGameDB()

	local result = { skills = {}, totalLevel = 0, combatLevel = Utility.Combat.getCombatLevel(self:getPeep()) }
	if stats and stats.stats then
		stats = stats.stats

		for skill in stats:iterate() do
			local s = gameDB:getResource(skill:getName(), "Skill")

			result.totalLevel = result.totalLevel + skill:getBaseLevel()

			table.insert(result.skills, {
				id = skill:getName(),
				name = Utility.getName(s, gameDB),
				description = Utility.getDescription(s, gameDB),
				xp = skill:getXP(),
				workingLevel = skill:getWorkingLevel(),
				baseLevel = skill:getBaseLevel(),
				xpNextLevel = math.max(Curve.XP_CURVE:compute(skill:getBaseLevel() + 1) - skill:getXP(), 0),
				xpPastCurrentLevel = skill:getXP() - Curve.XP_CURVE:compute(skill:getBaseLevel()),
				nextLevelXP = Curve.XP_CURVE:compute(skill:getBaseLevel() + 1) - Curve.XP_CURVE:compute(skill:getBaseLevel())
			})
		end
	else
		Log.warnOnce("Player '%s' lost stats (has behavior = %s, has stats = %s).", self:getPeep():getName(), Log.boolean(stats), Log.boolean(stats and stats.stats))
	end

	table.sort(result.skills, _sortSkills)

	return result
end

function PlayerStatsController:openSkillGuide(e)
	self:getGame():getUI():interrupt(self:getPeep())
	self:getGame():getUI():openBlockingInterface(self:getPeep(), "SkillGuide", e.skill)
end

return PlayerStatsController
