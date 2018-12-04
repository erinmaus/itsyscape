--------------------------------------------------------------------------------
-- Resources/Game/Items/Common/Bow.lua
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

local Bow = Class(RangedWeapon)
Bow.AMMO = Equipment.AMMO_ARROW

function Bow:getAttackRange()
	return 7
end

function Bow:getWeaponType()
	return 'bow'
end

function Bow:getCooldown(peep)
	return 1.8
end

return Bow
