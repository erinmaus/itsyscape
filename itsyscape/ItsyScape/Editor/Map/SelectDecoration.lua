--------------------------------------------------------------------------------
-- ItsyScape/Editor/Map/SelectDecoration.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Callback = require "ItsyScape.Common.Callback"
local Button = require "ItsyScape.UI.Button"
local DraggablePanel = require "ItsyScape.UI.DraggablePanel"
local GridLayout = require "ItsyScape.UI.GridLayout"
local Widget = require "ItsyScape.UI.Widget"

SelectDecoration = Class(Widget)
SelectDecoration.BUTTON_WIDTH = 256
SelectDecoration.BUTTON_HEIGHT = 64
SelectDecoration.PADDING = 8

SelectDecoration.FILTER_FRONT_WALL = function(name)
	local m = name:match("(%w*)%-wall%.front%..*")
	if m then
		return true, m
	end

	return false
end

SelectDecoration.FILTER_BACK_WALL = function(name)
	local m = name:match("(%w*)%-wall%.back%..*")
	if m then
		return true, m
	end

	return false
end

SelectDecoration.FILTER_TOP = function(name)
	local m = name:match("(%w*)%-top%..*")
	if m then
		return true, m
	end

	return false
end

SelectDecoration.FILTER_CORNER = function(name)
	local m = name:match("(%w*)%-icorner")
	if m then
		return true, m
	end

	return false
end

SelectDecoration.FILTER_BUILDING = function(name)
	local m = name:match("(%w*)%-?%.[%w%.]*")
	if not m then
		return true, name
	end

	return false
end

function SelectDecoration:new(application, staticMesh, filter)
	Widget.new(self)

	self.application = application
	self.onSelect = Callback()
	self.onCancel = Callback()

	local result = {}
	do
		local names = {}
		for group in staticMesh:iterate() do
			local s, n = filter(group)
			if s then
				names[n] = true
			end
		end

		for name in pairs(names) do
			table.insert(result, name)
		end

		table.sort(result)
	end

	local width = SelectDecoration.BUTTON_WIDTH + SelectDecoration.PADDING * 2
	local height = (SelectDecoration.BUTTON_HEIGHT + SelectDecoration.PADDING * 2) * (#result + 1)

	local windowWidth, windowHeight = love.window.getMode()

	self:setPosition(windowWidth / 2 - width / 2, windowHeight / 2 - height / 2)
	self:setSize(width, height)

	local panel = DraggablePanel()
	panel:setSize(self:getSize())
	self:addChild(panel)

	local gridLayout = GridLayout()
	gridLayout:setPadding(
		SelectDecoration.PADDING,
		SelectDecoration.PADDING)
	gridLayout:setUniformSize(
		true,
		SelectDecoration.BUTTON_WIDTH,
		SelectDecoration.BUTTON_HEIGHT)
	gridLayout:setSize(self:getSize())
	self:addChild(gridLayout)

	for i = 1, #result do
		local button = Button()
		button:setText(result[i])

		button.onClick:register(self.select, self, result[i])

		gridLayout:addChild(button)
	end

	local cancelButton = Button()
	cancelButton:setText("Cancel")
	cancelButton.onClick:register(self.cancel, self)
	gridLayout:addChild(cancelButton)
end

function SelectDecoration:select(option)
	self:close()
	self.onSelect(self, option)
end

function SelectDecoration:cancel()
	self:close()
	self.onCancel(self)
end

function SelectDecoration:open(x, y, parent)
	local currentX, currentY = self:getPosition()
	self:setPosition(x or currentX, y or currentY)

	local root = parent or self.application:getUIView():getRoot()
	root:addChild(self)
end

function SelectDecoration:close()
	local p = self:getParent()
	if p then
		p:removeChild(self)
	end
end

return SelectDecoration
