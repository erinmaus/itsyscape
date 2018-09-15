--------------------------------------------------------------------------------
-- ItsyScape/Mashina/Peep/FindNearbyCombatTarget.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local B = require "B"
local Utility = require "ItsyScape.Game.Utility"
local Probe = require "ItsyScape.Peep.Probe"

local FindNearbyCombatTarget = B.Node("FindNearbyCombatTarget")
FindNearbyCombatTarget.FILTER = B.Reference()
FindNearbyCombatTarget.FILTERS = B.Reference()
FindNearbyCombatTarget.DISTANCE = B.Reference()
FindNearbyCombatTarget.RESULT = B.Reference()
FindNearbyCombatTarget.SUCCESS = B.Local()

function FindNearbyCombatTarget:update(mashina, state, executor)
	local s = state[self.SUCCESS]
	if s then
		return B.Status.Success
	else
		return B.Status.Failure
	end
end

function FindNearbyCombatTarget:activated(mashina, state)
	local ore = state[self.RESOURCE]
	local director = mashina:getDirector()

	local p = director:probe(Probe.attackable(), Probe.near(mashina, state[self.DISTANCE] or math.huge, state[self.FILTER], unpack(state[self.FILTERS]))
	if p and #p > 0 then
		table.sort(
			p,
			function(a, b)
				local pI, pJ = Utility.Peep.getTile(mashina)
				local aI, aJ = Utility.Peep.getTile(a)
				local bI, bJ = Utility.Peep.getTile(b)

				local aDistance = math.abs(aI - pI) + math.abs(aJ - pJ)
				local bDistance = math.abs(bI - pI) + math.abs(bJ - pJ)
				return aDistance < bDistance
			end)

		state[self.SUCCESS] = true
		state[self.RESULT] = p[1]
	else
		state[self.SUCCESS] = false
		state[self.RESULT] = nil
	end
end

function FindNearbyCombatTarget:deactivated(mashina, state)
	state[self.SUCCESS] = nil
	state[self.RESULT] = nil
end

return FindNearbyCombatTarget
