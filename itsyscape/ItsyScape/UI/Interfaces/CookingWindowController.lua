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
local Mapp = require "ItsyScape.GameDB.Mapp"
local Controller = require "ItsyScape.UI.Controller"

local CookingWindowController = Class(Controller)

function CookingWindowController:new(peep, director)
	Controller.new(self, peep, director)

	self:prepareState()
end

function CookingWindowController:prepareState()
	self.state = { recipes = {} }
	self.recipes = {}
	self.recipesByID = {}

	self:populateRecipes()
	self:sortRecipes()
	self:marshalRecipes()
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
	elseif actionID == "close" then
		self:getGame():getUI():closeInstance(self)
	else
		Controller.poke(self, actionID, actionIndex, e)
	end
end

function CookingWindowController:populateRecipe(e)
	assert(type(e.index) == 'number', "index is not number")
	assert(e.index > 0, "index is negative or zero")
	assert(e.index <= #self.recipes, "index is out of bounds")

	if e.index == self.currentRecipeIndex then
		return
	end

	local recipe = self.recipes[e.index]
	self.state.currentRecipe = {}

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
					slotted = false
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
					slotted = false
				})
			end
		end
	end

	self:getDirector():getGameInstance():getUI():sendPoke(
		self,
		"populateRecipe",
		nil,
		{ self.state.currentRecipe })

	self.currentRecipeIndex = e.index
end

function CookingWindowController:pull()
	return self.state
end

return CookingWindowController
