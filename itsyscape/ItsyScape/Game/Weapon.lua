--------------------------------------------------------------------------------
-- ItsyScape/Game/Equipment.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Equipment = require "ItsyScape.Game.Equipment"
local Utility = require "ItsyScape.Game.Utility"
local AttackPoke = require "ItsyScape.Peep.AttackPoke"
local EquipmentBehavior = require "ItsyScape.Peep.Behaviors.EquipmentBehavior"
local EquipmentBonusesBehavior = require "ItsyScape.Peep.Behaviors.EquipmentBonusesBehavior"
local StatsBehavior = require "ItsyScape.Peep.Behaviors.StatsBehavior"
local AttackCooldownBehavior = require "ItsyScape.Peep.Behaviors.AttackCooldownBehavior"
local StatsBehavior = require "ItsyScape.Peep.Behaviors.StatsBehavior"

local Weapon = Class(Equipment)
Weapon.STANCE_AGGRESSIVE = 1 -- Gives strength, wisdom, or dexterity XP
Weapon.STANCE_CONTROLLED = 2 -- Gives attack, magic, or archery XP
Weapon.STANCE_DEFENSIVE  = 3 -- Gives defense XP
Weapon.STYLE_MAGIC   = 1
Weapon.STYLE_ARCHERY = 2
Weapon.STYLE_MELEE   = 3

Weapon.PURPOSE_KILL = 'kill'
Weapon.PURPOSE_TOOL = 'tool'

Weapon.BONUS_STAB    = 'Stab'
Weapon.BONUS_SLASH   = 'Slash'
Weapon.BONUS_CRUSH   = 'Crush'
Weapon.BONUS_ARCHERY = 'Ranged'
Weapon.BONUS_MAGIC   = 'Magic'
Weapon.BONUS_NONE    = 'None'
Weapon.BONUSES       = {
	["Stab"]   = true,
	["Slash"]  = true,
	["Crush"]  = true,
	["Ranged"] = true,
	["Magic"]  = true,
	["None"]   = true
}

Weapon.DamageRoll = Class()

function Weapon.DamageRoll:new(weapon, peep, purpose, target)
	purpose = purpose or Weapon.PURPOSE_KILL

	self.weapon = weapon
	self.peep = peep
	self.target = target

	local stats = peep:getBehavior(StatsBehavior)
	if stats and stats.stats then
		stats = stats.stats
	else
		stats = false
	end

	-- TODO: combat multipliers
	local style = weapon:getStyle()
	local bonus, level
	do
		if style == Weapon.STYLE_MAGIC then
			bonus = 'StrengthMagic'
		elseif style == Weapon.STYLE_ARCHERY then
			bonus = 'StrengthRanged'
		elseif style == Weapon.STYLE_MELEE then
			bonus = 'StrengthMelee'
		end

		local success, skill = weapon:getSkill(purpose)
		if success and stats and stats:hasSkill(skill) then
			level = stats:getSkill(skill):getWorkingLevel()
		end
	end

	if purpose == Weapon.PURPOSE_KILL then
		local StanceBehavior = require "ItsyScape.Peep.Behaviors.StanceBehavior"

		local stance = peep:getBehavior(StanceBehavior)
		if stance then
			if stance.stance == Weapon.STANCE_AGGRESSIVE then
				level = (level or 1) + 8
			end
		end
	elseif purpose == Weapon.PURPOSE_TOOL then
		level = (level or 1) + 8
	end

	self.bonusType = bonus
	self.level = level

	local bonuses = Utility.Peep.getEquipmentBonuses(peep)
	self.bonus = (bonuses[bonus] or 0)
end

function Weapon.DamageRoll:getWeapon()
	return self.weapon
end

function Weapon.DamageRoll:getSelf()
	return self.peep
end

function Weapon.DamageRoll:getTarget()
	return self.target
end

function Weapon.DamageRoll:getLevel()
	return self.level
end

function Weapon.DamageRoll:setLevel(value)
	self.level = self.level or value
end

function Weapon.DamageRoll:getBonus()
	return self.bonus
end

function Weapon.DamageRoll:getBonusType()
	return self.bonusType
end

function Weapon.DamageRoll:setBonus(value)
	self.bonus = self.bonus or value
end

function Weapon.DamageRoll:getMaxHit()
	return self.maxHit or Utility.Combat.calcMaxHit(self.level, 1, self.bonus)
end

function Weapon.DamageRoll:setMaxHit(value)
	if not value then
		self.maxHit = nil
	else
		self.maxHit = value
	end
end

function Weapon.DamageRoll:getMinHit()
	return self.minHit or 1
end

function Weapon.DamageRoll:setMinHit(value)
	if not value then
		self.minHit = nil
	else
		self.minHit = value
	end
end

function Weapon.DamageRoll:roll()
	local minHit = self:getMinHit()
	local maxHit = self:getMaxHit()

	minHit = math.min(minHit, maxHit)
	maxHit = math.max(minHit, maxHit)

	return math.random(minHit, maxHit)
end

Weapon.AttackRoll = Class()

function Weapon.AttackRoll:new(weapon, peep, target, bonus)
	self.weapon = weapon

	self.peep = peep
	self.target = target

	-- There's a cyclic dependency here. Ugly.
	local StanceBehavior = require "ItsyScape.Peep.Behaviors.StanceBehavior"

	local accuracyBonus
	if bonus == Weapon.BONUS_NONE then
		accuracyBonus = 0
	else
		local bonuses = Utility.Peep.getEquipmentBonuses(peep)
		local k = "Accuracy" .. bonus
		accuracyBonus = bonuses[k] or 0

		self.accuracyBonusType = k
	end

	self.accuracyBonus = accuracyBonus

	local defenseBonus
	if bonus == Weapon.BONUS_NONE then
		defenseBonus = 0
	else
		local bonuses = Utility.Peep.getEquipmentBonuses(target)
		local k = "Defense" .. bonus
		defenseBonus = bonuses[k] or 0

		self.defenseBonusType = k
	end

	self.defenseBonus = defenseBonus

	-- TODO: Handle prayers
	local attackLevel
	do
		local stats = peep:getBehavior(StatsBehavior)
		if stats and stats.stats then
			stats = stats.stats
			local _, _, accuracyStat = weapon:getSkill(Weapon.PURPOSE_KILL)
			if stats:hasSkill(accuracyStat) then
				attackLevel = stats:getSkill(accuracyStat):getWorkingLevel()
			end
		end

		local stance = peep:getBehavior(StanceBehavior)
		if stance then
			if stance.stance == Weapon.STANCE_CONTROLLED then
				attackLevel = (attackLevel or 1) + 8
			end
		end

		attackLevel = attackLevel or 1
	end

	self.attackLevel = attackLevel

	local defenceLevel
	do
		local stats = target:getBehavior(StatsBehavior)
		if stats and stats.stats then
			stats = stats.stats
			if stats:hasSkill("Defense") then
				defenseLevel = stats:getSkill("Defense"):getWorkingLevel()
			end
		end

		local stance = target:getBehavior(StanceBehavior)
		if stance then
			if stance.stance == Weapon.STANCE_DEFENSIVE then
				defenseLevel = (defenseLevel or 1) + 8
			end
		end

		defenseLevel = defenseLevel or 1
	end

	self.defenseLevel = defenseLevel
end

function Weapon.AttackRoll:getWeapon()
	return self.weapon
end

function Weapon.AttackRoll:getSelf()
	return self.peep
end

function Weapon.AttackRoll:getTarget()
	return self.target
end

function Weapon.AttackRoll:getDefenseLevel()
	return self.defenseLevel
end

function Weapon.AttackRoll:setDefenseLevel(value)
	self.defenseLevel = self.defenseLevel or value
end

function Weapon.AttackRoll:getAttackLevel()
	return self.attackLevel
end

function Weapon.AttackRoll:setAttackLevel(value)
	self.attackLevel = self.attackLevel or value
end

function Weapon.AttackRoll:getDefenseBonus()
	return self.defenseBonus
end

function Weapon.AttackRoll:setDefenseBonus(value)
	self.defenseBonus = self.defenseBonus or value
end

function Weapon.AttackRoll:getDefenseBonusType()
	return self.defenseBonusType
end

function Weapon.AttackRoll:getAccuracyBonus()
	return self.accuracyBonus
end

function Weapon.AttackRoll:setAccuracyBonus(value)
	self.accuracyBonus = self.accuracyBonus or value
end

function Weapon.AttackRoll:getAccuracyBonusType()
	return self.accuracyBonusType
end

function Weapon.AttackRoll:getMaxAttackRoll()
	return self.maxAttackRoll or Utility.Combat.calcAccuracyRoll(self.attackLevel, self.accuracyBonus)
end

function Weapon.AttackRoll:setMaxAttackRoll(value)
	self.maxAttackRoll = value or false
end

function Weapon.AttackRoll:getMaxDefenseRoll()
	return self.maxDefenseRoll or Utility.Combat.calcAccuracyRoll(self.defenseLevel, self.defenseBonus)
end

function Weapon.AttackRoll:setMaxDefenseRoll(value)
	self.maxDefenseRoll = value or false
end

function Weapon.AttackRoll:roll()
	local maxAttackRoll = self:getMaxAttackRoll()
	local maxDefenseRoll = self:getMaxDefenseRoll()

	local attackRoll = math.floor(math.random(0, maxAttackRoll))
	local defenseRoll = math.floor(math.random(0, maxDefenseRoll))

	return attackRoll > defenseRoll, attackRoll, defenseRoll
end

-- Rolls an attack.
function Weapon:rollAttack(peep, target, bonus)
	return Weapon.AttackRoll(self, peep, target, bonus)
end

function Weapon:rollDamage(peep, purpose, target)
	local roll = Weapon.DamageRoll(self, peep, purpose, target)
	for effect in peep:getEffects(require "ItsyScape.Peep.Effects.CombatEffect") do
		effect:applySelfToDamage(roll, purpose)
	end

	if target then
		for effect in peep:getEffects(require "ItsyScape.Peep.Effects.CombatEffect") do
			effect:applyTargetToDamage(roll, purpose)
		end
	end

	return roll
end

function Weapon:getBonusForStance(peep)
	return Weapon.BONUS_CRUSH
end

function Weapon:getAttackRange(peep)
	return 1
end

function Weapon:onAttackHit(peep, target)
	local damage = self:rollDamage(peep, Weapon.PURPOSE_KILL, target):roll()

	local attack = AttackPoke({
		attackType = self:getBonusForStance(peep):lower(),
		weaponType = self:getWeaponType(),
		damage = damage,
		aggressor = peep
	})

	target:poke('receiveAttack', attack)
	peep:poke('initiateAttack', attack)

	self:applyCooldown(peep)
end

function Weapon:onAttackMiss(peep, target)
	local attack = AttackPoke({
		attackType = self:getBonusForStance(peep):lower(),
		weaponType = self:getWeaponType(),
		damage = 0,
		aggressor = peep
	})

	target:poke('receiveAttack', attack)
	peep:poke('initiateAttack', attack)

	self:applyCooldown(peep)
end

function Weapon:applyCooldown(peep)
	peep:addBehavior(AttackCooldownBehavior)

	local cooldown = peep:getBehavior(AttackCooldownBehavior)
	cooldown.cooldown = self:getCooldown(peep)
	cooldown.ticks = peep:getDirector():getGameInstance():getCurrentTick()
end

function Weapon:perform(peep, target)
	local roll = self:rollAttack(peep, target, self:getBonusForStance(peep))
	do
		for effect in peep:getEffects(require "ItsyScape.Peep.Effects.CombatEffect") do
			effect:applySelfToAttack(roll)
		end
	end
	do
		for effect in target:getEffects(require "ItsyScape.Peep.Effects.CombatEffect") do
			effect:applyTargetToAttack(roll)
		end
	end

	local s, a, d = roll:roll()
	if s then
		self:onAttackHit(peep, target, a, d)
	else
		self:onAttackMiss(peep, target, a, d)
	end

	return true
end

function Weapon:getStyle()
	return Weapon.STYLE_MELEE
end

function Weapon:getSkill(purpose)
	local style = self:getStyle()
	if style == Weapon.STYLE_MAGIC then
		return true, "Wisdom", "Magic"
	elseif style == Weapon.STYLE_ARCHERY then
		return true, "Dexterity", "Archery"
	elseif style == Weapon.STYLE_MELEE then
		return true, "Strength", "Attack"
	end

	return false
end

function Weapon:getWeaponType()
	return 'none'
end

function Weapon:getCooldown(peep)
	return 2.4
end

function Weapon:getProjectile(peep)
	return nil
end

return Weapon
