--------------------------------------------------------------------------------
-- Resources/Game/Items/X_Power_Headshot/Logic.lua
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

-- Less accurate shot (20% lower attack roll), but deals damage from 200% to 400%.
-- An additional 100% against undead. 
local Headshot = Class(ProxyXWeapon)
Headshot.ACCURACY_DEBUFF = 0.8
Headshot.UNDEAD_DAMAGE_MODIFIER = 1
Headshot.MIN_DAMAGE_MULTIPLIER  = 2
Headshot.MAX_DAMAGE_MULTIPLIER  = 4

function Headshot:previewAttackRoll(roll)
	ProxyXWeapon.previewAttackRoll(self, roll)

	roll:setMaxAttackRoll(roll:getMaxAttackRoll() * Headshot.ACCURACY_DEBUFF)
end

function Headshot:previewDamageRoll(roll)
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

	local minDamageMultiplier = Headshot.MIN_DAMAGE_MULTIPLIER
	local maxDamageMultiplier = Headshot.MAX_DAMAGE_MULTIPLIER
	if isUndead then
		minDamageMultiplier = minDamageMultiplier + Headshot.UNDEAD_DAMAGE_MODIFIER
		maxDamageMultiplier = maxDamageMultiplier + Headshot.UNDEAD_DAMAGE_MODIFIER
		Log.info("Target '%s' is undead, dealing extra damage.", roll:getTarget():getName())
	end

	Log.info(
		"Damage multiplier against target '%s' is %d%% - %d%%.",
		roll:getTarget():getName(),
		minDamageMultiplier * 100,
		maxDamageMultiplier * 100)

	roll:setMinHit(roll:getMinHit() * minDamageMultiplier)
	roll:setMaxHit(roll:getMaxHit() * maxDamageMultiplier)
end

return Headshot
