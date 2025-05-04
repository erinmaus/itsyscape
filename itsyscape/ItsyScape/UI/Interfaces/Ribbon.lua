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
local Button = require "ItsyScape.UI.Button"
local ButtonStyle = require "ItsyScape.UI.ButtonStyle"
local Icon = require "ItsyScape.UI.Icon"
local Interface = require "ItsyScape.UI.Interface"
local GridLayout = require "ItsyScape.UI.GridLayout"
local Panel = require "ItsyScape.UI.Panel"
local PanelStyle = require "ItsyScape.UI.PanelStyle"
local ToolTip = require "ItsyScape.UI.ToolTip"
local Widget = require "ItsyScape.UI.Widget"

local Ribbon = Class(Interface)
Ribbon.BUTTON_SIZE = 64
Ribbon.PADDING = 8
Ribbon.BUTTON_PADDING = 4
Ribbon.TOOL_TIPS = {
	["PlayerPowers"] = {
		ToolTip.Header("Powers"),
		ToolTip.Text("Use offensive and defensive powers.")
	},
	["PlayerStance"] = {
		ToolTip.Header("Stance"),
		ToolTip.Text("View or change your combat stance.")
	},
	["PlayerInventory"] = {
		ToolTip.Header("Inventory"),
		ToolTip.Text("See the items you are currently carrying.")
	},
	["PlayerEquipment"] = {
		ToolTip.Header("Equipment"),
		ToolTip.Text("View, interact with, and remove your equipment."),
		ToolTip.Text("You can also see your equipment bonuses.")
	},
	["PlayerStats"] = {
		ToolTip.Header("Stats"),
		ToolTip.Text("View your stats and see helpful skill guides.")
	},
	["PlayerSpells"] = {
		ToolTip.Header("Spells"),
		ToolTip.Text("Cast spells and set your combat spells.")
	},
	["PlayerPrayers"] = {
		ToolTip.Header("Prayers"),
		ToolTip.Text("View available prayers and toggle them.")
	},
	["Nominomicon"] = {
		ToolTip.Header("Nominomicon"),
		ToolTip.Text("View your quest progress.")
	},
	["PlayerConfig"] = {
		ToolTip.Header("Settings & Exit"),
		ToolTip.Text("Show settings and an option to exit the game.")
	}
}

Ribbon.INACTIVE_BUTTON_STYLE = {
	inactive = "Resources/Game/UI/Buttons/Button-Default.png",
	pressed = "Resources/Game/UI/Buttons/Button-Pressed.png",
	hover = "Resources/Game/UI/Buttons/Button-Hover.png",
}

Ribbon.ACTIVE_BUTTON_STYLE = {
	inactive = "Resources/Game/UI/Buttons/ButtonActive-Default.png",
	pressed = "Resources/Game/UI/Buttons/ButtonActive-Pressed.png",
	hover = "Resources/Game/UI/Buttons/ButtonActive-Hover.png",
}

Ribbon.PANEL_STYLE = {
	image = "Resources/Game/UI/Panels/SideRibbon.png"
}

function Ribbon:new(id, index, ui)
	Interface.new(self, id, index, ui)

	self.panel = Panel()
	self.panel:setStyle(self.PANEL_STYLE, PanelStyle)
	self:addChild(self.panel)

	self.layout = GridLayout()
	self.layout:setPadding(self.PADDING, self.PADDING)
	self.layout:setSize(self.BUTTON_SIZE + self.PADDING * 2, 0)
	self.layout:setUniformSize(true, self.BUTTON_SIZE, self.BUTTON_SIZE)
	self.layout:setWrapContents(true)
	self:addChild(self.layout)

	self.icons = {}
	self.buttons = {}
	self.activeButton = false

	self:addButton("PlayerPowers", "Resources/Game/UI/Icons/Concepts/Powers.png")
	self:addButton("PlayerStance", "Resources/Game/UI/Icons/Common/Stance.png")
	self:addButton("PlayerInventory", "Resources/Game/UI/Icons/Common/Inventory.png")
	self:addButton("PlayerEquipment", "Resources/Game/UI/Icons/Common/Equipment.png")
	self:addButton("PlayerStats", "Resources/Game/UI/Icons/Common/Skills.png")
	self:addButton("PlayerSpells", "Resources/Game/UI/Icons/Skills/Magic.png")
	self:addButton("PlayerPrayers", "Resources/Game/UI/Icons/Skills/Faith.png")
	self:addButton("PlayerConfig", "Resources/Game/UI/Icons/Concepts/Settings.png")

	self:performLayout()
end

function Ribbon:performLayout()
	Interface.performLayout(self)

	self:setSize(self.layout:getSize())
	self.panel:setSize(self.layout:getSize())

	local panelWidth, panelHeight = self:getSize()
	local screenWidth, screenHeight = itsyrealm.graphics.getScaledMode()
	self:setPosition(screenWidth - panelWidth, screenHeight - panelHeight)
end

function Ribbon:addButton(tab, iconID)
	local button = Button()
	button:setID('Ribbon-' .. tab)
	button:setPosition(x, Ribbon.PADDING)
	button.onClick:register(function()
		if self.activeButton ~= button then
			self:sendPoke("open", nil, { tab = tab })
		else
			self:sendPoke("close", nil, {})
		end
	end)

	if self.TOOL_TIPS[tab] then
		button:setToolTip(unpack(self.TOOL_TIPS[tab]))
	end

	local icon = Icon()
	icon:setSize(
		self.BUTTON_SIZE - self.BUTTON_PADDING * 2,
		self.BUTTON_SIZE - self.BUTTON_PADDING * 2)
	icon:setIcon(iconID)
	icon:setPosition(self.BUTTON_PADDING, self.BUTTON_PADDING)
	button:addChild(icon)

	button:setStyle(self.INACTIVE_BUTTON_STYLE, ButtonStyle)

	self.layout:addChild(button)
	self.buttons[tab] = button
end

function Ribbon:activate(tab)
	if self.activeButton then
		self.activeButton:setStyle(self.INACTIVE_BUTTON_STYLE, ButtonStyle)
	end

	self.activeButton = false

	local button = self.buttons[tab]
	if button then
		button:setStyle(self.ACTIVE_BUTTON_STYLE, ButtonStyle)
		self.activeButton = button
	end
end

return Ribbon
