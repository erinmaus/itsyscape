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
local Vector = require "ItsyScape.Common.Math.Vector"
local Utility = require "ItsyScape.Game.Utility"
local Equipment = require "ItsyScape.Game.Equipment"
local Probe = require "ItsyScape.Peep.Probe"
local PropResourceHealthBehavior = require "ItsyScape.Peep.Behaviors.PropResourceHealthBehavior"
local GhostYendorian = require "Resources.Game.Peeps.Yendorian.GhostYendorian"

local GlyphboundYendorian = Class(GhostYendorian)

function GlyphboundYendorian:new(...)
	GhostYendorian.new(self, ...)

	self:addPoke("summon")
	self:addPoke("unbind")
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

function GlyphboundYendorian:_onDefaceGlyphstone(glyph)
	glyph:poke("fade")
end

function GlyphboundYendorian:_onWeakenIncantation(glyph, rocks)
	local completeDescription = {}

	for _, rock in ipairs(rocks) do
		if not Utility.Peep.isDepleted(rock) then
			table.insert(completeDescription, Utility.Peep.getOldOneDescription(rock))
		end
	end

	if #completeDescription == 0 then
		glyph:poke("fade")
	else
		Utility.Peep.setOldOneDescription(glyph, table.concat(completeDescription, " "))
	end
end

local function _sortByMapObjectID(a, b)
	local mapObjectA = Utility.Peep.getMapObject(a)
	local mapObjectB = Utility.Peep.getMapObject(b)

	if mapObjectA and mapObjectB then
		return mapObjectA.id.value < mapObjectB.id.value
	elseif mapObjectA then
		return true
	elseif mapObjectB then
		return false
	end

	return true
end

function GlyphboundYendorian:chargeNearbyGlyphstones(stoneGlyphboundYendorian, level)
	local mineableResource = self:getDirector():getGameDB():getResource("GlyphstoneRock_Weak", "Prop")
	if not mineableResource then
		Log.error("Could not get 'GlyphstoneRock_Weak' resource!")
		return
	end

	local rocks = self:getDirector():probe(
		self:getLayerName(),
		Probe.resource("Prop", "GlyphstoneRock"))
	table.sort(rocks, _sortByMapObjectID)

	local completeDescription = {}

	for _, rock in ipairs(rocks) do
		local _, propHealth = rock:addBehavior(PropResourceHealthBehavior)
		propHealth.maxProgress = math.ceil(level * 2.5)

		Utility.Peep.setResource(rock, mineableResource)
		rock:poke("spawned")

		local oldOneDescription = Utility.Peep.getOldOneDescription(rock)
		table.insert(completeDescription, oldOneDescription)

		local position = Utility.Peep.getPosition(rock)
		local projectedGlyph = Utility.spawnPropAtPosition(
			rock,
			"ProjectedGlyph",
			position.x, position.y, position.z)
		Utility.Peep.setOldOneDescription(projectedGlyph:getPeep(), oldOneDescription)

		rock:listen("depleted", self._onDefaceGlyphstone, self, projectedGlyph:getPeep())
	end

	local incantation = self:displayIncantation(stoneGlyphboundYendorian, table.concat(completeDescription, " "))
	for _, rock in ipairs(rocks) do
		rock:listen("depleted", self._onWeakenIncantation, self, incantation:getPeep(), rocks)
	end
end

function GlyphboundYendorian:displayIncantation(stoneGlyphboundYendorian, oldOneDescription)
	local position = Utility.Peep.getPosition(stoneGlyphboundYendorian)
	local projectedGlyph = Utility.spawnPropAtPosition(
		stoneGlyphboundYendorian,
		"ProjectedGlyph",
		position.x, position.y, position.z)

	Utility.Peep.setOldOneDescription(projectedGlyph:getPeep(), oldOneDescription)
	Utility.Peep.setSize(projectedGlyph:getPeep(), Vector(12, 0, 12))

	return projectedGlyph
end

function GlyphboundYendorian:onSummon(stoneGlyphboundYendorian, playerPeep)
	local maxSkillLevel = Utility.Peep.Stats.getMaxWorkingSkillLevel(
		playerPeep,
		unpack(Utility.Combat.ALL_COMBAT_SKILLS))

	local level = math.clamp((math.floor(maxSkillLevel / 10) + 1) * 10, 10, 80)
	self:setCombatSkillLevels(level)
	self:setEquipmentStatBonuses(level)
	self:chargeNearbyGlyphstones(stoneGlyphboundYendorian, level)
end

return GlyphboundYendorian
