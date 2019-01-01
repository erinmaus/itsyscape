--------------------------------------------------------------------------------
-- Resources/Game/Items/Common/Cane.lua
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

local Cane = Class(MagicWeapon)

function Cane:getFarAttackRange(peep)
	return 6
end

function Cane:getNearAttackRange(peep)
	return 1
end

function Cane:getBonusForStance(peep)
	if self:getSpell(peep) then
		return Weapon.BONUS_MAGIC
	else
		return Weapon.BONUS_SLASH
	end
end

function Cane:getWeaponType()
	return 'cane'
end

function Cane:getStyle()
	return Weapon.STYLE_MAGIC
end

function Cane:getCooldown()
	return 3.0
end

return Cane
