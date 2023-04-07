--------------------------------------------------------------------------------
-- Resources/Game/Items/Common/Staff.lua
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

local Staff = Class(MagicWeapon)

function Staff:getFarAttackRange(peep)
	return 10
end

function Staff:getNearAttackRange(peep)
	return 1
end

function Staff:getBonusForStance(peep)
	local spell = self:getSpell(peep)
	if self:getSpell(peep) then
		return spell:getBonusForStance(peep) or Weapon.BONUS_MAGIC
	else
		return Weapon.BONUS_CRUSH
	end
end

function Staff:getWeaponType()
	return 'staff'
end

function Staff:getStyle()
	return Weapon.STYLE_MAGIC
end

function Staff:getCooldown()
	return 3.6
end

return Staff
