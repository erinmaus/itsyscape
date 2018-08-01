--------------------------------------------------------------------------------
-- ItsyScape/Peep/Cortexes/MashinaCortex.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local B = require "B"
local BTreeBuilder = require "B.TreeBuilder"
local Class = require "ItsyScape.Common.Class"
local Cortex = require "ItsyScape.Peep.Cortex"
local MashinaBehavior = require "ItsyScape.Peep.Behaviors.MashinaBehavior"

local MashinaCortex = Class(Cortex)

function MashinaCortex:new()
	Cortex.new(self)

	self:require(MashinaBehavior)

	self.states = {}
end

function MashinaCortex:addPeep(peep)
	Cortex.addPeep(self, peep)

	self.states[peep] = { current = false }
end

function MashinaCortex:removePeep(peep)
	Cortex.removePeep(self, peep)

	self.states[peep] = nil
end

function MashinaCortex:update(delta)
	for peep in self:iterate() do
		local p = self.states[peep]
		local mashina = peep:getBehavior(MashinaBehavior)
		if p then
			if mashina.currentState ~= p.current then
				if mashina.currentState and mashina.states[mashina.currentState] then
					local s = mashina.states[mashina.currentState]
					p.executor = B.Executor(peep)
					p.tree = B.TreeBuilder.materialize(peep)
				else
					p.executor = nil
					p.tree = false
				end
				p.currentState = mashina.currentState
			end

			if p.tree and p.executor then
				local s = p.tree:execute(p.executor)
				local oldState = mashina.currentState
				if s == B.Status.Success then
					mashina.currentState = false
					peep:poke('mashinaFinished', {
						success = true,
						state = oldState
					})

					Log.info(
						'%s: state %s succeeded',
						peep:getName(),
						oldState)
				elseif s == B.Status.Failure then
					mashina.currentState = false
					peep:poke('mashinaFinished', {
						success = false,
						state = oldState
					})

					Log.info(
						'%s: state %s failed',
						peep:getName(),
						oldState)
				end
			end
		end
	end
end

return MashinaCortex
