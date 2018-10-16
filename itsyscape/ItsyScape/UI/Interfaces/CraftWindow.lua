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
local Widget = require "ItsyScape.UI.Widget"

local CraftWindow = Class(Interface)
CraftWindow.WIDTH = 480
CraftWindow.HEIGHT = 320
CraftWindow.BUTTON_SIZE = 48
CraftWindow.BUTTON_PADDING = 4
CraftWindow.PADDING = 4

function CraftWindow:new(id, index, ui)
	Interface.new(self, id, index, ui)

	local w, h = love.window.getMode()
	self:setSize(CraftWindow.WIDTH, CraftWindow.HEIGHT)
	self:setPosition(
		(w - CraftWindow.WIDTH) / 2,
		(h - CraftWindow.HEIGHT) / 2)

	local panel = Panel()
	panel:setSize(self:getSize())
	self:addChild(panel)

	self.grid = ScrollablePanel(GridLayout)
	self.grid:getInnerPanel():setUniformSize(
		true,
		CraftWindow.BUTTON_SIZE + CraftWindow.BUTTON_PADDING * 2,
		CraftWindow.BUTTON_SIZE + CraftWindow.BUTTON_PADDING * 2)
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
	quantityLabel:setSize(96)
	self.controlLayout:addChild(quantityLabel)

	self.quantityInput = TextInput()
	self.quantityInput:setText("0")
	self.quantityInput:setSize(192, CraftWindow.BUTTON_SIZE - CraftWindow.BUTTON_PADDING * 2)
	self.controlLayout:addChild(self.quantityInput)
	self.quantityInput.onFocus:register(function()
		self.quantityInput:setCursor(0, #self.quantityInput:getText() + 1)
	end)

	self.craftButton = Button()
	self.craftButton.onClick:register(self.craft, self)
	self.craftButton:setSize(160, CraftWindow.BUTTON_SIZE - CraftWindow.BUTTON_PADDING * 2)
	self.craftButton:setText("Make it!")
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
		for i = 1, #state.actions do
			local action = gameDB:getAction(state.actions[i].id)
			if action then
				local item
				for output in brochure:getOutputs(action) do
					local outputResource = brochure:getConstraintResource(output)
					local outputType = brochure:getResourceTypeFromResource(outputResource)
					if outputType.name == "Item" then
						item = outputResource
						break
					end
				end

				if item then
					local button = Button()
					button.onClick:register(self.selectAction, self, state.actions[i])

					local itemIcon = ItemIcon()
					itemIcon:setItemID(item.name)
					itemIcon:setPosition(2, 2)
					button:addChild(itemIcon)

					self.grid:addChild(button)
				end
			end
		end

		self.ready = true
	end
end

function CraftWindow:selectAction(action, button)
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

		self.quantityInput:setText(tostring(action.count))

		self:sendPoke("select", nil, { id = action.id })
	else
		self.activeAction = false
		self.previousSelection = false
	end
end

function CraftWindow:populateRequirements(e)
	local width = self.requirementsPanel:getSize()
	local height = 0

	local function emitSection(t, title, options)
		options = options or {}

		local panel = Panel()
		panel:setStyle(PanelStyle({ image = false }))
		local titleLabel = Label()
		titleLabel:setPosition(CraftWindow.PADDING, CraftWindow.PADDING)
		titleLabel:setStyle(LabelStyle({
			fontSize = 16,
			font = "Resources/Renderers/Widget/Common/DefaultSansSerif/Bold.ttf",
			textShadow = true
		}, self:getView():getResources()))
		titleLabel:setText(title)
		panel:addChild(titleLabel)

		local layout = GridLayout()
		layout:setPadding(CraftWindow.PADDING)
		layout:setSize(width, 0)
		layout:setWrapContents(true)
		layout:setPosition(CraftWindow.PADDING, 16 + CraftWindow.PADDING)
		layout:setPadding(CraftWindow.PADDING, CraftWindow.PADDING)
		panel:addChild(layout)

		local leftWidth = 32
		local rightWidth = width - leftWidth - CraftWindow.PADDING * 3
		local rowHeight = 32
		for i = 1, #t do
			local left
			if t[i].type:lower() == 'skill' then
				-- this is terrible
				-- TODO: Add Icon widget or something
				left = Icon()
				left:setSize(leftWidth, rowHeight)
				left:setIcon(string.format("Resources/Game/UI/Icons/Skills/%s.png", t[i].resource))
			elseif t[i].type:lower() == 'item' then
				left = ItemIcon()
				left:setSize(leftWidth, rowHeight)
				left:setItemID(t[i].resource)
			else
				left = Widget()
				left:setSize(leftWidth, rowHeight)
			end
			layout:addChild(left)

			local right = Label()
			right:setStyle(LabelStyle({
				fontSize = 16,
				font = "Resources/Renderers/Widget/Common/DefaultSansSerif/Regular.ttf",
				width = math.huge
			}, self:getView():getResources()))
			if t[i].type:lower() == 'skill' then
				if options.skillAsLevel then
					local level = Curve.XP_CURVE:getLevel(t[i].count)
					local text = string.format("Lvl %d %s", level, t[i].name)
					right:setText(text)
				else
					local text = string.format("+%d %s XP", math.floor(t[i].count), t[i].name)
					right:setText(text)
				end
			elseif t[i].type:lower() == 'item' then
				local text
				if t[i].count <= 1 then
					text = t[i].name
				else
					text = string.format("%dx %s", t[i].count, t[i].name)
				end
				right:setText(text)
			else
				local text
				if t[i].count <= 1 then
					text = t[i].name
				else
					text = string.format("%d %s", t[i].count, t[i].name)
				end
				right:setText(text)
			end
			right:setSize(rightWidth, rowHeight)
			layout:addChild(right)
		end

		local innerWidth, innerHeight = layout:getSize()
		panel:setSize(innerWidth, innerHeight + 16 + CraftWindow.PADDING)

		self.requirementsPanel:addChild(panel)
	end

	local c = {}
	for _, child in self.requirementsPanel:getInnerPanel():iterate() do
		c[child] = true
	end

	for child in pairs(c) do
		self.requirementsPanel:removeChild(child)
	end

	emitSection(e.requirements, "Requirements", { skillAsLevel = true })
	emitSection(e.inputs, "Inputs")
	emitSection(e.outputs, "Outputs")

	local _, innerPanelHeight = self.requirementsPanel:getInnerPanel():getSize()
	self.requirementsPanel:setScrollSize(width, innerPanelHeight)
	self.requirementsPanel:performLayout()
end

function CraftWindow:craft()
	if self.activeAction then
		local count = tonumber(self.quantityInput:getText()) or 1
		self:sendPoke("craft", nil, { id = self.activeAction.id, count = count })
	end
end

return CraftWindow
