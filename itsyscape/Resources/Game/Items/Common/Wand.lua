--------------------------------------------------------------------------------
-- Resources/Game/Items/Common/Wand.lua
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

local Wand = Class(MagicWeapon)

function Wand:getFarAttackRange(peep)
	return 4
end

function Wand:getNearAttackRange(peep)
	return 1
end

function Wand:getBonusForStance(peep)
	local spell = self:getSpell(peep)
	if self:getSpell(peep) then
		return spell:getBonusForStance(peep) or Weapon.BONUS_MAGIC
	else
		return Weapon.BONUS_STAB
	end
end

function Wand:getWeaponType()
	return 'wand'
end

function Wand:getStyle()
	return Weapon.STYLE_MAGIC
end

function Wand:getCooldown()
	return 1.8
end

return Wand
