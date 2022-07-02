--------------------------------------------------------------------------------
-- Resources/Game/Items/X_BoopSmash/Logic.lua
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

local BoopSmash = Class(MeleeWeapon)

function BoopSmash:getAttackRange(peep)
	return 2.5
end

function BoopSmash:getBonusForStance(peep)
	return Weapon.BONUS_CRUSH
end

function BoopSmash:getCooldown()
	return 1.8
end

return BoopSmash
