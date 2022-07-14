--------------------------------------------------------------------------------
-- Resources/Game/Items/X_Power_TrickShot/Logic.lua
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

local TrickShot = Class(ProxyXWeapon)

function TrickShot:perform(peep, target)
	local logic = self:getLogic()
	if logic then
		local attackRoll = logic:rollAttack(peep, target, logic:getBonusForStance(peep))
		local damageRoll = logic:rollDamage(peep, Weapon.PURPOSE_KILL, target)

		local maxAttackRoll = attackRoll:getMaxAttackRoll()
		local maxDefenseRoll = attackRoll:getMaxDefenseRoll()

		Log.info(
			"Trick Shot '%s' max attack roll = %d, '%s' max defense roll = %d.",
			peep:getName(), maxAttackRoll,
			target:getName(), maxDefenseRoll)

		local ratio
		if maxDefenseRoll == 0 then
			ratio = 2
		else
			ratio = math.max(math.min(maxAttackRoll / maxDefenseRoll, 0), 2)
		end

		Log.info("Damage ratio is %d%%.", ratio * 100)

		local maxHit = damageRoll:getMaxHit()
		local hit = math.floor(math.max(maxHit * ratio, 1) + 0.5)

		damageRoll:setMinHit(hit)
		damageRoll:setMaxHit(hit)

		local attack = AttackPoke({
			attackType = self:getBonusForStance(peep):lower(),
			weaponType = self:getWeaponType(),
			damage = damageRoll:roll(),
			aggressor = peep
		})

		target:poke('receiveAttack', attack)
		peep:poke('initiateAttack', attack)
	else
		return ProxyXWeapon.perform(self, peep, target)
	end
end

return TrickShot
