--------------------------------------------------------------------------------
-- ItsyScape/UI/Interfaces/Components/PropertiesPrompt.lua
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
local GamepadNumberInput = require "ItsyScape.UI.GamepadNumberInput"
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

local PropertiesPrompt = Class(Widget)

PropertiesPrompt.DEFAULT_WIDTH  = 640

PropertiesPrompt.Property = Class()

function PropertiesPrompt.Property:new(id, field, propertyType, value, text)
	self.id = id
	self.field = field
	self.type = propertyType
	self.value = value
	self.text = text or tostring(value)
end

function PropertiesPrompt.Property:clone()
	return PropertiesPrompt.Property(self.id, self.field, self.type, self.value, self.text)
end

function PropertiesPrompt.Property:getID()
	return self.id
end

function PropertiesPrompt.Property:getField()
	return self.field
end

function PropertiesPrompt.Property:getType()
	return self.type
end

function PropertiesPrompt.Property:getValue()
	return self.value
end

function PropertiesPrompt.Property:setValue(value)
	self.value = value
end

function PropertiesPrompt.Property:setText(value)
	self.text = value
end

function PropertiesPrompt.Property:getText()
	return self.text
end

function PropertiesPrompt:setProperties(properties)
	table.clear(self.properties)

	for _, property in ipairs(properties) do
		table.insert(self.properties, property:clone())
	end
end

function PropertiesPrompt:getProperties()
	return self.properties
end

function PropertiesPrompt:new()
	Widget.new(self)

	self.properties = {}

	self.onSubmit = Callback()
	self.onCancel = Callback()

	self:setSize(self.DEFAULT_WIDTH, 0)

	self:setData(GamepadSink, GamepadSink())

	self.titlePanel, self.titleLabel = Theme.newMiniTitlePanelWithLabel(self, self.DEFAULT_WIDTH)
	self.contentPanel = Theme.newContentPanel(
		self,
		self.DEFAULT_WIDTH,
		0,
		self.titlePanel)

	self.propertiesGrid = ScrollablePanel(GamepadGridLayout)
	self.propertiesGrid:getInnerPanel():setPadding(Theme.DEFAULT_OUTER_PADDING, Theme.DEFAULT_OUTER_PADDING)
	self.propertiesGrid:getInnerPanel():setWrapFocus(true)
	self.contentPanel:addChild(self.propertiesGrid)

	self.submitButton = Button()
	self.submitButton:setStyle(Theme.DEFAULT_INACTIVE_BUTTON_STYLE)
	self.submitButton:setText("Go!")
	self.submitButton.onClick:register(self._onSubmitted, self)

	self.cancelButton = Button()
	self.cancelButton:setStyle(Theme.DEFAULT_INACTIVE_BUTTON_STYLE)
	self.cancelButton:setText("Cancel")
	self.cancelButton.onClick:register(self._onCancelled, self)

	self:performLayout()
end

function PropertiesPrompt:setText(value)
	return self.titleLabel:setText(value)
end

function PropertiesPrompt:getText()
	return self.titleLabel:getText()
end

function PropertiesPrompt:getIsFocusable()
	return true
end

function PropertiesPrompt:focus(...)
	Widget.focus(self, ...)

	self.propertiesGrid:getInnerPanel():focus()
	print("foh-cus")
end

function PropertiesPrompt:_onPropertyValueChanged(property, _, value)
	if property:getType() == "number" or property:getType() == "integer" then
		property:setValue(tonumber(value) or property:getValue())
	elseif property:getType() == "boolean" then
		if value == "true" then
			property:setValue(true)
		elseif value == "false" then
			property:setValue(false)
		end
	else
		property:setValue(value)
	end

	property:setText(value)
end

function PropertiesPrompt:_onPropertySubmitted(input)
	self.propertiesGrid:getInnerPanel():tryFocusNext(0, 1)

	-- Skip over submit/cancel button and wrap back first property.
	if self.cancelButton:getIsFocused() then
		self.submitButton:focus()
	end
end

function PropertiesPrompt:_wrapNextProperty(_, _, directionX, directionY)
	self.propertiesGrid:getInnerPanel():tryFocusNext(directionX, directionY)
end

function PropertiesPrompt:_getForm()
	local result = {}
	for _, property in ipairs(self.properties) do
		result[property:getField()] = property:getValue()
	end
	return result
end

function PropertiesPrompt:_onSubmitted(button, index)
	if index ~= 1 then
		return
	end

	self:onSubmit(self.properties, self:_getForm())
end

function PropertiesPrompt:_onCancelled(button, index)
	if index ~= 1 then
		return
	end

	self:onCancel(self.properties, self:_getForm())
end

function PropertiesPrompt:performLayout()
	local selfWidth = self:getSize()

	local maxHeight
	if self:getParent() then
		local parentWidth, parentHeight = self:getParent():getSize()
		maxHeight = parentHeight - Theme.MINI_TITLE_HEIGHT
	else
		local screenWidth, screenHeight = itsyrealm.graphics.getScaledMode()
		maxHeight = screenHeight - Theme.DEFAULT_OUTER_PADDING * 2 - Theme.MINI_TITLE_HEIGHT
	end

	local rowWidth = selfWidth - Theme.DEFAULT_OUTER_PADDING * 2

	self.propertiesGrid:clearChildren()
	self.propertiesGrid:setSize(selfWidth, Theme.calculateRemainingSizeWithPadding(0, maxHeight, Theme.MINI_TITLE_HEIGHT))
	self.propertiesGrid:getInnerPanel():setPadding(Theme.DEFAULT_OUTER_PADDING, Theme.DEFAULT_OUTER_PADDING)

	for _, property in ipairs(self.properties) do
		local row = GamepadGridLayout()
		row:setPadding(Theme.DEFAULT_OUTER_PADDING, Theme.DEFAULT_OUTER_PADDING)
		row:setUniformSize(true, Theme.calculateTileSizeWithPadding(Theme.DEFAULT_OUTER_PADDING, rowWidth, 2), Theme.DEFAULT_BUTTON_SIZE)

		local label = Label()
		label:setStyle(self.BUTTON_LABEL_STYLE, LabelStyle)
		label:setText(property:getField())
		row:addChild(label)

		local input
		if property:getType() == "integer" then
			input = GamepadNumberInput()
			input:setNumDigits(4)
		else
			input = TextInput()
		end

		input:setText(tostring(property:getValue()))
		input.onSubmit:register(self._onPropertySubmitted, self)
		input.onValueChanged:register(self._onPropertyValueChanged, self, property)

		input:setStyle(Theme.DEFAULT_TEXT_INPUT_STYLE, TextInputStyle)
		row:addChild(input)
		row:performLayout()

		self.propertiesGrid:addChild(row)
	end

	local buttonRow = GamepadGridLayout()
	buttonRow:setPadding(Theme.DEFAULT_OUTER_PADDING, Theme.DEFAULT_OUTER_PADDING)
	buttonRow:setUniformSize(true, Theme.calculateTileSizeWithPadding(Theme.DEFAULT_OUTER_PADDING, rowWidth, 2), Theme.DEFAULT_BUTTON_SIZE)
	buttonRow:addChild(self.cancelButton)
	buttonRow:addChild(self.submitButton)
	self.propertiesGrid:addChild(buttonRow)

	local hasScrollbars = Theme.layoutScrollablePanelWithGridLayout(self.propertiesGrid, rowWidth, Theme.DEFAULT_BUTTON_SIZE)
	if hasScrollbars then
		local newRowWidth = self.propertiesGrid:getInnerPanel():getSize() - ScrollablePanel.DEFAULT_SCROLL_SIZE
		local elementWidth = Theme.calculateTileSizeWithPadding(Theme.DEFAULT_OUTER_PADDING, newRowWidth, 2)

		for _, widget in self.propertiesGrid:getInnerPanel():iterate() do
			widget:setUniformSize(true, elementWidth, Theme.DEFAULT_BUTTON_SIZE)
			widget:performLayout()
		end
	end

	local gridWidth, gridHeight = self.propertiesGrid:getInnerPanel():getSize()

	local selfHeight = math.min(maxHeight, gridHeight + Theme.MINI_TITLE_HEIGHT + Theme.DEFAULT_OUTER_PADDING)
	self:setSize(selfWidth, selfHeight)

	if self:getParent() then
		local parentWidth, parentHeight = self:getParent():getSize()
		self:setPosition((parentWidth - selfWidth) / 2, (parentHeight - selfHeight) / 2)
	end

	self.contentPanel:setSize(selfWidth, Theme.calculateRemainingSizeWithPadding(0, selfHeight, Theme.MINI_TITLE_HEIGHT))
	self.propertiesGrid:setSize(self.contentPanel:getSize())
end

return PropertiesPrompt
