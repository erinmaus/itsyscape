--------------------------------------------------------------------------------
-- Resources/Game/Peeps/GlyphboundYendorian/GlyphboundYendorian.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Utility = require "ItsyScape.Game.Utility"
local Equipment = require "ItsyScape.Game.Equipment"
local GhostYendorian = require "Resources.Game.Peeps.Yendorian.GhostYendorian"

local GlyphboundYendorian = Class(GhostYendorian)

function GlyphboundYendorian:new(...)
	GhostYendorian.new(self, ...)

	self:addPoke("summon")
end

function GlyphboundYendorian:ready(director, game)
	GhostYendorian.ready(self, director, game)

	Utility.Peep.equipXWeapon(self, "GlyphboundYendorian_Punch")
end

function GlyphboundYendorian:setCombatSkillLevels(level)
	for _, skillName in ipairs(Utility.Combat.SHARED_COMBAT_SKILLS) do
		Utility.Peep.Stats.setSkillLevel(self, skillName, level)
	end

	for _, skillName in ipairs(Utility.Combat.MELEE_COMBAT_SKILLS) do
		Utility.Peep.Stats.setSkillLevel(self, skillName, level)
	end

	Utility.Combat.setMaximumHealth(self, level * 15)
end

function GlyphboundYendorian:setEquipmentStatBonuses(level)
	Utility.Combat.setEquipmentStatBonus(
		self,
		"AccuracyStab",
		Utility.styleBonusForWeapon(level + 5))
	Utility.Combat.setEquipmentStatBonus(
		self,
		"AccuracyCrush",
		Utility.styleBonusForWeapon(level + 5))
	Utility.Combat.setEquipmentStatBonus(
		self,
		"DefenseStab",
		Utility.styleBonusForItem(level))
	Utility.Combat.setEquipmentStatBonus(
		self,
		"DefenseSlash",
		Utility.styleBonusForItem(level + 5))
	Utility.Combat.setEquipmentStatBonus(
		self,
		"DefenseCrush",
		Utility.styleBonusForItem(level - 10))
	Utility.Combat.setEquipmentStatBonus(
		self,
		"DefenseMagic",
		Utility.styleBonusForItem(level - 20))
	Utility.Combat.setEquipmentStatBonus(
		self,
		"DefenseRanged",
		Utility.styleBonusForItem(level + 5))
	Utility.Combat.setEquipmentStatBonus(
		self,
		"StrengthMelee",
		Utility.strengthBonusForWeapon(level + 5))
end

function GlyphboundYendorian:onSummon(playerPeep)
	local maxSkillLevel = Utility.Peep.Stats.getMaxWorkingSkillLevel(
		playerPeep,
		unpack(Utility.Combat.ALL_COMBAT_SKILLS))

	local level = (math.floor(maxSkillLevel / 10) + 1) * 10
	self:setCombatSkillLevels(level)
	self:setEquipmentStatBonuses(level)
end

return GlyphboundYendorian
