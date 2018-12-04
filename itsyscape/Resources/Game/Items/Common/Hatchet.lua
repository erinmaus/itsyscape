--------------------------------------------------------------------------------
-- Resources/Game/Items/Common/Hatchet.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Weapon = require "ItsyScape.Game.Weapon"
local MeleeWeapon = require "ItsyScape.Game.MeleeWeapon"

local Hatchet = Class(MeleeWeapon)

function Hatchet:getBonusForStance(peep)
	return Weapon.BONUS_SLASH
end

function Hatchet:getWeaponType()
	return 'pickaxe'
end

function Hatchet:getSkill(purpose)
	if purpose == Weapon.PURPOSE_TOOL then
		return true, "Woodcutting", "Woodcutting"
	elseif purpose == Weapon.PURPOSE_KILL then
		return true, "Strength", "Attack"
	else
		return false
	end
end

function Hatchet:getCooldown(peep)
	return 1.8
end

return Hatchet
