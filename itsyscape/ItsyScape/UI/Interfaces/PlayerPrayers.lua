--------------------------------------------------------------------------------
-- ItsyScape/UI/Interfaces/PlayerPrayers.lua
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
local Color = require "ItsyScape.Graphics.Color"
local ButtonStyle = require "ItsyScape.UI.ButtonStyle"
local Widget = require "ItsyScape.UI.Widget"
local DraggableButton = require "ItsyScape.UI.DraggableButton"
local GridLayout = require "ItsyScape.UI.GridLayout"
local Icon = require "ItsyScape.UI.Icon"
local Panel = require "ItsyScape.UI.Panel"
local PanelStyle = require "ItsyScape.UI.PanelStyle"
local ToolTip = require "ItsyScape.UI.ToolTip"
local PlayerTab = require "ItsyScape.UI.Interfaces.PlayerTab"

local PlayerPrayers = Class(PlayerTab)
PlayerPrayers.ICON_SIZE = 48
PlayerPrayers.PADDING = 8
PlayerPrayers.BUTTON_PADDING = 4

PlayerPrayers.INACTIVE_BUTTON_STYLE = {
	inactive = "Resources/Game/UI/Buttons/Button-Default.png",
	pressed = "Resources/Game/UI/Buttons/Button-Pressed.png",
	hover = "Resources/Game/UI/Buttons/Button-Hover.png",
}

PlayerPrayers.ACTIVE_BUTTON_STYLE = {
	inactive = "Resources/Game/UI/Buttons/ButtonActive-Default.png",
	pressed = "Resources/Game/UI/Buttons/ButtonActive-Pressed.png",
	hover = "Resources/Game/UI/Buttons/ButtonActive-Hover.png",
}

function PlayerPrayers:new(id, index, ui)
	PlayerTab.new(self, id, index, ui)

	self.buttons = {}
	self.numPrayers = 0
	self.onPrayersResized = Callback()

	self.layout = GridLayout()
	self.layout:setPadding(self.PADDING, self.PADDING)
	self.layout:setSize(self:getSize(), 0)
	self.layout:setWrapContents(true)
	self.layout:setUniformSize(
		true,
		PlayerPrayers.ICON_SIZE + PlayerPrayers.BUTTON_PADDING * 2,
		PlayerPrayers.ICON_SIZE + PlayerPrayers.BUTTON_PADDING * 2)

	self:addChild(self.layout)

	self.buttons = {}
end

function PlayerPrayers:getNumPrayers()
	return self.numPrayers
end

function PlayerPrayers:setNumPrayers(value)
	value = value or self.numPrayers
	assert(value >= 0 and value < math.huge, "too many or too little inventory value")

	if value ~= #self.buttons then
		if value < #self.buttons then
			while #self.buttons > value do
				local index = #self.buttons
				local top = self.buttons[index]

				self.layout:removeChild(top)
				table.remove(self.buttons, index)
			end
		else
			for i = #self.buttons + 1, value do
				local button = DraggableButton()
				local icon = Icon()
				icon:setSize(PlayerPrayers.ICON_SIZE, PlayerPrayers.ICON_SIZE)
				icon:setPosition(
					PlayerPrayers.BUTTON_PADDING,
					PlayerPrayers.BUTTON_PADDING)

				button:addChild(icon)
				button:setData("icon", icon)
				button:setData("index", i)
				button.onMouseEnter:register(self.hoverPrayer, self)
				button.onMouseLeave:register(self.unhoverPrayer, self)
				button.onLeftClick:register(self.togglePrayer, self)
				button.onDrag:register(self.drag, self)
				button.onDrop:register(self.drop, self)

				self.layout:addChild(button)
				table.insert(self.buttons, button)
			end
		end

		self.onPrayersResized(self, #self.buttons)
	end

	local state = self:getState()
	for i = 1, #self.buttons do
		local prayer = state.prayers[i]
		local button = self.buttons[i]

		button:setToolTip(
			ToolTip.Header(prayer.name),
			ToolTip.Text(prayer.description),
			ToolTip.Text(string.format("Requires level %d Faith.", prayer.level)))

		local icon = button:getData("icon")
		icon:setIcon(string.format("Resources/Game/Effects/%s/Icon.png", prayer.id))
	end

	self:performLayout()

	self.numPrayers = value
end

function PlayerPrayers:drag(button, x, y)
	if self:getView():getRenderManager():getCursor() ~= button:getData("icon") then
		self:getView():getRenderManager():setCursor(button:getData("icon"))
	end
end

function PlayerPrayers:drop(button, x, y)
	if self:getView():getRenderManager():getCursor() == button:getData("icon") then
		self:getView():getRenderManager():setCursor(nil)
	end
end

function PlayerPrayers:hoverPrayer(button)
	-- Nothing.
end

function PlayerPrayers:unhoverPrayer(button)
	-- Nothing.
end

function PlayerPrayers:togglePrayer(button)
	local index = button:getData("index")
	local prayers = self:getState().prayers or {}
	local prayer = prayers[index]
	if prayer then
		self:sendPoke("toggle", nil, { prayer = prayer.id })
	end
end

function PlayerPrayers:update(...)
	PlayerTab.update(self, ...)

	local state = self:getState()
	for i = 1, #self.buttons do
		local prayer = state.prayers[i]
		local button = self.buttons[i]
		local icon = button:getData("icon")
		local active = button:getData("active")

		if prayer then
			if prayer.isActive and (not active or active == nil) then
				button:setStyle(self.ACTIVE_BUTTON_STYLE, ButtonStyle)
			elseif not prayer.isActive and (active or active == nil) then
				button:setStyle(self.INACTIVE_BUTTON_STYLE, ButtonStyle)
			end

			if prayer.enabled then
				icon:setColor(Color(1))
			else
				icon:setColor(Color(0.3))
			end

			button:setData("active", prayer.isActive)
		end
	end
end

return PlayerPrayers
