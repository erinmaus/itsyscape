--------------------------------------------------------------------------------
-- ItsyScape/UI/Interfaces/InventoryGamepadContentTab.lua
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
local Vector = require "ItsyScape.Common.Math.Vector"
local Utility = require "ItsyScape.Game.Utility"
local Widget = require "ItsyScape.UI.Widget"
local ButtonStyle = require "ItsyScape.UI.ButtonStyle"
local DraggableButton = require "ItsyScape.UI.DraggableButton"
local ItemIcon = require "ItsyScape.UI.ItemIcon"
local GridLayout = require "ItsyScape.UI.GridLayout"
local Panel = require "ItsyScape.UI.Panel"
local PanelStyle = require "ItsyScape.UI.PanelStyle"
local ToolTip = require "ItsyScape.UI.ToolTip"
local GamepadContentTab = require "ItsyScape.UI.Interfaces.GamepadContentTab"
local Widget = require "ItsyScape.UI.Widget"

local InventoryGamepadContentTab = Class(GamepadContentTab)
InventoryGamepadContentTab.PADDING = 8
InventoryGamepadContentTab.ICON_SIZE = 48
InventoryGamepadContentTab.BUTTON_PADDING = 2

function InventoryGamepadContentTab:new(interface)
	GamepadContentTab.new(self, interface)

	self.layout = GridLayout()
	self.layout:setSize(self:getSize())
	self.layout:setPadding(self.PADDING, self.PADDING)
	self.layout:setUniformSize(
		true,
		self.ICON_SIZE + self.BUTTON_PADDING * 2,
		self.ICON_SIZE + self.BUTTON_PADDING * 2)
	self:addChild(self.layout)

	self.numItems = 0
end

function InventoryGamepadContentTab:updateNumItems(count)
	if value < #self.buttons then
		while self.layout:getNumChildren() > count do
			self.layout:removeChild(self.layout:getChildAt(count))
		end
	else
		for i = self.layout:getNumChildren() + 1, count do
			local button = DraggableButton()
			button:setSize(
				self.ICON_SIZE + self.BUTTON_PADDING * 2,
				self.ICON_SIZE + self.BUTTON_PADDING * 2)

			local icon = ItemIcon()
			icon:setSize(self.ICON_SIZE, self.ICON_SIZE)
			icon:setPosition(self.BUTTON_PADDING, self.BUTTON_PADDING)
			button:addChild(icon)

			button.onDrop:register(self.buttonSwap, self)
			button.onDrag:register(self.buttonDrag, self)
			button.onLeftClick:register(self.activate, self, i)
			button.onRightClick:register(self.probe, self, i)
			button.onMouseMove:register(self.prepareToolTip, self, i)

			button:setData("icon", icon)
			button:getData("index", i)
		end
	end
end

function InventoryGamepadContentTab:pokeInventoryItem(index, actionID)
	self:getInterface():sendPoke("pokeInventoryItem", nil, { index = index, id = actionID })
end

function InventoryGamepadContentTab:swapInventoryItem(a, b)
	self:getInterface():sendPoke("swapInventoryItems", nil, { a = a, b = b })

	local state = self:getState()
	if state.items then
		state.items[a], state.items[b] = state.items[b], state.items[a]
	end

	self:refresh(state)
end

function InventoryGamepadContentTab:dropInventoryItem(index)
	self:getInterface():sendPoke("dropInventoryItem", nil, { index = index })
end

function InventoryGamepadContentTab:probeInventoryItem(index)
	self:getInterface():sendPoke("probeInventoryItem", nil, { index = index })
end

function InventoryGamepadContentTab:beginSwap(index)
	local button = self.layout:getChildAt(index)
	if not button then
		return
	end

	local icon = button:getData("icon")
	icon:setIsActive(true)

	self.currentSwapIndex = index
end

function InventoryGamepadContentTab:endSwap(index)
	if not self.currentSwapIndex then
		return
	end

	local button = self.layout:getChildAt(self.currentSwapIndex)
	if not button then
		return
	end

	local icon = button:getData("icon")
	icon:setIsActive(false)

	if index ~= self.currentSwapIndex then
		self:swapInventoryItem(self.currentSwapIndex, index)
	end

	self.currentSwapIndex = false
end

function InventoryGamepadContentTab:buttonSwap(button, x, y)
	local index = button:getData("index")

	local newIndex
	for _, widget in self.layout:iterate() do
		local widgetX, widgetY = widget:getPosition()
		local widgetWidth, widgetHeight = widget:getSize()

		if x >= widgetX and y >= widgetY and x <= widgetX + widgetWidth and y <= widgetY + widgetHeight then
			local newIndex = widget
			break
		end
	end

	if index and newIndex and index ~= newIndex then
		self:swapInventoryItem(index, newIndex)
	end

	local renderManager = self:getUIView():getRenderManager()
	if renderManager:getCursor() == button:getData("icon") then
		renderManager:setCursor(button:getData("icon"))
	end
end

function InventoryGamepadContentTab:buttonDrag(button)
	local renderManager = self:getUIView():getRenderManager()
	if renderManager:getCursor() ~= button:getData("icon") then
		renderManager:setCursor(button:getData("icon"))
	end
end

function InventoryGamepadContentTab:refresh(state)
	GamepadContentTab.refresh(self, state)

	if state.count ~= self.numItems then
		self:updateNumItems(self.numItems)
	end

	for i = 1, state.count do
		local icon = self:getChildAt(i)

		local item = state.items[i]
		if not item then
			icon:setItemID(false)
			icon:setItemCount(0)
			icon:setItemIsNoted(false)
		else
			icon:setItemID(item.id)
			icon:setItemCount(item.count)
			icon:setItemIsNoted(not not item.noted)
		end
	end
end

function InventoryGamepadContentTab:probe(index, button)
	local state = self:getState()
	if not state.items then
		return
	end

	local item = state.items[index]
	local item = items[index]
	if not item then
		return
	end

	local object = item.name

	local actions = {}
	for _, action in ipairs(item.actions) do
		table.insert(actions, {
			id = action.type,
			verb = action.verb,
			object = object,
			objectType = "item",
			callback = Function(self.pokeInventoryItem, self, index, action.id)
		})
	end

	table.insert(actions, {
		id = "Examine",
		verb = "Examine",
		object = object,
		objectType = "item",
		callback = Function(self.examine, self, item)
	})

	table.insert(actions, {
		id = "Drop",
		verb = "Drop",
		object = object,
		objectType = "item",
		callback = Function(self.drop, self, index)
	})

	local pokeMenu = self:getUIView():probe(actions)
	pokeMenu.onClose:register(Function(self.probeInventoryItem, self, false))

	self:probeInventoryItem(index)
end

function InventoryGamepadContentTab:examine(item)
	self:getUIView():examine(self:getItemExamine(item))
end

function InventoryGamepadContentTab:prepareToolTip(index, button)
	local icon = button:getData("icon")
	self:examineItem(icon, self:getState().items, index)
end

return InventoryGamepadContentTab
