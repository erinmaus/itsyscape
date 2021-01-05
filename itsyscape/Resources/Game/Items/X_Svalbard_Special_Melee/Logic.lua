--------------------------------------------------------------------------------
-- Resources/Game/Items/X_Svalbard_Special_Melee/Logic.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Weapon = require "ItsyScape.Game.Weapon"
local MeleeWeapon = require "ItsyScape.Game.MeleeWeapon"

local SvalbardMeleeSpecial = Class(MeleeWeapon)

function SvalbardMeleeSpecial:onAttackHit(peep, target)
	local attack = MeleeWeapon.onAttackHit(self, peep, target)
	peep:poke('heal', {
		hitPoints = attack:getDamage() * 2 
	})
end

function SvalbardMeleeSpecial:onAttackMiss(peep, target)
	MeleeWeapon.onAttackMiss(self, peep, target)

	local damage = self:rollDamage(peep, Weapon.PURPOSE_KILL, target):roll()
	peep:poke('heal', {
		hitPoints = damage * 2,
		zealous = true
	})
end

function SvalbardMeleeSpecial:getBonusForStance(peep)
	return Weapon.BONUS_MAGIC
end

function SvalbardMeleeSpecial:getSkill(purpose)
	return true, "Strength", "Attack"
end

function SvalbardMeleeSpecial:getAttackRange()
	return 3
end

function SvalbardMeleeSpecial:onEquip(peep)
	peep:poke('equipSpecialWeapon', self, "Special (Melee)")
end

function SvalbardMeleeSpecial:getWeaponType()
	return 'unarmed'
end

function SvalbardMeleeSpecial:getCooldown(peep)
	return 3
end

return SvalbardMeleeSpecial
