--------------------------------------------------------------------------------
-- Resources/Game/Effects/Power_Counter/Effect.lua
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
local AttackPoke = require "ItsyScape.Peep.AttackPoke"
local CombatTargetBehavior = require "ItsyScape.Peep.Behaviors.CombatTargetBehavior"
local ActorReferenceBehavior = require "ItsyScape.Peep.Behaviors.ActorReferenceBehavior"
local CombatEffect = require "ItsyScape.Peep.Effects.CombatEffect"

-- The next attack the opponent lands will be countered for up to 400% damage,
-- based on Strength level. Pierces most defenses and buffs.
local Counter = Class(CombatEffect)
Counter.MIN_DAMAGE_MULTIPLIER = 2
Counter.MAX_DAMAGE_MULTIPLIER = 4
Counter.MIN_STRENGTH_LEVEL    = 40
Counter.MAX_STRENGTH_LEVEL    = 50
Counter.DURATION = math.huge

function Counter:getBuffType()
	return Effect.BUFF_TYPE_POSITIVE
end

function Counter:applyTargetToAttack(roll)
	local aggressor = roll:getSelf()
	local aggressorActor = aggressor:getBehavior(ActorReferenceBehavior)
	aggressorActor = aggressorActor and aggressorActor.actor

	local peep = self:getPeep()
	local peepTargetActor = peep:getBehavior(CombatTargetBehavior)
	peepTargetActor = peepTargetActor and peepTargetActor.actor

	if aggressorActor and peepTargetActor and aggressorActor:getID() == peepTargetActor:getID() then
		self:onSelfHit(aggressor)
	end
end

function Counter:onSelfHit(aggressor)
	local peep = self:getPeep()
	local weapon = Utility.Peep.getEquippedWeapon(peep, true)
	if not weapon or not Class.isCompatibleType(weapon, Weapon) then
		Log.info("Peep '%s' doesn't have a weapon; using default weapon.", peep:getName())
		weapon = Weapon()
	end

	local damageRoll = weapon:rollDamage(peep, Weapon.PURPOSE_KILL, aggressor)

	local level = peep:getState():count(
		"Skill",
		"Strength",
		{ ['skill-as-level'] = true })

	local multiplier = (level - Counter.MIN_STRENGTH_LEVEL) / (Counter.MAX_STRENGTH_LEVEL - Counter.MIN_STRENGTH_LEVEL)
	multiplier = math.min(math.max(multiplier, Counter.MIN_DAMAGE_MULTIPLIER), Counter.MAX_DAMAGE_MULTIPLIER)

	damageRoll:setMinHit(math.floor(multiplier * damageRoll:getMaxHit() + 0.5))
	damageRoll:setMaxHit(math.floor(multiplier * damageRoll:getMaxHit() + 0.5))

	Log.info("Countering foe '%s' with '%d%%' damage.", multiplier * 100)

	local attack = AttackPoke({
		attackType = weapon:getBonusForStance(peep):lower(),
		weaponType = weapon:getWeaponType(),
		damage = damageRoll:roll(),
		aggressor = peep
	})

	aggressor:poke('receiveAttack', attack)

	local stage = peep:getDirector():getGameInstance():getStage()
	stage:fireProjectile("Power_Counter", peep, aggressor)

	peep:removeEffect(self)
end

return Counter
