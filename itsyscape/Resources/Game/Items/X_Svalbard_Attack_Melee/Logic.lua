--------------------------------------------------------------------------------
-- Resources/Game/Items/X_Svalbard_Attack_Melee/Logic.lua
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

local SvalbardMeleeAttack = Class(MeleeWeapon)

function SvalbardMeleeAttack:getBonusForStance(peep)
	return Weapon.BONUS_SLASH
end

function SvalbardMeleeAttack:getAttackRange()
	return 3
end

function SvalbardMeleeAttack:onEquip(peep)
	peep:poke('equipXWeapon', self, "Attack (Melee)")
end

function SvalbardMeleeAttack:getWeaponType()
	return 'unarmed'
end

function SvalbardMeleeAttack:getCooldown(peep)
	return 3
end

return SvalbardMeleeAttack
