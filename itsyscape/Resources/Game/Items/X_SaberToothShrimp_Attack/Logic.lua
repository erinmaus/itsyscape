--------------------------------------------------------------------------------
-- Resources/Game/Items/X_SaberToothShrimp_Attack/Logic.lua
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

local Fire = Class(RangedWeapon)
Fire.AMMO = Equipment.AMMO_NONE

function Fire:getAttackRange(peep)
	return math.huge
end

function Fire:getCooldown()
	return 1.2
end

return Fire
