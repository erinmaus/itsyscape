--------------------------------------------------------------------------------
-- Resources/Game/Items/X_MimicBite/Logic.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Equipment = require "ItsyScape.Game.Equipment"
local Weapon = require "ItsyScape.Game.Weapon"
local MeleeWeapon = require "ItsyScape.Game.MeleeWeapon"

local MimicBite = Class(MeleeWeapon)

function MimicBite:getAttackRange(peep)
	return 1
end

function MimicBite:getBonusForStance(peep)
	return Weapon.BONUS_STAB
end

function MimicBite:getCooldown()
	return 1.8
end

return MimicBite
