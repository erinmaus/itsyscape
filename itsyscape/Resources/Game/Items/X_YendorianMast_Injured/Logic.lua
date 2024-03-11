--------------------------------------------------------------------------------
-- Resources/Game/Items/X_YendorianMast_Injured/Logic.lua
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

function YendorianMast:rollDamage(peep, purpose, target)
	-- We want to overrie the magic damage.
	return Weapon.rollDamage(peep, purpose, target)
end

function YendorianMast:getAttackRange()
	return 4
end

function YendorianMast:getWeaponType()
	return 'staff'
end

function YendorianMast:getCooldown(peep)
	return 3
end

function YendorianMast:getProjectile()
	return "StormLightning"
end

return YendorianMast
