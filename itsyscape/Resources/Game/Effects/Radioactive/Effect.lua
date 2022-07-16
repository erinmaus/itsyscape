--------------------------------------------------------------------------------
-- Resources/Game/Effects/Radioactive/Effect.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Utility = require "ItsyScape.Game.Utility"
local Effect = require "ItsyScape.Peep.Effect"
local AttackPoke = require "ItsyScape.Peep.AttackPoke"
local CombatStatusBehavior = require "ItsyScape.Peep.Behaviors.CombatStatusBehavior"
local SizeBehavior = require "ItsyScape.Peep.Behaviors.SizeBehavior"
local CombatEffect = require "ItsyScape.Peep.Effects.CombatEffect"

-- Increases accuracy and damage by 20%, but deals a damage-over-time effect.
local Radioactive = Class(CombatEffect)
Radioactive.DURATION = 60
Radioactive.OFFENSE_MULTIPLIER = 1.2
Radioactive.TICK = 6
Radioactive.DAMAGE_PER_TICK = 0.01
Radioactive.MAX_DAMAGE_PER_TICK = 20
Radioactive.SPREAD_CHANCE = 0.2
Radioactive.SPREAD_DISTANCE = 1

function Radioactive:new(activator)
	CombatEffect.new(self, activator)

	self.activator = activator
	self.tick = Radioactive.TICK
end

function Radioactive:getBuffType()
	return Effect.BUFF_TYPE_NEGATIVE
end

function Radioactive:applySelfToAttack(roll)
	local attackRoll = roll:getMaxAttackRoll() * Radioactive.OFFENSE_MULTIPLIER
	roll:setMaxAttackRoll(attackRoll)

	local target = roll:getTarget()
	local peep = roll:getSelf()

	local selfPosition = Utility.Peep.getAbsolutePosition(peep)
	local targetPosition = Utility.Peep.getAbsolutePosition(target)
	local distance = (selfPosition - targetPosition):getLength() - Radioactive.SPREAD_DISTANCE

	local size = peep:getBehavior(SizeBehavior)
	if size and (distance <= size.size.x or distance <= size.size.z) then
		local spreadRoll = math.random()
		if spreadRoll <= Radioactive.SPREAD_CHANCE then
			Log.info(
				"Spreading Radioactive debuff to '%s' from '%s'.",
				target:getName(),
				peep:getName())

			local gameDB = target:getDirector():getGameDB()
			local resource = gameDB:getResource("Radioactive", "Effect")
			Utility.Peep.applyEffect(target, resource, true, peep)
		end
	end
end

function Radioactive:applySelfToDamage(roll)
	roll:setDamageMultiplier(roll:getDamageMultiplier() * Radioactive.OFFENSE_MULTIPLIER)
end

function Radioactive:update(delta)
	CombatEffect.update(self, delta)

	self.tick = self.tick - delta
	if self.tick <= 0 then
		self.tick = Radioactive.TICK

		local peep = self:getPeep()
		if peep then
			local health = peep:getBehavior(CombatStatusBehavior)
			local damage = math.floor(math.min(health.currentHitpoints * Radioactive.DAMAGE_PER_TICK, Radioactive.MAX_DAMAGE_PER_TICK) + 0.5)
			peep:poke('receiveAttack', AttackPoke({
				damage = damage,
				aggressor = self.activator
			}))
		end
	end
end

return Radioactive
