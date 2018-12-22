--------------------------------------------------------------------------------
-- Resources/Game/Items/X_UndeadSquidRock/Logic.lua
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

local UndeadSquidRock = Class(RangedWeapon)
UndeadSquidRock.AMMO = Equipment.AMMO_NONE

function UndeadSquidRock:getAmmo()
	return Equipment.AMMO_NONE
end

function UndeadSquidRock:getAttackRange(peep)
	return math.huge
end

function UndeadSquidRock:getProjectile()
	return 'UndeadSquidRock'
end

function UndeadSquidRock:getCooldown()
	return 1.8
end

return UndeadSquidRock
