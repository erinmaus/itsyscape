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
				end
			end
		end
	end
end

function CraftWindowController:poke(actionID, actionIndex, e)
	if actionID == "craft" then
		self:craft(e)
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

return CraftWindowController
