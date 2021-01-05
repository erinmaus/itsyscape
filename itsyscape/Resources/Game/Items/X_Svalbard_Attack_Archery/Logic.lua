--------------------------------------------------------------------------------
-- Resources/Game/Items/X_Svalbard_Attack_Archery/Logic.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Weapon = require "ItsyScape.Game.Weapon"
local RangedWeapon = require "ItsyScape.Game.RangedWeapon"

local SvalbardArcheryAttack = Class(RangedWeapon)
SvalbardArcheryAttack.AMMO = Weapon.AMMO_NONE

function SvalbardArcheryAttack:getBonusForStance(peep)
	return Weapon.BONUS_ARCHERY
end

function SvalbardArcheryAttack:getAttackRange()
	return 32
end

function SvalbardArcheryAttack:onEquip(peep)
	peep:poke('fly')
	peep:poke('equipXWeapon', self, "Attack (Archery)")
end

function SvalbardArcheryAttack:getWeaponType()
	return 'unarmed'
end

function SvalbardArcheryAttack:getCooldown(peep)
	return 3
end

function SvalbardArcheryAttack:getProjectile()
	return nil
end

return SvalbardArcheryAttack
