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

function CraftWindowController:new(peep, director, categoryKey, categoryValue, actionTypeFilter)
	Controller.new(self, peep, director)

	local game = director:getGameInstance()
	local gameDB = director:getGameDB()
	local brochure = gameDB:getBrochure()

	local resources = gameDB:getRecords("ResourceCategory", {
		Key = categoryKey,
		Value = categoryValue
	})

	self.state = { actions = {} }

	for i = 1, #resources do
		local resource = resources[i]:get("Resource")

		for action in brochure:findActionsByResource(resource) do
			local actionType = brochure:getActionDefinitionFromAction(action)
			if actionType.name == actionTypeFilter then
				local a, ActionType = Utility.getAction(game, action, 'craft')
				local actionInstance = ActionType(game, action)
				if actionInstance:canPerform(peep:getState(), { ['item-inventory'] = true }) then
					table.insert(self.state.actions, a)
				end
			end
		end
	end
end

function CraftWindowController:poke(actionID, actionIndex, e)
	if false then
		-- Nothing.
	else
		Controller.poke(self, actionID, actionIndex, e)
	end
end

function CraftWindowController:pull()
	return self.state
end

return CraftWindowController
