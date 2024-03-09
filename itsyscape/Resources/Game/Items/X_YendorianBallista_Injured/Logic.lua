--------------------------------------------------------------------------------
-- Resources/Game/Items/X_YendorianBallista_Injured/Logic.lua
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

local YendorianBallista = Class(RangedWeapon)
YendorianBallista.AMMO = Equipment.AMMO_NONE

function YendorianBallista:getAmmo()
	return Equipment.AMMO_NONE
end

function YendorianBallista:getAttackRange(peep)
	return 10
end

function YendorianBallista:getWeaponType()
	return 'ballista'
end

function YendorianBallista:getProjectile()
	return 'YendorianBallista'
end

function YendorianBallista:getDelay()
	return 26 / 24
end

function YendorianBallista:getCooldown()
	return 3
end

return YendorianBallista
