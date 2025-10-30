--------------------------------------------------------------------------------
-- ItsyScape/UI/Interfaces/Components/MakeContentTab.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Callback = require "ItsyScape.Common.Callback"
local Class = require "ItsyScape.Common.Class"
local Function = require "ItsyScape.Common.Function"
local Config = require "ItsyScape.Game.Config"
local Utility = require "ItsyScape.Game.Utility"
local Color = require "ItsyScape.Graphics.Color"
local Button = require "ItsyScape.UI.Button"
local ButtonStyle = require "ItsyScape.UI.ButtonStyle"
local ItemIcon = require "ItsyScape.UI.ItemIcon"
local GridLayout = require "ItsyScape.UI.GridLayout"
local GamepadGridLayout = require "ItsyScape.UI.GamepadGridLayout"
local GamepadNumberInput = require "ItsyScape.UI.GamepadNumberInput"
local Label = require "ItsyScape.UI.Label"
local LabelStyle = require "ItsyScape.UI.LabelStyle"
local Panel = require "ItsyScape.UI.Panel"
local PanelStyle = require "ItsyScape.UI.PanelStyle"
local ScrollablePanel = require "ItsyScape.UI.ScrollablePanel"
local TextInputStyle = require "ItsyScape.UI.TextInputStyle"
local ToolTip = require "ItsyScape.UI.ToolTip"
local Widget = require "ItsyScape.UI.Widget"
local ConstraintsPanel = require "ItsyScape.UI.Interfaces.Common.ConstraintsPanel"
local EquipmentStatsPanel = require "ItsyScape.UI.Interfaces.Common.EquipmentStatsPanel"
local GamepadContentTab = require "ItsyScape.UI.Interfaces.Components.GamepadContentTab"
local StatBar = require "ItsyScape.UI.Interfaces.Components.StatBar"

local MakeContentTab = Class(GamepadContentTab)
MakeContentTab.PADDING = 8
MakeContentTab.BUTTON_PADDING = 4
MakeContentTab.MAKE_ROW_HEIGHT = 64
MakeContentTab.MAKE_INPUT_HEIGHT = 48

MakeContentTab.ITEM_PANEL_STYLE = {
	image = "Resources/Game/UI/Buttons/ItemButton-Default.png"
}

MakeContentTab.ITEM_NAME_LABEL_STYLE = {
	font = "Resources/Renderers/Widget/Common/Serif/SemiBold.ttf",
	fontSize = 16,
	color = { 1, 1, 1, 1 },
	lineHeight = 0.8,
	textShadow = true
}

MakeContentTab.ITEM_DESCRIPTION_LABEL_STYLE = {
	font = "Resources/Renderers/Widget/Common/DefaultSansSerif/Regular.ttf",
	fontSize = 16,
	color = { 1, 1, 1, 1 },
	textShadow = true
}

MakeContentTab.GROUP_PANEL_STYLE = {
	image = "Resources/Game/UI/Panels/WindowGroup.png"
}

MakeContentTab.INPUT_STYLE = {
	inactive = "Resources/Game/UI/TextInputs/Default-Inactive.png",
	active = "Resources/Game/UI/TextInputs/Default-Active.png",
	hover = "Resources/Game/UI/TextInputs/Default-Hover.png",
	font = "Resources/Renderers/Widget/Common/DefaultSansSerif/Regular.ttf",
	fontSize = 32,
	color = { 0.2, 0.2, 0.2, 0.2 },
	align = "center",
	textShadow = true
}

function MakeContentTab:new(interface)
	GamepadContentTab.new(self, interface)

	self.onMake = Callback()

	self.layout = GridLayout()
	self.layout:setSize(self:getSize())
	self.layout:setPadding(self.PADDING, self.PADDING)
	self:addChild(self.layout)

	self.makeLayout = GamepadGridLayout()
	self.makeLayout:setPadding(self.PADDING, (self.MAKE_ROW_HEIGHT - self.MAKE_INPUT_HEIGHT) / 2)
	self.makeLayout:setEdgePadding(false, true)
	self.makeLayout:setSize(self.WIDTH - self.PADDING * 2, self.MAKE_ROW_HEIGHT)
	self.layout:addChild(self.makeLayout)

	self.makeInput = GamepadNumberInput()
	self.makeInput:setStyle(self.INPUT_STYLE, TextInputStyle)
	self.makeInput:setNumDigits(2)
	self.makeInput:setValue(1)
	self.makeInput:setSize(
		self.WIDTH - self.MAKE_INPUT_HEIGHT * 2 - self.PADDING * 3,
		self.MAKE_INPUT_HEIGHT)
	self.makeInput:setZDepth(100)
	self.makeInput.onSubmit:register(self.make, self)
	self.makeInput.onValueChanged:register(self.updateConstraints, self)
	self.makeInput.onGamepadRelease:register(self.onMakeInputGamepadRelease, self)
	self.makeLayout:addChild(self.makeInput)

	self.makeButton = Button()
	self.makeButton:setSize(self.MAKE_INPUT_HEIGHT * 2, self.MAKE_INPUT_HEIGHT)
	self.makeButton.onClick:register(self.onMakeButtonClick, self)
	self.makeButton:setText("Make")
	self.makeLayout:addChild(self.makeButton)

	local constraintsGroup = Panel()
	constraintsGroup:setStyle(self.GROUP_PANEL_STYLE, PanelStyle)
	constraintsGroup:setSize(self.WIDTH - self.PADDING * 2, self.HEIGHT - self.MAKE_ROW_HEIGHT - self.PADDING * 3)
	self.layout:addChild(constraintsGroup)

	local constraintsGroupWidth, constraintsGroupHeight = constraintsGroup:getSize()

	self.constraintsPanel = ScrollablePanel(GridLayout)
	self.constraintsPanel:getInnerPanel():setWrapContents(true)
	self.constraintsPanel:getInnerPanel():setPadding(0, 0)
	self.constraintsPanel:setSize(
		constraintsGroupWidth - self.PADDING * 2,
		constraintsGroupHeight - self.PADDING * 2)
	self.constraintsPanel:setPosition(self.PADDING, self.PADDING)
	constraintsGroup:addChild(self.constraintsPanel)

	local constraintsPanelWidth = self.WIDTH - self.PADDING * 2 - ScrollablePanel.DEFAULT_SCROLL_SIZE
	local constraintsConfig = {
		headerFontSize = 16,
		constraintFontSize = 16,
		padding = 0
	}

	self.inputsPanel = ConstraintsPanel(self:getUIView(), constraintsConfig)
	self.inputsPanel:setText("Takes")
	self.inputsPanel:setSize(constraintsPanelWidth)
	self.constraintsPanel:addChild(self.inputsPanel)

	self.outputsPanel = ConstraintsPanel(self:getUIView(), constraintsConfig)
	self.outputsPanel:setText("Gives")
	self.outputsPanel:setSize(constraintsPanelWidth)
	self.constraintsPanel:addChild(self.outputsPanel)

	self.layout:setID("MakeItem")
end

function MakeContentTab:getIsFocusable()
	return true
end

function MakeContentTab:focus(reason)
	GamepadContentTab.focus(self, reason)

	local inputProvider = self:getInputProvider()
	if inputProvider then
		inputProvider:setFocusedWidget(self.makeInput, reason)
		self.constraintsPanel:getInnerPanel():setScroll(0, 0)
	end
end

function MakeContentTab:_multiplyConstraints(constraints, multiplier)
	local result = {}
	for _, constraint in ipairs(constraints) do
		table.insert(result, {
			type = constraint.type,
			resource = constraint.resource,
			name = constraint.name,
			description = constraint.description,
			count = constraint.count * multiplier
		})
	end
	return result
end

function MakeContentTab:updateConstraints()
	local value = math.max(self.makeInput:getValue(), 1)

	local state = self:getState()
	self.inputsPanel:setConstraints(self:_multiplyConstraints(state.constraints.inputs, value))
	self.outputsPanel:setConstraints(self:_multiplyConstraints(state.constraints.outputs, value))
	self.constraintsPanel:performLayout()
end

function MakeContentTab:onMakeInputGamepadRelease(_, joystick, button)
	local inputProvider = self:getInputProvider()
	if inputProvider then
		if inputProvider:isCurrentJoystick(joystick) and button == inputProvider:getKeybind("gamepadPrimaryAction") then
			inputProvider:setFocusedWidget(self.makeButton, "select")
		end
	end
end

function MakeContentTab:make(count)
	local state = self:getState()
	count = count or self.makeInput:getValue()

	self:getInterface():sendPoke("craft", nil, { count = count, id = state.id })
end

function MakeContentTab:onMakeInputSubmit()
	self:make()
end

function MakeContentTab:onMakeButtonClick(button, buttonIndex)
	if buttonIndex == 1 then
		self:make()
	elseif buttonIndex == 2 then
		local state = self:getState()
		local actions = {
			{
				id = -1,
				verb = "Make-1",
				type = "make",
				object = state.item.name,
				objectID = state.item.id,
				objectType = "item",
				callback = Function(self.make, self, 1)
			},
			{
				id = -2,
				verb = "Make-All",
				type = "make",
				object = state.item.name,
				objectID = state.item.id,
				objectType = "item",
				callback = Function(self.make, self, state.actionCount)
			},
			{
				id = -3,
				verb = "Make-X",
				type = "make",
				object = state.item.name,
				objectID = state.item.id,
				objectType = "item",
				callback = Function(self.make, self)
			}
		}

		local buttonX, buttonY = button:getAbsolutePosition()
		local buttonWidth, buttonHeight = button:getSize()
		buttonX = buttonX + buttonWidth / 2
		buttonY = buttonY + buttonHeight / 2

		self:getUIView():probe(actions, buttonX, buttonY, true, false)
	end
end

function MakeContentTab:gamepadScroll(x, y)
	self.constraintsPanel:mouseScroll(x, y)
end

function MakeContentTab:refresh(state)
	GamepadContentTab.refresh(self, state)

	self:updateConstraints()
	self.makeInput:setValue(state.actionCount or 1)
end

return MakeContentTab
