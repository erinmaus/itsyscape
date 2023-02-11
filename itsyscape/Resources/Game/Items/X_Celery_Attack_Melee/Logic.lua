--------------------------------------------------------------------------------
-- Resources/Game/Items/X_Celery_Attack_Melee/Logic.lua
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

local CeleryMeleeAttack = Class(MeleeWeapon)

function CeleryMeleeAttack:getAttackRange()
	return 2
end

function CeleryMeleeAttack:getBonusForStance(peep)
	return Weapon.BONUS_CRUSH
end

function CeleryMeleeAttack:getWeaponType()
	return 'unarmed'
end

function CeleryMeleeAttack:getCooldown(peep)
	return 2
end

return CeleryMeleeAttack
