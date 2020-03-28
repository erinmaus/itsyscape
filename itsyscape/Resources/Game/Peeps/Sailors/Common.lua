--------------------------------------------------------------------------------
-- Resources/Peeps/Sailing/BaseSailor.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Utility = require "ItsyScape.Game.Utility"

local Common = {}

function Common.getBuyAction(game, resource, requiredAction)
	local action
	do
		local actions = Utility.getActions(game, resource, 'sailing')
		for k = 1, #actions do
			if (requiredAction and actions[k].instance:is(requiredAction)) or
			   (actions[k].instance:is('SailingBuy') or actions[k].instance:is('SailingUnlock'))
			then
				action = actions[k].instance
				break
			end
		end
	end

	if not action then
		Log.warn("No sailing buy/unlock action for resource: '%s'.", resource.name)
	end

	return action
end

function Common.getAllFirstMates(player)
	local gameDB = player:getDirector():getGameDB()
	local roles = gameDB:getRecords(
		"ResourceCategory", {
			Key = "SailingRole",
			Value = "FirstMate"
		})

	local results = {}
	for i = 1, #roles do
		table.insert(results, roles[i]:get("Resource"))
	end

	return results
end

function Common.getAllCrew(player)
	local gameDB = player:getDirector():getGameDB()
	return gameDB:getResources("SailingCrew")
end

function Common.getUnlockableFirstMates(player, requiredAction)
	local firstMates = Common.getAllFirstMates(player)

	local results = {}
	for i = 1, #firstMates do
		local firstMate = firstMates[i]
		local unlockAction = Common.getBuyAction(
			player:getDirector():getGameInstance(),
			firstMate,
			requiredAction)

		if unlockAction and unlockAction:canPerform(player:getState()) then
			table.insert(results, firstMate)
		end
	end

	return results
end

function Common.getUnlockableCrew(player, requiredAction)
	local crew = Common.getAllCrew(player)

	local results = {}
	for i = 1, #crew do
		local c = crew[i]
		local unlockAction = Common.getBuyAction(
			player:getDirector():getGameInstance(),
			c,
			requiredAction)

		if unlockAction and unlockAction:canPerform(player:getState()) then
			table.insert(results, c)
		end
	end

	return results
end

function Common.getActiveFirstMateResource(player)
	local director = player:getDirector()
	local playerStorage = director:getPlayerStorage(player):getRoot()
	local firstMateStorage = playerStorage:getSection("Ship"):getSection("FirstMate")
	local firstMateResourceName = firstMateStorage:get("resource")

	if firstMateResourceName then
		return director:getGameDB():getResource(firstMateResourceName, "Peep"),
		       firstMateStorage:get("pending") or false
	end

	Log.warn("No active or pending first mate for player '%s'.", player:getName())
	return nil, false
end

function Common.isActiveFirstMate(player, firstMate)
	local activeFirstMateResource, pending = Common.getActiveFirstMateResource(player)
	local firstMateResource = Utility.Peep.getResource(firstMate)

	if not pending and
	   activeFirstMateResource and
	   firstMateResource and
	   activeFirstMateResource.id.value == firstMateResource.id.value
	then
		return true
	end

	return false
end

function Common.setActiveFirstMateResource(player, resource, pending)
	local director = player:getDirector()
	local playerStorage = director:getPlayerStorage(player):getRoot()
	local firstMateStorage = playerStorage:getSection("Ship"):getSection("FirstMate")

	firstMateStorage:set({
		resource = resource.name,
		pending = pending or false
	})
end

function Common.unsetActiveFirstMateResource(player)
	local director = player:getDirector()
	local playerStorage = director:getPlayerStorage(player):getRoot()
	local firstMateStorage = playerStorage:getSection("Ship"):getSection("FirstMate")
	firstMateStorage:set({ pending = true })
end

return Common
