--------------------------------------------------------------------------------
-- Resources/Game/Items/X_Dummy_Bow/Logic.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local RangedWeapon = require "ItsyScape.Game.RangedWeapon"
local Utility = require "ItsyScape.Game.Utility"

local XDummyBow = Class(RangedWeapon)
XDummyBow.AMMO = RangedWeapon.AMMO_NONE

function XDummyBow:getCooldown(peep)
	return Utility.Peep.Dummy.getAttackCooldown(peep) or 2.4
end

function XDummyBow:getAttackRange(peep)
	return Utility.Peep.Dummy.getAttackRange(peep) or 8
end

function XDummyBow:getProjectile(peep)
	return Utility.Peep.Dummy.getProjectile(peep) or "BronzeArrow"
end

return XDummyBow
