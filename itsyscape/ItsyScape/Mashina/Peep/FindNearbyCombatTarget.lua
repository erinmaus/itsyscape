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
			return p ~= mashina and (not includeNPCs or p:hasBehavior(PlayerBehavior))
		end,
		state[self.FILTER],
		unpack(state[self.FILTERS] or {}))
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
