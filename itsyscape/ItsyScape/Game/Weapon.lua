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
local CurveConfig = require "ItsyScape.Game.CurveConfig"
local AttackPoke = require "ItsyScape.Peep.AttackPoke"
local EquipmentBehavior = require "ItsyScape.Peep.Behaviors.EquipmentBehavior"
local EquipmentBonusesBehavior = require "ItsyScape.Peep.Behaviors.EquipmentBonusesBehavior"
local PlayerBehavior = require "ItsyScape.Peep.Behaviors.PlayerBehavior"
local StatsBehavior = require "ItsyScape.Peep.Behaviors.StatsBehavior"
local AttackCooldownBehavior = require "ItsyScape.Peep.Behaviors.AttackCooldownBehavior"
local StatsBehavior = require "ItsyScape.Peep.Behaviors.StatsBehavior"

local Weapon = Class(Equipment)
Weapon.STANCE_NONE       = 0 -- For NPCs
Weapon.STANCE_AGGRESSIVE = 1 -- Gives strength, wisdom, or dexterity XP
Weapon.STANCE_CONTROLLED = 2 -- Gives attack, magic, or archery XP
Weapon.STANCE_DEFENSIVE  = 3 -- Gives defense XP
Weapon.STYLE_NONE    = 0
Weapon.STYLE_MAGIC   = 1
Weapon.STYLE_ARCHERY = 2
Weapon.STYLE_MELEE   = 3
Weapon.STYLE_SAILING = 4

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
	local StanceBehavior = require "ItsyScape.Peep.Behaviors.StanceBehavior"

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

	self.style = weapon:getStyle()
	local bonusType, level, bonuses, skill
	do
		if self.style == Weapon.STYLE_MAGIC then
			bonusType = 'StrengthMagic'
		elseif self.style == Weapon.STYLE_ARCHERY then
			bonusType = 'StrengthRanged'
		elseif self.style == Weapon.STYLE_MELEE then
			bonusType = 'StrengthMelee'
		elseif self.style == Weapon.STYLE_SAILING then
			bonusType = 'StrengthSailing'
		end

		local success
		success, skill = weapon:getSkill(purpose)
		if success and stats and stats:hasSkill(skill) then
			level = stats:getSkill(skill):getWorkingLevel()
		end
	end

	bonuses = Utility.Peep.getEquipmentBonuses(peep)

	self.minHitBoost = 0
	self.maxHitBoost = 0
	if purpose == Weapon.PURPOSE_KILL then
		local stance = peep:getBehavior(StanceBehavior)
		if stance then
			if stance.stance == Weapon.STANCE_AGGRESSIVE then
				self.maxHitBoost = 1 + math.floor((level or 1) * 0.1)
				level = (level or 1) + 8
			elseif stance.stance == Weapon.STANCE_CONTROLLED then
				local strengthSkill, accuracySkill = weapon:getSkill(purpose)
				local strengthLevel = stats and stats:hasSkill(strengthSkill) and stats:getSkill(strengthSkill):getWorkingLevel()
				local attackLevel = stats and stats:hasSkill(strengthSkill) and stats:getSkill(strengthSkill):getWorkingLevel()

				local minLevel = math.min(strengthLevel or 1, attackLevel or 1)
				self.minHitBoost = math.floor(minLevel * 0.05)
			end
		end

		self.stat = skill
		self.bonus = (bonuses[bonusType] or 0)
	elseif purpose == Weapon.PURPOSE_TOOL then
		self.bonus = 0

		local gameDB = peep:getDirector():getGameDB()
		local itemResource = gameDB:getResource(weapon:getID(), "Item")
		if itemResource then
			local equipmentRecord = gameDB:getRecord("Equipment", {
				Resource = itemResource
			})

			if equipmentRecord then
				self.bonus = equipmentRecord:get(bonusType)
				bonuses = { [bonusType] = self.bonus }
			end
		end

		level = (level or 1) + 8
	end

	self.bonusType = bonusType
	self.level = level or 1
	self.hitReduction = 0
	self.damageMultiplier = 1

	if target then
		local targetBonuses = Utility.Peep.getEquipmentBonuses(target)
		local targetStats
		do
			targetStats = target:getBehavior(StatsBehavior)
			if targetStats then
				targetStats = targetStats.stats
			end
		end

		local defenseLevel = 1
		if targetStats then
			defenseLevel = targetStats:hasSkill("Defense") and targetStats:getSkill("Defense"):getWorkingLevel()
		end

		local stance = target:getBehavior(StanceBehavior)
		if stance then
			if stance.stance == Weapon.STANCE_DEFENSIVE then
				self.hitReduction = 1 + math.floor(defenseLevel * 0.15)
				defenseLevel = defenseLevel + 8
			end
		end

		if target:hasBehavior(PlayerBehavior) then
			local styleBonus = weapon:getBonusForStance(peep)

			local accuracyBonusName = "Accuracy" .. styleBonus
			local accuracyBonus = bonuses[accuracyBonusName] or 0
			local accuracyTier = math.max(CurveConfig.StyleBonus:solvePlus(accuracyBonus * 3) - 10, 0)

			local defenseBonusName = "Defense" .. styleBonus
			local defenseBonus = targetBonuses[defenseBonusName] or 0
			local defenseTier = math.max(CurveConfig.StyleBonus:solvePlus(defenseBonus), 0)

			local armorDamageReduction = math.max(math.min(CurveConfig.ArmorDamageReduction:evaluate(defenseTier - accuracyTier), 100), 0)
			local defenseDamageReduction = math.max(math.min(CurveConfig.DefenseDamageReduction:evaluate(defenseLevel), 100), 0)
			local totalDamageReduction = armorDamageReduction + defenseDamageReduction

			local clampedMultiplier = math.max(math.min(totalDamageReduction / 100, 1), 0)

			self.damageMultiplier = 1 - clampedMultiplier
		end
	end
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
	self.level = value or self.level
end

function Weapon.DamageRoll:getDamageStat()
	return self.stat
end

function Weapon.DamageRoll:getStyle()
	return self.style
end

function Weapon.DamageRoll:getBonus()
	return self.bonus
end

function Weapon.DamageRoll:getBonusType()
	return self.bonusType
end

function Weapon.DamageRoll:setBonus(value)
	self.bonus = value or self.bonus
end

function Weapon.DamageRoll:getBaseHit()
	return Utility.Combat.calcMaxHit(self.level, 1, self.bonus)
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

function Weapon.DamageRoll:getDamageMultiplier()
	return self.damageMultiplier
end

function Weapon.DamageRoll:setDamageMultiplier(value)
	if not value then
		self.damageMultiplier = 0
	else
		self.damageMultiplier = value
	end
end

function Weapon.DamageRoll:roll()
	local minHit = math.max(self:getMinHit() - self.hitReduction, 0)
	local maxHit = math.max(self:getMaxHit() - self.hitReduction + self.maxHitBoost, 0)

	minHit = math.min(minHit + self.minHitBoost, maxHit)
	if maxHit > 0 then
		minHit = math.max(minHit, 1)
	end

	minHit = math.min(minHit, maxHit)
	maxHit = math.max(minHit, maxHit)

	return math.ceil(love.math.random(minHit, maxHit) * self.damageMultiplier)
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
	self.stanceAttackRollMultiplier = 1

	local attackLevel
	do
		local stats = peep:getBehavior(StatsBehavior)
		if stats and stats.stats then
			stats = stats.stats
			local _, _, accuracyStat = weapon:getSkill(Weapon.PURPOSE_KILL)
			if stats:hasSkill(accuracyStat) then
				attackLevel = stats:getSkill(accuracyStat):getWorkingLevel()
			end

			self.stat = accuracyStat
		end

		local stance = peep:getBehavior(StanceBehavior)
		if stance then
			if stance.stance == Weapon.STANCE_CONTROLLED then
				attackLevel = (attackLevel or 1) + 8
				self.stanceAttackRollMultiplier = 1.1
			end
		end

		attackLevel = attackLevel or 1
	end

	self.attackLevel = attackLevel

	local defenseLevel
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
	self.defenseLevel = value or self.defenseLevel
end

function Weapon.AttackRoll:getAccuracyStat()
	return self.stat
end

function Weapon.AttackRoll:getAttackLevel()
	return self.attackLevel
end

function Weapon.AttackRoll:setAttackLevel(value)
	self.attackLevel = value or self.attackLevel
end

function Weapon.AttackRoll:getDefenseBonus()
	return self.defenseBonus
end

function Weapon.AttackRoll:setDefenseBonus(value)
	self.defenseBonus = value or self.defenseBonus
end

function Weapon.AttackRoll:getDefenseBonusType()
	return self.defenseBonusType
end

function Weapon.AttackRoll:getAccuracyBonus()
	return self.accuracyBonus
end

function Weapon.AttackRoll:setAccuracyBonus(value)
	self.accuracyBonus = value or self.accuracyBonus
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

function Weapon.AttackRoll:setAlwaysHits(value)
	self.alwaysHits = value or false
end

function Weapon.AttackRoll:roll()
	local maxAttackRoll = math.floor(self:getMaxAttackRoll() * self.stanceAttackRollMultiplier)
	local maxDefenseRoll = self:getMaxDefenseRoll()

	local attackRoll, defenseRoll
	if self.alwaysHits then
		attackRoll = 1
		defenseRoll = 0
	else
		attackRoll = math.floor(love.math.random(0, maxAttackRoll))
		defenseRoll = math.floor(love.math.random(0, maxDefenseRoll))
	end

	return attackRoll > defenseRoll, attackRoll, defenseRoll
end

-- Rolls an attack.
function Weapon:rollAttack(peep, target, bonus)
	local roll = Weapon.AttackRoll(self, peep, target, bonus)
	self:applyAttackModifiers(roll)
	self:previewAttackRoll(roll)

	peep:poke("rollAttack", roll)

	return roll
end

function Weapon:previewAttackRoll(roll)
	-- Nothing.
end

function Weapon:applyAttackModifiers(roll)
	if roll:getSelf() then
		for effect in roll:getSelf():getEffects(require "ItsyScape.Peep.Effects.CombatEffect") do
			effect:applySelfToAttack(roll)
		end
	end

	if roll:getTarget() then
		for effect in roll:getTarget():getEffects(require "ItsyScape.Peep.Effects.CombatEffect") do
			effect:applyTargetToAttack(roll)
		end
	end
end

function Weapon:previewDamageRoll(roll)
	-- Nothing.
end

function Weapon:applyDamageModifiers(roll, purpose)
	if roll:getSelf() then
		for effect in roll:getSelf():getEffects(require "ItsyScape.Peep.Effects.CombatEffect") do
			effect:applySelfToDamage(roll, purpose)
		end
	end

	if roll:getTarget() then
		for effect in roll:getTarget():getEffects(require "ItsyScape.Peep.Effects.CombatEffect") do
			effect:applyTargetToDamage(roll, purpose)
		end
	end
end

function Weapon:rollDamage(peep, purpose, target)
	local roll = Weapon.DamageRoll(self, peep, purpose, target)
	self:applyDamageModifiers(roll)
	self:previewDamageRoll(roll)

	peep:poke("rollDamage", roll)

	return roll
end

function Weapon:getBonusForStance(peep)
	return Weapon.BONUS_CRUSH
end

function Weapon:getAttackRange(peep)
	return 1
end

function Weapon:onAttackHit(peep, target)
	local roll = self:rollDamage(peep, Weapon.PURPOSE_KILL, target)
	do
		if roll:getSelf() then
			for effect in roll:getSelf():getEffects(require "ItsyScape.Peep.Effects.CombatEffect") do
				effect:dealDamage(roll)
			end
		end

		if roll:getTarget() then
			for effect in roll:getTarget():getEffects(require "ItsyScape.Peep.Effects.CombatEffect") do
				effect:receiveDamage(roll)
			end
		end
	end

	local damage = roll:roll()
	local attack = AttackPoke({
		attackType = self:getBonusForStance(peep):lower(),
		weaponType = self:getWeaponType(),
		damage = damage,
		aggressor = peep,
		delay = self:getDelay(peep, target)
	})

	if damage < 0 then
		target:poke('heal', {
			hitPoints = -damage
		})
	else

		target:poke('receiveAttack', attack, peep)
		peep:poke('initiateAttack', attack, target)
	end

	self:dealtDamage(peep, target, attack)
	self:applyCooldown(peep, target)

	return attack
end

function Weapon:dealtDamage(peep, target, attack)
	-- Nothing.
end

function Weapon:onAttackMiss(peep, target)
	local attack = AttackPoke({
		attackType = self:getBonusForStance(peep):lower(),
		weaponType = self:getWeaponType(),
		damage = 0,
		aggressor = peep,
		delay = self:getDelay(peep, target)
	})

	target:poke('receiveAttack', attack, peep)
	peep:poke('initiateAttack', attack, target)

	self:applyCooldown(peep, target)

	return attack
end

function Weapon:applyCooldown(peep, target)
	if self:getCooldown(peep) == 0 then
		return
	end

	local cooldown = self:getCooldown(peep)
	do
		for effect in peep:getEffects(require "ItsyScape.Peep.Effects.CombatEffect") do
			cooldown = effect:applyToSelfWeaponCooldown(peep, cooldown)
		end

		if target then
			for effect in target:getEffects(require "ItsyScape.Peep.Effects.CombatEffect") do
				cooldown = effect:applyToTargetWeaponCooldown(target, cooldown)
			end
		end
	end

	local _, c = peep:addBehavior(AttackCooldownBehavior)
	c.cooldown = math.max(c.cooldown, cooldown)
	c.ticks = peep:getDirector():getGameInstance():getCurrentTime()
end

function Weapon:perform(peep, target)
	local roll = self:rollAttack(peep, target, self:getBonusForStance(peep))

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

function Weapon:getDelay(peep, target)
	if peep:hasBehavior(PlayerBehavior) then
		return 0
	else
		return 0.5
	end
end

function Weapon:getCooldown(peep)
	return 2.4
end

function Weapon:getProjectile(peep)
	return nil
end

return Weapon
