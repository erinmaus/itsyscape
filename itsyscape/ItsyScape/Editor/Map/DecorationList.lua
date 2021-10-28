--------------------------------------------------------------------------------
-- ItsyScape/Editor/Map/DecorationList.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Callback = require "ItsyScape.Common.Callback"
local PromptWindow = require "ItsyScape.Editor.Common.PromptWindow"
local Decoration = require "ItsyScape.Graphics.Decoration"
local Button = require "ItsyScape.UI.Button"
local ButtonStyle = require "ItsyScape.UI.ButtonStyle"
local DraggablePanel = require "ItsyScape.UI.DraggablePanel"
local GridLayout = require "ItsyScape.UI.GridLayout"
local ScrollablePanel = require "ItsyScape.UI.ScrollablePanel"
local Widget = require "ItsyScape.UI.Widget"

DecorationList = Class(Widget)
DecorationList.WIDTH = 120
DecorationList.PADDING = 8

function DecorationList:new(application)
	Widget.new(self)

	self.onSelect = Callback()

	self.application = application

	local windowWidth, windowHeight = love.window.getMode()
	local width = DecorationList.WIDTH + DecorationList.PADDING * 2 + ScrollablePanel.DEFAULT_SCROLL_SIZE
	self:setSize(width, windowHeight)
	self:setPosition(0, 0)

	local panel = DraggablePanel()
	panel:setSize(width, windowHeight)
	self:addChild(panel)

	self.newButton = Button()
	self.newButton:setText("New")
	self.newButton:setSize(width - DecorationList.PADDING * 2, 32)
	self.newButton:setPosition(DecorationList.PADDING, DecorationList.PADDING)
	self.newButton.onClick:register(function()
		local namePrompt = PromptWindow(self.application)
		local tileSetPrompt = PromptWindow(self.application)

		namePrompt.onSubmit:register(function(_, name)
			tileSetPrompt:open("Enter decoration tile set ID.", "Tile Set")
		end)

		tileSetPrompt.onSubmit:register(function(_, name)
			local decorationFilename = string.format("Resources/Game/TileSets/%s/Layout.lstatic", name)
			if love.filesystem.getInfo(decorationFilename) then
				local t = { tileSetID = name }
				self.application:getGame():getStage():decorate(name, Decoration(t))
			else
				Log.warn("Couldn't find decoration tile set '%s'.", name)
			end
		end)
		namePrompt:open("Enter name for decoration.", "Name")
	end)
	self:addChild(self.newButton)

	self.scrollablePanel = ScrollablePanel(GridLayout)
	self.scrollablePanel:setPosition(
		DecorationList.PADDING,
		DecorationList.PADDING + 32)
	self.scrollablePanel:setSize(
		width,
		windowHeight - 32 - DecorationList.PADDING)
	self:addChild(self.scrollablePanel)

	local gridLayout = self.scrollablePanel:getInnerPanel()
	gridLayout:setPadding(
		DecorationList.PADDING,
		DecorationList.PADDING)
	gridLayout:setUniformSize(
		true,
		width - DecorationList.PADDING * 2,
		32)

	self.scrollablePanel:setSize(width, windowHeight)

	self.decorations = {}

	self.currentDecoration = false
	self.currentDecorationButton = false
end

function DecorationList:open(x, y, parent)
	local currentX, currentY = self:getPosition()
	self:setPosition(x or currentX, y or currentY)

	local root = parent or self.application:getUIView():getRoot()
	root:addChild(self)
end

function DecorationList:close()
	local p = self:getParent()
	if p then
		p:removeChild(self)
	end
end

function DecorationList:update(...)
	Widget.update(self, ...)

	local decorations, count = self.application:getGameView():getDecorations()
	local needsUpdate = false
	do
		for k in pairs(decorations) do
			if not self.decorations[k] then
				needsUpdate = true
				break
			end
		end

		if not needsUpdate then
			for k in pairs(self.decorations) do
				if not decorations[k] then
					needsUpdate = true
					break
				end
			end
		end
	end

	if needsUpdate then
		local currentWidth, currentHeight = self.scrollablePanel:getScrollSize()
		local newHeight = count * (32 + DecorationList.PADDING * 2)

		self.scrollablePanel:setScrollSize(currentWidth, newHeight)

		local d = {}
		for k in pairs(decorations) do
			table.insert(d, k)
		end

		table.sort(d)

		do
			local p = self.scrollablePanel:getInnerPanel()
			local children = {}
			for _, child in p:iterate() do
				children[child] = true
			end

			for child in pairs(children) do
				p:removeChild(child)
			end
		end

		for i = 1, #d do
			local decoration = decorations[d[i]]
			local button = Button()
			button:setText(d[i])

			button.onClick:register(function()
				self:select(d[i], decoration, button)
			end)

			self.scrollablePanel:addChild(button)
		end

		self.decorations = decorations
	end
end

function DecorationList:select(group, decoration, button)
	if self.currentDecorationButton then
		self.currentDecorationButton:setStyle(nil)
	end

	if self.currentDecoration == group then
		button:setStyle(nil)
		self.currentDecoration = false
		self.currentDecorationButton = false
	else
		button:setStyle(ButtonStyle({
			pressed = "Resources/Renderers/Widget/Button/ActiveDefault-Pressed.9.png",
			inactive = "Resources/Renderers/Widget/Button/ActiveDefault-Inactive.9.png",
			hover = "Resources/Renderers/Widget/Button/ActiveDefault-Hover.9.png",
			color = { 1, 1, 1, 1 },
			font = "Resources/Renderers/Widget/Common/DefaultSansSerif/Regular.ttf",
			fontSize = 24,
			textShadow = true,
			padding = 4
		}, self.application:getUIView():getResources()))

		self.onSelect(self, group, decoration)
		self.currentDecoration = group
		self.currentDecorationButton = button
	end
end

function DecorationList:getCurrentDecoration()
	if not self.currentDecoration then
		return nil, nil
	else
		return self.currentDecoration, self.decorations[self.currentDecoration]
	end
end

return DecorationList
