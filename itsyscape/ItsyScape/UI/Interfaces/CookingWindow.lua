--------------------------------------------------------------------------------
-- ItsyScape/UI/Interfaces/CookingWindow.lua
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
local GridLayout = require "ItsyScape.UI.GridLayout"
local Label = require "ItsyScape.UI.Label"
local LabelStyle = require "ItsyScape.UI.LabelStyle"
local Interface = require "ItsyScape.UI.Interface"
local ItemIcon = require "ItsyScape.UI.ItemIcon"
local Panel = require "ItsyScape.UI.Panel"
local PanelStyle = require "ItsyScape.UI.PanelStyle"
local ScrollablePanel = require "ItsyScape.UI.ScrollablePanel"
local TextInput = require "ItsyScape.UI.TextInput"
local ToolTip = require "ItsyScape.UI.ToolTip"
local ConstraintsPanel = require "ItsyScape.UI.Interfaces.Common.ConstraintsPanel"

local CookingWindow = Class(Interface)

CookingWindow.WIDTH  = 800
CookingWindow.HEIGHT = 480

CookingWindow.BUTTON_SIZE    = 48
CookingWindow.BUTTON_PADDING = 8

CookingWindow.INACTIVE_BUTTON_STYLE = {
	pressed = "Resources/Renderers/Widget/Button/Default-Pressed.9.png",
	inactive = "Resources/Renderers/Widget/Button/Default-Inactive.9.png",
	hover = "Resources/Renderers/Widget/Button/Default-Hover.9.png",
	font = "Resources/Renderers/Widget/Common/DefaultSansSerif/Bold.ttf",
	fontSize = 16,
	textShadow = true
}

CookingWindow.ACTIVE_BUTTON_STYLE = {
	pressed = "Resources/Renderers/Widget/Button/ActiveDefault-Pressed.9.png",
	inactive = "Resources/Renderers/Widget/Button/ActiveDefault-Inactive.9.png",
	hover = "Resources/Renderers/Widget/Button/ActiveDefault-Hover.9.png",
	font = "Resources/Renderers/Widget/Common/DefaultSansSerif/Bold.ttf",
	fontSize = 16,
	textShadow = true
}

function CookingWindow:new(id, index, ui)
	Interface.new(self, id, index, ui)

	local width, height = love.graphics.getScaledMode()

	self:setPosition(
		width / 2 - CookingWindow.WIDTH / 2,
		height / 2 - CookingWindow.HEIGHT / 2)
	self:setSize(CookingWindow.WIDTH, CookingWindow.HEIGHT)

	self.panel = Panel()
	self.panel:setSize(CookingWindow.WIDTH, CookingWindow.HEIGHT)
	self:addChild(self.panel)

	self.closeButton = Button()
	self.closeButton:setSize(CookingWindow.BUTTON_SIZE, CookingWindow.BUTTON_SIZE)
	self.closeButton:setPosition(CookingWindow.WIDTH - CookingWindow.BUTTON_SIZE, 0)
	self.closeButton:setText("X")
	self.closeButton.onClick:register(function()
		self:sendPoke("close", nil, {})
	end)
	self:addChild(self.closeButton)

	self.grid = ScrollablePanel(GridLayout)
	self.grid:getInnerPanel():setWrapContents(true)
	self.grid:getInnerPanel():setPadding(CookingWindow.BUTTON_PADDING)
	self.grid:getInnerPanel():setUniformSize(
		true,
		CookingWindow.WIDTH * (1 / 3) - CookingWindow.BUTTON_PADDING * 2,
		CookingWindow.BUTTON_SIZE)
	self.grid:setSize(CookingWindow.WIDTH * (1 / 3), CookingWindow.HEIGHT)
	self:addChild(self.grid)

	local state = self:getState()
	if state and state.recipes then
		for i = 1, #state.recipes do
			local recipe = state.recipes[i]
			local item = recipe.output or recipe

			local button = Button()
			button:setText(item.name)
			button:setToolTip(ToolTip.Header(item.name), ToolTip.Text(item.description))
			button:setStyle(ButtonStyle(
				CookingWindow.INACTIVE_BUTTON_STYLE,
				self:getView():getResources()))

			local itemIcon = ItemIcon()
			itemIcon:setItemID(item.resource)
			button:addChild(itemIcon)

			self.grid:addChild(button)
		end
	end
end

return CookingWindow
