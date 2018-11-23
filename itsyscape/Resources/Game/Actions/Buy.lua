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
	for i = 1, quantity do
		for input in brochure:getInputs(self:getAction()) do
			local resource = brochure:getConstraintResource(input)
			local resourceType = brochure:getResourceTypeFromResource(resource)

			state:take(resourceType.name, resource.name, input.count, Buy.FLAGS)
		end

		for output in brochure:getOutputs(self:getAction()) do
			local resource = brochure:getConstraintResource(output)
			local resourceType = brochure:getResourceTypeFromResource(resource)

			if not state:give(resourceType.name, resource.name, output.count, Buy.FLAGS) then
				for input in brochure:getInputs(self:getAction()) do
					local resource = brochure:getConstraintResource(input)
					local resourceType = brochure:getResourceTypeFromResource(resource)

					state:give(resourceType.name, resource.name, input.count, Buy.FLAGS)
				end

				return false, "not enough inventory space"
			end
		end
	end

	return true
end

return Buy
