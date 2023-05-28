--------------------------------------------------------------------------------
-- ItsyScape/Mashina/Peep/Notify.lua
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

local Notify = B.Node("Notify")
Notify.PEEP = B.Reference()
Notify.INSTANCE = B.Reference()
Notify.MESSAGE = B.Reference()

function Notify:update(mashina, state, executor)
	local peep = state[self.PEEP] or mashina
	local instance = state[self.INSTANCE] or false

	local p
	if instance then
		p = Utility.Peep.getInstance(peep)
	else
		p = peep
	end

	Utility.Peep.notify(p, state[self.MESSAGE])

	return B.Status.Success
end

return Notify
