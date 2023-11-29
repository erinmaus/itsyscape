--------------------------------------------------------------------------------
-- Resources/Game/Effects/Tetanus/Effect.lua
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
local Effect = require "ItsyScape.Peep.Effect"
local CombatEffect = require "ItsyScape.Peep.Effects.CombatEffect"

-- Increases minimum damage by 1 per hit, up to 20% of max hit.
local Tetanus = Class(CombatEffect)

Tetanus.DURATION = 10
Tetanus.MAX_DAMAGE = 0.2

function Tetanus:new(activator)
	CombatEffect.new(self)

	self.currentBoost = 1
	self.activator = activator
end

function Tetanus:getDescription()
	return string.format("+%d dmg", self.currentBoost)
end

function Tetanus:boost()
	local maxDamageBoost = 1

	local weapon = Utility.Peep.getEquippedWeapon(self.activator, true)
	if weapon then
		local damageRoll = weapon:rollDamage(self.activator, Weapon.PURPOSE_KILL, self:getPeep())
		maxDamageBoost = math.floor(damageRoll:getMaxHit() * Tetanus.MAX_DAMAGE + 0.5)
	end

	local oldBoost = self.currentBoost
	self.currentBoost = math.min(self.currentBoost + 1, maxDamageBoost)
	self:setDuration(Tetanus.DURATION)

	if self.currentBoost > oldBoost then
		Log.info("Increased Tetanus minimum damage to %d from %d.", self.currentBoost, oldBoost)
	elseif self.currentBoost < oldBoost then
		Log.info("Decreased Tetanus minimum damage to %d from %d.", self.currentBoost, oldBoost)
	else
		Log.info("Tetanus minimum damage (%d) did not increase; reached maximum boost.", self.currentBoost)
	end
end

function Tetanus:getBuffType()
	return Effect.BUFF_TYPE_NEGATIVE
end

function Tetanus:applyTargetToDamage(damageRoll)
	damageRoll:setMinHit(damageRoll:getMinHit() + self.currentBoost)
end

return Tetanus
