--------------------------------------------------------------------------------
-- ItsyScape/Mashina/Peep/PowerApplied.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local B = require "B"
local Peep = require "ItsyScape.Peep.Peep"

local PowerApplied = B.Node("PowerApplied")
PowerApplied.PEEP = B.Reference()
PowerApplied.POWER = B.Reference()
PowerApplied.ACTIVATOR = B.Reference()
PowerApplied.ACTION = B.Reference()
PowerApplied.EVENT = B.Local()

function PowerApplied:update(mashina, state, executor)
	local event = state[self.EVENT]
	state[self.EVENT] = nil

	if event then
		state[self.POWER] = event.power:getResource().name
		state[self.ACTIVATOR] = event.activator
		state[self.ACTION] = event.action

		return B.Status.Success
	else
		state[self.POWER] = nil
		state[self.ACTIVATOR] = nil
		state[self.ACTION] = nil

		return B.Status.Working
	end
end

function PowerApplied:hit(state, _, event)
	state[self.EVENT] = event
end

function PowerApplied:activated(mashina, state, executor)
	local callback = self.callback or function(self, ...)
		self:hit(...)
	end

	self.callback = callback
	self.peep = state[self.PEEP] or mashina

	self.peep:listen("powerApplied", callback, self, state)
end

function PowerApplied:deactivated(mashina, state, executor)
	self:removed()
end

function PowerApplied:removed()
	if self.peep then
		self.peep:silence("powerApplied", self.callback)
		self.callback = nil
		self.peep = nil
	end
end

return PowerApplied
