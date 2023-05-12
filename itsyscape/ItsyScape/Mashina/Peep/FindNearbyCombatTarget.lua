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
local PlayerBehavior = require "ItsyScape.Peep.Behaviors.PlayerBehavior"

local FindNearbyCombatTarget = B.Node("FindNearbyCombatTarget")
FindNearbyCombatTarget.FILTER = B.Reference()
FindNearbyCombatTarget.FILTERS = B.Reference()
FindNearbyCombatTarget.DISTANCE = B.Reference()
FindNearbyCombatTarget.INCLUDE_NPCS = B.Reference()
FindNearbyCombatTarget.RESULT = B.Reference()

function FindNearbyCombatTarget:update(mashina, state, executor)
	local director = mashina:getDirector()

	local includeNPCs = state[self.INCLUDE_NPCS]

	local p = director:probe(
		mashina:getLayerName(),
		Probe.attackable(),
		Probe.near(mashina, state[self.DISTANCE] or math.huge),
		function(p)
			if not includeNPCs then
				if p:hasBehavior(PlayerBehavior) and p ~= mashina then
					return true
				end
			else
				return p ~= mashina
			end
			
			return false
		end,
		state[self.FILTER],
		unpack(state[self.FILTERS] or {}))
	if p and #p > 0 then
		table.sort(
			p,
			function(a, b)
				local p = Utility.Peep.getPosition(mashina)
				local aP = Utility.Peep.getPosition(a)
				local bP = Utility.Peep.getPosition(b)

				local aDistance = (aP - p):getLength()
				local bDistance = (bP - p):getLength()
				return aDistance < bDistance
			end)

		for i = 1, #p do
			if p[i] ~= mashina then
				state[self.RESULT] = p[i]
				return B.Status.Success
			end
		end
	end

	state[self.RESULT] = nil
	return B.Status.Failure
end

return FindNearbyCombatTarget
