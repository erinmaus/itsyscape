--------------------------------------------------------------------------------
-- ItsyScape/Game/MeleeWeapon.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Weapon = require "ItsyScape.Game.Weapon"

local MeleeWeapon = Class(Weapon)

function MeleeWeapon:getAttackRange(peep)
	return 1
end

function MeleeWeapon:getStyle()
	return Weapon.STYLE_MELEE
end

return MeleeWeapon
