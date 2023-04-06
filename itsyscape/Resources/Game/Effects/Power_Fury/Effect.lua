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
Fury.DURATION = math.huge
Fury.MIN_FADE_DURATION = 10
Fury.MAX_FADE_DURATION = 20
Fury.MIN_DAMAGE_MULTIPLIER_STEP = 0.05
Fury.MAX_DAMAGE_MULTIPLIER_STEP = 0.10
Fury.MAX_DAMAGE_MULTIPLIER = 1
Fury.MIN_LEVEL = 30
Fury.MAX_LEVEL = 60

function Fury:new(activator)
	CombatEffect.new(self)

	local level = activator:getState():count(
		"Skill",
		"Defense",
		{ ['skill-as-level'] = true })

	local delta = (level - Fury.MIN_LEVEL) / (Fury.MAX_LEVEL - Fury.MIN_LEVEL)
	delta = math.min(math.max(delta, 0), 1)

	self.fadeDuration = delta * (Fury.MAX_FADE_DURATION - Fury.MIN_FADE_DURATION) + Fury.MIN_FADE_DURATION
	self.damageMultiplierStep = delta * (Fury.MAX_DAMAGE_MULTIPLIER_STEP - Fury.MIN_DAMAGE_MULTIPLIER_STEP) + Fury.MIN_DAMAGE_MULTIPLIER_STEP
	self.currentDamageMultiplier = 0
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

function Fury:applyTargetToAttack(roll)
	local oldDamageMultiplier = self.currentDamageMultiplier
	self.currentDamageMultiplier = math.min(self.currentDamageMultiplier + self.damageMultiplierStep, Fury.MAX_DAMAGE_MULTIPLIER)

	if self.currentDamageMultiplier > oldDamageMultiplier then
		Log.info("Damage increased to %d%%.", self.currentDamageMultiplier * 100)
	end
end

function Fury:update(delta)
	CombatEffect.update(self, delta)

	local equippedShield = Utility.Peep.getEquippedShield(self:getPeep(), true)
	if not equippedShield then
		self.fadeDuration = self.fadeDuration - delta
		self:setDuration(self.fadeDuration)
	else
		self:setDuration(math.huge)
	end
end

return Fury
