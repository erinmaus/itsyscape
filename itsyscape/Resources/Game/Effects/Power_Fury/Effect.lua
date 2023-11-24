--------------------------------------------------------------------------------
-- Resources/Game/Effects/Power_Fury/Effect.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Weapon = require "ItsyScape.Game.Weapon"
local Utility = require "ItsyScape.Game.Utility"
local Effect = require "ItsyScape.Peep.Effect"
local CombatEffect = require "ItsyScape.Peep.Effects.CombatEffect"

-- Prevents 50%-100% of damage from the next attack.
local Fury = Class(CombatEffect)
Fury.MIN_FADE_DURATION = 20
Fury.MAX_FADE_DURATION = 30
Fury.MIN_DAMAGE_MULTIPLIER_STEP = 0.05
Fury.MAX_DAMAGE_MULTIPLIER_STEP = 0.10
Fury.MAX_DAMAGE_MULTIPLIER = 1
Fury.MIN_LEVEL = 30
Fury.MAX_LEVEL = 60

function Fury:new(activator)
	CombatEffect.new(self)

	self.currentDamageMultiplier = 0
end

function Fury:getDamageMultiplierStep()
	local level = self:getPeep():getState():count(
		"Skill",
		"Defense",
		{ ['skill-as-level'] = true })

	local step = Utility.Combat.calcBoost(
		level,
		Fury.MIN_LEVEL, Fury.MAX_LEVEL,
		Fury.MIN_DAMAGE_MULTIPLIER_STEP, Fury.MAX_DAMAGE_MULTIPLIER_STEP)
	return step
end

function Fury:boostDuration()
	local level = self:getPeep():getState():count(
		"Skill",
		"Defense",
		{ ['skill-as-level'] = true })

	local duration = Utility.Combat.calcBoost(
		level,
		Fury.MIN_LEVEL, Fury.MAX_LEVEL,
		Fury.MIN_FADE_DURATION, Fury.MAX_FADE_DURATION)
	self.fadeDuration = math.min((self.fadeDuration or 0) + duration, duration)

	Log.info("Fury duration for peep '%s' is now %.2f seconds.", self:getPeep():getName(), self.fadeDuration)
end

function Fury:enchant(peep)
	CombatEffect.enchant(self, peep)
	self:boostDuration()
end

function Fury:getDescription()
	return string.format("%d%%", self.currentDamageMultiplier * 100)
end

function Fury:getBuffType()
	return Effect.BUFF_TYPE_POSITIVE
end

function Fury:applySelfToDamage(roll)
	roll:setMaxHit(math.floor(roll:getMaxHit() * (1 + self.currentDamageMultiplier)))
	roll:setMinHit(math.floor(roll:getMinHit() * (1 + self.currentDamageMultiplier)))
end

function Fury:receiveDamage(roll)
	local oldDamageMultiplier = self.currentDamageMultiplier
	self.currentDamageMultiplier = math.min(self.currentDamageMultiplier + self:getDamageMultiplierStep(), Fury.MAX_DAMAGE_MULTIPLIER)

	if self.currentDamageMultiplier > oldDamageMultiplier then
		Log.info("Damage for peep '%s' increased to %d%%.", self:getPeep():getName(), self.currentDamageMultiplier * 100)
	end

	self:boostDuration()
end

function Fury:update(delta)
	local equippedShield = Utility.Peep.getEquippedShield(self:getPeep(), true)
	if not equippedShield then
		self.fadeDuration = 0
	else
		self.fadeDuration = (self.fadeDuration or 0) - delta
	end
	self:setDuration(self.fadeDuration)

	CombatEffect.update(self, delta)
end

return Fury
