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

function GlyphboundYendorian:chargeNearbyGlyphstones(level)
	local mineableResource = self:getDirector():getGameDB():getResource("GlyphstoneRock_Weak", "Prop")
	if not mineableResource then
		Log.error("Could not get 'GlyphstoneRock_Weak' resource!")
		return
	end

	local rocks = self:getDirector():probe(
		self:getLayerName(),
		Probe.resource("Prop", "GlyphstoneRock"))

	for _, rock in ipairs(rocks) do
		local _, propHealth = rock:addBehavior(PropResourceHealthBehavior)
		propHealth.maxProgress = math.ceil(level * 2.5)

		Utility.Peep.setResource(rock, mineableResource)
		rock:poke("spawned")

		local oldOneDescription = Utility.Peep.getOldOneDescription(rock)

		local position = Utility.Peep.getPosition(rock)
		local projectedGlyph = Utility.spawnPropAtPosition(
			rock,
			"ProjectedGlyph",
			position.x, position.y, position.z)
		Utility.Peep.setOldOneDescription(projectedGlyph:getPeep(), oldOneDescription)

		rock:listen("depleted", self._onDefaceGlyphstone, self, projectedGlyph:getPeep())
	end
end

function GlyphboundYendorian:displayIncantation(stoneGlyphboundYendorian)
	local position = Utility.Peep.getPosition(stoneGlyphboundYendorian)
	local projectedGlyph = Utility.spawnPropAtPosition(
		stoneGlyphboundYendorian,
		"ProjectedGlyph",
		position.x, position.y, position.z)

	local oldOneDescription = Utility.Peep.getOldOneDescription(stoneGlyphboundYendorian)
	Utility.Peep.setOldOneDescription(projectedGlyph:getPeep(), oldOneDescription)

	Utility.Peep.setSize(projectedGlyph:getPeep(), Vector(12, 0, 12))

	self:listen("unbind", self._onDefaceGlyphstone, self, projectedGlyph:getPeep())
end

function GlyphboundYendorian:onSummon(stoneGlyphboundYendorian, playerPeep)
	local maxSkillLevel = Utility.Peep.Stats.getMaxWorkingSkillLevel(
		playerPeep,
		unpack(Utility.Combat.ALL_COMBAT_SKILLS))

	local level = math.clamp((math.floor(maxSkillLevel / 10) + 1) * 10, 10, 80)
	self:setCombatSkillLevels(level)
	self:setEquipmentStatBonuses(level)
	self:chargeNearbyGlyphstones(level)
	self:displayIncantation(stoneGlyphboundYendorian)
end

return GlyphboundYendorian
