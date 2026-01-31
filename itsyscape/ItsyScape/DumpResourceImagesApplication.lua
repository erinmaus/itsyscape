--------------------------------------------------------------------------------
-- ItsyScape/DumpResourceImagesApplication.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Application = require "ItsyScape.Application"
local Class = require "ItsyScape.Common.Class"
local Utility = require "ItsyScape.Game.Utility"
local Mapp = require "ItsyScape.GameDB.Mapp"
local Interface = require "ItsyScape.UI.Interface"
local Theme = require "ItsyScape.UI.Interfaces.Theme"
local SkillGuideInfoContentTab = require "ItsyScape.UI.Interfaces.Components.SkillGuideInfoContentTab"

local DumpResourceImagesApplication = Class(Application)

DumpResourceImagesApplication.FakeInterface = Class(Interface)
function DumpResourceImagesApplication.FakeInterface:new(view)
	Interface.new(self, "Fake", 1, view)
end

function DumpResourceImagesApplication.FakeInterface:getOverflow()
	return true
end

function DumpResourceImagesApplication:new()
	Application.new(self)

	self.fakeInterface = DumpResourceImagesApplication.FakeInterface(self:getUIView())
	self:getUIView():getRoot():addChild(self.fakeInterface)

	self.actionsBySkill = {}
	self:pullResources()

	self:getGameView():getResourceManager():queueEvent(function()
		self:dump()
	end)
end

function DumpResourceImagesApplication:pullResources()
	local pendingActionTypes = self:getPendingActionTypes()

	local visitedActionTypes = { "Equip" }
	for _, actionType in ipairs(pendingActionTypes) do
		if not visitedActionTypes[actionType] then
			visitedActionTypes[actionType] = true

			self:pullActions(actionType)
		end
	end
end

function DumpResourceImagesApplication:getPendingActionTypes()
	local actionTypes = self:getGameDB():getRecords("SkillAction", {})

	local pendingActionTypes = {}
	for _, actionType in ipairs(actionTypes) do
		table.insert(pendingActionTypes, actionType:get("ActionType"))
	end

	return pendingActionTypes
end

function DumpResourceImagesApplication:pullActions(actionType)
	local gameDB = self:getGameDB()
	local brochure = gameDB:getBrochure()

	local actionDefinition = Mapp.ActionDefinition()
	if not brochure:tryGetActionDefinition(actionType, actionDefinition) then
		return
	end

	for action in brochure:findActionsByDefinition(actionDefinition) do
		local a = Utility.getAction(self:getGame(), action)
		if a then
			local skills = self:pullActionSkills(action)

			for skill in pairs(skills) do
				self:addSkillAction(skill, a)
			end
		end
	end
end

function DumpResourceImagesApplication:pullActionSkills(action)
	local constraints = Utility.getActionConstraints(self:getGame(), action)

	local skills = {}
	for _, c in pairs(constraints) do
		for _, constraint in ipairs(c) do
			if constraint.type == "Skill" then
				skills[constraint.resource] = true
			end
		end
	end

	return skills
end

function DumpResourceImagesApplication:addSkillAction(skill, a)
	local actions = self.actionsBySkill[skill]
	if not actions then
		actions = { id = {} }
		self.actionsBySkill[skill] = actions
	end

	if not actions.id[a.instance:getID()] then
		actions.id[a.instance:getID()] = true
		table.insert(actions, a)
	end
end

function DumpResourceImagesApplication:dump()
	for skill, actions in pairs(self.actionsBySkill) do
		local directoryName = string.format("DumpResourceImages/%s", skill)
		love.filesystem.createDirectory(directoryName)

		for _, action in ipairs(actions) do
			local verb = action.instance:getName()

			local state = {
				action = { id = action.instance:getID() },
				constraints = Utility.getActionConstraints(self:getGame(), action.instance:getAction())
			}

			local content = SkillGuideInfoContentTab(self.fakeInterface)
			self.fakeInterface:addChild(content)

			content:setPosition(Theme.DEFAULT_OUTER_PADDING, Theme.DEFAULT_OUTER_PADDING)
			content:refresh(state)
			content:expand()

			local width, height = content:getSize()
			local canvas = love.graphics.newCanvas(
				width + Theme.DEFAULT_OUTER_PADDING * 2,
				height + Theme.DEFAULT_INNER_PADDING * 2)

			love.graphics.setCanvas(canvas)
			self:getUIView():draw()
			love.graphics.setCanvas()


			canvas:newImageData():encode("png", string.format("%s/%s %s.png", directoryName, verb, content.label:getText()))
			canvas:release()

			Log.info("Dumped %s -> %s.", verb, content.label:getText())
			coroutine.yield()

			self.fakeInterface:removeChild(content)
		end
	end

	Log.info("Done!")
	love.event.quit()
end

return DumpResourceImagesApplication
