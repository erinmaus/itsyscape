--------------------------------------------------------------------------------
-- Resources/Game/Effects/GhostBindersRing/Effect.lua
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
local CombatEffect = require "ItsyScape.Peep.Effects.CombatEffect"
local StatsBehavior = require "ItsyScape.Peep.Behaviors.StatsBehavior"
local CombatStatusBehavior = require "ItsyScape.Peep.Behaviors.CombatStatusBehavior"

-- Has a 25% chance of turning damage dealt by ghosts and undead into healing.
local GhostBindersRing = Class(CombatEffect)
GhostBindersRing.CHANCE = 0.25

function GhostBindersRing:getBuffType()
	return Effect.BUFF_TYPE_POSITIVE
end

function GhostBindersRing:isUndead(resource)
	if not resource then
		return false
	end

	local peep = self:getPeep()
	if not peep then
		return false
	end

	local gameDB = peep:getDirector():getGameDB()
	local undeadTag = gameDB:getRecord("ResourceTag", {
		Value = "Undead",
		Resource = resource
	})

	return undeadTag ~= nil
end

function GhostBindersRing:applyTargetToDamage(roll)
	local peep = roll:getSelf()
	local peepResource = Utility.Peep.getResource(peep)
	local peepMapObject = Utility.Peep.getMapObject(peep)

	if self:isUndead(peepResource) or self:isUndead(peepMapObject) then
		if math.random() <= GhostBindersRing.CHANCE then
			Log.info(
				"Damage turned to healing via ghost binder's ring (attacker: '%s', defender: '%s').",
				roll:getSelf():getName(),
				roll:getTarget():getName())

			roll:setDamageMultiplier(-1)
		end
	end
end

function GhostBindersRing:update(delta)
	CombatEffect.update(self, delta)

	local peep = self:getPeep()

	local ring = Utility.Peep.getEquippedItem(peep, Equipment.PLAYER_SLOT_FINGER)
	local hasRing = ring and ring:getID() == "GhostBindersRing"
	if not hasRing then
		peep:removeEffect(self)
		return
	end
end

return GhostBindersRing
