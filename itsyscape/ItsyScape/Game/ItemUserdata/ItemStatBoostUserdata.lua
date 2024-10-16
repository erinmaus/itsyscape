--------------------------------------------------------------------------------
-- ItsyScape/Game/ItemUserdata/ItemStatBoostUserdata.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local ItemUserdata = require "ItsyScape.Game.ItemUserdata"
local Utility = require "ItsyScape.Game.Utility"
local StatsBehavior = require "ItsyScape.Peep.Behaviors.StatsBehavior"

local ItemStatBoostUserdata = Class(ItemUserdata)

function ItemStatBoostUserdata:new(...)
	ItemUserdata.new(self, ...)

	self.skillBoosts = {}
end

function ItemStatBoostUserdata:getBoost(skill)
	return self.skillBoosts[skill] or 0
end

function ItemStatBoostUserdata:setBoost(skill, level)
	if level == 0 then
		self.skillBoosts[skill] = nil
	else
		self.skillBoosts[skill] = level
	end
end

function ItemStatBoostUserdata:iterateSkillBoosts()
	return pairs(self.skillBoosts)
end

function ItemStatBoostUserdata:getDescription()
	if not next(self.skillBoosts) then
		return nil
	end

	local result = {}
	for skill, boost in self:iterateSkillBoosts() do
		local skillResource = self:getGameDB():getResource(skill, "Skill")
		local skillName = Utility.getName(skillResource, self:getGameDB()) or ("*" .. skillResource.name)

		if boost < 0 then
			table.insert(result, "- " .. self:buildDescription("Message_ItemStatBoostUserdata_Debuff", skillName, math.abs(boost)))
		elseif boost > 0 then
			table.insert(result, "- " .. self:buildDescription("Message_ItemStatBoostUserdata_Buff", skillName, boost))
		end
	end

	table.sort(result)
	return table.concat(result, "\n")
end

function ItemStatBoostUserdata:combine(otherUserdata)
	if otherUserdata:getType() ~= self:getType() then
		return false
	end

	for skill, boost in otherUserdata:iterateSkillBoosts() do
		self:setBoost(skill, self:getBoost(skill) + boost)
	end

	return true
end

function ItemStatBoostUserdata:serialize()
	return self.skillBoosts
end

function ItemStatBoostUserdata:deserialize(data)
	self.skillBoosts = data
end

function ItemStatBoostUserdata:fromRecord(record)
	self:setBoost(record:get("Skill").name, record:get("Boost"))
end

function ItemStatBoostUserdata:apply(peep)
	local stats = peep:getBehavior(StatsBehavior)
	stats = stats and stats.stats
	if not stats then
		return
	end

	for skill, boost in self:iterateSkillBoosts() do
		local skill = stats:hasSkill(skill) and stats:getSkill(skill)
		if skill then
			if boost < 0 then
				skill:setLevelBoost(skill:getLevelBoost() + boost)
			else
				skill:setLevelBoost(math.max(skill:getLevelBoost(), boost))
			end
		end
	end
end

return ItemStatBoostUserdata
