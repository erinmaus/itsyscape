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
local narrator = require "narrator.narrator"
local Class = require "ItsyScape.Common.Class"
local Utility = require "ItsyScape.Game.Utility"
local Controller = require "ItsyScape.UI.Controller"

local ReadBookController = Class(Controller)

function ReadBookController:new(peep, director, resource)
	Controller.new(self, peep, director)

	self.resource = resource

	local filename = string.format("Resources/Game/Books/%s/Book.json", resource.name)
	self.bookConfig = json.decode(love.filesystem.read(filename))


	local text = love.filesystem.read(string.format("Resources/Game/Books/%s/en_US.ink", resource.name)) or ""
	local book = narrator.parse_content(text)
	self.text = narrator.init_story(book)

	local methods = {}
	do
		local commonMethods = Utility.Text.bind(peep)
		for name, commonMethod in pairs(commonMethods) do
			methods[name] = commonMethod
			self.text:bind(name, commonMethod)
		end

		local chunkFilenames = {
			"Resources/Game/Books/Common/Common.lua",
			"Resources/Game/Books/Common/en_US.lua",
			string.format("Resources/Game/Books/Common/%s/Common.lua", resource.name),
			string.format("Resources/Game/Books/Common/%s/en_US.lua", resource.name)
		}

		for _, chunkFilename in ipairs(chunkFilenames) do
			local chunk = love.filesystem.load(chunkFilename)
			if chunk then
				local bind = chunk()
				local specificMethods = bind(peep, methods)

				for name, specificMethod in pairs(specificMethods) do
					methods[name] = specificMethod
					self.text:bind(name, specificMethod)
				end
			end
		end
	end
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
			x = pageIndex and (pageIndex % 2 == 1 and 20 or 5),
			y = pageIndex and 5,
			width = pageIndex and (pageIndex % 2 == 1 and 80 or 75)
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
		self.text:jump_to(knot)
		if self.text:can_continue() then
			local paragraphs = self.text:continue()

			local text = {}
			for _, paragraph in ipairs(paragraphs) do
				table.insert(text, paragraph.text)
			end
			text = table.concat(text, "\n")

			local tree = Utility.Text.parse(text)
			result.commands = self:_parseTextTree(tree, pageIndex)
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

	for i, page in ipairs(self.bookConfig.pages) do
		table.insert(state.book.pages, self:_pullPart(page, i))
	end

	return state
end

return ReadBookController
