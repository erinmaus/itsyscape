--------------------------------------------------------------------------------
-- Resources/Game/Items/X_Keelhauler_MudSplash/Logic.lua
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
local Utility = require "ItsyScape.Game.Utility"
local AttackPoke = require "ItsyScape.Peep.AttackPoke"
local StanceBehavior = require "ItsyScape.Peep.Behaviors.StanceBehavior"

local MudSplash = Class(RangedWeapon)
MudSplash.AMMO = Equipment.AMMO_NONE

function MudSplash:getBonusForStance(peep)
	return Weapon.BONUS_ARCHERY
end

function MudSplash:getAttackRange()
	return 6
end

function MudSplash:getWeaponType()
	return 'unarmed'
end

function MudSplash:onEquip(peep)
	local resource = Utility.Peep.getResource(peep)
	if resource and resource.name == "Keelhauler" then
		Utility.Peep.Creep.addAnimation(peep, "animation-attack", "Keelhauler_Attack_Archery")
	end
end

function MudSplash:getCooldown(peep)
	local stance = peep:getBehavior(StanceBehavior)
	if stance and stance.stance == Weapon.STANCE_AGGRESSIVE then
		return 6
	else
		return 4
	end
end

function MudSplash:getProjectile()
	return "Flare"
end

return MudSplash
