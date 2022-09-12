--------------------------------------------------------------------------------
-- Resources/Game/Effects/Power_Riposte/Effect.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Weapon = require "ItsyScape.Game.Weapon"
local AttackPoke = require "ItsyScape.Peep.AttackPoke"
local Effect = require "ItsyScape.Peep.Effect"
local CombatEffect = require "ItsyScape.Peep.Effects.CombatEffect"
local CombatTargetBehavior = require "ItsyScape.Peep.Behaviors.CombatTargetBehavior"

-- Blocks 25%-50% of next melee attack, dealing 100%-300% damage back in return.
local Riposte = Class(CombatEffect)
Riposte.DURATION = 20

function Riposte:new(activator)
	CombatEffect.new(self)

	local level = activator:getState():count(
		"Skill",
		"Strength",
		{ ['skill-as-level'] = true })

	self.damageMultiplier = 1 - math.min((level / 50) * 0.25 + 0.25, 0.5)
	self.counterMultiplier = math.min((level / 50) * 2 + 1, 3)
end

function Riposte:getBuffType()
	return Effect.BUFF_TYPE_POSITIVE
end

function Riposte:applyTargetToDamage(roll)
	local target = self:getPeep():getBehavior(CombatTargetBehavior)
	target = target and target.actor
	if target and target:getPeep() == roll:getSelf() then 
		local damage = roll:roll()
		roll:setMaxHit(math.floor(damage * self.damageMultiplier))
		roll:setMinHit(math.floor(damage * self.damageMultiplier))

		local attack = AttackPoke({
			damage = math.floor(damage * self.counterMultiplier + 0.5),
			aggressor = self:getPeep()
		})
		roll:getSelf():poke('receiveAttack', attack)

		self:getPeep():removeEffect(self)
	end
end

return Riposte
