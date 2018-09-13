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
local Equipment = require "ItsyScape.Game.Equipment"
local Utility = require "ItsyScape.Game.Utility"
local Mapp = require "ItsyScape.GameDB.Mapp"
local Button = require "ItsyScape.UI.Button"
local ButtonStyle = require "ItsyScape.UI.ButtonStyle"
local GridLayout = require "ItsyScape.UI.GridLayout"
local Label = require "ItsyScape.UI.Label"
local Interface = require "ItsyScape.UI.Interface"
local ItemIcon = require "ItsyScape.UI.ItemIcon"
local Panel = require "ItsyScape.UI.Panel"
local PanelStyle = require "ItsyScape.UI.PanelStyle"
local TextInput = require "ItsyScape.UI.TextInput"
local ScrollablePanel = require "ItsyScape.UI.ScrollablePanel"

local CraftWindow = Class(Interface)
CraftWindow.WIDTH = 480
CraftWindow.HEIGHT = 320
CraftWindow.BUTTON_SIZE = 48
CraftWindow.BUTTON_PADDING = 4

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
	self.grid:setSize(CraftWindow.WIDTH * (3 / 4), CraftWindow.HEIGHT - CraftWindow.BUTTON_SIZE)
	self:addChild(self.grid)

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
		self.quantityInput:setCursor(1, #self.quantityInput:getText())
	end)

	self.craftButton = Button()
	self.craftButton.onClick:register(self.craft, self)
	self.craftButton:setSize(160, CraftWindow.BUTTON_SIZE - CraftWindow.BUTTON_PADDING * 2)
	self.craftButton:setText("Make it!")
	self.controlLayout:addChild(self.craftButton)

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
	else
		self.activeAction = false
		self.previousSelection = false
	end
end

function CraftWindow:craft()
	if self.activeAction then
		local count = tonumber(self.quantityInput:getText()) or 1
		self:sendPoke("craft", nil, { id = self.activeAction.id, count = count })
	end
end

return CraftWindow
