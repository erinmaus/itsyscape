--------------------------------------------------------------------------------
-- ItsyScape/Game/ShipWeapon.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Weapon = require "ItsyScape.Game.Weapon"
local Sailing = require "ItsyScape.Game.Skills.Sailing"

local ShipWeapon = Class(Weapon)

function ShipWeapon:rollDamage(peep, purpose, target)
	local roll = Weapon.DamageRoll(self, peep, purpose or Weapon.PURPOSE_TOOL, target)

	if roll:getBonus() < 0 then
		Log.info("Bonus less than zero for ammo '%s', dealing no damage.", self:getID())
		roll:setDamageMultiplier(0)
	end

	roll:setMinHit(Sailing.calcCannonMinHit(roll:getLevel(), roll:getBonus()))
	roll:setMaxHit(Sailing.calcCannonMaxHit(roll:getLevel(), roll:getBonus()))

	self:applyAttackModifiers(roll)
	self:previewAttackRoll(roll)

	return roll
end

function ShipWeapon:rollAttack(peep, target, bonus)
	local roll = Weapon.rollAttack(self, peep, target, bonus)
	roll:setAlwaysHits(true)

	return roll
end

function ShipWeapon:getAttackRange()
	return math.huge
end

function ShipWeapon:getStyle()
	return Weapon.STYLE_SAILING
end

function ShipWeapon:getCooldown()
	return 0
end

function ShipWeapon:getBonusForStance()
	return Weapon.BONUS_NONE
end

function ShipWeapon:getSkill()
	return true, "Sailing", "Sailing"
end

return ShipWeapon
