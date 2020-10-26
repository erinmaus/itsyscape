--------------------------------------------------------------------------------
-- ItsyScape/UI/QuestAcceptController.lua
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

local QuestAcceptController = Class(Controller)

function QuestAcceptController:new(peep, director, resource, action, questGiver)
	Controller.new(self, peep, director)

	local gameDB = self:getGame():getGameDB()
	local brochure = gameDB:getBrochure()

	self.resource = resource
	self.resourceType = brochure:getResourceTypeFromResource(self.resource)
	self.action = action
	self.questGiver = questGiver

	self.state = Utility.getActionConstraints(director:getGameInstance(), action:getAction())
	self.state.questName = Utility.getName(self.resource, gameDB) or self.resource.name .. "*"
end

function QuestAcceptController:poke(actionID, actionIndex, e)
	if actionID == "accept" then
		self:accept(e)
	elseif actionID == "decline" or actionID == "close" then
		self:getGame():getUI():closeInstance(self)
	else
		Controller.poke(self, actionID, actionIndex, e)
	end
end

function QuestAcceptController:accept(e)
	local hasResource = self:getPeep():getState():has(
		self.resourceType.name,
		self.resource.name)
	local success = hasResource or Utility.performAction(
		self:getGame(),
		self.resource,
		self.action:getAction().id.value,
		nil,
		self:getPeep():getState(), self:getPeep())

	if success then
		if self.questGiver then
			self.questGiver:poke('acceptedQuest', self:getPeep(), self.resource, self.action)
		end

		self:getGame():getUI():closeInstance(self)
	end
end

function QuestAcceptController:pull()
	return self.state
end

return QuestAcceptController
