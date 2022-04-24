--------------------------------------------------------------------------------
-- Resources/Game/Items/X_Power_Backstab/Logic.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local ProxyXWeapon = require "ItsyScape.Game.ProxyXWeapon"
local Weapon = require "ItsyScape.Game.Weapon"
local AttackPoke = require "ItsyScape.Peep.AttackPoke"
local CombatTargetBehavior = require "ItsyScape.Peep.Behaviors.CombatTargetBehavior"

-- Deals 100%-300% damage to opponent if they are not in combat with the
-- attacker.
local Backstab = Class(ProxyXWeapon)

function Backstab:onAttackHit(peep, target)
	local logic = self:getLogic()
	local t = target:getBehavior(CombatTargetBehavior)
	if logic and (not t or not t.target or t.target:getPeep() ~= target) then
		local roll = logic:rollDamage(peep, Weapon.PURPOSE_KILL, target)
		local maxHit = roll:getMaxHit()

		local level = peep:getState():count(
			"Skill",
			"Strength",
			{ ['skill-as-level'] = true })

		local scale = math.min((level / 50) * 2 + 1, 3)
		local damage = math.floor(maxHit * scale + 0.5)

		roll:setMinHit(maxHit)
		roll:setMaxHit(maxHit)

		local attack = AttackPoke({
			attackType = self:getBonusForStance(peep):lower(),
			weaponType = self:getWeaponType(),
			damage = roll:roll(),
			aggressor = peep
		})

		target:poke('receiveAttack', attack)
		peep:poke('initiateAttack', attack)
	else
		return ProxyXWeapon.onAttackHit(self, peep, target)
	end
end

return Backstab
