--------------------------------------------------------------------------------
-- Resources/Game/Effects/GanymedesStunningStrike/Effect.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Vector = require "ItsyScape.Common.Math.Vector"
local Equipment = require "ItsyScape.Game.Equipment"
local Utility = require "ItsyScape.Game.Utility"
local Effect = require "ItsyScape.Peep.Effect"
local AttackCooldownBehavior = require "ItsyScape.Peep.Behaviors.AttackCooldownBehavior"
local CombatTargetBehavior = require "ItsyScape.Peep.Behaviors.CombatTargetBehavior"
local MovementBehavior = require "ItsyScape.Peep.Behaviors.MovementBehavior"

-- Stuns the opponent by 0.2 seconds.
--
-- As well, 1% of damage is applied as an additional cooldown, in seconds.
local GanymedesStunningStrike = Class(Effect)
GanymedesStunningStrike.STUN = 0.2
GanymedesStunningStrike.STUN_DIVISOR = 100

function GanymedesStunningStrike:new(...)
	Effect.new(self, ...)
end

function GanymedesStunningStrike:getBuffType()
	return Effect.BUFF_TYPE_POSITIVE
end

function GanymedesStunningStrike:attack(attack)
	local target
	do
		local peep = self:getPeep()
		local combatTarget = peep:getBehavior(CombatTargetBehavior)
		target = not combatTarget or not combatTarget.actor or combatTarget.actor:getPeep()
	end

	if not target then
		Log.info("No target; can't stun.")
		return
	end

	local damage = attack:getDamage()
	if damage > 0 then
		local currentTime = target:getDirector():getGameInstance():getCurrentTime()
		local cooldown = target:getBehavior(AttackCooldownBehavior)
		if not cooldown then
			target:addBehavior(AttackCooldownBehavior)

			cooldown = target:getBehavior(AttackCooldownBehavior)
			cooldown.ticks = currentTime
		end

		local baseStun = GanymedesStunningStrike.STUN
		local additionalStun = damage / GanymedesStunningStrike.STUN_DIVISOR
		local totalStun = baseStun + additionalStun

		Log.info(
			"Applied a base stun of %.3f seconds, with an additional stun of %.3f seconds (%.3f total) to target '%s'.",
			baseStun, additionalStun, totalStun, target:getName())

		cooldown.cooldown = cooldown.cooldown + totalStun
	end
end

function GanymedesStunningStrike:enchant(peep)
	Effect.enchant(self, peep)

	self._attack = function(_, attack, target)
		self:attack(attack, target)
	end

	peep:listen('initiateAttack', self._attack)
end

function GanymedesStunningStrike:sizzle()
	local peep = self:getPeep()

	peep:silence('initiateAttack', self._attack)

	Effect.sizzle(self)
end

function GanymedesStunningStrike:update(delta)
	Effect.update(self, delta)

	local peep = self:getPeep()

	local weapon = Utility.Peep.getEquippedItem(peep, Equipment.PLAYER_SLOT_RIGHT_HAND) or
	               Utility.Peep.getEquippedItem(peep, Equipment.PLAYER_SLOT_TWO_HANDED)
	local hasGanymedesBow = weapon and weapon:getID() == "GanymedesBow"
	if not hasGanymedesBow then
		peep:removeEffect(self)
	end
end

return GanymedesStunningStrike
