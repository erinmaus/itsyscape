--------------------------------------------------------------------------------
-- Resources/Game/Items/Common/Blunderbuss.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Equipment = require "ItsyScape.Game.Equipment"
local Utility = require "ItsyScape.Game.Utility"
local RangedWeapon = require "ItsyScape.Game.RangedWeapon"

local Blunderbuss = Class(RangedWeapon)
Blunderbuss.AMMO = Equipment.AMMO_BULLET
Blunderbuss.FULL_DAMAGE_DISTANCE = 2

function Blunderbuss:getAttackRange()
	return 8
end

function Blunderbuss:rollDamage(peep, purpose, target)
	local roll = RangedWeapon.rollDamage(self, peep, purpose, target)
	local selfPosition = Utility.Peep.getAbsolutePosition(peep)
	local targetPosition = Utility.Peep.getAbsolutePosition(target)
	local distance = math.max((targetPosition - selfPosition):getLength() - self.FULL_DAMAGE_DISTANCE, 0)
	local range = math.max(self:getAttackRange() - self.FULL_DAMAGE_DISTANCE, 1)
	local multiplier = 1 - distance / (range + 1)

	roll:setDamageMultiplier(roll:getDamageMultiplier() * multiplier)
	return roll
end

function Blunderbuss:getWeaponType()
	return 'blunderbuss'
end

function Blunderbuss:getCooldown(peep)
	return 3
end

function RangedWeapon:getProjectile(peep)
	return nil
end

return Blunderbuss
