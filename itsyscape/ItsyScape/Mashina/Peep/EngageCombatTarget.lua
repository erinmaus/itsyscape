--------------------------------------------------------------------------------
-- ItsyScape/Mashina/Peep/EngageCombatTarget.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local B = require "B"
local AttackCommand = require "ItsyScape.Game.AttackCommand"
local Utility = require "ItsyScape.Game.Utility"
local Probe = require "ItsyScape.Peep.Probe"
local ActorReferenceBehavior = require "ItsyScape.Peep.Behaviors.ActorReferenceBehavior"
local CombatTargetBehavior = require "ItsyScape.Peep.Behaviors.CombatTargetBehavior"

local EngageCombatTarget = B.Node("EngageCombatTarget")
EngageCombatTarget.PEEP = B.Reference()
EngageCombatTarget.INCLUDE_NPCS = B.Reference()

function EngageCombatTarget:update(mashina, state, executor)
	local peep = state[self.PEEP]
	if not peep then
		return B.Status.Failure
	end

	if not Utility.Peep.canAttack(peep) then
		return B.Status.Failure
	end

	local actor = peep:getBehavior(ActorReferenceBehavior)
	if not actor or not actor.actor then
		return B.Status.Failure
	else
		actor = actor.actor
	end

	if mashina:getCommandQueue():interrupt(AttackCommand()) then
		local _, target = mashina:addBehavior(CombatTargetBehavior)
		if not target then
			mashina:getCommandQueue():clear()
			return B.Status.Failure
		end

		target.actor = actor

		return B.Status.Success
	end

	return B.Status.Failure
end

return EngageCombatTarget
