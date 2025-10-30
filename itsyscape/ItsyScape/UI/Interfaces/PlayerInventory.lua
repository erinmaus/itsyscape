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
local InventoryGamepadContentTab = require "ItsyScape.UI.Interfaces.Components.InventoryGamepadContentTab"

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

	local x, y = itsyrealm.mouse.getPosition()

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

	local isBlocked = false
	do
		local blockedWidget
		isBlocked, blockedWidget = self.ui:getInputProvider():isBlocking(x, y)
		isBlocked = isBlocked and blockedWidget ~= self
	end

	self:unsetToolTip()
	if #self.hits >= 1 and not isBlocked then
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

	if button == 1 and (_CONF.probe == false or #self.hits <= 1) then
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
	elseif button == 2 or (button == 1 and #self.hits > 1 and _CONF.probe ~= false) then
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

	self.content = InventoryGamepadContentTab(self)
	self.content.onUseItem:register(self.useItem, self)
	self:addChild(self.content)

	self.onClose:register(self.close, self)
end

function PlayerInventory:close()
	self:cancelUse()
end

function PlayerInventory:mousePress(...)
	PlayerTab.mousePress(self, ...)

	self:cancelUse()
end

function PlayerInventory:useItem(_, button, index)
	self:cancelUse()

	button:getData("icon"):setIsActive(true)
	self:getView():getRenderManager():setCursor(button:getData("icon"))

	self.isUsingItem = true
	self.activeItemIndex = index
	self.activeButtonIcon = button:getData("icon")

	local root = self:getView():getRoot()

	self.facade = PlayerInventory.UseItemFacade(self, self:getView(), self:getState().items[index])
	root:addChild(self.facade)

	self:sendPoke("useInventoryItem", nil, { index = index })
end

function PlayerInventory:useItemOnProp(prop)
	self:sendPoke("useInventoryItemOnProp", nil, {
		itemIndex = self.activeItemIndex,
		propID = prop:getID()
	})

	self:cancelUse()
end

function PlayerInventory:useItemOnActor(actor)
	self:sendPoke("useInventoryItemOnActor", nil, {
		itemIndex = self.activeItemIndex,
		actorID = actor:getID()
	})

	self:cancelUse()
end

function PlayerInventory:cancelUse()
	if self:getView():getRenderManager():getCursor() == self.activeButtonIcon then
		self:getView():getRenderManager():setCursor(nil)
	end

	if self.activeButtonIcon then
		self.activeButtonIcon:setIsActive(false)
	end

	self.isUsingItem = false
	self.activeButtonIcon = nil
	self.activeItemIndex = nil

	if self.facade then
		self.facade:unsetToolTip()

		local parent = self.facade:getParent()
		if parent then
			parent:removeChild(self.facade)
		end

		self.facade = nil
	end

	self:sendPoke("use", nil, { index = false })
end

function PlayerInventory:tick()
	PlayerTab.tick(self)
	self.content:refresh(self:getState())
end

return PlayerInventory
