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
local Probe = require "ItsyScape.Peep.Probe"
local ActorReferenceBehavior = require "ItsyScape.Peep.Behaviors.ActorReferenceBehavior"
local PropReferenceBehavior = require "ItsyScape.Peep.Behaviors.PropReferenceBehavior"
local Controller = require "ItsyScape.UI.Controller"

local QuestProgressNotificationController = Class(Controller)

QuestProgressNotificationController.QUEST_CACHE = {}
QuestProgressNotificationController.KEY_ITEM_TO_QUEST_CACHE = {}

function QuestProgressNotificationController.updateCache(gameDB)
	if next(QuestProgressNotificationController.QUEST_CACHE) ~= nil then
		return
	end

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

function QuestProgressNotificationController:new(peep, director, keyItem)
	Controller.new(self, peep, director)

	local game = director:getGameInstance()
	local gameDB = director:getGameDB()
	local brochure = gameDB:getBrochure()

	QuestProgressNotificationController.updateCache(gameDB)

	if keyItem then
		self:updateKeyItem(keyItem)
	else
		local storage = self:getDirector():getPlayerStorage(self:getPeep())
		local lastQuest = storage:getRoot():getSection("Nominomicon"):get("lastQuest")

		if lastQuest then
			gameDB = self:getDirector():getGameDB()
			local quest = gameDB:getResource(lastQuest, "Quest")

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

	self.nextStep = nil
	self.mapResource = nil
	self.tryAgain = true

	self:getDirector():getGameInstance():getUI():sendPoke(
		self,
		"updateQuest",
		nil,
		{})
end

function QuestProgressNotificationController:updateKeyItem(keyItem)
	self:updateQuest(QuestProgressNotificationController.KEY_ITEM_TO_QUEST_CACHE[keyItem.name])
end

function QuestProgressNotificationController:updateMapHints()
	local peep = self:getPeep()
	local nextStep = Utility.Quest.getNextStep(self.questID, peep)
	local mapResource = Utility.Peep.getMapResource(peep)

	if not nextStep then
		self.hints = {}
		return
	end

	if (self.mapResource and self.mapResource.name == mapResource.name) and self.nextStep[1].name == nextStep[1].name and not self.tryAgain then
		return
	end

	local tryAgain = false
	local hints = {}
	local director = self:getDirector()
	local gameDB = director:getGameDB()
	for i = 1, #nextStep do
		local step = nextStep[i]

		if not peep:getState():has("KeyItem", step.name) then
			local hint = gameDB:getRecord("KeyItemLocationHint", {
				Map = mapResource,
				KeyItem = step
			})

			if hint then
				local description = Utility.getDescription(step, gameDB, nil, 1)
				local mapObject = hint:get("MapObject")

				local hit = director:probe(peep:getLayerName(), Probe.mapObject(mapObject))[1]
				if hit then
					local prop = hit:getBehavior(PropReferenceBehavior)
					if prop and prop.prop then
						table.insert(hints, { prop = prop.prop:getID(), description = description })
					end

					local actor = hit:getBehavior(ActorReferenceBehavior)
					if actor and actor.actor then
						table.insert(hints, { actor = actor.actor:getID(), description = description })
					end
				elseif not gameDB:getRecord("PeepMapObject", { MapObject = mapObject }) and
				       not gameDB:getRecord("PropMapObject", { MapObject = mapObject })
				then
					local location = gameDB:getRecord("MapObjectLocation", {
						MapObject = mapObject
					})

					if location then
						table.insert(hints, {
							layer = Utility.Peep.getLayer(peep),
							x = location:get("PositionX"),
							y = location:get("PositionY"),
							z = location:get("PositionZ"),
							description = description
						})
					end
				else
					tryAgain = true
				end
			end
		end
	end

	self:getDirector():getGameInstance():getUI():sendPoke(
		self,
		"updateHints",
		nil,
		{})

	self.mapResource = mapResource
	self.nextStep = nextStep

	self.hints = hints
	self.tryAgain = tryAgain
end

function QuestProgressNotificationController:update(delta)
	Controller.update(self, delta)

	if not self.questID or not self.log then
		self:getGame():getUI():closeInstance(self)
	elseif self:getPeep():getState():has("Quest", self.questID) then
		self:getGame():getUI():closeInstance(self)
	else
		if self.questID then
			self:updateMapHints()
		end
	end
end

function QuestProgressNotificationController:pull()
	if self.questID and self.log then
		return {
			questName = QuestProgressNotificationController.QUEST_CACHE[self.questID].name,
			steps = self.log,
			hints = self.hints or {}
		}
	else
		return {
			questName = "",
			steps = {},
			hints = {}
		}
	end
end

return QuestProgressNotificationController
