--------------------------------------------------------------------------------
-- Resources/Game/Items/X_RatKing_Bite/Logic.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Weapon = require "ItsyScape.Game.Weapon"
local Utility = require "ItsyScape.Game.Utility"
local MeleeWeapon = require "ItsyScape.Game.MeleeWeapon"

local RatKingUnleashedBite = Class(MeleeWeapon)

function RatKingUnleashedBite:getAttackRange()
	return 2
end

function RatKingUnleashedBite:getBonusForStance(peep)
	return Weapon.BONUS_STAB
end

function RatKingUnleashedBite:getCooldown(peep)
	return 3
end

return RatKingUnleashedBite
