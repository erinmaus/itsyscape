--------------------------------------------------------------------------------
-- Resources/Game/Items/X_Power_Hesitate/Logic.lua
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
local Effect = require "ItsyScape.Peep.Effect"
local CombatEffect = require "ItsyScape.Peep.Effects.CombatEffect"

-- More accurate shot (50% higher attack roll). Deals a delayed 100% damage,
-- ignoring all debuffs on self and all buffs on target.
local Hesitate = Class(ProxyXWeapon)
Hesitate.ACCURACY_BUFF = 1.5
Hesitate.DELAY = 2

function Hesitate:applyAttackModifiers(roll)
	for effect in roll:getSelf():getEffects(CombatEffect) do
		if effect:getBuffType() ~= Effect.BUFF_TYPE_NEGATIVE then
			effect:applySelfToAttack(roll)
		end
	end

	for effect in roll:getTarget():getEffects(CombatEffect) do
		if effect:getBuffType() == Effect.BUFF_TYPE_NEGATIVE then
			effect:applyTargetToAttack(roll)
		end
	end
end

function Hesitate:previewAttackRoll(roll)
	ProxyXWeapon.previewAttackRoll(self, roll)

	roll:setMaxAttackRoll(roll:getMaxAttackRoll() * Hesitate.ACCURACY_BUFF)
end

function Hesitate:applyDamageModifiers(roll)
	for effect in roll:getSelf():getEffects(CombatEffect) do
		if effect:getBuffType() ~= Effect.BUFF_TYPE_NEGATIVE then
			effect:applySelfToDamage(roll, purpose)
		end
	end

	for effect in roll:getTarget():getEffects(CombatEffect) do
		if effect:getBuffType() == Effect.BUFF_TYPE_NEGATIVE then
			effect:applyTargetToDamage(roll, purpose)
		end
	end
end

function Hesitate:previewDamageRoll(roll)
	ProxyXWeapon.previewDamageRoll(self, roll)
	roll:setMinHit(roll:getMaxHit())
end

function Hesitate:getDelay()
	return Hesitate.DELAY
end

return Hesitate
