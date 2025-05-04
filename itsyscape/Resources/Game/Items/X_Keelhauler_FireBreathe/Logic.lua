--------------------------------------------------------------------------------
-- Resources/Game/Items/X_Keelhauler_FireBreathe/Logic.lua
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
local MagicWeapon = require "ItsyScape.Game.MagicWeapon"
local AttackPoke = require "ItsyScape.Peep.AttackPoke"
local StanceBehavior = require "ItsyScape.Peep.Behaviors.StanceBehavior"

local FireBreathe = Class(MagicWeapon)

function FireBreathe:getBonusForStance(peep)
	return Weapon.BONUS_MAGIC
end

function FireBreathe:getAttackRange()
	return 8
end

function FireBreathe:getWeaponType()
	return 'unarmed'
end

function FireBreathe:onEquip(peep)
	local resource = Utility.Peep.getResource(peep)
	if resource and resource.name == "Keelhauler" then
		Utility.Peep.Creep.addAnimation(peep, "animation-attack", "Keelhauler_Attack_Magic")
	end
end

function FireBreathe:getCooldown(peep)
	local stance = peep:getBehavior(StanceBehavior)
	if stance and stance.stance == Weapon.STANCE_AGGRESSIVE then
		return 6
	else
		return 4
	end
end

return FireBreathe
