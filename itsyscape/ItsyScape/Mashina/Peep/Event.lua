--------------------------------------------------------------------------------
-- ItsyScape/Mashina/Peep/Event.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local B = require "B"

local Event = B.Node("Event")
Event.PEEP = B.Reference()
Event.EVENT = B.Reference()
Event.POKE = B.Reference()
Event.ARGS = B.Reference()
Event.TIME = B.Reference()

function Event:update(mashina, state, executor)
	local peep = state[self.PEEP] or mashina
	local event = state[self.EVENT]
	local poke = state[self.POKE]
	local args = state[self.ARGS]
	local time = state[self.TIME]

	if not event then
		return B.Status.Failure
	end

	if type(poke) == 'function' then
		poke = poke(mashina, state, executor)
	end

	if type(args) == 'function' then
		args = { args(mashina, state, executor) }
	end

	local a
	if args then
		if poke then
			a = { poke, unpack(args, 1, table.maxn(args)) }
		else
			a = args or {}
		end
	else
		a = { poke }
	end

	if time then
		peep:pushPoke(time, "event", event, mashina, unpack(a, 1, table.maxn(a)))
	else
		peep:poke("event", event, mashina, unpack(a, 1, table.maxn(a)))
	end

	return B.Status.Success
end

return Event
