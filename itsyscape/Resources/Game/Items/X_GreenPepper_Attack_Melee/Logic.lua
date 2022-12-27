--------------------------------------------------------------------------------
-- Resources/Game/Items/X_GreenPepper_Attack_Melee/Logic.lua
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

local GreenPepperMeleeAttack = Class(MeleeWeapon)

function GreenPepperMeleeAttack:getAttackRange()
	return 3
end

function GreenPepperMeleeAttack:getBonusForStance(peep)
	return Weapon.BONUS_CRUSH
end

function GreenPepperMeleeAttack:getWeaponType()
	return 'unarmed'
end

function GreenPepperMeleeAttack:getCooldown(peep)
	return 1.6
end

return GreenPepperMeleeAttack
