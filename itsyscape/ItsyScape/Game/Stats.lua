--------------------------------------------------------------------------------
-- ItsyScape/Game/Stats.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Curve = require "ItsyScape.Game.Curve"
local Mapp = require "ItsyScape.GameDB.Mapp"

-- Stores stats.
--
-- Stats are stored as a map between xp and levels.
local Stats = Class()

-- Provides functionality for a specific skill entry.
Stats.Skill = Class()
Stats.Skill.MAX = 99

function Stats.Skill:new(name)
	self.name = name
	self.xp = 0
	self.level = 1
	self.levelBoost = 0
	self.isDirty = false
end

-- Gets the name of the skill.
function Stats.Skill:getName()
	return self.name
end

-- Adds XP, 'amount'.
--
-- 'amount' is clamped to zero.
function Stats.Skill:addXP(amount)
	self.xp = math.max(math.floor(self.xp), 0)
	self.isDirty = true
end

-- Sets the XP directly.
--
-- This is generally a bad idea.
--
-- 'xp' is clamped to 0.
function Stats.Skill:setXP(value)
	self.xp = math.max(value, 0)
	self.isDirty = true
end

-- Gets how much XP the skill has.
function Stats.Skill:getXP()
	return self.xp
end

-- Gets the 'working' XP.
--
-- This includes the additional amount of XP to equal the working level.
function Stats.Skill:getWorkingXP()
	local xpDifference = self.xp - Curve.XP_CURVE:compute(self:getBaseLevel() + 1)
	local workingXP = Curve.XP_CURVE:compute(self:getWorkingLevel())
	return xpDifference + workingXP
end

-- Gets the level boost.
function Stats.Skill:getLevelBoost()
	return self.levelBoost
end

-- Sets the level boost.
--
-- Values may be below zero for debuffs.
function Stats.Skill:setLevelBoost(value)
	self.levelBoost = math.floor(value)
end

-- Gets the base level. This is the level derived from XP.
function Stats.Skill:getBaseLevel()
	if self.isDirty then
		self.level = Curve.XP_CURVE:getLevel(self.xp, Stats.Skill.MAX)
		self.isDirty = false
	end

	return self.level
end

-- Gets the working level.
--
-- This is the sum of baseLevel + levelBoost, clamped to zero.
function Stats.Skill:getWorkingLevel()
	return math.max(self:getBaseLevel() + self.levelBoost, 0)
end

-- Creates a new Stats using skills in 'gameDB'.
function Stats:new(id, gameDB)
	self.id = id
	self.skills = {}
	self.skillsByIndex = {}

	local brochure = gameDB:getBrochure()
	local resourceType = Mapp.ResourceType()
	if brochure:tryGetResourceType("Skill", resourceType) then
		for resource in brochure:findResourcesByType(resourceType) do
			local skill = Stats.Skill(resource.name)
			self.skills[resource.name] = skill
			table.insert(self.skillsByIndex, skill)
		end
	end
end

function Stats:getID()
	return self.id
end

-- Returns true if skill 'skill' exists, false otherwise.
function Stats:hasSkill(skill)
	return self.skills[skill] ~= nil
end

-- Iterates over the skills.
--
-- The iterator returns the skill.
function Stats:iterate()
	local index = 1
	return function()
		local current = self.skillsByIndex[index]
		if index <= #self.skillsByIndex then
			index = index + 1
		end

		return current
	end
end

-- Gets skill 'skill'.
--
-- The skill must exist.
function Stats:getSkill(skill)
	assert(self:hasSkill(skill), "skill not found")

	return self.skills[skill]
end

-- Loads the stats from a save file.
--
-- NYI.
function Stats:load(...)
	-- Nothing.
end

-- Saves the stats into a save file.
--
-- NYI.
function Stats:save(...)
	-- Nothing.
end

return Stats
