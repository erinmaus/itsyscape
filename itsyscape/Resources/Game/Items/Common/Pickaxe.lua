--------------------------------------------------------------------------------
-- Resources/Game/Items/Common/Pickaxe.lua
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

local Pickaxe = Class(MeleeWeapon)

function Pickaxe:getBonusForStance(peep)
	return Weapon.BONUS_STAB
end

function Pickaxe:getWeaponType()
	return 'pickaxe'
end

function Pickaxe:getSkill(purpose)
	if purpose == Weapon.PURPOSE_TOOL then
		return true, "Mining", "Mining"
	elseif purpose == Weapon.PURPOSE_KILL then
		return true, "Strength", "Attack"
	else
		return false
	end
end

function Pickaxe:getWeaponType()
	return 'pickaxe'
end

function Pickaxe:getCooldown(peep)
	return 1.2
end

return Pickaxe
