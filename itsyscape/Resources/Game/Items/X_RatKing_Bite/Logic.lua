--------------------------------------------------------------------------------
-- Resources/Game/Items/X_RatKing_Bite/Logic.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Weapon = require "ItsyScape.Game.Weapon"
local Utility = require "ItsyScape.Game.Utility"
local MeleeWeapon = require "ItsyScape.Game.MeleeWeapon"

local RatKingBite = Class(MeleeWeapon)

function RatKingBite:getAttackRange()
	return 2
end

function RatKingBite:getBonusForStance(peep)
	return Weapon.BONUS_STAB
end

function RatKingBite:getCooldown(peep)
	return 2.2
end

function RatKingBite._isRat(target)
	local resource = Utility.Peep.getResource(target)
	if not resource then
		return false
	end

	local tag = self:getDirector():getGameDB():getRecord({
		Value = "Rat",
		Resource = resource
	})

	if tag then
		return true
	else
		return false
	end
end

function RatKingBite:rollAttack(peep, target, bonus)
	local attackRoll = MeleeWeapon.rollAttack(self, peep, target, bonus)

	if RatKingBite._isRat(target) then
		attackRoll:setAlwaysHits(true)
	end

	return attackRoll
end

function RatKingBite:rollDamage(peep, purpose, target)
	local damageRoll = MeleeWeapon.rollDamage(self, peep, purpose, target)

	if RatKingBite._isRat(target) then
		damageRoll:setMinHit(20)
		damageRoll:setMaxHit(40)
	end

	return damageRoll
end

return RatKingBite
