--------------------------------------------------------------------------------
-- Resources/Game/Actions/Buy.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Mapp = require "ItsyScape.GameDB.Mapp"
local Action = require "ItsyScape.Peep.Action"
local InventoryBehavior = require "ItsyScape.Peep.Behaviors.InventoryBehavior"

local Buy = Class(Action)
Buy.SCOPES = { ['buy'] = true }
Buy.FLAGS = { ['item-inventory'] = true }

function Buy:canPerform(state)
	return Action.canPerform(self, state, { ["item-inventory"] = true })
end

function Buy:count(state, flags)
	local count
	local brochure = self:getGameDB():getBrochure()
	for input in brochure:getInputs(self:getAction()) do
		local resource = brochure:getConstraintResource(input)
		local resourceType = brochure:getResourceTypeFromResource(resource)

		if not state:has(resourceType.name, resource.name, input.count, flags) then
			return 0
		else
			if resourceType.name == "Item" then
				local resourceCount = state:count(resourceType.name, resource.name, flags)
				count = math.min(math.floor(resourceCount / input.count), count or math.huge)
			end
		end
	end

	return count
end

function Buy:perform(state, peep, quantity)
	if not self:canPerform(state) then
		return false
	end

	local director = peep:getDirector()
	local inventory = peep:getBehavior(InventoryBehavior)
	if inventory and inventory.inventory then
		inventory = inventory.inventory
	else
		return false, "no inventory"
	end


	local gameDB = director:getGameDB()
	local brochure = gameDB:getBrochure()

	quantity = math.min(quantity, self:count(state, Buy.FLAGS))
	if quantity < 1 then
		return false, "can't buy anything"
	end

	for input in brochure:getInputs(self:getAction()) do
		local resource = brochure:getConstraintResource(input)
		local resourceType = brochure:getResourceTypeFromResource(resource)

		local tookItem = state:take(resourceType.name, resource.name, input.count * quantity, Buy.FLAGS)
		if not tookItem then
			-- This can only happen if Action.count is wrong.
			-- If that's the case, just log it and continue.
			-- It's unfair to take a resources and bail without some reward. 
			Log.error("Could not take %d of resource '%s' (resource type: '%s') when buying; incoming free item.", input.count * quantity, resource.name, resourceType.name)
		end
	end

	for output in brochure:getOutputs(self:getAction()) do
		local resource = brochure:getConstraintResource(output)
		local resourceType = brochure:getResourceTypeFromResource(resource)

		if not state:give(resourceType.name, resource.name, output.count * quantity, Buy.FLAGS) then
			for input in brochure:getInputs(self:getAction()) do
				local resource = brochure:getConstraintResource(input)
				local resourceType = brochure:getResourceTypeFromResource(resource)

				state:give(resourceType.name, resource.name, input.count * quantity, Buy.FLAGS)
			end

			return false, "not enough inventory space"
		end
	end

	Action.perform(self, state, peep)
	return true
end

return Buy
