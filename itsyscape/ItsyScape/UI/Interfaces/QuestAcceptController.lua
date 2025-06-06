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

	local completeAction
	do
		local questActions = Utility.getActions(
			self:getGame(),
			self.resource,
			'quest',
			false)
		for _, action in ipairs(questActions) do
			if action.instance:is("QuestComplete") then
				completeAction = action.instance
				break
			end
		end
	end

	local requirements = Utility.getActionConstraints(self:getGame(), action:getAction())
	local rewards = Utility.getActionConstraints(self:getGame(), completeAction:getAction())


	self.state = {
		requirements = requirements.requirements,
		inputs = requirements.inputs,
		outputs = rewards.outputs or requirements.outputs
	}

	self.state.questName = Utility.getName(self.resource, gameDB) or self.resource.name .. "*"

	local instance = self.actionInfo and self.actionInfo.instance
	self.state.canPerform = self.action:canPerform(self:getPeep():getState(), self:getPeep())
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
	local success = hasResource or self.action:perform(self:getPeep():getState(), self:getPeep())

	if success then
		if self.questGiver then
			self.questGiver:poke('acceptQuest', self:getPeep(), self.resource, self.action)
		end

		self:getGame():getUI():closeInstance(self)
	else
		Utility.UI.notifyFailure(self:getPeep(), "Message_QuestRequirementsNotMet")
	end
end

function QuestAcceptController:pull()
	return self.state
end

return QuestAcceptController
