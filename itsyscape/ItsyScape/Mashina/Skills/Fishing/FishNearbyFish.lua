--------------------------------------------------------------------------------
-- ItsyScape/Mashina/Skills/Fish/FishNearbyFish.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local B = require "B"
local Utility = require "ItsyScape.Game.Utility"
local PropResourceHealthBehavior = require "ItsyScape.Peep.Behaviors.PropResourceHealthBehavior"
local Probe = require "ItsyScape.Peep.Probe"

local FishNearbyFish = B.Node("FishNearbyFish")
FishNearbyFish.RESOURCE = B.Reference()
FishNearbyFish.SUCCESS = B.Local()

function FishNearbyFish:update(mashina, state, executor)
	local s = state[self.SUCCESS]
	if s then
		return B.Status.Success
	else
		return B.Status.Failure
	end
end

function FishNearbyFish:activated(mashina, state)
	local fish = state[self.RESOURCE]
	local director = mashina:getDirector()
	local game = director:getGameInstance()
	local p = director:probe(mashina:getLayerName(), Probe.actionOutput("Fish", fish, "Item"))
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
	
	state[self.SUCCESS] = false

	for i = 1, #p do
		local best = p[i]
		local health = best:getBehavior(PropResourceHealthBehavior)
		if health and health.currentProgress < health.maxProgress then
			local actions = Utility.getActions(game, Utility.Peep.getResource(best), "world")
			for _, action in ipairs(actions) do
				if action.instance:is("fish") then
					print("TRYIN'")
					local s = action.instance:perform(
						mashina:getState(),
						mashina,
						best)

					if s then
						state[self.SUCCESS] = true
						break
					end
				end
			end
		end

		if state[self.SUCCESS] then
			break
		end
	end
end

function FishNearbyFish:deactivated(mashina, state)
	state[self.SUCCESS] = nil
end

return FishNearbyFish
