--------------------------------------------------------------------------------
-- ItsyScape/Peep/Action.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Mapp = require "ItsyScape.GameDB.Mapp"

local Action = Class()

function Action:new(game, action)
	self.game = game
	self.gameDB = game:getGameDB()
	self.action = action

	local definition = self.gameDB:getBrochure():getActionDefinitionFromAction(action)
	self.definitionName = definition.name
	self.definitionID = definition.id.value
end

function Action:getGame()
	return self.game
end

function Action:getGameDB()
	return self.gameDB
end

function Action:getAction()
	return self.action
end

-- Returns the ID of the action, as a number.
--
-- This should be the GameDB ID.
function Action:getID()
	return self.action.id.value
end

-- Returns the name of the action, from the definition.
function Action:getName()
	return self.definitionName
end

-- Gets the definition ID, as a number.
--
-- This should be the GameDB ID.
function Action:getDefinitionID()
	return self.definitionID
end

-- Gets the verb in 'lang'.
--
-- 'lang' defaults to "en-US". If no verb is found, returns false.
function Action:getVerb(lang)
	lang = lang or "en-US"

	local nameRecord = self.gameDB:getRecords("ActionVerb", { Action = self.action, Language = lang }, 1)[1]
	if nameRecord then
		return nameRecord:get("Value")
	else
		return false
	end
end

-- Returns true if the Action can be performed. Otherwise, returns false.
--
-- The default implementation only evaluates requirements, not inputs.
function Action:canPerform(state)
	local brochure = self.gameDB:getBrochure()
	for requirement in brochure:getRequirements(self.action) do
		local resource = brochure:getConstraintResource(requirement)
		local resourceType = brochure:getResourceTypeFromResource(resource)

		if not state:has(resourceType.name, resource.name, requirement.count) then
			return false
		end
	end
end

-- Performs the action.
--
-- The arguments vary depending on the type of Action; there can be no standard.
--
-- For example, Actions perfomed on an Item generally are in the form
-- (item, peep); Actions performed via an object are in the form (item, peep,
-- object); and so on.
--
-- Returns true if the action could be performed, or false otherwise. If the
-- action fails, a message should be returned.
function Action:perform(poke, ...)
	return false, "not implemented"
end

return Action
