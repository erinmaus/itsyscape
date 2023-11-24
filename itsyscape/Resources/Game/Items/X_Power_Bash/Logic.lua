--------------------------------------------------------------------------------
-- Resources/Game/Items/X_Power_Bash/Logic.lua
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
local Equipment = require "ItsyScape.Game.Equipment"
local Shield = require "ItsyScape.Game.Shield"
local Utility = require "ItsyScape.Game.Utility"
local ActorReferenceBehavior = require "ItsyScape.Peep.Behaviors.ActorReferenceBehavior"
local AttackCooldownBehavior = require "ItsyScape.Peep.Behaviors.AttackCooldownBehavior"
local HumanoidBehavior = require "ItsyScape.Peep.Behaviors.HumanoidBehavior"
local MovementBehavior = require "ItsyScape.Peep.Behaviors.MovementBehavior"
local HumanoidActorAnimatorCortex = require "ItsyScape.Peep.Cortexes.HumanoidActorAnimatorCortex"

-- Less accurate shot (20% lower attack skill), but deals damage from 200% to 400%.
-- An additional 100% against undead. 
local Bash = Class(ProxyXWeapon)

function Bash:previewAttackRoll(roll)
	ProxyXWeapon.previewAttackRoll(self, roll)
end

function Bash:previewDamageRoll(roll)
	ProxyXWeapon.previewDamageRoll(self, roll)

	local shield = Utility.Peep.getEquippedItem(roll:getSelf(), Equipment.PLAYER_SLOT_LEFT_HAND)
	local logic = shield and shield:getManager():getLogic(shield:getID())
	if not logic or not Class.isCompatibleType(logic, Shield) then
		roll:setBonus(0)
		return
	end

	local stats = Utility.Item.getInstanceStats(shield, roll:getSelf())

	local bonusFromDefense = 0
	for stat in pairs(Equipment.DEFENSIVE_STATS) do
		for _, i in ipairs(stats) do
			if i.name == stat then
				bonusFromDefense = math.max(bonusFromDefense, i.value or 0)
				break
			end
		end
	end

	local bonusFromStrength = 0
	for stat in pairs(Equipment.STRENGTH_STATS) do
		for _, i in ipairs(stats) do
			if i.name == stat then
				bonusFromStrength = math.max(bonusFromStrength, i.value or 0)
				break
			end
		end
	end

	local totalBonus = bonusFromDefense + bonusFromStrength
	Log.info(
		"Replacing current strength bonus %d with new strength bonus %d from shield.",
		roll:getBonus(), totalBonus)
	roll:setBonus(totalBonus)
end


function Bash:dealtDamage(peep, target, attack)
	ProxyXWeapon.dealtDamage(self, peep, target, attack)

	local level = peep:getState():count(
		"Skill",
		"Defense",
		{ ['skill-as-level'] = true })

	local additionalCooldown = Utility.Combat.calcBoost(level, 10, 50, 10, 20)
	local _, cooldown = target:addBehavior(AttackCooldownBehavior)
	cooldown.cooldown = cooldown.cooldown + additionalCooldown

	Log.info(
		"Peep '%s' bashed opponent '%s' for '%d' damage and stunning them for %.2f seconds.",
		peep:getName(), target:getName(), attack:getDamage(), additionalCooldown)

	if peep:hasBehavior(HumanoidBehavior) then
		local direction = peep:hasBehavior(MovementBehavior) and peep:getBehavior(MovementBehavior).facing

		local resource
		if direction == MovementBehavior.FACING_LEFT then
			resource = peep:getResource(
				"animation-defend-shield-left",
				"ItsyScape.Graphics.AnimationResource")
		elseif direction == MovementBehavior.FACING_RIGHT then
			resource = peep:getResource(
				"animation-defend-shield-right",
				"ItsyScape.Graphics.AnimationResource")
		end

		local actor = peep:getBehavior(ActorReferenceBehavior)
		actor = actor and actor.actor
		if actor and resource then
			actor:playAnimation('combat-attack', HumanoidActorAnimatorCortex.ATTACK_PRIORITY + 1, resource)
		end
	end
end

function Bash:getProjectile()
	return "Power_Bash"
end

return Bash
