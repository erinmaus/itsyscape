--------------------------------------------------------------------------------
-- ItsyScape/UI/CookingWindowController.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Utility = require "ItsyScape.Game.Utility"
local Cooking = require "ItsyScape.Game.Skills.Cooking"
local Mapp = require "ItsyScape.GameDB.Mapp"
local Controller = require "ItsyScape.UI.Controller"
local InventoryBehavior = require "ItsyScape.Peep.Behaviors.InventoryBehavior"
local StatsBehavior = require "ItsyScape.Peep.Behaviors.StatsBehavior"

local CookingWindowController = Class(Controller)

function CookingWindowController:new(peep, director)
	Controller.new(self, peep, director)

	self:prepareState()

	Utility.UI.broadcast(
		self:getDirector():getGameInstance():getUI(),
		self:getPeep(),
		"Ribbon",
		"hide",
		nil,
		{})
end

function CookingWindowController:close()
	Controller.close(self)

	Utility.UI.broadcast(
		self:getDirector():getGameInstance():getUI(),
		self:getPeep(),
		"Ribbon",
		"show",
		nil,
		{})
end

function CookingWindowController:prepareState()
	self.state = { recipes = {}, inventory = {} }
	self.recipes = {}
	self.recipesByID = {}
	self.inventory = {}

	self:populateInventory()
	self:populateRecipes()
	self:sortRecipes()
	self:marshalRecipes()
end

function CookingWindowController:populateInventory()
	table.clear(self.state.inventory)
	table.clear(self.inventory)

	local inventory = self:getPeep():getBehavior(InventoryBehavior)
	inventory = inventory and inventory.inventory
 
	if not inventory then
		return
	end

	local broker = inventory:getBroker()
	if not broker then
		return
	end

	for key in broker:keys(inventory) do
		for item in broker:iterateItemsByKey(inventory, key) do
			self:tryPopulateInventoryWithItem(broker, item)
			break
		end
	end
end

function CookingWindowController:tryPopulateInventoryWithItem(broker, item)
	local gameDB = self:getDirector():getGameDB()
	local itemResource = gameDB:getResource(item:getID(), "Item")
	local ingredient = gameDB:getRecord("Ingredient", {
		Item = itemResource
	})

	if not ingredient then
		return
	end

	local usable = false
	local xp = 0
	do
		local actions = Utility.getActions(self:getDirector():getGameInstance(), itemResource, 'craft')
		for i = 1, #actions do
			local action = actions[i]

			local isCookAction = action.instance:is("CookIngredient")
			local canPerformAction = action.instance:canPerform(self:getPeep():getState())

			if isCookAction and canPerformAction then
				usable = true
			end

			if isCookAction then
				local constraints = Utility.getActionConstraints(self:getDirector():getGameInstance(), action.instance:getAction())
				for _, output in ipairs(constraints.outputs) do
					if output.type == "Skill" and output.resource == "Cooking" then
						xp = xp + output.count
					end
				end
			end
		end
	end

	table.insert(self.inventory, {
		item = item,
		ref = broker:getItemRef(item),
		ingredient = ingredient,
		count = 0,
		usable = usable,
		xp = xp
	})

	table.insert(self.state.inventory, {
		ref = broker:getItemRef(item),
		count = item:getCount(),
		resource = item:getID(),
		name = Utility.Item.getInstanceName(item, gameDB),
		description = Utility.Item.getInstanceDescription(item, gameDB),
		hints = Utility.Item.getUserdataHints(item:getID(), gameDB),
		usable = usable,
		xp = xp
	})
end

function CookingWindowController:resetInventory()
	if #self.inventory ~= #self.state.inventory then
		Log.warn("Cooking window interface inventory state de-synced for peep '%s'.", self:getPeep():getName())
		return
	end

	for i = 1, #self.inventory do
		self.inventory[i].count = 0
		self.state.inventory[i].count = self.inventory[i].item:getCount()
	end
end

function CookingWindowController:populateRecipes()
	local director = self:getDirector()
	local game = director:getGameInstance()
	local gameDB = director:getGameDB()

	for resource in gameDB:getResources("Recipe") do
		local actions = Utility.getActions(game, resource, 'craft', false)
		if actions then
			for j = 1, #actions do
				if actions[j].instance:is("cookrecipe") then
					local recipe = {
						resource = resource.name,
						recipe = Cooking.Recipe(resource, game),
						action = actions[j],
						constraints = Utility.getActionConstraints(game, actions[j].instance:getAction()),
						name = Utility.getName(resource, gameDB) or ("*" .. resource.name),
						description = Utility.getDescription(resource, gameDB) or ("*" .. resource.name),
					}

					table.insert(self.recipes, recipe)
					self.recipesByID[resource.name] = recipe

					break
				end
			end
		end
	end
end

function CookingWindowController:sortRecipes()
	table.sort(self.recipes, function(a, b)
		local aXP
		for i = 1, #a.constraints.requirements do
			if a.constraints.requirements[i].type:lower() == "skill" and
			   a.constraints.requirements[i].resource:lower() == "cooking"
			then
				aXP = a.constraints.requirements[i].count
			end
		end
		aXP = aXP or 0

		local bXP
		for i = 1, #b.constraints.requirements do
			if b.constraints.requirements[i].type:lower() == "skill" and
			   b.constraints.requirements[i].resource:lower() == "cooking"
			then
				bXP = b.constraints.requirements[i].count
			end
		end
		bXP = bXP or 0

		if aXP < bXP then
			return true
		elseif aXP == bXP then
			return a.resource < b.resource
		end

		return false
	end)
end

function CookingWindowController:marshalRecipes()
	for i = 1, #self.recipes do
		local recipe = self.recipes[i]

		local item
		for i = 1, #recipe.constraints.outputs do
			if recipe.constraints.outputs[i].type:lower() == "item" then
				item = recipe.constraints.outputs[i]
			end
		end

		table.insert(self.state.recipes, {
			resource = recipe.resource,
			action = {
				id = recipe.action.id,
				type = recipe.action.type,
				verb = recipe.action.verb,
			},
			constraints = recipe.constraints,
			name = recipe.name,
			description = recipe.description,
			output = item
		})
	end
end

function CookingWindowController:poke(actionID, actionIndex, e)
	if actionID == "populateRecipe" then
		self:populateRecipe(e)
	elseif actionID == "addIngredient" then
		self:addIngredient(e)
	elseif actionID == "removeIngredient" then
		self:removeIngredient(e)
	elseif actionID == "cook" then
		self:cook()
	elseif actionID == "clear" then
		self:clear()
	elseif actionID == "close" then
		self:getGame():getUI():closeInstance(self)
	else
		Controller.poke(self, actionID, actionIndex, e)
	end
end

function CookingWindowController:populateRecipe(e, force)
	assert(type(e.index) == 'number', "index is not number")
	assert(e.index > 0, "index is negative or zero")
	assert(e.index <= #self.recipes, "index is out of bounds")

	if e.index == self.currentRecipeIndex and not force then
		return
	end

	if self.currentRecipeIndex then
		self.recipes[self.currentRecipeIndex].recipe:reset()
	end

	local recipe = self.recipes[e.index]
	self.state.currentRecipe = { index = e.index }

	for i = 1, #recipe.constraints.requirements do
		local requirement = recipe.constraints.requirements[i]

		if requirement.type:lower() == "item" or requirement.type:lower() == "ingredient" then
			for j = 1, requirement.count do
				table.insert(self.state.currentRecipe, {
					type = requirement.type,
					resource = requirement.resource,
					constraint = requirement,
					type = 'requirement',
					item = requirement,
					count = 0
				})
			end
		end
	end

	for i = 1, #recipe.constraints.inputs do
		local input = recipe.constraints.inputs[i]

		if input.type:lower() == "item" or input.type:lower() == "ingredient" then
			for j = 1, input.count do
				table.insert(self.state.currentRecipe, {
					type = input.type,
					resource = input.resource,
					constraint = input,
					type = 'input',
					item = input,
					count = 0
				})
			end
		end
	end

	self:resetInventory()

	self:getDirector():getGameInstance():getUI():sendPoke(
		self,
		"populateRecipe",
		nil,
		{ self.state.currentRecipe })

	self:getDirector():getGameInstance():getUI():sendPoke(
		self,
		"populateInventory",
		nil,
		{ self.state.inventory })

	self.currentRecipeIndex = e.index
end

function CookingWindowController:pull()
	return self.state
end

function CookingWindowController:getCurrentRecipe()
	if not self.currentRecipeIndex then
		return nil
	end

	return self.recipes[self.currentRecipeIndex].recipe
end

function CookingWindowController:addIngredient(e)
	if not self.currentRecipeIndex then
		Log.warn("Cannot add ingredient to recipe for peep '%s', no recipe selected.", self:getPeep():getName())
		return
	end

	local inventoryItem, inventoryItemIndex
	for i = 1, #self.inventory do
		local inventory = self.inventory[i]
		if inventory.ref == e.ref then
			inventoryItem = inventory
			inventoryItemIndex = i
			break
		end
	end

	if not inventoryItem then
		Log.warn("Item (ref = %d) not found in inventory for peep '%s', cannot cook with it.", e.ref, self:getPeep():getName())
		return
	end

	local recipe = self.recipes[self.currentRecipeIndex].recipe
	if not recipe:canAddIngredient(self:getPeep(), inventoryItem.item) then
		Utility.UI.notifyFailure(self:getPeep(), "Message_Cooking_IngredientNotInRecipe")
		return
	end

	if inventoryItem.count == inventoryItem.item:getCount() then
		Utility.UI.notifyFailure(self:getPeep(), "Message_Cooking_AlreadyAddedIngredient")
		return
	end

	local success, index = recipe:addIngredient(self:getPeep(), inventoryItem.item)

	if not success then
		Log.warn("Could not add item (ref = %d) to recipe for peep '%s', maybe it has exceeded its count?", e.ref, self:getPeep():getName())
		Utility.UI.notifyFailure(self:getPeep(), "Message_Cooking_TooManyIngredients")
		return
	end

	if inventoryItem.count < inventoryItem.item:getCount() then
		inventoryItem.count = inventoryItem.count + 1
	else
		Log.warn("Tried adding an inventory item (ref = %d) that is potentially used up for peep '%s'.", e.ref, self:getPeep():getName())
		return
	end

	self.state.inventory[inventoryItemIndex].count = inventoryItem.item:getCount() - inventoryItem.count
	self.state.currentRecipe[index].count = 1
	self.state.currentRecipe[index].item = self.state.inventory[inventoryItemIndex]

	self:getDirector():getGameInstance():getUI():sendPoke(
		self,
		"populateInventory",
		nil,
		{ self.state.inventory })
end

function CookingWindowController:removeIngredient(e)
	if not self.currentRecipeIndex then
		Log.warn("Cannot remove ingredient from recipe for peep '%s', no recipe selected.", self:getPeep():getName())
		return
	end

	local recipe = self.recipes[self.currentRecipeIndex].recipe
	local item = recipe:getSlottedIngredientItem(e.index)

	if not item then
		Log.warn("Cannot remove ingredient from recipe for peep '%s', no item in slot %d.", self:getPeep():getName(), e.index)
		return
	end

	local inventoryItemIndex
	for i = 1, #self.inventory do
		if self.inventory[i].item:getRef() == item:getRef() then
			inventoryItemIndex = i
			break
		end
	end

	if not inventoryItemIndex then
		Log.warn("Cannot remove ingredient from recipe for peep '%s', item not in inventory.", self:getPeep():getName())
		return
	end

	local success, slotIndex = recipe:removeIngredient(self:getPeep(), self.inventory[inventoryItemIndex].item)
	if not success then
		Log.warn("Cannot remove ingredient from recipe for peep '%s', item not slotted.", self:getPeep():getName())
		return
	end

	self.inventory[inventoryItemIndex].count = self.inventory[inventoryItemIndex].count - 1
	self.state.inventory[inventoryItemIndex].count = self.state.inventory[inventoryItemIndex].count + 1
	self.state.currentRecipe[slotIndex].item = self.state.currentRecipe[slotIndex].constraint
	self.state.currentRecipe[slotIndex].count = 0

	self:getDirector():getGameInstance():getUI():sendPoke(
		self,
		"populateInventory",
		nil,
		{ self.state.inventory })
end

function CookingWindowController:cook()
	if not self.currentRecipeIndex then
		Log.warn("Cannot add ingredient to recipe for peep '%s', no recipe selected.", self:getPeep():getName())
		return
	end

	local recipe = self.recipes[self.currentRecipeIndex].recipe
	if not recipe:getIsReady() then
		Utility.UI.notifyFailure(self:getPeep(), "Message_Cooking_RecipeNotReady")
		return
	end

	local xpBefore = self:getPeep():getState():count("Skill", "Cooking", { ['skill-unboosted'] = true })
	local action = self.recipes[self.currentRecipeIndex].action
	if action.instance:perform(self:getPeep():getState(), self:getPeep(), recipe) then
		local xpAfter = self:getPeep():getState():count("Skill", "Cooking", { ['skill-unboosted'] = true })

		local result = recipe:getResult()
		if result then
			local broker = self:getDirector():getItemBroker()
			local gameDB = self:getDirector():getGameDB()

			self.state.lastCookedItem = {
				ref = broker:getItemRef(result),
				count = result:getCount(),
				resource = result:getID(),
				name = Utility.Item.getInstanceName(result, gameDB),
				description = Utility.Item.getInstanceDescription(result, gameDB),
				totalXP = xpAfter - xpBefore
			}
		end

		self:populateInventory()
		self:populateRecipe({ index = self.currentRecipeIndex }, true)
	end
end

function CookingWindowController:clear()
	if self.currentRecipeIndex then
		self.recipes[self.currentRecipeIndex].recipe:reset()
	end

	self.state.lastCookedItem = nil

	self:getDirector():getGameInstance():getUI():sendPoke(
		self,
		"populateInventory",
		nil,
		{ self.state.inventory })
end

return CookingWindowController
