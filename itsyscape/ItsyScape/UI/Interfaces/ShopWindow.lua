--------------------------------------------------------------------------------
-- ItsyScape/UI/Interfaces/PlayerStats.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Utility = require "ItsyScape.Game.Utility"
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
local ConstraintsPanel = require "ItsyScape.UI.Interfaces.Common.ConstraintsPanel"

local ShopWindow = Class(Interface)
ShopWindow.WIDTH = 480
ShopWindow.HEIGHT = 320
ShopWindow.BUTTON_SIZE = 48
ShopWindow.BUTTON_PADDING = 4
ShopWindow.PADDING = 4

function ShopWindow:new(id, index, ui)
	Interface.new(self, id, index, ui)

	local w, h = love.window.getMode()
	self:setSize(ShopWindow.WIDTH, ShopWindow.HEIGHT)
	self:setPosition(
		(w - ShopWindow.WIDTH) / 2,
		(h - ShopWindow.HEIGHT) / 2)

	local panel = Panel()
	panel:setSize(self:getSize())
	self:addChild(panel)

	self.grid = ScrollablePanel(GridLayout)
	self.grid:getInnerPanel():setUniformSize(
		true,
		ShopWindow.BUTTON_SIZE + ShopWindow.BUTTON_PADDING * 2,
		ShopWindow.BUTTON_SIZE + ShopWindow.BUTTON_PADDING * 2)
	self.grid:getInnerPanel():setPadding(ShopWindow.BUTTON_PADDING)
	self.grid:setSize(ShopWindow.WIDTH * (1 / 2), ShopWindow.HEIGHT)
	self:addChild(self.grid)

	self.costPanel = ConstraintsPanel(self:getView())
	self.costPanel:setText("Cost")
	self.costPanel:setSize(ShopWindow.WIDTH * (1 / 2), ShopWindow.HEIGHT / 3)
	self.costPanel:setPosition(ShopWindow.WIDTH * (1 / 2), 0)
	self:addChild(self.costPanel)

	self.productPanel = ConstraintsPanel(self:getView())
	self.productPanel:setText("Product")
	self.productPanel:setSize(ShopWindow.WIDTH * (1 / 2), ShopWindow.HEIGHT / 3)
	self.productPanel:setPosition(ShopWindow.WIDTH * (1 / 2), ShopWindow.HEIGHT / 3)
	self:addChild(self.productPanel)

	self.actionPanel = GridLayout()
	self.actionPanel:setPadding(ShopWindow.PADDING)
	self.actionPanel:setSize(ShopWindow.WIDTH * (1 / 2), ShopWindow.PADDING * 2 + ShopWindow.BUTTON_SIZE * 3)
	self.actionPanel:setPosition(ShopWindow.WIDTH * (1 / 2), ShopWindow.HEIGHT - ShopWindow.BUTTON_SIZE * 2 - ShopWindow.PADDING * 5)

	self.quantityInput = TextInput()
	self.quantityInput:setText("1")
	self.quantityInput:setSize(ShopWindow.WIDTH / 2 * (2 / 3), ShopWindow.BUTTON_SIZE)
	self.quantityInput.onFocus:register(function(input)
		self.quantityInput:setCursor(0, #self.quantityInput:getText() + 1)
	end)
	self.actionPanel:addChild(self.quantityInput)

	do
		local QUANTITIES = {
			false, 1, 10, 100
		}

		for i = 1, #QUANTITIES do
			local quantity = QUANTITIES[i]
			local buyButton = Button()
			buyButton:setText(tostring(quantity or "Buy"))
			buyButton.onClick:register(self.buy, self, quantity)
			buyButton:setSize(ShopWindow.WIDTH / 2 / 4, ShopWindow.BUTTON_SIZE)
			self.actionPanel:addChild(buyButton)
		end
	end

	self.closeButton = Button()
	self.closeButton:setSize(ShopWindow.BUTTON_SIZE, ShopWindow.BUTTON_SIZE)
	self.closeButton:setPosition(ShopWindow.WIDTH - ShopWindow.BUTTON_SIZE, 0)
	self.closeButton:setText("X")
	self.closeButton.onClick:register(function()
		self:sendPoke("close", nil, {})
	end)
	self:addChild(self.closeButton)

	self.ready = false
	self.activeItem = false
	self.previousSelection = false
end

function ShopWindow:update(...)
	Interface.update(self, ...)

	if not self.ready then
		local state = self:getState()
		local gameDB = self:getView():getGame():getGameDB()
		local brochure = gameDB:getBrochure()
		for i = 1, #state.inventory do
			local action = gameDB:getAction(state.inventory[i].id)
			if action then
				local item, quantity
				for output in brochure:getOutputs(action) do
					local outputResource = brochure:getConstraintResource(output)
					local outputType = brochure:getResourceTypeFromResource(outputResource)
					if outputType.name == "Item" then
						item = outputResource
						quantity = output.count
						break
					end
				end

				if item then
					local button = Button()
					button.onClick:register(self.selectItem, self, state.inventory[i])

					local itemIcon = ItemIcon()
					itemIcon:setItemID(item.name)
					if quantity > 1 then
						itemIcon:setItemCount(quantity)
					end
					itemIcon:setPosition(2, 2)

					button:addChild(itemIcon)

					self.grid:addChild(button)
				end
			end
		end

		self.ready = true
	end
end

function ShopWindow:selectItem(action, button)
	if self.previousSelection then
		self.previousSelection:setStyle(nil)
	end

	if self.previousSelection ~= button then
		button:setStyle(ButtonStyle({
			pressed = "Resources/Renderers/Widget/Button/ActiveDefault-Pressed.9.png",
			inactive = "Resources/Renderers/Widget/Button/ActiveDefault-Inactive.9.png",
			hover = "Resources/Renderers/Widget/Button/ActiveDefault-Hover.9.png"
		}, self:getView():getResources()))

		self.activeItem = action
		self.previousSelection = button

		self.quantityInput:setText(tostring(action.count))

		self:sendPoke("select", nil, { id = action.id })
		self:addChild(self.actionPanel)
	else
		self.activeItem = false
		self.previousSelection = false
		self:removeChild(self.actionPanel)
		self:populateRequirements({
			inputs = {},
			outputs = {}
		})
	end
end

function ShopWindow:populateRequirements(e)
	self.costPanel:setConstraints(e.inputs)
	self.productPanel:setConstraints(e.outputs)
end

function ShopWindow:buy(quantity)
	if not quantity then
		local s, r = pcall(tonumber, self.quantityInput:getText())
		if s then
			quantity = r
		end

		if quantity then
			self:sendPoke("buy", nil, { id = self.activeItem.id, count = quantity })
		end
	else
		self.quantityInput:setText(tostring(quantity))
	end
end

return ShopWindow
