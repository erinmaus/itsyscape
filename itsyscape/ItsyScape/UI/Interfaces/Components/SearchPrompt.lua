--------------------------------------------------------------------------------
-- ItsyScape/UI/Interfaces/Components/SearchPrompt.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Callback = require "ItsyScape.Common.Callback"
local Class = require "ItsyScape.Common.Class"
local Button = require "ItsyScape.UI.Button"
local Icon = require "ItsyScape.UI.Icon"
local Interface = require "ItsyScape.UI.Interface"
local GamepadSink = require "ItsyScape.UI.GamepadSink"
local GamepadGridLayout = require "ItsyScape.UI.GamepadGridLayout"
local ScrollablePanel = require "ItsyScape.UI.ScrollablePanel"
local Label = require "ItsyScape.UI.Label"
local LabelStyle = require "ItsyScape.UI.LabelStyle"
local Panel = require "ItsyScape.UI.Panel"
local PanelStyle = require "ItsyScape.UI.PanelStyle"
local TextInput = require "ItsyScape.UI.TextInput"
local TextInputStyle = require "ItsyScape.UI.TextInputStyle"
local ToolTip = require "ItsyScape.UI.ToolTip"
local Widget = require "ItsyScape.UI.Widget"
local Theme = require "ItsyScape.UI.Interfaces.Theme"

local SearchPrompt = Class(Widget)

SearchPrompt.DEFAULT_WIDTH  = 640
SearchPrompt.DEFAULT_HEIGHT = 480

SearchPrompt.SUBMIT_BUTTON_WIDTH = 128

SearchPrompt.Suggestion = Class()

function SearchPrompt.Suggestion:new(id, value, description)
	self.id = id
	self.value = value
	self.description = description
end

function SearchPrompt.Suggestion:getID()
	return self.id
end

function SearchPrompt.Suggestion:getValue()
	return self.value
end

function SearchPrompt.Suggestion:getDescription()
	return self.value
end

function SearchPrompt:new()
	Widget.new(self)

	self.onSubmit = Callback()
	self:setSize(self.DEFAULT_WIDTH, self.DEFAULT_HEIGHT)

	self:setData(GamepadSink, GamepadSink())

	self.titlePanel, self.titleLabel = Theme.newMiniTitlePanelWithLabel(self, self.DEFAULT_WIDTH)
	self.contentPanel = Theme.newContentPanel(
		self,
		self.DEFAULT_WIDTH,
		self.DEFAULT_HEIGHT - Theme.MINI_TITLE_HEIGHT,
		self.titlePanel)

	self.contentPanel.onGamepadDirection:register(self._wrapSearchPrompt, self)

	self.searchInput = TextInput()
	self.searchInput:setStyle(Theme.DEFAULT_TEXT_INPUT_STYLE, TextInputStyle)
	self.searchInput.onSubmit:register(self._onSearchPromptSubmitted, self)
	self.searchInput.onValueChanged:register(self._onSearchPromptValueChanged, self)
	self.contentPanel:addChild(self.searchInput)

	local searchInputWidth = self.searchInput:getSize()

	self.submitButton = Button()
	self.submitButton:setStyle(Theme.DEFAULT_INACTIVE_BUTTON_STYLE)
	self.submitButton:setText("Go!")
	self.submitButton.onClick:register(self._onSubmitted, self)
	self.contentPanel:addChild(self.submitButton)

 	self.suggestionsGrid = ScrollablePanel(GamepadGridLayout)
	self.suggestionsGrid:getInnerPanel():setPadding(Theme.DEFAULT_INNER_PADDING, Theme.DEFAULT_INNER_PADDING)
	self.suggestionsGrid:getInnerPanel().onWrapFocus(self._wrapSuggestionsGrid, self)

	self.noSuggestionsLabel = Label()
	self.noSuggestionsLabel:setText("No suggestions.\nTry typing more.")
	self.noSuggestionsLabel:setStyle(Theme.BUTTON_LABEL_STYLE, LabelStyle)

	self.noSuggestionsWidget = Widget()
	self.noSuggestionsWidget:addChild(self.noSuggestionsLabel)
	self.contentPanel:addChild(self.noSuggestionsWidget)

	self:performLayout()
end

function SearchPrompt:setText(value)
	return self.titleLabel:setText(value)
end

function SearchPrompt:getText()
	return self.titleLabel:getText()
end

function SearchPrompt:_onSearchPromptValueChanged(_, value)
	local suggestions = self:getSuggestions(value)

	self.suggestionsGrid:clearChildren()
	if #suggestions == 0 then
		self.contentPanel:removeChild(self.suggestionsGrid)
		self.contentPanel:addChild(self.noSuggestionsWidget)
	else
		self.contentPanel:removeChild(self.noSuggestionsWidget)
		self.contentPanel:addChild(self.suggestionsGrid)

		for _, suggestion in ipairs(suggestions) do
			local button = Button()
			button:setStyle(Theme.DEFAULT_INACTIVE_BUTTON_STYLE, ButtonStyle)
			button:setText(suggestion:getValue())
			button:setToolTip(
				ToolTip.Header(suggestion:getValue()),
				suggestion:getDescription())
			button.onClick:register(self._selectSuggestion, self, suggestion)

			self.suggestionsGrid:addChild(button)
		end

		local elementWidth = self.suggestionsGrid:getSize()
		Theme.layoutScrollablePanelWithGridLayout(self.suggestionsGrid, elementWidth, Theme.DEFAULT_BUTTON_SIZE)
	end
end

function SearchPrompt:_onSearchPromptSubmitted(_, value)
	self:onSubmit(value, nil)
	self.submitButton:focus()
end

function SearchPrompt:_onSubmitted(button, index)
	if index ~= 1 then
		return
	end

	self:onSubmit(self.searchInput:getText(), nil)
end

function SearchPrompt:_selectSuggestion(suggestion)
	self:onSubmit(suggestion:getValue(), suggestion)
end

function SearchPrompt:_wrapSuggestionsGrid(_, widget, directionX, directionY)
	if directionY == -1 then
		self.searchInput:focus()
	else
		if widget then
			widget:focus()
		end
	end
end

function SearchPrompt:_wrapSearchPrompt(_, directionX, directionY)
	if self.searchInput:getIsFocused() or self.submitButton:getIsFocused() then
		if self.suggestionsGrid:getInnerPanel():getNumChildren() >= 1 then
			self.suggestionsGrid:focus()
		end
	end
end

function SearchPrompt:setSuggestionsGenerator(func)
	self.suggestionsGenerator = func
end

function SearchPrompt:getSuggestionsGenerator()
	return self.suggestionsGenerator
end

function SearchPrompt:getSuggestions(value)
	if self.suggestionsGenerator then
		return self.suggestionsGenerator(value or self.searchInput:getText())
	end

	return {}
end

function SearchPrompt:performLayout()
	local selfWidth, selfHeight = self:getSize()
	if self:getParent() then
		local parentWidth, parentHeight = self:getParent():getSize()
		self:setPosition((parentWidth - selfWidth) / 2, (parentHeight - selfHeight) / 2)
	end

	self.titlePanel:setSize(selfWidth, Theme.MINI_TITLE_HEIGHT)
	self.contentPanel:setSize(selfWidth, selfHeight - Theme.MINI_TITLE_HEIGHT)

	local _, contentHeight = self.contentPanel:getSize()

	self.searchInput:setSize(
		Theme.calculateRemainingSizeWithPadding(Theme.DEFAULT_INNER_PADDING, selfWidth, self.SUBMIT_BUTTON_WIDTH),
		Theme.DEFAULT_BUTTON_SIZE)
	self.searchInput:setPosition(Theme.DEFAULT_INNER_PADDING, Theme.DEFAULT_INNER_PADDING)

	local searchInputWidth = self.searchInput:getSize()

	self.submitButton:setPosition(Theme.calculateSizeWithPadding(Theme.DEFAULT_INNER_PADDING, searchInputWidth), Theme.DEFAULT_INNER_PADDING)
	self.submitButton:setSize(self.SUBMIT_BUTTON_WIDTH, Theme.DEFAULT_BUTTON_SIZE)

	self.suggestionsGrid:setPosition(
		Theme.DEFAULT_INNER_PADDING,
		Theme.DEFAULT_INNER_PADDING + Theme.calculateSizeWithPadding(Theme.DEFAULT_INNER_PADDING, Theme.DEFAULT_BUTTON_SIZE))
	self.suggestionsGrid:setSize(
		Theme.calculateRemainingSizeWithPadding(Theme.DEFAULT_INNER_PADDING, selfWidth),
		Theme.calculateRemainingSizeWithPadding(Theme.DEFAULT_INNER_PADDING, contentHeight, Theme.DEFAULT_BUTTON_SIZE))

	self.noSuggestionsWidget:setPosition(self.suggestionsGrid:getPosition())
	self.noSuggestionsWidget:setSize(self.suggestionsGrid:getSize())
end

return SearchPrompt
