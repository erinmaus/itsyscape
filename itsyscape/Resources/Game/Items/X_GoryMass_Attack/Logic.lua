--------------------------------------------------------------------------------
-- Resources/Game/Items/X_GoryMass_Attack/Logic.lua
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

local GoryMassAttack = Class(MeleeWeapon)

function GoryMassAttack:rollDamage(peep, purpose, target)
	local roll = MeleeWeapon.rollDamage(self, peep, purpose, target)
	local maxHit = roll:getMaxHit()
	local minHit = math.floor(maxHit / 2)
	roll:setMinHit(minHit)

	return roll
end

function GoryMassAttack:perform(peep, target)
	self:onAttackHit(peep, target)
end

function GoryMassAttack:getBonusForStance(peep)
	return Weapon.BONUS_CRUSH
end

function GoryMassAttack:getWeaponType()
	return 'unarmed'
end

return GoryMassAttack
