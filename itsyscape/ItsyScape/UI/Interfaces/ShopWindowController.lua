--------------------------------------------------------------------------------
-- ItsyScape/UI/ShopWindowController.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Utility = require "ItsyScape.Game.Utility"
local Controller = require "ItsyScape.UI.Controller"

local ShopWindowController = Class(Controller)

function ShopWindowController:new(peep, director, shop)
	Controller.new(self, peep, director)

	local game = director:getGameInstance()
	local gameDB = director:getGameDB()
	local brochure = gameDB:getBrochure()

	self.state = { inventory = {} }
	self.inventoryByID = {}
	self.shop = shop or false

	if self.shop then
		for action in brochure:findActionsByResource(shop) do
			local actionType = brochure:getActionDefinitionFromAction(action)
			local a, ActionType = Utility.getAction(game, action, 'buy')
			if a and ActionType then
				local actionInstance = ActionType(game, action)
				if actionInstance:is('buy') then
					a.count = actionInstance:count(peep:getState(), flags)
					table.insert(self.state.inventory, a)

					self.inventoryByID[a.id] = actionInstance
				end
			end
		end
	end
end

function ShopWindowController:poke(actionID, actionIndex, e)
	if actionID == "buy" then
		self:buy(e)
	elseif actionID == "select" then
		self:select(e)
	elseif actionID == "close" then
		self:getGame():getUI():closeInstance(self)
	else
		Controller.poke(self, actionID, actionIndex, e)
	end
end

function ShopWindowController:pull()
	return self.state
end

function ShopWindowController:buy(e)
	assert(type(e.id) == "number", "action ID must be number")
	assert(self.inventoryByID[e.id] ~= nil, "action with ID not found")
	assert(type(e.count) == "number", "count must be number")

	local action = self.inventoryByID[e.id]
	local player = self:getPeep()
	local count = math.min(action:count(player:getState(), player), e.count)

	action:perform(player:getState(), player, e.count)
end

function ShopWindowController:select(e)
	assert(type(e.id) == "number", "action ID must be number")
	assert(self.inventoryByID[e.id] ~= nil, "action with ID not found")

	local director = self:getDirector()
	local gameDB = director:getGameDB()
	local brochure = gameDB:getBrochure()

	local action = self.inventoryByID[e.id]:getAction()
	local result = {}
	do
		result.requirements = {}
		for requirement in brochure:getRequirements(action) do
			local resource = brochure:getConstraintResource(requirement)
			local resourceType = brochure:getResourceTypeFromResource(resource)

			table.insert(
				result.requirements,
				{
					type = resourceType.name,
					resource = resource.name,
					name = Utility.getName(resource, gameDB) or resource.name,
					count = requirement.count
				})
		end
	end
	do
		result.inputs = {}
		for input in brochure:getInputs(action) do
			local resource = brochure:getConstraintResource(input)
			local resourceType = brochure:getResourceTypeFromResource(resource)

			table.insert(
				result.inputs,
				{
					type = resourceType.name,
					resource = resource.name,
					name = Utility.getName(resource, gameDB) or resource.name,
					count = input.count
				})
		end
	end
	do
		result.outputs = {}
		for output in brochure:getOutputs(action) do
			local resource = brochure:getConstraintResource(output)
			local resourceType = brochure:getResourceTypeFromResource(resource)

			table.insert(
				result.outputs,
				{
					type = resourceType.name,
					resource = resource.name,
					name = Utility.getName(resource, gameDB) or resource.name,
					count = output.count
				})
		end
	end

	director:getGameInstance():getUI():sendPoke(
		self,
		"populateRequirements",
		nil,
		{ result })
end

return ShopWindowController
