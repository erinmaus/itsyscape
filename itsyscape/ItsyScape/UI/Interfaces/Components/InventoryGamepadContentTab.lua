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
local Color = require "ItsyScape.Graphics.Color"
local Widget = require "ItsyScape.UI.Widget"
local ButtonStyle = require "ItsyScape.UI.ButtonStyle"
local DraggableButton = require "ItsyScape.UI.DraggableButton"
local ItemIcon = require "ItsyScape.UI.ItemIcon"
local GamepadGridLayout = require "ItsyScape.UI.GamepadGridLayout"
local Panel = require "ItsyScape.UI.Panel"
local PanelStyle = require "ItsyScape.UI.PanelStyle"
local ToolTip = require "ItsyScape.UI.ToolTip"
local Widget = require "ItsyScape.UI.Widget"
local GamepadToolTip = require "ItsyScape.UI.GamepadToolTip"
local GamepadContentTab = require "ItsyScape.UI.Interfaces.Components.GamepadContentTab"

local InventoryGamepadContentTab = Class(GamepadContentTab)
InventoryGamepadContentTab.PADDING = 8
InventoryGamepadContentTab.ICON_SIZE = 48
InventoryGamepadContentTab.BUTTON_PADDING = 4
InventoryGamepadContentTab.SWAP_ICON_COLOR = Color(0.8, 0.8, 0.8, 0.5)

InventoryGamepadContentTab.ITEM_BUTTON_STYLE = {
	pressed = "Resources/Game/UI/Buttons/ItemButton-Pressed.png",
	hover = "Resources/Game/UI/Buttons/ItemButton-Hover.png",
	inactive = "Resources/Game/UI/Buttons/ItemButton-Default.png"
}

function InventoryGamepadContentTab:new(interface)
	GamepadContentTab.new(self, interface)

	self.layout = GamepadGridLayout()
	self.layout:setSize(self:getSize())
	self.layout:setPadding(self.PADDING, self.PADDING)
	self.layout:setUniformSize(
		true,
		self.ICON_SIZE + self.BUTTON_PADDING * 2,
		self.ICON_SIZE + self.BUTTON_PADDING * 2)
	self.layout.onBlurChild:register(self._onBlurLayoutChild, self)
	self.layout.onFocusChild:register(self._onFocusLayoutChild, self)
	self.layout.onWrapFocus:register(self._onLayoutWrapFocus, self)
	self:addChild(self.layout)

	self.swapIcon = ItemIcon()
	self.swapIcon:setSize(self.ICON_SIZE, self.ICON_SIZE)
	self.swapIcon:setIsActive(true)
	self.swapIcon:setColor(self.SWAP_ICON_COLOR)
	self:addChild(self.swapIcon)

	self.toolTip = GamepadToolTip()
	self.toolTip:setKeybind("gamepadPrimaryAction")
	self:getInterface().onClose:register(self._onClose, self)

	self.numItems = 0
	self.currentInventorySlotIndex = 1
	self.showToolTip = false
end

function InventoryGamepadContentTab:getCurrentInventorySlotIndex()
	return self.currentInventorySlotIndex
end

function InventoryGamepadContentTab:_updateToolTip()
	local root = self:getUIView():getRoot()

	local state = self:getState()
	local item = state.items and state.items[self.currentInventorySlotIndex]
	local action = item and item.actions[1]
	if ((item and action) or self.currentSwapIndex) and self.showToolTip then
		if self.toolTip:getParent() ~= root then
			root:addChild(self.toolTip)
		end

		if self.currentSwapIndex then
			self.toolTip:setText("Swap")
		else
			self.toolTip:setText(action.verb)
		end

		local toolTipWidth = self.toolTip:getSize()

		local child = self.layout:getChildAt(self.currentInventorySlotIndex)
		local absoluteChildX, absoluteChildY = child:getAbsolutePosition()
		local childWidth, childHeight = child:getSize()
		local positionX, positionY = absoluteChildX + childWidth - self.PADDING, absoluteChildY + childHeight - self.PADDING

		local selfAbsoluteX1 = self.layout:getAbsolutePosition()
		local selfWidth = self.layout:getSize()

		self.toolTip:setPosition(math.min(positionX, selfAbsoluteX1 + selfWidth - toolTipWidth), positionY)
	else
		if self.toolTip:getParent() == root then
			root:removeChild(self.toolTip)
		end
	end
end

function InventoryGamepadContentTab:_onBlurLayoutChild(layout, child)
	self.showToolTip = false
	self:_updateToolTip()
end

function InventoryGamepadContentTab:_onFocusLayoutChild(layout, child)
	if not child then
		return
	end

	self.currentInventorySlotIndex = child:getData("index") or -1

	local iconWidth, iconHeight = self.swapIcon:getSize()
	local childX, childY = child:getPosition()
	local childWidth, childHeight = child:getSize()

	self.swapIcon:setPosition(
		childX - iconWidth / 2,
		childY - iconHeight / 2)

	self.showToolTip = true
	self:_updateToolTip()
end

function InventoryGamepadContentTab:_onLayoutWrapFocus(_, child, directionX, directionY)
	local inputProvider = self:getInputProvider()
	if inputProvider then
		if directionX ~= 0 then
			inputProvider:setFocusedWidget(child, "select")
		elseif directionY > 0 then
			inputProvider:setFocusedWidget(child, "select")
		end
	end

	self:onWrapFocus(directionX, directionY)
end

function InventoryGamepadContentTab:_onClose()
	local toolTipParent = self.toolTip:getParent()
	if toolTipParent then
		toolTipParent:removeChild(self.toolTip)
	end
end

function InventoryGamepadContentTab:getIsFocusable()
	return true
end

function InventoryGamepadContentTab:focus(reason)
	GamepadContentTab.focus(self, reason)

	local inputProvider = self:getInputProvider()
	if inputProvider then
		local child = self.layout:getChildAt(self.currentInventorySlotIndex)
		inputProvider:setFocusedWidget(child or self.layout, reason)
	end
end

function InventoryGamepadContentTab:updateNumItems(count)
	if count < self.layout:getNumChildren() then
		while self.layout:getNumChildren() > count do
			self.layout:removeChild(self.layout:getChildAt(count))
		end
	else
		for i = self.layout:getNumChildren() + 1, count do
			local button = DraggableButton()
			button:setSize(
				self.ICON_SIZE + self.BUTTON_PADDING * 2,
				self.ICON_SIZE + self.BUTTON_PADDING * 2)
			button:setStyle(ButtonStyle(self.ITEM_BUTTON_STYLE, self:getResources()))

			local icon = ItemIcon()
			icon:setSize(self.ICON_SIZE, self.ICON_SIZE)
			icon:setPosition(self.BUTTON_PADDING, self.BUTTON_PADDING)
			button:addChild(icon)

			button.onDrop:register(self.buttonSwap, self)
			button.onDrag:register(self.buttonDrag, self)
			button.onLeftClick:register(self.activate, self, i)
			button.onRightClick:register(self.probe, self, i)
			button.onMouseMove:register(self.prepareToolTip, self, i)
			button.onGamepadRelease:register(self._onInventoryItemGamepadRelease, self, i)

			button:setData("icon", icon)
			button:setData("index", i)

			self.layout:addChild(button)
		end
	end

	self.layout:performLayout()
	self.numItems = count
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

function InventoryGamepadContentTab:_onInventoryItemGamepadRelease(index, _, joystick, button)
	local inputProvider = self:getInputProvider()
	if not inputProvider then
		return
	end

	if not inputProvider:isCurrentJoystick(joystick) then
		return
	end

	if inputProvider:getKeybind("gamepadTertiaryAction") ~= button then
		return
	end

	if self.currentSwapIndex then
		self:endSwap(index)
	else
		self:beginSwap(index)
	end
end

function InventoryGamepadContentTab:beginSwap(index)
	local button = self.layout:getChildAt(index)
	if not button then
		return
	end

	self.currentSwapIndex = index
end

function InventoryGamepadContentTab:endSwap(newIndex)
	if not self.currentSwapIndex then
		return
	end

	local button = self.layout:getChildAt(self.currentSwapIndex)
	if not button then
		return
	end

	local index = self.currentSwapIndex
	self.currentSwapIndex = false

	self.swapIcon:setItemID(false)
	self.swapIcon:setItemCount(0)
	self.swapIcon:setItemIsNoted(false)

	if newIndex ~= index then
		self:swapInventoryItem(index, newIndex)
	end
end

function InventoryGamepadContentTab:buttonSwap(button, x, y)
	local index = button:getData("index")

	local newIndex
	for _, widget in self.layout:iterate() do
		local widgetX, widgetY = widget:getPosition()
		local widgetWidth, widgetHeight = widget:getSize()

		if x >= widgetX and y >= widgetY and x <= widgetX + widgetWidth and y <= widgetY + widgetHeight then
			newIndex = widget:getData("index")
			break
		end
	end

	if index and newIndex and index ~= newIndex then
		self:swapInventoryItem(index, newIndex)
	end

	local renderManager = self:getUIView():getRenderManager()
	if renderManager:getCursor() == button:getData("icon") then
		renderManager:setCursor(nil)
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
		self:updateNumItems(state.count)
	end

	for i = 1, state.count do
		local button = self.layout:getChildAt(i)
		local icon = button:getData("icon")

		if i == self.currentSwapIndex then
			icon:setItemID(false)
			icon:setItemCount(0)
			icon:setItemIsNoted(false)

			icon = self.swapIcon
		end

		local item = state.items[i]
		if not item then
			button:setID("Inventory-Item-Null")
			icon:setItemID(false)
			icon:setItemCount(0)
			icon:setItemIsNoted(false)
		else
			button:setID(string.format("Inventory-Item-%s", item.id))
			icon:setItemID(item.id)
			icon:setItemCount(item.count)
			icon:setItemIsNoted(not not item.noted)
		end
	end

	local slotIndex = math.clamp(self.currentInventorySlotIndex, 1, self.layout:getNumChildren())
	if slotIndex ~= self.currentInventorySlotIndex then
		local child = self.layout:getChildAt(slotIndex)
		local inputProvider = self:getInputProvider()
		if inputProvider and child then
			inputProvider:setFocusedWidget(child, "select")
		end
	end

	self:_updateToolTip()
end

function InventoryGamepadContentTab:activate(index, button)
	if self.currentSwapIndex then
		self:endSwap(index)
		return
	end

	local state = self:getState()
	if not state.items then
		return
	end

	local item = state.items[index]
	if not item then
		return
	end

	if #item.actions == 0 then
		self:probe(index, button)
	else
		self:pokeInventoryItem(index, item.actions[1].id)
	end
end

function InventoryGamepadContentTab:probe(index, button)
	local state = self:getState()
	if not state.items then
		return
	end

	local item = state.items[index]
	if not item and not self.currentSwapIndex then
		return
	end

	local object = item and item.name or "Empty inventory slot"

	local actions = {}
	if self.currentSwapIndex then
		table.insert(actions, {
			id = "Swap",
			verb = "Swap",
			object = object,
			objectType = "item",
			callback = Function(self.endSwap, self, index)
		})

		table.insert(actions, {
			id = "Examine",
			verb = "Examine",
			object = object,
			objectType = "item",
			callback = Function(self.examine, self, item)
		})
	else
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
			id = "Swap",
			verb = "Swap",
			object = object,
			objectType = "item",
			callback = Function(self.beginSwap, self, index)
		})

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
	end

	local buttonX, buttonY = button:getAbsolutePosition()
	local buttonWidth, buttonHeight = button:getSize()
	buttonX = buttonX + buttonWidth / 2
	buttonY = buttonY + buttonHeight / 2

	local pokeMenu = self:getUIView():probe(actions, buttonX, buttonY, true, false)
	pokeMenu.onClose:register(Function(self.probeInventoryItem, self, false))

	self:probeInventoryItem(index)
end

function InventoryGamepadContentTab:examine(item)
	self:getUIView():examine(self:getInterface():getItemExamine(item))
end

function InventoryGamepadContentTab:prepareToolTip(index, button)
	local icon = button:getData("icon")
	if self.currentSwapIndex == index then
		icon:setToolTip()
	else
		self:getInterface():examineItem(icon, self:getState().items, index)
	end
end

return InventoryGamepadContentTab
