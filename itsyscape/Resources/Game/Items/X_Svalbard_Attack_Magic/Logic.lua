--------------------------------------------------------------------------------
-- Resources/Game/Items/X_Svalbard_Attack_Magic/Logic.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Weapon = require "ItsyScape.Game.Weapon"
local MagicWeapon = require "ItsyScape.Game.MagicWeapon"

local SvalbardMagicAttack = Class(MagicWeapon)

function SvalbardMagicAttack:getBonusForStance(peep)
	return Weapon.BONUS_MAGIC
end

function SvalbardMagicAttack:getAttackRange()
	return 32
end

function SvalbardMagicAttack:onEquip(peep)
	peep:poke('equipXWeapon', self, "Attack (Melee)")
end

function SvalbardMagicAttack:getWeaponType()
	return 'unarmed'
end

function SvalbardMagicAttack:getCooldown(peep)
	return 3
end

function SvalbardMagicAttack:getProjectile()
	return nil
end

return SvalbardMagicAttack
