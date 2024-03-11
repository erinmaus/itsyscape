--------------------------------------------------------------------------------
-- ItsyScape/Mashina/Peep/PowerActivated.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local B = require "B"
local Peep = require "ItsyScape.Peep.Peep"

local PowerActivated = B.Node("PowerActivated")
PowerActivated.PEEP = B.Reference()
PowerActivated.POWER = B.Reference()
PowerActivated.TARGET = B.Reference()
PowerActivated.ACTION = B.Reference()
PowerActivated.EVENT = B.Local()

function PowerActivated:update(mashina, state, executor)
	local event = state[self.EVENT]
	state[self.EVENT] = nil

	if event then
		state[self.POWER] = event.power:getResource().name
		state[self.TARGET] = event.target
		state[self.ACTION] = event.action

		return B.Status.Success
	else
		state[self.POWER] = nil
		state[self.TARGET] = nil
		state[self.ACTION] = nil

		return B.Status.Working
	end
end

function PowerActivated:hit(state, _, event)
	state[self.EVENT] = event
end

function PowerActivated:activated(mashina, state, executor)
	local callback = self.callback or function(self, ...)
		self:hit(...)
	end

	self.callback = callback
	self.peep = state[self.PEEP] or mashina

	self.peep:listen("powerApplied", callback, self, state)
end

function PowerActivated:deactivated(mashina, state, executor)
	self:removed()
end

function PowerActivated:removed()
	if self.peep then
		self.peep:silence("powerApplied", self.callback)
		self.callback = nil
		self.peep = nil
	end
end

return PowerActivated
