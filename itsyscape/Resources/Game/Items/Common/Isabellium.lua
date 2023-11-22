--------------------------------------------------------------------------------
-- Resources/Game/Items/Common/Isabellium.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Equipment = require "ItsyScape.Game.Equipment"
local Weapon = require "ItsyScape.Game.Weapon"
local EquipmentBonusesBehavior = require "ItsyScape.Peep.Behaviors.EquipmentBonusesBehavior"
local StatsBehavior = require "ItsyScape.Peep.Behaviors.StatsBehavior"

local Isabellium = Class()

function Isabellium:new(item, slot, itemID)
	self.calcFunc = {}
	self.currentStats = {}

	for i = 1, #Equipment.STATS do
		local stat = Equipment.STATS[i]
		self.currentStats[stat] = 0
	end

	self.skills = {}

	self.slot = slot
	self.itemID = itemID
	self.item = item

	self.peep = false
end

function Isabellium:setBonusMultiplier(stat, multiplier, func, offset)
	local function _composeFunc(level)
		return func and func(math.max(level + (offset or 0), 1), multiplier or 1) or 0
	end

	self.calcFunc[stat] = _composeFunc
	if self.peep then
		self:update()
	end
end

function Isabellium:linkSkill(skill)
	self.skills[skill] = true
end

function Isabellium:attach(peep)
	self.peep = peep
	self:update()

	self._onDequip = function(_, e)
		local item = e and e.item

		if item and item:getRef() == self.item:getRef() then
			self:detach()
		end
	end

	self._onLevelUp = function(_, skill)
		if not skill or self.skills[skill:getName()] then
			self:update()
		end
	end

	local stats = peep:getBehavior(StatsBehavior)
	stats = stats and stats.stats
	if stats then
		stats.onLevelUp:register(self._onLevelUp)
		stats.onBoost:register(self._onLevelUp)
		stats.onDeserialize:register(self._onLevelUp)
	end

	peep:listen('dequipItem', self._onDequip)
end

function Isabellium:detach()
	self:revert()

	self.peep:silence('dequipItem', self._onDequip)

	local stats = self.peep:getBehavior(StatsBehavior)
	stats = stats and stats.stats
	if stats then
		stats.onLevelUp:unregister(self._onLevelUp)
		stats.onDeserialize:unregister(self._onLevelUp)
	end
end

function Isabellium:revert()
	local equipmentBonuses = self.peep:getBehavior(EquipmentBonusesBehavior)
	if equipmentBonuses then
		for stat, value in pairs(self.currentStats) do
			equipmentBonuses.bonuses[stat] = equipmentBonuses.bonuses[stat] - value
			self.currentStats[stat] = 0
		end
	end
end

function Isabellium:update()
	self:revert()

	self.currentStats = self:getStats(self.peep)

	local _, equipmentBonuses = self.peep:addBehavior(EquipmentBonusesBehavior)
	for stat, value in pairs(self.currentStats) do
		equipmentBonuses.bonuses[stat] = equipmentBonuses.bonuses[stat] + value
	end
end

function Isabellium:getStats(peep)
	local stats = peep:getBehavior(StatsBehavior)
	stats = stats and stats.stats

	local level, total = 0, 0
	if stats then
		for skill in pairs(self.skills) do
			level = level + ((stats:hasSkill(skill) and stats:getSkill(skill):getWorkingLevel()) or 0)
			total = total + 1
		end
	end
	level = math.ceil(level / total)

	local bonuses = {}
	for stat, multiplier in pairs(self.calcFunc) do
		local func = self.calcFunc[stat]

		local value
		if func then
			value = func(level)
		else
			value = 0
		end

		bonuses[stat] = value
	end

	return bonuses
end

return Isabellium
