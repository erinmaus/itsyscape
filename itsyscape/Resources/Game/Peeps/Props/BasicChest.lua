--------------------------------------------------------------------------------
-- Resources/Peeps/Props/BasicChest.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Vector = require "ItsyScape.Common.Math.Vector"
local Utility = require "ItsyScape.Game.Utility"
local Prop = require "ItsyScape.Peep.Peeps.Prop"
local SizeBehavior = require "ItsyScape.Peep.Behaviors.SizeBehavior"
local SimpleInventoryProvider = require "ItsyScape.Game.SimpleInventoryProvider"

local BasicChest = Class(Prop)

function BasicChest:new(...)
	Prop.new(self, ...)

	local size = self:getBehavior(SizeBehavior)
	size.size = Vector(1, 1, 1)

	Utility.Peep.addInventory(self, SimpleInventoryProvider)

	self:addPoke('materialize')
end

function BasicChest.getDroppedItem(loot, weight)
	local currentWeight = 0
	local item = loot[1]

	if item then
		currentWeight = item.weight
	end

	local p = math.random(0, weight)
	for i = 2, #loot do
		if currentWeight > p then
			break
		end

		local nextItem = loot[i]
		local nextItemWeight = loot[i].weight
		local nextWeight = currentWeight + nextItemWeight

		item = nextItem
		currentWeight = nextWeight
	end

	return item
end

function BasicChest:onMaterialize(e)
	local count = e.count

	local rewards = {}
	local totalWeight = 0
	do
		local gameDB = self:getDirector():getGameDB()
		local actions = Utility.getActions(self:getDirector():getGameInstance(), e.dropTable)
		for _, action in ipairs(actions) do
			if action.instance:is("Reward") then
				local rewardEntry = gameDB:getRecord("RewardEntry", {
					Action = action.instance:getAction()
				})

				if rewardEntry then
					table.insert(rewards, {
						action = action.instance,
						weight = rewardEntry:get("Weight")
					})

					totalWeight = totalWeight + rewardEntry:get("Weight")
				end
			end
		end
	end

	local xp = {}
	for i = 1, count do
		local reward = BasicChest.getDroppedItem(rewards, totalWeight)
		self:reward(reward.action, e, xp)
	end

	for skill, xp in pairs(xp) do
		e.peep:getState():give("Skill", skill, xp)
	end
end

function BasicChest:reward(action, e, xp)
	local gameDB = action:getGameDB()
	local brochure = gameDB:getBrochure()
	for output in brochure:getOutputs(action:getAction()) do
		local resource = brochure:getConstraintResource(output)
		local resourceType = brochure:getResourceTypeFromResource(resource)

		if resourceType.name:lower() == "skill" then
			xp[resource.name] = (xp[resource.name] or 0) + output.count
		elseif resourceType.name:lower() == "item" then
			e.chest:getState():give("Item", resource.name, output.count, { ['item-inventory'] = true, ['item-noted'] = true })
		else
			Log.warn("Unhandled reward: '%s' of type '%s' (%dx)", resource.name, resourceType.name, output.count)
		end
	end
end

return BasicChest
