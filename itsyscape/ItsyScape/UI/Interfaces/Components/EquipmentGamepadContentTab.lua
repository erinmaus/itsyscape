--------------------------------------------------------------------------------
-- ItsyScape/UI/Interfaces/EquipmentGamepadContentTab.lua
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
local Equipment = require "ItsyScape.Game.Equipment"
local Utility = require "ItsyScape.Game.Utility"
local Widget = require "ItsyScape.UI.Widget"
local ButtonStyle = require "ItsyScape.UI.ButtonStyle"
local DraggableButton = require "ItsyScape.UI.DraggableButton"
local GamepadGridLayout = require "ItsyScape.UI.GamepadGridLayout"
local GamepadToolTip = require "ItsyScape.UI.GamepadToolTip"
local ItemIcon = require "ItsyScape.UI.ItemIcon"
local Panel = require "ItsyScape.UI.Panel"
local PanelStyle = require "ItsyScape.UI.PanelStyle"
local ToolTip = require "ItsyScape.UI.ToolTip"
local EquipmentStatsPanel = require "ItsyScape.UI.Interfaces.Common.EquipmentStatsPanel"
local GamepadContentTab = require "ItsyScape.UI.Interfaces.Components.GamepadContentTab"
local Widget = require "ItsyScape.UI.Widget"

local EquipmentGamepadContentTab = Class(GamepadContentTab)
EquipmentGamepadContentTab.PADDING = 8
EquipmentGamepadContentTab.ICON_SIZE = 48
EquipmentGamepadContentTab.BUTTON_PADDING = 2

EquipmentGamepadContentTab.GROUP_PANEL_STYLE = {
	image = "Resources/Game/UI/Panels/WindowGroup.png"
}

EquipmentGamepadContentTab.ITEM_BUTTON_STYLE = {
	pressed = "Resources/Game/UI/Buttons/ItemButton-Pressed.png",
	hover = "Resources/Game/UI/Buttons/ItemButton-Hover.png",
	inactive = "Resources/Game/UI/Buttons/ItemButton-Default.png"
}

function EquipmentGamepadContentTab:new(interface)
	GamepadContentTab.new(self, interface)

	self.layout = GamepadGridLayout()
	self.layout:setSize(self:getSize(), 0)
	self.layout:setWrapContents(true)
	self.layout:setPadding(self.PADDING, self.PADDING)
	self.layout:setUniformSize(
		true,
		self.ICON_SIZE + self.BUTTON_PADDING * 2,
		self.ICON_SIZE + self.BUTTON_PADDING * 2)
	self.layout.onBlurChild:register(self._onBlurLayoutChild, self)
	self.layout.onFocusChild:register(self._onFocusLayoutChild, self)
	self.layout.onWrapFocus:register(self._onLayoutWrapFocus, self)
	self:addChild(self.layout)

	self:updateSlots(#Equipment.SLOTS)
	self.layout:performLayout()

	local statsPanel = Panel()
	statsPanel:setStyle(self.GROUP_PANEL_STYLE, PanelStyle)
	statsPanel:setSize(self.WIDTH, EquipmentStatsPanel.DEFAULT_HEIGHT)
	local _, layoutHeight = self.layout:getSize()
	statsPanel:setPosition(0, layoutHeight + self.PADDING)
	self:addChild(statsPanel)

	self.stats = EquipmentStatsPanel(self:getUIView(), { width = self.WIDTH - self.PADDING * 2 })
	statsPanel:addChild(self.stats)

	self.toolTip = GamepadToolTip()
	self.toolTip:setKeybind("gamepadPrimaryAction")
	self:getInterface().onClose:register(self._onClose, self)

	self.currentEquipmentSlotIndex = 1
	self.showToolTip = false
end

function EquipmentGamepadContentTab:_onBlurLayoutChild(layout, child)
	self.showToolTip = false
	self:_updateToolTip()
end

function EquipmentGamepadContentTab:_onLayoutWrapFocus(_, child, directionX, directionY)
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

function EquipmentGamepadContentTab:_onFocusLayoutChild(layout, child)
	if not child then
		return
	end

	self.currentEquipmentSlotIndex = child:getData("index") or -1

	self.showToolTip = true
	self:_updateToolTip()
end

function EquipmentGamepadContentTab:_onClose()
	local toolTipParent = self.toolTip:getParent()
	if toolTipParent then
		toolTipParent:removeChild(self.toolTip)
	end
end

function EquipmentGamepadContentTab:updateSlots(count)
	for i = 1, count do
		local button = DraggableButton()
		button:setSize(
			self.ICON_SIZE + self.BUTTON_PADDING * 2,
			self.ICON_SIZE + self.BUTTON_PADDING * 2)
		button:setStyle(self.ITEM_BUTTON_STYLE, ButtonStyle)

		local icon = ItemIcon()
		icon:setSize(self.ICON_SIZE, self.ICON_SIZE)
		icon:setPosition(self.BUTTON_PADDING, self.BUTTON_PADDING)
		button:addChild(icon)

		button.onLeftClick:register(self.activate, self, i)
		button.onRightClick:register(self.probe, self, i)
		button.onMouseMove:register(self.prepareToolTip, self, i)

		button:setData("icon", icon)
		button:setData("index", i)

		self.layout:addChild(button)
	end
end

function EquipmentGamepadContentTab:focus(reason)
	GamepadContentTab.focus(self, reason)

	local inputProvider = self:getInputProvider()
	if inputProvider then
		local child = self.layout:getChildAt(self.currentEquipmentSlotIndex)
		inputProvider:setFocusedWidget(child or self.layout, reason)
	end
end

function EquipmentGamepadContentTab:getCurrentEquipmentSlot()
	return Equipment.SLOTS[self.currentEquipmentSlotIndex] or -1
end

function EquipmentGamepadContentTab:getEquipmentItem(slot)
	local gameDB = self:getGameDB()
	local state = self:getState()

	local item = state.items and state.items[slot]
	if item then
		return item
	end

	local placeholderSlotRecord = gameDB:getRecord("EquipmentPlaceholder", {
		EquipSlot = slot
	})

	if not placeholderSlotRecord then
		return nil
	end

	local itemResource = placeholderSlotRecord:get("Resource")

	return {
		id = itemResource.name,
		count = 1,
		noted = false,
		name = Utility.getName(itemResource, gameDB),
		description = Utility.getDescription(itemResource, gameDB),
		actions = {}
	}
end

function EquipmentGamepadContentTab:_updateToolTip()
	local root = self:getUIView():getRoot()

	local state = self:getState()
	local item = self:getEquipmentItem(self:getCurrentEquipmentSlot())
	local action = item and item.actions[1]
	if item and action and self.showToolTip then
		if self.toolTip:getParent() ~= root then
			root:addChild(self.toolTip)
		end

		self.toolTip:setText(action.verb)

		local toolTipWidth = self.toolTip:getSize()

		local child = self.layout:getChildAt(self.currentEquipmentSlotIndex)
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

function EquipmentGamepadContentTab:pokeEquipmentItem(index, actionID)
	self:getInterface():sendPoke("pokeEquipmentItem", nil, { index = Equipment.SLOTS[index], id = actionID })
end

function EquipmentGamepadContentTab:probeEquipmentItem(index)
	self:getInterface():sendPoke("probeEquipmentItem", nil, { index = Equipment.SLOTS[index] })
end

function EquipmentGamepadContentTab:refresh(state)
	GamepadContentTab.refresh(self, state)

	for index, slot in ipairs(Equipment.SLOTS) do
		local button = self.layout:getChildAt(index)
		local icon = button:getData("icon")

		local item = self:getEquipmentItem(slot)
		if not item then
			button:setID("Equipment-Item-Null")
			icon:setItemID(false)
			icon:setItemCount(0)
			icon:setItemIsNoted(false)
		else
			button:setID(string.format("Equipment-Item-%s", item.id))
			icon:setItemID(item.id)
			icon:setItemCount(item.count)
			icon:setItemIsNoted(not not item.noted)
		end
	end

	local slotIndex = math.clamp(self.currentEquipmentSlotIndex, 1, self.layout:getNumChildren())
	if slotIndex ~= self.currentEquipmentSlotIndex then
		local child = self.layout:getChildAt(slotIndex)
		local inputProvider = self:getInputProvider()
		if inputProvider and child then
			inputProvider:setFocusedWidget(child, "select")
		end
	end

	self.stats:updateStats(state.stats)
	self:_updateToolTip()
end

function EquipmentGamepadContentTab:activate(index, button)
	local state = self:getState()
	if not state.items then
		return
	end

	local item = state.items[Equipment.SLOTS[index]]
	if not item then
		return
	end

	if #item.actions == 0 then
		self:probe(index, button)
	else
		self:pokeEquipmentItem(index, item.actions[1].id)
	end
end

function EquipmentGamepadContentTab:probe(index, button)
	local state = self:getState()
	if not state.items then
		return
	end

	local item = state.items[Equipment.SLOTS[index]]
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
			callback = Function(self.pokeEquipmentItem, self, index, action.id)
		})
	end

	table.insert(actions, {
		id = "Examine",
		verb = "Examine",
		object = object,
		objectType = "item",
		callback = Function(self.examine, self, item)
	})

	local buttonX, buttonY = button:getAbsolutePosition()
	local buttonWidth, buttonHeight = button:getSize()
	buttonX = buttonX + buttonWidth / 2
	buttonY = buttonY + buttonHeight / 2

	local pokeMenu = self:getUIView():probe(actions, buttonX, buttonY, true, false)
	pokeMenu.onClose:register(Function(self.probeEquipmentItem, self, false))

	self:probeEquipmentItem(index)
end

function EquipmentGamepadContentTab:examine(item)
	self:getUIView():examine(self:getInterface():getItemExamine(item))
end

function EquipmentGamepadContentTab:prepareToolTip(index, button)
	local icon = button:getData("icon")
	self:getInterface():examineItem(icon, self:getState().items, index)
end

return EquipmentGamepadContentTab
