--------------------------------------------------------------------------------
-- ItsyScape/Mashina/Skills/Mining/UseNearbyFurnace.lua
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

local UseNearbyFurnace = B.Node("UseNearbyFurnace")
UseNearbyFurnace.FURNACE = B.Reference()
UseNearbyFurnace.RESOURCE = B.Reference()
UseNearbyFurnace.COUNT = B.Reference()
UseNearbyFurnace.SUCCESS = B.Local()

function UseNearbyFurnace:update(mashina, state, executor)
	local s = state[self.SUCCESS]
	if s then
		return B.Status.Success
	else
		return B.Status.Failure
	end
end

function UseNearbyFurnace:activated(mashina, state)
	local ore = state[self.RESOURCE]
	local director = mashina:getDirector()
	local game = director:getGameInstance()
	local gameDB = director:getGameDB()
	local brochure = gameDB:getBrochure()
	local p = director:probe(Probe.resource("Prop", state[self.FURNACE] or "Furnace_Default"))
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

	local smeltAction, smeltActionCount
	do
		local flags = { ['item-inventory'] = true }
		local resource = gameDB:getResource(state[self.RESOURCE] or "", "Item")
		if resource then
			for action in brochure:findActionsByResource(resource) do
				local actionType = brochure:getActionDefinitionFromAction(action)
				if actionType.name:lower() == "smelt" then
					local a, ActionType = Utility.getAction(game, action, 'craft')
					local actionInstance = ActionType(game, action)
					if actionInstance:canPerform(peep:getState(), flags) then
						smeltActionCount = actionInstance:count(peep:getState(), flags)
						smeltAction = actionInstance
						break
					end
				end
			end
		end
	end
	
	state[self.SUCCESS] = false
	if smeltAction and smeltActionCount > 0 then
		local best = p[1]
		if best then
			local actions = Utility.getActions(game, best:getGameDBResource(), 'hidden')
			for i = 1, #actions do
				local action = actions[i].instance
				if action:is("UseCraftWindow") then
					local s = action:perform(
						mashina:getState(),
						mashina,
						best,
						smeltAction,
						state[self.COUNT] or smeltActionCount)

					if s then
						state[self.SUCCESS] = true
					end

					break
				end
			end
		end
	end
end

function UseNearbyFurnace:deactivated(mashina, state)
	state[self.SUCCESS] = nil
end

return UseNearbyFurnace
