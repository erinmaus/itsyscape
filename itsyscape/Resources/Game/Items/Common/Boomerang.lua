--------------------------------------------------------------------------------
-- Resources/Game/Items/Common/Boomerang.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Weapon = require "ItsyScape.Game.Weapon"
local Equipment = require "ItsyScape.Game.Equipment"
local RangedWeapon = require "ItsyScape.Game.RangedWeapon"

local Boomerang = Class(RangedWeapon)
Boomerang.AMMO = Equipment.AMMO_NONE

function Boomerang:getAttackRange()
	return 5
end

function Boomerang:getWeaponType()
	return 'boomerang'
end

function Boomerang:getCooldown(peep)
	return 1.2
end

return Boomerang
