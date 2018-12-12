--------------------------------------------------------------------------------
-- Resources/Game/Items/Common/Longbow.lua
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

local Longbow = Class(RangedWeapon)
Longbow.AMMO = Equipment.AMMO_ARROW

function Longbow:getAttackRange()
	return 12
end

function Longbow:getWeaponType()
	return 'longbow'
end

function Longbow:getCooldown(peep)
	return 3.0
end

return Longbow
