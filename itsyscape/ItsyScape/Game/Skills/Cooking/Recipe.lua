--------------------------------------------------------------------------------
-- ItsyScape/Game/Skills/Cooking/Recipe.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Utility = require "ItsyScape.Game.Utility"

local Recipe = Class()

function Recipe:new(resource, game)
	self.game = game
	self.gameDB = game:getGameDB()

	if type(resource) == 'string' then
		self.resource = self.gameDB:getResource(resource, "Recipe")
		if not self.resource then
			Log.error("Could not get recipe resource '%s'.", resource)
			return
		end
	else
		self.resource = resource
	end

	local action
	do
		local actions = Utility.getActions(self.game, self.resource, 'craft')
		for i = 1, #actions do
			local instance = actions[i].instance
			if instance:is("CookRecipe") then
				action = instance
				break
			end
		end
	end

	if not action then
		Log.error("Could not get cook recipe action for resource '%s'.", self.resource.name)
		return
	end

	self.action = action
	self.constraints = Utility.getActionConstraints(self.game, self.action:getAction())

	self.slots = {}
	self:_addSlots(self.constraints.requirements)
	self:_addSlots(self.constraints.inputs)
end

function Recipe:getResource()
	return self.resource
end

function Recipe:getSlots()
	local result = {}

	for i = 1, #self.slots do
		table.insert(result, self.slots[i].item)
	end

	return result
end

function Recipe:getIsReady()
	for i = 1, #self.slots do
		if not self.slots[i].item then
			return false
		end
	end

	return true
end

function Recipe:getItemID()
	for i = 1, #self.constraints.outputs do
		if self.constraints.outputs[i].type:lower() == "item" then
			return self.constraints.outputs[i].resource
		end
	end
end

function Recipe:_addSlots(constraints)
	for i = 1, #constraints do
		local constraint = constraints[i]
		if constraint.type:lower() == "item" or constraint.type:lower() == "ingredient" then
			for j = 1, constraint.count do
				table.insert(self.slots, {
					type = constraint.type,
					resource = constraint.resource,
					constraint = constraint,
					item = false
				})
			end
		end
	end
end

function Recipe:_itemMatchesConstraint(itemResource, constraint)
	if constraint.type:lower() == "ingredient" then
		local ingredientRecords = self.gameDB:getRecords("Ingredient", {
			Item = itemResource,
			Ingredient = self.gameDB:getResource(constraint.resource, "Ingredient")
		})

		for j = 1, #ingredientRecords do
			if ingredientRecords[j]:get("Ingredient").name == constraint.resource then
				return true
			end
		end
	elseif constraint.type:lower() == "item" then
		if itemResource.name == constraint.resource then
			return true
		end
	end

	return false
end

function Recipe:_canAddIngredient(item, constraints)
	local itemResource = self.gameDB:getResource(item:getID(), "Item")
	if not itemResource then
		return false
	end

	for i = 1, #constraints do
		local constraint = constraints[i]
		if self:_itemMatchesConstraint(itemResource, constraint) then
			return true
		end
	end

	return false
end

function Recipe:_canPeepCookIngredient(peep, item)
	local itemResource = self.gameDB:getResource(item:getID(), "Item")
	if not itemResource then
		return false
	end

	local actions = Utility.getActions(self.game, itemResource, 'craft')
	for i = 1, #actions do
		local instance = actions[i].instance
		if instance:is("CookIngredient") and instance:canPerform(peep:getState()) then
			return true
		end
	end

	return false
end

function Recipe:canAddIngredient(peep, item)
	if not self.constraints then
		return false
	end

	local canAddToRequirements = self:_canAddIngredient(item, self.constraints.requirements)
	local canAddToInputs = self:_canAddIngredient(item, self.constraints.inputs)
	local canCook = self:_canPeepCookIngredient(peep, item)

	return (canAddToRequirements or canAddToInputs) and canCook
end

function Recipe:addIngredient(peep, item)
	if not self:canAddIngredient(peep, item) then
		return false
	end

	local itemResource = self.gameDB:getResource(item:getID(), "Item")
	if not itemResource then
		return false
	end

	local count = 0
	for i = 1, #self.slots do
		local slot = self.slots[i]

		if not slot.item then
			local isMatch = self:_itemMatchesConstraint(itemResource, slot.constraint)
			if isMatch then
				slot.item = item

				return true, i
			end
		elseif slot.item:getRef() == item:getRef() then
			count = count + 1
			if count > item:getCount() then
				return false
			end
		end
	end

	return false
end

return Recipe
