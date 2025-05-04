--------------------------------------------------------------------------------
-- Resources/Game/Items/X_Keelhauler_Dash/Logic.lua
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
local ZealPoke = require "ItsyScape.Game.ZealPoke"
local AttackPoke = require "ItsyScape.Peep.AttackPoke"
local StanceBehavior = require "ItsyScape.Peep.Behaviors.StanceBehavior"
local HumanoidBehavior = require "ItsyScape.Peep.Behaviors.HumanoidBehavior"

local Dash = Class(MeleeWeapon)

function Dash:getBonusForStance(peep)
	return Weapon.BONUS_CRUSH
end

function Dash:previewAttackRoll(roll)
	MeleeWeapon.previewAttackRoll(self, roll)
	roll:setAlwaysHits(true)
end

function Dash:previewDamageRoll(roll)
	MeleeWeapon.previewDamageRoll(self, roll)
	roll:setBonus(math.floor(roll:getBonus() * 1.5))
end

function Dash:dealtDamage(peep, target, attack, roll)
	MeleeWeapon.dealtDamage(self, peep, target, attack, roll)

	local zeal = math.clamp(attack:getDamage() / 100)
	local poke = ZealPoke.onDefend({
		damageRoll = roll,
		attack = attack,
		zeal = -zeal
	})
	target:poke("zeal", poke)

	if target:hasBehavior(HumanoidBehavior) then
		Utility.Peep.playAnimation(peep, "x-keelhauler-charge", "Human_Trip_1", 10)
	end
end

function Dash:getAttackRange()
	return 4
end

function Dash:getWeaponType()
	return 'unarmed'
end

function Dash:getCooldown(peep)
	return 0
end

function Dash:getProjectile()
	return "ShockwaveSplosion"
end

return Dash
