--------------------------------------------------------------------------------
-- Resources/Game/Items/X_RatKingsJester_Splosion/Logic.lua
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
local RangedWeapon = require "ItsyScape.Game.RangedWeapon"

local Splosion = Class(RangedWeapon)
Splosion.AMMO = RangedWeapon.AMMO_NONE

function Splosion:getAttackRange()
	return math.huge
end

function Splosion:rollAttack(peep, target, bonus)
	local attackRoll = RangedWeapon.rollAttack(self, peep, target, bonus)
	attackRoll:setAlwaysHits(true)

	return attackRoll
end

return Splosion
