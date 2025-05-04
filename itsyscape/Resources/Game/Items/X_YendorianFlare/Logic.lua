--------------------------------------------------------------------------------
-- Resources/Game/Items/X_YendorianFlare/Logic.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Equipment = require "ItsyScape.Game.Equipment"
local Weapon = require "ItsyScape.Game.Weapon"
local RangedWeapon = require "ItsyScape.Game.RangedWeapon"

local YendorianFlare = Class(RangedWeapon)
YendorianFlare.AMMO = Equipment.AMMO_NONE

function YendorianFlare:getAttackRange()
	return 4
end

function YendorianFlare:getWeaponType()
	return 'pistol'
end

function YendorianFlare:getCooldown(peep)
	return 3
end

function YendorianFlare:getProjectile()
	return "Flare"
end

return YendorianFlare
