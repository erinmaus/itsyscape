--------------------------------------------------------------------------------
-- Resources/Game/Items/X_Svalbard_PartiallyDigestedAdventurer_Attack/Logic.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Equipment = require "ItsyScape.Game.Equipment"
local MeleeWeapon = require "ItsyScape.Game.MeleeWeapon"
local Weapon = require "ItsyScape.Game.Weapon"
local AttackPoke = require "ItsyScape.Peep.AttackPoke"
local AttackCooldownBehavior = require "ItsyScape.Peep.Behaviors.AttackCooldownBehavior"

local PartiallyDigestedAdventurerAttack = Class(MeleeWeapon)

function PartiallyDigestedAdventurerAttack:getBonusForStance(peep)
	return Weapon.BONUS_CRUSH
end

function PartiallyDigestedAdventurerAttack:getAttackRange()
	return 1.5
end

function PartiallyDigestedAdventurerAttack:getWeaponType()
	return 'unarmed'
end

function PartiallyDigestedAdventurerAttack:getCooldown(peep)
	return 3
end

function PartiallyDigestedAdventurerAttack:perform(peep, target)
	local roll = self:rollDamage(peep, Weapon.PURPOSE_KILL, target)
	roll:setDamageMultiplier(1.0)
	roll:setMinHit(math.floor(roll:getMaxHit() / 2))

	local attack = AttackPoke({
		attackType = self:getBonusForStance(peep):lower(),
		weaponType = self:getWeaponType(),
		damage = roll:roll(),
		aggressor = peep
	})

	target:poke('receiveAttack', attack)
	peep:poke('initiateAttack', attack)

	self:applyCooldown(peep)
end

return PartiallyDigestedAdventurerAttack
	