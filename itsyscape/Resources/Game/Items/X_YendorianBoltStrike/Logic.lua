--------------------------------------------------------------------------------
-- Resources/Game/Items/X_YendorianBoltStrike/Logic.lua
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

local YendorianBoltStrike = Class(RangedWeapon)
YendorianBoltStrike.AMMO = Equipment.AMMO_NONE

function YendorianBoltStrike:getAmmo()
	return Equipment.AMMO_NONE
end

function YendorianBoltStrike:getAttackRange(peep)
	return 11
end

function YendorianBoltStrike:getProjectile()
	return 'YendorianBoltStrike'
end

function YendorianBoltStrike:getDelay()
	return 26 / 24
end

function YendorianBoltStrike:getCooldown()
	return 1.8
end

return YendorianBoltStrike
