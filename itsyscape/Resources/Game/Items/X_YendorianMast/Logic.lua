--------------------------------------------------------------------------------
-- Resources/Game/Items/X_Svalbard_Attack_Magic/Logic.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Weapon = require "ItsyScape.Game.Weapon"
local MagicWeapon = require "ItsyScape.Game.MagicWeapon"

local YendorianMast = Class(MagicWeapon)

function YendorianMast:getBonusForStance(peep)
	return Weapon.BONUS_MAGIC
end

function YendorianMast:getAttackRange()
	return 11
end

function YendorianMast:getWeaponType()
	return 'staff'
end

function YendorianMast:getCooldown(peep)
	return 1.8
end

return YendorianMast
