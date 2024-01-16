--------------------------------------------------------------------------------
-- Resources/Game/Items/X_DisemboweledSmash/Logic.lua
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

local SmashAttack = Class(MeleeWeapon)

function SmashAttack:getAttackRange()
	return 2
end

function SmashAttack:getBonusForStance(peep)
	return Weapon.BONUS_CRUSH
end

function SmashAttack:getWeaponType()
	return 'unarmed'
end

function SmashAttack:getCooldown(peep)
	return 2
end

return SmashAttack
