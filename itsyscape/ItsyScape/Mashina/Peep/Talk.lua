--------------------------------------------------------------------------------
-- ItsyScape/Mashina/Peep/Talk.lua
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

local Talk = B.Node("Talk")
Talk.PEEP = B.Reference()
Talk.MESSAGE = B.Reference()
Talk.COLOR = B.Reference()
Talk.DURATION = B.Reference()

function Talk:update(mashina, state, executor)
	local peep = state[self.PEEP] or mashina

	local message = state[self.MESSAGE]
	if not message then
		return B.Status.Failure
	end

	local actor = peep:getBehavior(ActorReferenceBehavior)
	if not actor or not actor.actor then
		return B.Status.Failure
	else
		actor = actor.actor
	end

	actor:flash('Message', 1, message, state[self.COLOR], state[self.DURATION])
	Log.info("\"%s\", said %s.", message, peep:getName())

	return B.Status.Success
end

return Talk
