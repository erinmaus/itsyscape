--------------------------------------------------------------------------------
-- Resources/Game/Items/Common/FishingRod.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Weapon = require "ItsyScape.Game.Weapon"
local Weapon = require "ItsyScape.Game.Weapon"
local MeleeWeapon = require "ItsyScape.Game.MeleeWeapon"

local FishingRod = Class(MeleeWeapon)

function FishingRod:getAttackRange()
	return 2
end

function FishingRod:getBonusForStance(peep)
	return Weapon.BONUS_CRUSH
end

function FishingRod:getWeaponType()
	return 'pickaxe'
end

function FishingRod:getSkill(purpose)
	if purpose == Weapon.PURPOSE_TOOL then
		return true, "Fishing", "Fishing"
	elseif purpose == Weapon.PURPOSE_KILL then
		return true, "Strength", "Attack"
	else
		return false
	end
end

function FishingRod:getWeaponType()
	return 'fishing-rod'
end

function FishingRod:getCooldown(peep)
	return 5.6
end

return FishingRod
