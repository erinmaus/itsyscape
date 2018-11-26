--------------------------------------------------------------------------------
-- ItsyScape/UI/Interfaces/Ribbon.lua
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
local Button = require "ItsyScape.UI.Button"
local ButtonStyle = require "ItsyScape.UI.ButtonStyle"
local Interface = require "ItsyScape.UI.Interface"
local Panel = require "ItsyScape.UI.Panel"
local PanelStyle = require "ItsyScape.UI.PanelStyle"
local Widget = require "ItsyScape.UI.Widget"

local Ribbon = Class(Interface)
Ribbon.BUTTON_SIZE = 64
Ribbon.PADDING = 8

function Ribbon:new(id, index, ui)
	Interface.new(self, id, index, ui)

	self.panel = Panel()
	self.panel:setStyle(PanelStyle({
		image = "Resources/Renderers/Widget/Panel/Ribbon.9.png"
	}, ui:getResources()))
	self:addChild(self.panel)

	self.icons = {}
	self.buttons = {}
	self.activeButton = false

	self:addButton("PlayerStance", "Resources/Game/UI/Icons/Common/Stance.png")
	self:addButton("PlayerInventory", "Resources/Game/UI/Icons/Common/Inventory.png")
	self:addButton("PlayerEquipment", "Resources/Game/UI/Icons/Common/Equipment.png")
	self:addButton("PlayerStats", "Resources/Game/UI/Icons/Common/Skills.png")
	self:addButton("PlayerSpells", "Resources/Game/UI/Icons/Skills/Magic.png")
end

function Ribbon:addButton(tab, icon)
	local width = self:getSize()

	local newWidth = width + Ribbon.BUTTON_SIZE + Ribbon.PADDING * 2
	local x = width + Ribbon.PADDING

	local button = Button()
	button:setPosition(x, Ribbon.PADDING)
	button:setSize(Ribbon.BUTTON_SIZE, Ribbon.BUTTON_SIZE)
	button.onClick:register(function()
		if self.activeButton ~= button then
			self:sendPoke("open", nil, { tab = tab })
			self.activeButton = button
		else
			self:sendPoke("close", nil, {})
			self.activeButton = false
		end
	end)

	button:setStyle(ButtonStyle({
		inactive = "Resources/Renderers/Widget/Button/Ribbon-Inactive.9.png",
		hover = "Resources/Renderers/Widget/Button/Ribbon-Hover.9.png",
		pressed = "Resources/Renderers/Widget/Button/Ribbon-Pressed.9.png",
		icon = { filename = icon, x = 0.5, y = 0.5 }
	}, self:getView():getResources()))

	self:addChild(button)

	self:setSize(newWidth, Ribbon.PADDING * 2 + Ribbon.BUTTON_SIZE)
	self.panel:setSize(self:getSize())

	local windowWidth, windowHeight = love.window.getMode()
	self:setPosition(
		windowWidth - newWidth,
		windowHeight - Ribbon.PADDING * 2 - Ribbon.BUTTON_SIZE)

	self.icons[button] = icon
	self.buttons[tab] = button
end

function Ribbon:activate(tab)
	if self.activeButton then
		self.activeButton:setStyle(ButtonStyle({
			inactive = "Resources/Renderers/Widget/Button/Ribbon-Inactive.9.png",
			hover = "Resources/Renderers/Widget/Button/Ribbon-Hover.9.png",
			pressed = "Resources/Renderers/Widget/Button/Ribbon-Pressed.9.png",
			icon = { filename = self.icons[self.activeButton], x = 0.5, y = 0.5 }
		}, self:getView():getResources()))

		self.activeButton = false
	end

	local button = self.buttons[tab]
	if button then
		button:setStyle(ButtonStyle({
			inactive = "Resources/Renderers/Widget/Button/Ribbon-Pressed.9.png",
			hover = "Resources/Renderers/Widget/Button/Ribbon-Pressed.9.png",
			pressed = "Resources/Renderers/Widget/Button/Ribbon-Pressed.9.png",
			icon = { filename = self.icons[button], x = 0.5, y = 0.5 }
		}, self:getView():getResources()))

		self.activeButton = button
	end
end

return Ribbon
