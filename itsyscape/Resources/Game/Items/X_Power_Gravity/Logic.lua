--------------------------------------------------------------------------------
-- Resources/Game/Items/X_Power_Gravity/Logic.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Equipment = require "ItsyScape.Game.Equipment"
local ProxyXWeapon = require "ItsyScape.Game.ProxyXWeapon"
local Weapon = require "ItsyScape.Game.Weapon"
local AttackPoke = require "ItsyScape.Peep.AttackPoke"
local StatsBehavior = require "ItsyScape.Peep.Behaviors.StatsBehavior"

local Gravity = Class(ProxyXWeapon)

Gravity.MAX_DAMAGE_MULTIPLIER = 3
Gravity.MIN_DAMAGE_MULTIPLIER = 1

Gravity.MIN_DEBUFF            = 0.1
Gravity.MAX_DEBUFF            = 0.2

function Gravity:perform(peep, target)
	local logic = self:getLogic()
	if logic then
		local damageRoll = logic:rollDamage(peep, Weapon.PURPOSE_KILL, target)
		damageRoll:setMinHit(damageRoll:getMaxHit() * Gravity.MIN_DAMAGE_MULTIPLIER)
		damageRoll:setMaxHit(damageRoll:getMaxHit() * Gravity.MAX_DAMAGE_MULTIPLIER)

		local damage = damageRoll:roll()

		local stats = target:getBehavior(StatsBehavior)
		do
			stats = stats and stats.stats
			if stats then
				Log.info("Debuffing '%s'.", target:getName())
				
				local skill = stats:getSkill("Constitution")
				local workingLevel = skill:getWorkingLevel()
				local debuff = (damage - damageRoll:getMinHit()) / (damageRoll:getMaxHit() - damageRoll:getMinHit())
				debuff = debuff * (Gravity.MAX_DEBUFF - Gravity.MIN_DEBUFF) + Gravity.MIN_DEBUFF
				
				local difference = workingLevel - debuff
				skill:setLevelBoost(skill:getLevelBoost() - difference)

				Log.info("Debuffed skill Constitution by %d levels.", skill:getName(), debuff)
			end
		end

		local attack = AttackPoke({
			attackType = self:getBonusForStance(peep):lower(),
			weaponType = self:getWeaponType(),
			damage = damageRoll:roll(),
			aggressor = peep
		})

		target:poke('receiveAttack', attack)
		peep:poke('initiateAttack', attack)

		target:poke('land')

		local stage = peep:getDirector():getGameInstance():getStage()
		stage:fireProjectile("Power_Gravity", peep, target)
	else
		return ProxyXWeapon.perform(self, peep, target)
	end
end

return Gravity
