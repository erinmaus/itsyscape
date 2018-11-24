--------------------------------------------------------------------------------
-- ItsyScape/UI/CraftWindowController.lua
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

local CraftWindowController = Class(Controller)

function CraftWindowController:new(peep, director, prop, categoryKey, categoryValue, actionTypeFilter)
	Controller.new(self, peep, director)

	local game = director:getGameInstance()
	local gameDB = director:getGameDB()
	local brochure = gameDB:getBrochure()

	local resources = gameDB:getRecords("ResourceCategory", {
		Key = categoryKey,
		Value = categoryValue
	})

	self.state = { actions = {} }
	self.actionsByID = {}
	self.prop = prop

	local flags = { ['item-inventory'] = true }
	for i = 1, #resources do
		local resource = resources[i]:get("Resource")

		for action in brochure:findActionsByResource(resource) do
			local actionType = brochure:getActionDefinitionFromAction(action)
			if actionType.name == actionTypeFilter then
				local a, ActionType = Utility.getAction(game, action, 'craft')
				local actionInstance = ActionType(game, action)
				if actionInstance:canPerform(peep:getState(), flags) then
					a.count = actionInstance:count(peep:getState(), flags)
					table.insert(self.state.actions, a)

					self.actionsByID[a.id] = actionInstance
				else
					print 'failed'
				end
			end
		end
	end
end

function CraftWindowController:poke(actionID, actionIndex, e)
	if actionID == "craft" then
		self:craft(e)
	elseif actionID == "select" then
		self:select(e)
	elseif actionID == "close" then
		self:getGame():getUI():closeInstance(self)
	else
		Controller.poke(self, actionID, actionIndex, e)
	end
end

function CraftWindowController:pull()
	return self.state
end

function CraftWindowController:craft(e)
	assert(type(e.id) == "number", "action ID must be number")
	assert(self.actionsByID[e.id] ~= nil, "action with ID not found")
	assert(type(e.count) == "number", "count must be number")
	assert(e.count > 0, "count must be greater than zero")
	assert(e.count < math.huge, "count must be less than infinity")

	e.count = math.min(e.count, 60)

	local action = self.actionsByID[e.id]
	local player = self:getPeep()
	local count = math.min(action:count(player:getState(), player), e.count)

	if player:getCommandQueue():clear() then
		for i = 1, e.count do
			action:perform(
				player:getState(),
				player,
				self.prop)
		end
	end

	self:getGame():getUI():closeInstance(self)
end

function CraftWindowController:select(e)
	assert(type(e.id) == "number", "action ID must be number")
	assert(self.actionsByID[e.id] ~= nil, "action with ID not found")

	local director = self:getDirector()
	local gameDB = director:getGameDB()
	local brochure = gameDB:getBrochure()

	local action = self.actionsByID[e.id]:getAction()
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

return CraftWindowController
