--------------------------------------------------------------------------------
-- Resources/Game/Items/X_MagmaSnailRock/Logic.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Equipment = require "ItsyScape.Game.Equipment"
local RangedWeapon = require "ItsyScape.Game.RangedWeapon"

local MagmaSnailRock = Class(RangedWeapon)
MagmaSnailRock.AMMO = Equipment.AMMO_NONE

function MagmaSnailRock:getAmmo()
	return Equipment.AMMO_NONE
end

function MagmaSnailRock:getAttackRange(peep)
	return 4
end

function MagmaSnailRock:getProjectile()
	return 'MagmaSnailRock'
end

function MagmaSnailRock:getCooldown()
	return 1.2
end

return MagmaSnailRock
