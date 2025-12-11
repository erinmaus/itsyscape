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
local Nomicon = require "nomicon"
local Class = require "ItsyScape.Common.Class"
local Utility = require "ItsyScape.Game.Utility"
local Controller = require "ItsyScape.UI.Controller"

local ReadBookController = Class(Controller)

function ReadBookController:new(peep, director, resource)
	Controller.new(self, peep, director)

	self.resource = resource

	local filename = string.format("Resources/Game/Books/%s/TableOfContents.json", resource.name)
	self.bookConfig = json.decode(love.filesystem.read(filename))

	local text = love.filesystem.read(string.format("Resources/Game/Books/%s/Book.json", resource.name)) or "{}"
	self.story = Nomicon.Story(json.decode(text), self:getVariables())

	Utility.Text.bindBook(self.story, peep, nil, "en-US")

	do
		local commonPath = string.format("Resources.Game.Books.%s.Common", resource.name)
		local s, r = pcall(require, commonPath)
		if s then
			Utility.Text.bindBook(self.story, peep, r, "en-US")
		else
			if love.filesystem.getInfo(string.format("Resources/Game/Books/%s/Common.lua", characterName)) or
			   love.filesystem.getInfo(string.format("Resources/Game/Books/%s/Common/init.lua", characterName))
		   	then
		   		Log.warn("Couldn't load common dialog '%s' for '%s': %s", commonPath, characterName, r)
		   	end
		end
	end
end

function ReadBookController:getDefaultVariables()
	return {
		player_name = string.format("%%person(%s)", self:getPeep():getName())
	}
end

function ReadBookController:getVariables()
	return self:getDefaultVariables()
end

function ReadBookController:_parseTextTree(parent, pageIndex, commands, currentStyle, currentText)
	commands = commands or {}
	currentStyle = currentStyle or {}
	currentText = currentText or {}

	local previousStyle = currentStyle
	for _, child in ipairs(parent.children) do
		if type(child) == "string" then
			if previousStyle ~= currentStyle then
				local command = {
					x = pageIndex and (pageIndex % 2 == 1 and 20 or 5),
					y = pageIndex and 5,
					width = pageIndex and (pageIndex % 2 == 1 and 75 or 80)
				}

				for key, value in pairs(currentStyle) do
					command[key] = value
				end

				command.value = table.concat(currentText)
				table.clear(currentText)

				command.command = "text"
				table.insert(commands, command)

				previousStyle = currentStyle
			end

			table.insert(currentText, child)
		elseif type(child) == "table" then
			local parseChildTree = false

			if child.tag == "style" then
				if next(child.attributes) ~= nil then
					local newStyle = {}

					for key, value in pairs(currentStyle) do
						newStyle[key] = value
					end

					for attributeName, attribute in pairs(child.attributes) do
						newStyle[attributeName] = attribute.value
					end

					currentStyle = newStyle
				end

				parseChildTree = true
			elseif child.tag == "text" then
				local command = {}

				for key, value in pairs(currentStyle) do
					command[key] = value
				end

				for attributeName, attribute in pairs(child.attributes) do
					command[attributeName] = attribute.value
				end

				command.value = table.concat(child.children, "\n")
				command.command = "text"
				table.insert(commands, command)
			elseif child.tag == "glyph" then
				local command = {}

				for key, value in pairs(currentStyle) do
					command[key] = value
				end

				for attributeName, attribute in pairs(child.attributes) do
					command[attributeName] = attribute.value
				end

				command.value = tonumber(command.value or "0") or 0
				command.command = "glyph"
				table.insert(commands, command)
			elseif child.tag == "glyphs" then
				local command = {}

				for key, value in pairs(currentStyle) do
					command[key] = value
				end

				for attributeName, attribute in pairs(child.attributes) do
					command[attributeName] = attribute.value
				end

				command.value = table.concat(child.children, "\n")
				command.command = "glyphs"
				table.insert(commands, command)
			elseif child.tag == "image" then
				local command = {}

				for key, value in pairs(currentStyle) do
					command[key] = value
				end

				command.command = "image"

				table.insert(commands, command)
			else
				parseChildTree = true
			end

			if parseChildTree then
				self:_parseTextTree(child, pageIndex, commands, currentStyle, currentText)
			end
		end
	end

	if not parent.parent and #currentText >= 1 then
		local command = {
			x = pageIndex and (pageIndex % 2 == 1 and 25 or 5),
			y = pageIndex and 5,
			width = 75
		}

		for key, value in pairs(currentStyle) do
			command[key] = value
		end

		command.value = table.concat(currentText)
		table.clear(currentText)

		command.command = "text"
		table.insert(commands, command)
	end

	return commands
end

function ReadBookController:_pullPart(partConfig, pageIndex)
	partConfig = partConfig or {}

	local result = {
		skeleton = partConfig.skeleton,
		models = partConfig.models,
		animations = partConfig.animations,
		commands = {}
	}

	local knot = partConfig.knot
	if knot then
		self.story:choose(knot)

		local paragraphs = {}
		while self.story:canContinue() do
			local paragraph = self.story:continue()
			table.insert(paragraphs, paragraph)
		end

		local pageText = table.concat(paragraphs, "\n")
		local tree = Utility.Text.parse(pageText)
		result.commands = self:_parseTextTree(tree, pageIndex)
	end

	return result
end

function ReadBookController:buildState()
	self.bookState = {
		resource = self.resource.name,
		book = {
			book = self:_pullPart(self.bookConfig.book),
			front = self:_pullPart(self.bookConfig.front),
			back = self:_pullPart(self.bookConfig.back),
			page = self:_pullPart(self.bookConfig.page),
			pages = {}
		}
	}

	for i, page in ipairs(self.bookConfig.pages) do
		table.insert(self.bookState.book.pages, self:_pullPart(page, i))
	end
end

function ReadBookController:updateTime()
	local playerStorage = self:getDirector():getPlayerStorage(self:getPeep())
	local rootStorage = playerStorage:getRoot()

	self.currentTime = Utility.Time.getAndUpdateTime(rootStorage)
end

function ReadBookController:pull()
	self:updateTime()

	return {
		time = self.currentTime
	}
end

function ReadBookController:update(...)
	Controller.update(self, ...)

	if not self.bookState then
		self:buildState()
		self:send("prepareBook", self.bookState)
	end
end

return ReadBookController
