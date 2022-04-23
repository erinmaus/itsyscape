--------------------------------------------------------------------------------
-- Resources/Game/Items/Common/Pistol.lua
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

local Pistol = Class(RangedWeapon)
Pistol.AMMO = Equipment.AMMO_BULLET

function Pistol:getAttackRange()
	return 6
end

function Pistol:getWeaponType()
	return 'pistol'
end

function Pistol:getCooldown(peep)
	return 1.2
end

return Pistol
