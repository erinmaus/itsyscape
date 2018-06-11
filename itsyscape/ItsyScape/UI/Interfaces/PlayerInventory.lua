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
local InventoryItemButton = require "ItsyScape.UI.InventoryItemButton"
local Panel = require "ItsyScape.UI.Panel"
local PanelStyle = require "ItsyScape.UI.PanelStyle"
local PlayerTab = require "ItsyScape.UI.Interfaces.PlayerTab"

local PlayerInventory = Class(PlayerTab)

function PlayerInventory:new(id, index, ui)
	PlayerTab.new(self, id, index, ui)

	self.buttons = {}
	self.numItems = 0
	self.onInventoryResized = Callback()

	self.panel = Panel()
	self.panel:setStyle(PanelStyle({
		image = "Resources/Renderers/Widget/Panel/Default.9.png"
	}, ui:getResources()))
	self:addChild(self.panel)

	self.panel:setSize(self:getSize())

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
				local top = #self.buttons

				top.onDrop:unregister(self.swap)
				self:removeChild(self.buttons[top])

				table.remove(self.buttons, top)
			end
		else
			for i = #self.buttons + 1, value do
				local button = InventoryItemButton()
				button:getIcon():setData('index', i)
				button:getIcon():bind("itemID", "items[{index}].id")
				button:getIcon():bind("itemCount", "items[{index}].count")
				button:getIcon():bind("itemIsNoted", "items[{index}].noted")

				button.onDrop:register(self.swap, self)
				button.onDrag:register(self.drag, self)
				button.onLeftClick:register(self.activate, self)
				button.onRightClick:register(self.probe, self)

				self:addChild(button)
				table.insert(self.buttons, button)
			end
		end

		self.onInventoryResized(self, #self.buttons)
	end

	self:performLayout()

	self.numItems = value
end

function PlayerInventory:performLayout()
	local width, height = self:getSize()
	local padding = 8
	local x, y = 0, padding

	-- performLayout is invoked in new so we can't depend on buttons being
	-- non-nil since PlayerTab constructor runs first
	if self.buttons then
		for _, child in ipairs(self.buttons) do
			local childWidth, childHeight = child:getSize()
			if x > 0 and x + childWidth + InventoryItemButton.DEFAULT_PADDING > width then
				x = 0
				y = y + childHeight + padding
			end

			child:setPosition(x + padding, y)
			x = x + childWidth + padding
		end

		self.panel:setSize(width, height)
	end
end

function PlayerInventory:drag(button, x, y)
	if self:getView():getRenderManager():getCursor() ~= button:getIcon() then
		self:getView():getRenderManager():setCursor(button:getIcon())
	end
end

function PlayerInventory:swap(button, x, y)
	local index = button:getIcon():getData('index')
	if index then
		local width, height = self:getSize()
		if x >= 0 and y >= 0 and x <= width and y <= height then
			local buttonSize = InventoryItemButton.DEFAULT_SIZE + 8
			
			local i = math.floor(x / buttonSize)
			local j = math.floor(y / buttonSize)
			local newIndex = j * math.max(math.floor(width / buttonSize), 1) + i + 1

			self:sendPoke("swap", nil, { a = index, b = newIndex })
		end
	end

	if self:getView():getRenderManager():getCursor() == button:getIcon() then
		self:getView():getRenderManager():setCursor(nil)
	end
end

function PlayerInventory:probe(button)
	local index = button:getIcon():getData('index')
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
				-- TODO: examine item
				Log.info("It's a %s.", object)
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
	local index = button:getIcon():getData('index')
	local items = self:getState().items or {}
	local item = items[index]
	if item then
		local action = item.actions[1]
		if action then
			self:sendPoke("poke", nil, { index = index, id = action.id })
		end
	end
end

return PlayerInventory