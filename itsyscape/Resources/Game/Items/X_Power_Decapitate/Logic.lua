--------------------------------------------------------------------------------
-- Resources/Game/Items/X_Power_Decapitate/Logic.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Vector = require "ItsyScape.Common.Math.Vector"
local ProxyXWeapon = require "ItsyScape.Game.ProxyXWeapon"
local Utility = require "ItsyScape.Game.Utility"
local SpecialAttackBehavior = require "ItsyScape.Peep.Behaviors.SpecialAttackBehavior"

-- Less accurate shot (20% lower attack skill), but deals damage from 200% to 400%.
-- An additional 100% against undead.
-- Always hits following the foe using a special attack.
local Decapitate = Class(ProxyXWeapon)
Decapitate.ACCURACY_DEBUFF = 0.8
Decapitate.UNDEAD_DAMAGE_MODIFIER = 1
Decapitate.MIN_DAMAGE_MULTIPLIER  = 2
Decapitate.MAX_DAMAGE_MULTIPLIER  = 4

function Decapitate:previewAttackRoll(roll)
	ProxyXWeapon.previewAttackRoll(self, roll)

	local target = roll:getTarget()
	if target and target:hasBehavior(SpecialAttackBehavior) then
		roll:setAlwaysHits(true)
	else
		roll:setAttackLevel(math.floor(roll:getAttackLevel() * Decapitate.ACCURACY_DEBUFF + 0.5))
	end
end

function Decapitate:onAttackHit(peep, target, ...)
	ProxyXWeapon.onAttackHit(self, peep, target, ...)

	local stage = target:getDirector():getGameInstance():getStage()
	stage:fireProjectile("Power_Decapitate", peep, target)

	Utility.Combat.tryPunish(target, peep)
end

function Decapitate:previewDamageRoll(roll)
	ProxyXWeapon.previewDamageRoll(self, roll)

	local isUndead = false
	do
		local target = roll:getTarget()
		local resource = Utility.Peep.getResource(target)
		if resource then
			local gameDB = target:getDirector():getGameDB()
			local tag = gameDB:getRecord("ResourceTag", { Value = "Undead", Resource = resource })
			if tag then
				isUndead = true
			end
		end
	end

	local minDamageMultiplier = Decapitate.MIN_DAMAGE_MULTIPLIER
	local maxDamageMultiplier = Decapitate.MAX_DAMAGE_MULTIPLIER
	if isUndead then
		minDamageMultiplier = minDamageMultiplier + Decapitate.UNDEAD_DAMAGE_MODIFIER
		maxDamageMultiplier = maxDamageMultiplier + Decapitate.UNDEAD_DAMAGE_MODIFIER
		Log.info("Target '%s' is undead, dealing extra damage.", roll:getTarget():getName())
	end

	local target = roll:getTarget()
	if target and target:hasBehavior(SpecialAttackBehavior) then
		minDamageMultiplier = maxDamageMultiplier
	end

	Log.info(
		"Damage multiplier against target '%s' is %d%% - %d%%.",
		roll:getTarget():getName(),
		minDamageMultiplier * 100,
		maxDamageMultiplier * 100)

	roll:setMinHit(roll:getMinHit() * minDamageMultiplier)
	roll:setMaxHit(roll:getMaxHit() * maxDamageMultiplier)
end

return Decapitate
