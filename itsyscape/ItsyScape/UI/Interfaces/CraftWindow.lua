--------------------------------------------------------------------------------
-- ItsyScape/UI/Interfaces/PlayerStats.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Callback = require "ItsyScape.Common.Callback"
local Class = require "ItsyScape.Common.Class"
local Curve = require "ItsyScape.Game.Curve"
local Equipment = require "ItsyScape.Game.Equipment"
local Utility = require "ItsyScape.Game.Utility"
local Mapp = require "ItsyScape.GameDB.Mapp"
local Button = require "ItsyScape.UI.Button"
local ButtonStyle = require "ItsyScape.UI.ButtonStyle"
local GridLayout = require "ItsyScape.UI.GridLayout"
local Label = require "ItsyScape.UI.Label"
local LabelStyle = require "ItsyScape.UI.LabelStyle"
local Interface = require "ItsyScape.UI.Interface"
local Icon = require "ItsyScape.UI.Icon"
local ItemIcon = require "ItsyScape.UI.ItemIcon"
local Panel = require "ItsyScape.UI.Panel"
local PanelStyle = require "ItsyScape.UI.PanelStyle"
local TextInput = require "ItsyScape.UI.TextInput"
local ScrollablePanel = require "ItsyScape.UI.ScrollablePanel"
local ItemIcon = require "ItsyScape.UI.ItemIcon"
local ToolTip = require "ItsyScape.UI.ToolTip"
local Widget = require "ItsyScape.UI.Widget"
local ConstraintsPanel = require "ItsyScape.UI.Interfaces.Common.ConstraintsPanel"

local CraftWindow = Class(Interface)
CraftWindow.WIDTH = 800
CraftWindow.HEIGHT = 640
CraftWindow.BUTTON_SIZE = 48
CraftWindow.BUTTON_PADDING = 4
CraftWindow.PADDING = 4

function CraftWindow:new(id, index, ui)
	Interface.new(self, id, index, ui)

	local w, h = love.graphics.getScaledMode()
	self:setSize(CraftWindow.WIDTH, CraftWindow.HEIGHT)
	self:setPosition(
		(w - CraftWindow.WIDTH) / 2,
		(h - CraftWindow.HEIGHT) / 2)

	local panel = Panel()
	panel:setSize(self:getSize())
	self:addChild(panel)

	self.grid = ScrollablePanel(GridLayout)
	self.grid:getInnerPanel():setWrapContents(true)
	self.grid:getInnerPanel():setPadding(CraftWindow.BUTTON_PADDING)
	self.grid:setSize(CraftWindow.WIDTH * (1 / 2), CraftWindow.HEIGHT - CraftWindow.BUTTON_SIZE)
	self:addChild(self.grid)

	self.requirementsPanel = ScrollablePanel(GridLayout)
	self.requirementsPanel:getInnerPanel():setPadding(0, 0)
	self.requirementsPanel:getInnerPanel():setWrapContents(true)
	self.requirementsPanel:setSize(CraftWindow.WIDTH * (1 / 2), CraftWindow.HEIGHT - CraftWindow.BUTTON_SIZE)
	self.requirementsPanel:setPosition(CraftWindow.WIDTH * (1 / 2), CraftWindow.PADDING)
	self:addChild(self.requirementsPanel)

	self.controlLayout = GridLayout()
	self.controlLayout:setSize(CraftWindow.WIDTH, CraftWindow.BUTTON_SIZE)
	self.controlLayout:setPadding(CraftWindow.BUTTON_PADDING)
	self.controlLayout:setPosition(0, CraftWindow.HEIGHT - CraftWindow.BUTTON_SIZE)
	self:addChild(self.controlLayout)

	local quantityLabel = Label()
	quantityLabel:setText("Quantity:")
	quantityLabel:setSize(128)
	quantityLabel:setStyle(LabelStyle({
		font = "Resources/Renderers/Widget/Common/Serif/Bold.ttf",
		fontSize = 22,
		textShadow = true,
		color = { 1, 1, 1, 1 }
	}, ui:getResources()))
	self.controlLayout:addChild(quantityLabel)

	self.quantityInput = TextInput()
	self.quantityInput:setText("0")
	self.quantityInput:setID("Craft-QuantityInput")
	self.quantityInput:setSize(160, CraftWindow.BUTTON_SIZE - CraftWindow.BUTTON_PADDING * 2)
	self.controlLayout:addChild(self.quantityInput)
	self.quantityInput.onFocus:register(function()
		self.quantityInput:setCursor(0, #self.quantityInput:getText() + 1)
	end)

	self.craftButton = Button()
	self.craftButton.onClick:register(self.craft, self)
	self.craftButton:setSize(160, CraftWindow.BUTTON_SIZE - CraftWindow.BUTTON_PADDING * 2)
	self.craftButton:setText("Make it!")
	self.craftButton:setID("Craft-MakeIt!")
	self.controlLayout:addChild(self.craftButton)

	self.closeButton = Button()
	self.closeButton:setSize(CraftWindow.BUTTON_SIZE, CraftWindow.BUTTON_SIZE)
	self.closeButton:setPosition(CraftWindow.WIDTH - CraftWindow.BUTTON_SIZE, 0)
	self.closeButton:setText("X")
	self.closeButton.onClick:register(function()
		self:sendPoke("close", nil, {})
	end)
	self:addChild(self.closeButton)

	self.ready = false
	self.previousSelection = false
	self.activeAction = false
end

function CraftWindow:update(...)
	Interface.update(self, ...)

	if not self.ready then
		local state = self:getState()
		local gameDB = self:getView():getGame():getGameDB()
		local brochure = gameDB:getBrochure()

		local gridWidth = self.grid:getSize()
		for i = 1, #state.groups do
			local group = state.groups[i]
			local grid = GridLayout()

			grid:setWrapContents(true)
			grid:setSize(gridWidth, 0)
			grid:setPadding(CraftWindow.PADDING, CraftWindow.PADDING)

			local label = Label()
			label:setText(group.literal)
			label:setStyle(LabelStyle({
				font = "Resources/Renderers/Widget/Common/Serif/Bold.ttf",
				fontSize = 24,
				textShadow = true,
				color = { 1, 1, 1, 1 }
			}, self:getView():getResources()))
			label:setSize(gridWidth, 32)
			grid:addChild(label)

			for j = 1, #group do
				local action = gameDB:getAction(group[j].id)
				if action then
					local item, count
					for output in brochure:getOutputs(action) do
						local outputResource = brochure:getConstraintResource(output)
						local outputType = brochure:getResourceTypeFromResource(outputResource)
						if outputType.name == "Item" then
							item = outputResource
							count = output.count
							break
						end
					end

					if item then
						local name, description = Utility.Item.getInfo(
							item.name,
							self:getView():getGame():getGameDB())

						local button = Button()
						button.onClick:register(self.selectAction, self, group[j], group[j].canPerform)
						button:setSize(
							CraftWindow.BUTTON_SIZE + CraftWindow.BUTTON_PADDING * 2,
							CraftWindow.BUTTON_SIZE + CraftWindow.BUTTON_PADDING * 2)

						local itemIcon = ItemIcon()
						itemIcon:setItemID(item.name)
						itemIcon:setItemCount(count)
						itemIcon:setIsDisabled(not group[j].canPerform)
						itemIcon:setPosition(2, 2)
						button:addChild(itemIcon)

						button:setID("Craft-" .. item.name)

						itemIcon:setToolTip(
							ToolTip.Header(name),
							ToolTip.Text(description))

						grid:addChild(button)
					end
				end
			end

			self.grid:addChild(grid)
		end
		self.grid:setScrollSize(self.grid:getInnerPanel():getSize())

		self.ready = true
	end
end

function CraftWindow:selectAction(action, canPerform, button)
	if self.previousSelection then
		self.previousSelection:setStyle(nil)
	end

	if self.previousSelection ~= button then
		button:setStyle(ButtonStyle({
			pressed = "Resources/Renderers/Widget/Button/ActiveDefault-Pressed.9.png",
			inactive = "Resources/Renderers/Widget/Button/ActiveDefault-Inactive.9.png",
			hover = "Resources/Renderers/Widget/Button/ActiveDefault-Hover.9.png"
		}, self:getView():getResources()))

		self.activeAction = action
		self.previousSelection = button
		self.canPerform = canPerform

		self.quantityInput:setText(tostring(action.count))

		self:sendPoke("select", nil, { id = action.id })
	else
		self.activeAction = false
		self.canPerform = false
		self.previousSelection = false
	end
end

function CraftWindow:populateRequirements(e)
	local width = self.requirementsPanel:getSize()
	local height = 0

	local function emitSection(t, title, options)
		options = options or {}

		local panel = ConstraintsPanel(self:getView())
		panel:setText(title)
		if options.skillAsLevel then
			panel:setData("skillAsLevel", true)
		end
		panel:setSize(width - ScrollablePanel.DEFAULT_SCROLL_SIZE)
		panel:setConstraints(t)

		self.requirementsPanel:addChild(panel)
	end

	self.requirementsPanel:getInnerPanel():clearChildren()

	emitSection(e.requirements, "Requirements", { skillAsLevel = true })
	emitSection(e.inputs, "Inputs")
	emitSection(e.outputs, "Outputs")

	local _, innerPanelHeight = self.requirementsPanel:getInnerPanel():getSize()
	self.requirementsPanel:setScrollSize(width, innerPanelHeight)
	self.requirementsPanel:getInnerPanel():setScroll(0, 0)
	self.requirementsPanel:performLayout()
end

function CraftWindow:craft()
	if self.activeAction and self.canPerform then
		local count = tonumber(self.quantityInput:getText()) or 1
		self:sendPoke("craft", nil, { id = self.activeAction.id, count = count })
	end
end

return CraftWindow
