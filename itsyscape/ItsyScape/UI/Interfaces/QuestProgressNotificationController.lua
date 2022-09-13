--------------------------------------------------------------------------------
-- ItsyScape/UI/QuestProgressNotificationController.lua
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

local QuestProgressNotificationController = Class(Controller)

QuestProgressNotificationController.QUEST_CACHE = {}
QuestProgressNotificationController.KEY_ITEM_TO_QUEST_CACHE = {}

function QuestProgressNotificationController:new(peep, director, keyItem)
	Controller.new(self, peep, director)

	local game = director:getGameInstance()
	local gameDB = director:getGameDB()
	local brochure = gameDB:getBrochure()

	if next(QuestProgressNotificationController.QUEST_CACHE) == nil then
		for q in gameDB:getResources("Quest") do
			local quest = {
				id = q.name,
				name = Utility.getName(q, gameDB),
				description = Utility.getDescription(q, gameDB)
			}

			quest.steps = Utility.Quest.build(q, gameDB)
			quest.info = Utility.Quest.buildWorkingQuestLog(quest.steps, gameDB)

			QuestProgressNotificationController.QUEST_CACHE[quest.id] = quest

			for i = 1, #quest.steps do
				local keyItems = quest.steps[i]
				for j = 1, #keyItems do
					local keyItem = keyItems[j]
					QuestProgressNotificationController.KEY_ITEM_TO_QUEST_CACHE[keyItem.name] = q
				end
			end
		end
	end

	if keyItem then
		self:updateKeyItem(keyItem)
	else
		local storage = self:getDirector():getPlayerStorage(self:getPeep())
		local lastQuest = storage:getRoot():getSection("Nominomicon"):get("lastQuest")

		if lastQuest then
			gameDB = self:getDirector():getGameDB()
			local quest = gameDB:getResource("Quest", lastQuest)

			if quest then
				self:updateQuest(quest)
			end
		end
	end
end

function QuestProgressNotificationController:poke(actionID, actionIndex, e)
	if actionID == "close" then
		self:getGame():getUI():closeInstance(self)
	else
		Controller.poke(self, actionID, actionIndex, e)
	end
end

function QuestProgressNotificationController:updateQuest(quest)
	self.questID = (quest and quest.name) or self.questID
	self.log = nil

	if self.questID then
		local quest = QuestProgressNotificationController.QUEST_CACHE[self.questID]
		if quest then
			self.log = Utility.Quest.buildRichTextLabelFromQuestLog(quest.info, self:getPeep())
		end
	end

	if self.log then
		local storage = self:getDirector():getPlayerStorage(self:getPeep())
		storage:getRoot():getSection("Nominomicon"):set("lastQuest", self.questID)
	end

	self:getDirector():getGameInstance():getUI():sendPoke(
		self,
		"updateQuest",
		nil,
		{})
end

function QuestProgressNotificationController:updateKeyItem(keyItem)
	self:updateQuest(QuestProgressNotificationController.KEY_ITEM_TO_QUEST_CACHE[keyItem.name])
end

function QuestProgressNotificationController:update(delta)
	Controller.update(self, delta)

	if not self.questID or not self.log then
		self:getGame():getUI():closeInstance(self)
	end
end

function QuestProgressNotificationController:pull()
	if self.questID and self.log then
		return {
			questName = QuestProgressNotificationController.QUEST_CACHE[self.questID].name,
			steps = self.log
		}
	else
		return {
			questName = "",
			steps = {}
		}
	end
end

return QuestProgressNotificationController
