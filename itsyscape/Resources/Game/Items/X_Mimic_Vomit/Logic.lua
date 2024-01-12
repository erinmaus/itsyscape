--------------------------------------------------------------------------------
-- Resources/Game/Items/X_Mimic_Vomit/Logic.lua
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
local Utility = require "ItsyScape.Game.Utility"
local RangedWeapon = require "ItsyScape.Game.RangedWeapon"

local MimicVomit = Class(RangedWeapon)
MimicVomit.AMMO = Weapon.AMMO_NONE

function MimicVomit:getAttackRange(peep)
	return 10
end

function MimicVomit:getCooldown()
	return 2.5
end

function MimicVomit:getProjectile(peep)
	local resource = Utility.Peep.getResource(peep)
	if not resource then
		return nil
	end

	if resource.name == "ChestMimic" then
		return "MimicVomit_Coins"
	elseif resource.name == "CrateMimic" then
		return "MimicVomit_Planks"
	elseif resource.name == "BarrelMimic" then
		return "MimicVomit_Ale"
	end

	return "MimicVomit_Planks"
end

return MimicVomit
