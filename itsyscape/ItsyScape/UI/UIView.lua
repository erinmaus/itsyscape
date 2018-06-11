--------------------------------------------------------------------------------
-- ItsyScape/UI/UIView.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Button = require "ItsyScape.UI.Button"
local ButtonRenderer = require "ItsyScape.UI.ButtonRenderer"
local DraggablePanel = require "ItsyScape.UI.DraggablePanel"
local InventoryItemButton = require "ItsyScape.UI.InventoryItemButton"
local InventoryItemButtonRenderer = require "ItsyScape.UI.InventoryItemButtonRenderer"
local ItemIcon = require "ItsyScape.UI.ItemIcon"
local ItemIconRenderer = require "ItsyScape.UI.ItemIconRenderer"
local PokeMenu = require "ItsyScape.UI.PokeMenu"
local Panel = require "ItsyScape.UI.Panel"
local PanelRenderer = require "ItsyScape.UI.PanelRenderer"
local Widget = require "ItsyScape.UI.Widget"
local WidgetInputProvider = require "ItsyScape.UI.WidgetInputProvider"
local WidgetRenderManager = require "ItsyScape.UI.WidgetRenderManager"
local WidgetResourceManager = require "ItsyScape.UI.WidgetResourceManager"

local UIView = Class()

function UIView:new(game)
	self.game = game

	local ui = game:getUI()
	ui.onOpen:register(self.open, self)
	ui.onClose:register(self.close, self)
	ui.onPoke:register(self.poke, self)

	self.root = Widget()
	self.inputProvider = WidgetInputProvider(self.root)

	self.resources = WidgetResourceManager()

	self.renderManager = WidgetRenderManager()
	self.renderManager:addRenderer(Button, ButtonRenderer(self.resources))
	self.renderManager:addRenderer(Panel, PanelRenderer(self.resources))
	self.renderManager:addRenderer(DraggablePanel, PanelRenderer(self.resources))
	self.renderManager:addRenderer(InventoryItemButton, InventoryItemButtonRenderer(self.resources))
	self.renderManager:addRenderer(ItemIcon, ItemIconRenderer(self.resources))
	self.renderManager:addRenderer(PokeMenu, PanelRenderer(self.resources))

	self.interfaces = {}

	self.pokeMenu = false
end

function UIView:release()
	local ui = self:getUI()
	ui.onOpen:unregister(self.open)
	ui.onClose:unregister(self.close)
end

function UIView:getGame()
	return self.game
end

function UIView:getUI()
	return self.game:getUI()
end

function UIView:getInputProvider()
	return self.inputProvider
end

function UIView:getRenderManager()
	return self.renderManager
end

function UIView:getRoot()
	return self.root
end

function UIView:getResources()
	return self.resources
end

function UIView:open(interfaceID, index)
	local TypeName = string.format("ItsyScape.UI.Interfaces.%s", interfaceID)
	local Type = require(TypeName)

	local interfaces = self.interfaces[interfaceID] or {}
	local interface = Type(interfaceID, index, self)
	interfaces[index] = interface
	self.interfaces[interfaceID] = interfaces

	self.root:addChild(interface)
end

function UIView:close(interfaceID, index)
	local interfaces = self.interfaces[interfaceID]
	if interfaces then
		local interface = interfaces[index]
		if interface then
			self.root:removeChild(interface)
			interfaces[index] = nil
		end
	end
end

function UIView:poke(interfaceID, index, actionID, actionIndex, e)
	local interfaces = self.interfaces[interfaceID]
	if interfaces then
		local interface = interfaces[index]
		if interface then
			interface:poke(actionID, actionIndex, e)
		end
	end
end

function UIView:probe(actions)
	if self.pokeMenu then
		self.pokeMenu:close()
	end

	self.pokeMenu = PokeMenu(self, actions)
	do
		local windowWidth, windowHeight = love.window.getMode()
		local menuWidth, menuHeight = self.pokeMenu:getSize()
		local mouseX, mouseY = love.mouse.getPosition()
		local menuX = mouseX - PokeMenu.PADDING
		local menuY = mouseY - PokeMenu.PADDING

		if menuX + menuWidth > windowWidth then
			local difference = menuX + menuWidth - windowWidth
			menuX = menuX - difference
		end

		if menuY + menuHeight > windowHeight then
			local difference = menuY + menuHeight - windowHeight
			menuY = menuY - difference
		end

		self.pokeMenu:setPosition(
			menuX,
			menuY)

		self.pokeMenu.onClose:register(function() self.pokeMenu = false end)

		self.root:addChild(self.pokeMenu)
	end
end

function UIView:update(delta)
	self.root:update(delta)
end

function UIView:draw()
	local width, height = love.window.getMode()
	self.root:setSize(width, height)

	love.graphics.setBlendMode('alpha')
	love.graphics.origin()
	love.graphics.ortho(width, height)

	self.renderManager:start()
	self.renderManager:draw(self.root)
	self.renderManager:stop()
end

return UIView
