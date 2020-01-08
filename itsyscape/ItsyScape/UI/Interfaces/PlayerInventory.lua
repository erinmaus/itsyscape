--------------------------------------------------------------------------------
-- ItsyScape/UI/Interfaces/PlayerInventory.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Callback = require "ItsyScape.Common.Callback"
local Class = require "ItsyScape.Common.Class"
local Utility = require "ItsyScape.Game.Utility"
local Widget = require "ItsyScape.UI.Widget"
local ButtonStyle = require "ItsyScape.UI.ButtonStyle"
local DraggableButton = require "ItsyScape.UI.DraggableButton"
local ItemIcon = require "ItsyScape.UI.ItemIcon"
local GridLayout = require "ItsyScape.UI.GridLayout"
local Panel = require "ItsyScape.UI.Panel"
local PanelStyle = require "ItsyScape.UI.PanelStyle"
local ToolTip = require "ItsyScape.UI.ToolTip"
local PlayerTab = require "ItsyScape.UI.Interfaces.PlayerTab"

local PlayerInventory = Class(PlayerTab)
PlayerInventory.PADDING = 8
PlayerInventory.ICON_SIZE = 48
PlayerInventory.BUTTON_PADDING = 2

function PlayerInventory:new(id, index, ui)
	PlayerTab.new(self, id, index, ui)

	self.buttons = {}
	self.numItems = 0
	self.onInventoryResized = Callback()

	local panel = Panel()
	panel = Panel()
	panel:setStyle(PanelStyle({
		image = "Resources/Renderers/Widget/Panel/Default.9.png"
	}, ui:getResources()))
	panel:setSize(self:getSize())
	self:addChild(panel)

	self.layout = GridLayout()
	self.layout:setPadding(PlayerInventory.PADDING, PlayerInventory.PADDING)
	self.layout:setUniformSize(
		true,
		PlayerInventory.ICON_SIZE + PlayerInventory.BUTTON_PADDING * 2,
		PlayerInventory.ICON_SIZE + PlayerInventory.BUTTON_PADDING * 2)
	panel:addChild(self.layout)

	self.layout:setSize(self:getSize())

	self.buttons = {}
end

function PlayerInventory:poke(actionID, actionIndex, e)
	if not PlayerTab.poke(self, actionID, actionIndex, e) then
		-- Nothing.
	end
end

function PlayerInventory:getNumItems()
	return self.numItems
end

function PlayerInventory:setNumItems(value)
	value = value or self.numItems
	assert(value >= 0 and value < math.huge, "too many or too little inventory value")

	if value ~= #self.buttons then
		if value < #self.buttons then
			while #self.buttons > value do
				local index = #self.buttons
				local top = self.buttons[index]

				table.remove(self.buttons, index)
				self.layout:removeChild(top)
			end
		else
			for i = #self.buttons + 1, value do
				local button = DraggableButton()
				local icon = ItemIcon()
				icon:setData('index', i)
				icon:bind("itemID", "items[{index}].id")
				icon:bind("itemCount", "items[{index}].count")
				icon:bind("itemIsNoted", "items[{index}].noted")
				icon:setSize(
					PlayerInventory.ICON_SIZE,
					PlayerInventory.ICON_SIZE)
				icon:setPosition(
					PlayerInventory.BUTTON_PADDING,
					PlayerInventory.BUTTON_PADDING)

				button:setStyle(ButtonStyle({
					inactive = "Resources/Renderers/Widget/Button/InventoryItem.9.png",
					hover = "Resources/Renderers/Widget/Button/InventoryItem.9.png",
					pressed = "Resources/Renderers/Widget/Button/InventoryItem.9.png"
				}, self:getView():getResources()))

				button:addChild(icon)
				button:setData('icon', icon)
				button.onDrop:register(self.swap, self)
				button.onDrag:register(self.drag, self)
				button.onLeftClick:register(self.activate, self)
				button.onRightClick:register(self.probe, self)

				button.onMouseMove:register(self.examine, self, i)

				self.layout:addChild(button)
				table.insert(self.buttons, button)
			end
		end

		self.onInventoryResized(self, #self.buttons)
	end

	self.numItems = value
end

function PlayerInventory:examine(index, button)
	local icon = button:getData('icon')

	local item = self:getState().items[index]
	if not item then
		icon:setToolTip()
		return
	end

	local object, description = Utility.Item.getInfo(
		item.id,
		self:getView():getGame():getGameDB())

	local action = item.actions[1]
	if action then
		object = action.verb .. " " .. object
	end

	icon:setToolTip(
		ToolTip.Header(object),
		ToolTip.Text(description))
end

function PlayerInventory:drag(button, x, y)
	if self:getView():getRenderManager():getCursor() ~= button:getData('icon') then
		self:getView():getRenderManager():setCursor(button:getData('icon'))
	end
end

function PlayerInventory:swap(button, x, y)
	local index = button:getData('icon'):getData('index')
	local BUTTON_SIZE = PlayerInventory.ICON_SIZE + PlayerInventory.BUTTON_PADDING * 2
	if index then
		local width, height = self:getSize()
		if x >= 0 and y >= 0 and x <= width and y <= height then
			local buttonSize = BUTTON_SIZE + PlayerInventory.PADDING
			
			local i = math.floor(x / buttonSize)
			local j = math.floor(y / buttonSize)
			local newIndex = j * math.max(math.floor(width / buttonSize), 1) + i + 1
			newIndex = math.min(math.max(1, newIndex), self.numItems)

			self:sendPoke("swap", nil, { a = index, b = newIndex })
		end
	end

	if self:getView():getRenderManager():getCursor() == button:getData('icon') then
		self:getView():getRenderManager():setCursor(nil)
	end
end

function PlayerInventory:probe(button)
	local index = button:getData('icon'):getData('index')
	local items = self:getState().items or {}
	local item = items[index]
	if item then
		local object
		do
			-- TODO: [LANG]
			local gameDB = self:getView():getGame():getGameDB()
			object = Utility.Item.getName(item.id, gameDB, "en-US")
			if not object then
				object = "*" .. item.id
			end
		end

		local actions = {}
		for i = 1, #item.actions do
			table.insert(actions, {
				id = item.actions[i].type,
				verb = item.actions[i].verb,
				object = object,
				callback = function()
					self:sendPoke("poke", nil, { index = index, id = item.actions[i].id })
				end
			})
		end

		table.insert(actions, {
			id = "Use",
			verb = "Use", -- TODO: [LANG]
			object = object,
			callback = function()
				Log.info("Not yet implemented.")
			end
		})

		table.insert(actions, {
			id = "Examine",
			verb = "Examine", -- TODO: [LANG]
			object = object,
			callback = function()
				self:getView():examine(item.id)
			end
		})

		table.insert(actions, {
			id = "Drop",
			verb = "Drop", -- TODO: [LANG]
			object = object,
			callback = function()
				self:sendPoke("drop", nil, { index = index })
			end
		})

		self:getView():probe(actions)
	end
end

function PlayerInventory:activate(button)
	local index = button:getData('icon'):getData('index')
	local items = self:getState().items or {}
	local item = items[index]
	if item then
		local action = item.actions[1]
		if action then
			self:sendPoke("poke", nil, { index = index, id = action.id })
		end
	end
end

function PlayerInventory:update()
	local items = self:getState().items or {}

	for i = 1, self.numItems do
		if items[i] then
			self.buttons[i]:setID("Inventory-" .. items[i].id)
		else
			self.buttons[i]:setID(nil)
		end
	end
end

return PlayerInventory
