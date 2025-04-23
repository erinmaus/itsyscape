--------------------------------------------------------------------------------
-- Resources/Game/Items/X_Keelhauler_Bite/Logic.lua
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
local Utility = require "ItsyScape.Game.Utility"
local AttackPoke = require "ItsyScape.Peep.AttackPoke"
local StanceBehavior = require "ItsyScape.Peep.Behaviors.StanceBehavior"

local Bite = Class(MeleeWeapon)

function Bite:getBonusForStance(peep)
	return Weapon.BONUS_CRUSH
end

function Bite:getAttackRange()
	return 4
end

function Bite:getWeaponType()
	return 'unarmed'
end

function Bite:onEquip(peep)
	local resource = Utility.Peep.getResource(peep)
	if resource and resource.name == "Keelhauler" then
		Utility.Peep.Creep.addAnimation(peep, "animation-attack", "Keelhauler_Attack_Melee")
	end
end

function Bite:getCooldown(peep)
	local stance = peep:getBehavior(StanceBehavior)
	if stance and stance.stance == Weapon.STANCE_AGGRESSIVE then
		return 6
	else
		return 4
	end
end

return Bite
