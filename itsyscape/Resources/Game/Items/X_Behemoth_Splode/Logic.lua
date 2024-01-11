--------------------------------------------------------------------------------
-- Resources/Game/Items/X_Behemoth_Splode/Logic.lua
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
local RangedWeapon = require "ItsyScape.Game.RangedWeapon"

local BehemothSplode = Class(RangedWeapon)
BehemothSplode.AMMO = Weapon.AMMO_NONE

function BehemothSplode:previewAttackRoll(roll)
	roll:setAlwaysHits(true)
end

function BehemothSplode:getAttackRange(peep)
	return 16
end

function BehemothSplode:getCooldown()
	return 2
end

return BehemothSplode
