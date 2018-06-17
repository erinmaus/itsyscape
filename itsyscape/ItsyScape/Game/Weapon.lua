--------------------------------------------------------------------------------
-- ItsyScape/Game/Equipment.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Equipment = require "ItsyScape.Game.Equipment"

local Weapon = Class(Equipment)
Weapon.STANCE_AGGRESSIVE = 1 -- Gives strength, wisdom, or dexterity XP
Weapon.STANCE_CONTROLLED = 2 -- Gives attack, magic, or archery XP
Weapon.STANCE_DEFENSIVE  = 3 -- Gives defense XP
Weapon.STYLE_MAGIC   = 1
Weapon.STYLE_ARCHERY = 2
Weapon.STYLE_MELEE   = 3

function Weapon:getAttackRange(peep)
	return 1
end

function Weapon:perform(peep)
	-- Nothing.
end

function Weapon:getStyle()
	return Weapon.STYLE_MELEE
end

return Weapon
