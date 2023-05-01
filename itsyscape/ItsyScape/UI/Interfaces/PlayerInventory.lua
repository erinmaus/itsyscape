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
local PlayerTab = require "ItsyScape.UI.Interfaces.PlayerTab"
local Widget = require "ItsyScape.UI.Widget"

local PlayerInventory = Class(PlayerTab)
PlayerInventory.PADDING = 8
PlayerInventory.ICON_SIZE = 48
PlayerInventory.BUTTON_PADDING = 2

PlayerInventory.UseItemFacade = Class(Widget)
function PlayerInventory.UseItemFacade:new(interface, ui, item)
	Widget.new(self)

	self.interface = interface
	self.ui = ui
	self.item = item

	local w, h = love.graphics.getScaledMode()
	self:setSize(w, h)
	self:setPosition(0, 0)
	self:setZDepth(-1000)
end

function PlayerInventory.UseItemFacade:getIsFocusable()
	return true
end

function PlayerInventory.UseItemFacade:mouseMove(...)
	Widget.mouseMove(self, ...)

	local x, y = love.mouse.getPosition()

	local ray = _APP:shoot(x, y)

	local hits = {}

	local game = self.ui:getGame()
	local stage = game:getStage()
	for actor in stage:iterateActors() do
		local min, max = actor:getBounds()
		do
			min = min or Vector.ZERO
			max = max or Vector.ZERO

			local _, _, layer = actor:getTile()
			local node = self.ui:getGameView():getMapSceneNode(layer)
			if node then
				local transform = node:getTransform():getGlobalDeltaTransform(_APP:getFrameDelta())
				min, max = Vector.transformBounds(min, max, transform)
			end
		end

		local success, position = ray:hitBounds(min, max)
		if success then
			table.insert(hits, {
				actor = actor,
				z = -position.z
			})
		end
	end


	for prop in stage:iterateProps() do
		local min, max = prop:getBounds()
		do
			min = min or Vector.ZERO
			max = max or Vector.ZERO

			local _, _, layer = prop:getTile()
			local node = self.ui:getGameView():getMapSceneNode(layer)
			if node then
				local transform = node:getTransform():getGlobalDeltaTransform(_APP:getFrameDelta())
				min, max = Vector.transformBounds(min, max, transform)
			end
		end

		local success, position = ray:hitBounds(min, max)
		if success then
			table.insert(hits, {
				prop = prop,
				z = -position.z
			})
		end
	end

	table.sort(hits, function(a, b)
		return a.z < b.z
	end)

	self.hits = hits

	self:unsetToolTip()
	if #self.hits >= 1 then
		local hit = self.hits[1]

		local renderManager = self.ui:getRenderManager()
		self.toolTipWidget = renderManager:setToolTip(
			5,
			ToolTip.Header(string.format("Use %s -> %s", self.item.name, (hit.actor or hit.prop):getName())),
			ToolTip.Text((hit.actor or hit.prop):getDescription()))
	end

	_APP.cameraController:mouseMove(false, ...)
end

function PlayerInventory.UseItemFacade:unsetToolTip()
	local renderManager = self.ui:getRenderManager()
	if self.toolTipWidget then
		renderManager:unsetToolTip(self.toolTipWidget)
	end
end

function PlayerInventory.UseItemFacade:mousePress(_x, _y, button)
	Widget.mousePress(self, _x, _y, button)

	self:mouseMove(love.mouse.getPosition())

	if button == 1 then
		local hit = self.hits[1]
		if hit then
			if hit.actor then
				self.interface:useItemOnActor(hit.actor)
			elseif hit.prop then
				self.interface:useItemOnProp(hit.prop)
			else
				self.interface:cancelUse()
			end
		else
			self.interface:cancelUse()
		end
	elseif button == 2 then
		local actions = {}

		for i = 1, #self.hits do
			local hit = self.hits[i]
			if hit.prop then
				table.insert(actions, {
					id = hit.prop:getID(),
					verb = string.format("Use %s ->", self.item.name),
					object = hit.prop:getName(),
					callback = function()
						self.interface:useItemOnProp(hit.prop)
					end
				})
			elseif hit.actor then
				table.insert(actions, {
					id = hit.actor:getID(),
					verb = string.format("Use %s ->", self.item.name),
					object = hit.actor:getName(),
					callback = function()
						self.interface:useItemOnActor(hit.actor)
					end
				})
			end
		end

		self.ui:probe(actions)
	end

	self:unsetToolTip()

	_APP.cameraController:mousePress(false, _x, _y, button)
end

function PlayerInventory.UseItemFacade:mouseRelease(...)
	Widget.mouseRelease(self, ...)

	_APP.cameraController:mouseRelease(false, ...)
end

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

	self:examineItem(icon, self:getState().items, index)
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

function PlayerInventory:useItem(button, index)
	button:getData('icon'):setIsActive(true)
	self:getView():getRenderManager():setCursor(button:getData('icon'))

	self.isUsingItem = true
	self.activeItemIndex = index
	self.activeButtonIcon = button:getData('icon')

	local root = self:getView():getRoot()

	self.facade = PlayerInventory.UseItemFacade(self, self:getView(), self:getState().items[index])
	root:addChild(self.facade)
end

function PlayerInventory:useItemOnProp(prop)
	self:sendPoke("useItemOnProp", nil, {
		itemIndex = self.activeItemIndex,
		propID = prop:getID()
	})

	self:cancelUse()
end

function PlayerInventory:useItemOnActor(actor)
	self:sendPoke("useItemOnActor", nil, {
		itemIndex = self.activeItemIndex,
		actorID = actor:getID()
	})

	self:cancelUse()
end

function PlayerInventory:cancelUse()
	if self:getView():getRenderManager():getCursor() == self.activeButtonIcon then
		self:getView():getRenderManager():setCursor(nil)
	end

	self.activeButtonIcon:setIsActive(false)

	self.isUsingItem = false
	self.activeButtonIcon = nil
	self.activeItemIndex = nil

	if self.facade then
		self.facade:unsetToolTip()
		self.facade:getParent():removeChild(self.facade)
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
				self:useItem(button, index)
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
	if self.isUsingItem then
		self:sendPoke("useItemOnItem", nil, {
			index1 = self.activeItemIndex,
			index2 = button:getData('icon'):getData('index')
		})

		self:cancelUse()
	else
		local index = button:getData('icon'):getData('index')
		local items = self:getState().items or {}
		local item = items[index]
		if item then
			local action = item.actions[1]
			if action then
				self:sendPoke("poke", nil, { index = index, id = action.id })
			else
				self:useItem(button, button:getData('icon'):getData('index'))
			end
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
