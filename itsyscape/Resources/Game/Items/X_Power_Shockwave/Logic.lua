--------------------------------------------------------------------------------
-- Resources/Game/Items/X_Power_Shockwave/Logic.lua
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
local AttackCooldownBehavior = require "ItsyScape.Peep.Behaviors.AttackCooldownBehavior"

-- Stuns opponent for 5-10 seconds, dealing 50%-150% damage, capping at
-- level 50 dexterity.
local Shockwave = Class(ProxyXWeapon)

function Shockwave:onAttackHit(peep, target)
	local logic = self:getLogic()
	if logic then
		local roll = logic:rollDamage(peep, Weapon.PURPOSE_KILL, target)
		local maxHit = roll:getMaxHit()

		local level = peep:getState():count(
			"Skill",
			"Dexterity",
			{ ['skill-as-level'] = true })

		local scale = math.min((level / 50) + 0.5, 1.5)
		local damage = math.floor(maxHit * scale + 0.5)

		local attack = AttackPoke({
			attackType = self:getBonusForStance(peep):lower(),
			weaponType = self:getWeaponType(),
			damage = damage,
			aggressor = peep
		})

		local stage = peep:getDirector():getGameInstance():getStage()
		stage:fireProjectile("ShockwaveSplosion", peep, target)

		target:poke('receiveAttack', attack)
		peep:poke('initiateAttack', attack)

		local additionalCooldown = math.min(level / 50 + 5, 10)
		local _, cooldown = target:addBehavior(AttackCooldownBehavior)
		cooldown.cooldown = cooldown.cooldown + additionalCooldown
		cooldown.ticks = peep:getDirector():getGameInstance():getCurrentTick()
	else
		return ProxyXWeapon.onAttackHit(self, peep, target)
	end
end

return Shockwave
