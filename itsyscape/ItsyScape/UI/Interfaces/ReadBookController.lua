--------------------------------------------------------------------------------
-- ItsyScape/UI/Interfaces/ReadBookController.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local json = require "json"
local Class = require "ItsyScape.Common.Class"
local Utility = require "ItsyScape.Game.Utility"
local Controller = require "ItsyScape.UI.Controller"

local ReadBookController = Class(Controller)

function ReadBookController:new(peep, director, resource)
	Controller.new(self, peep, director)

	self.resource = resource

	local filename = string.format("Resources/Game/Books/%s/Book.json", resource.name)
	self.bookConfig = json.decode(love.filesystem.read(filename))
end

function ReadBookController:_pullPart(partConfig)
	partConfig = partConfig or {}

	local result = {
		skeleton = partConfig.skeleton,
		models = partConfig.models,
		animations = partConfig.animations,
		commands = {}
	}

	for _, command in ipairs(partConfig.commands or {}) do
		local isVisible = true
		if command.condition then
			for _, condition in ipairs(command.condition) do
				local resourceType = condition.resource
				local resourceName = condition.name
				local count = condition.count or 1
				local flags = {}
				for _, flag in ipairs(condition.flags or {}) do
					flags[flag] = true
				end

				if resourceType and resourceName then
					local hasCondition = self:getPeep():getState():has(resourceType, resourceName, count, flags)
					if command.invert then
						hasCondition = not hasCondition
					end

					isVisible = isVisible and hasCondition
				end
			end
		end

		if isVisible then
			table.insert(result.commands, command)
		end
	end

	return result
end

function ReadBookController:pull()
	local state = {
		resource = self.resource.name,
		book = {
			book = self:_pullPart(self.bookConfig.book),
			front = self:_pullPart(self.bookConfig.front),
			back = self:_pullPart(self.bookConfig.back),
			page = self:_pullPart(self.bookConfig.page),
			pages = {}
		}
	}

	for _, page in ipairs(self.bookConfig.pages) do
		table.insert(state.book.pages, self:_pullPart(page))
	end

	return state
end

return ReadBookController
