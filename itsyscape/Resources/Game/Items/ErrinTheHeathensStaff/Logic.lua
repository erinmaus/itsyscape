--------------------------------------------------------------------------------
-- Resources/Game/Items/ErrinTheHeathensStaff/Logic.lua
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

local ErrinTheHeathensStaff = Class(MagicWeapon)

function ErrinTheHeathensStaff:getFarAttackRange(peep)
	return 10
end

function ErrinTheHeathensStaff:getNearAttackRange(peep)
	return 1
end

function ErrinTheHeathensStaff:getBonusForStance(peep)
	if self:getSpell(peep) then
		return Weapon.BONUS_MAGIC
	else
		return Weapon.BONUS_CRUSH
	end
end

function ErrinTheHeathensStaff:getWeaponType()
	return 'staff'
end

function ErrinTheHeathensStaff:getStyle()
	return Weapon.STYLE_MAGIC
end

return ErrinTheHeathensStaff
