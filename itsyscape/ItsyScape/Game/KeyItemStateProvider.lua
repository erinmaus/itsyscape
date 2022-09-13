--------------------------------------------------------------------------------
-- ItsyScape/Game/KeyItemStateProvider.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local State = require "ItsyScape.Game.State"
local Utility = require "ItsyScape.Game.Utility"
local StateProvider = require "ItsyScape.Game.StateProvider"
local QuestProgressNotificationController = require "ItsyScape.UI.Interfaces.QuestProgressNotificationController"

local KeyItemStateProvider = Class(StateProvider)

function KeyItemStateProvider:new(peep)
	local director = peep:getDirector()
	local storage = director:getPlayerStorage(peep)

	self.storage = storage:getRoot():getSection("KeyItems")
	self.peep = peep

	QuestProgressNotificationController.updateCache(director:getGameDB())
end

function KeyItemStateProvider:getPriority()
	return State.PRIORITY_LOCAL
end

function KeyItemStateProvider:updateQuestProgressNotificationController(resource)
	local isOpen, index = Utility.UI.isOpen(self.peep, "QuestProgressNotification")
	if not isOpen then
		local _, n = Utility.UI.openInterface(self.peep, "QuestProgressNotification", false)
		index = n
	end

	if index then
		local controller = Utility.UI.getOpenInterface(self.peep, "QuestProgressNotification", index)
		controller:updateKeyItem(resource)
	end
end

function KeyItemStateProvider:has(name, count, flags)
	return (count or 1) <= self:count(name, flags)
end

function KeyItemStateProvider:take(name, count, flags)
	local gameDB = self.peep:getDirector():getGameDB()
	local resource = gameDB:getResource(name, "KeyItem")
	if not resource then
		return false
	end

	self.storage:set(name, nil)
	return true
end

function KeyItemStateProvider:give(name, count, flags)
	local gameDB = self.peep:getDirector():getGameDB()
	local resource = gameDB:getResource(name, "KeyItem")
	if not resource then
		return false
	end

	local hadKeyItem = self.storage:get(name)

	self.storage:set(name, true)

	if not hadKeyItem then
		Log.analytic("PLAYER_GOT_KEY_ITEM", name)
		Log.info(
			"Player '%s' (%d) obtained key item %s.",
			self.peep:getName(),
			Utility.Peep.getPlayerModel(self.peep) and Utility.Peep.getPlayerModel(self.peep):getID(),
			name)

		local quest = QuestProgressNotificationController.KEY_ITEM_TO_QUEST_CACHE[name]
		print("quest", quest, quest.name)
		if quest and Utility.Quest.didComplete(quest, self.peep) then
			Utility.UI.openInterface(self.peep, "QuestCompleteNotification", false, quest)
		end
	end

	self:updateQuestProgressNotificationController(resource)

	return true
end

function KeyItemStateProvider:count(name, flags)
	if self.storage:get(name) == true then
		return math.huge
	else
		return 0
	end
end

return KeyItemStateProvider
