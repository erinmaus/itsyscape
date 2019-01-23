--------------------------------------------------------------------------------
-- ItsyScape/UI/Interfaces/Nominomicon.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Utility = require "ItsyScape.Game.Utility"
local Button = require "ItsyScape.UI.Button"
local ButtonStyle = require "ItsyScape.UI.ButtonStyle"
local GridLayout = require "ItsyScape.UI.GridLayout"
local Label = require "ItsyScape.UI.Label"
local LabelStyle = require "ItsyScape.UI.LabelStyle"
local Interface = require "ItsyScape.UI.Interface"
local Panel = require "ItsyScape.UI.Panel"
local PanelStyle = require "ItsyScape.UI.PanelStyle"
local ToolTip = require "ItsyScape.UI.ToolTip"

local Nominomicon = Class(Interface)
Nominomicon.WIDTH = 480
Nominomicon.HEIGHT = 320
Nominomicon.BUTTON_SIZE = 48
Nominomicon.BUTTON_PADDING = 4
Nominomicon.PADDING = 4

Nominomicon.INACTIVE_BUTTON_STYLE = {
	pressed = "Resources/Renderers/Widget/Button/Default-Pressed.9.png",
	inactive = "Resources/Renderers/Widget/Button/Default-Inactive.9.png",
	hover = "Resources/Renderers/Widget/Button/Default-Hover.9.png",
	font = "Resources/Renderers/Widget/Common/DefaultSansSerif/Bold.ttf",
	fontSize = 16,
	textShadow = true
}

Nominomicon.ACTIVE_BUTTON_STYLE = {
	pressed = "Resources/Renderers/Widget/Button/ActiveDefault-Pressed.9.png",
	inactive = "Resources/Renderers/Widget/Button/ActiveDefault-Inactive.9.png",
	hover = "Resources/Renderers/Widget/Button/ActiveDefault-Hover.9.png",
	font = "Resources/Renderers/Widget/Common/DefaultSansSerif/Bold.ttf",
	fontSize = 16,
	textShadow = true
}

function Nominomicon:new(id, index, ui)
	Interface.new(self, id, index, ui)

	local w, h = love.window.getMode()
	local WIDTH = math.max(math.floor(w / 2), Nominomicon.WIDTH)
	local HEIGHT = math.max(math.floor(h / 2), Nominomicon.HEIGHT)

	self:setSize(WIDTH, HEIGHT)
	self:setPosition(
		(w - WIDTH) / 2,
		(h - HEIGHT) / 2)

	local panel = Panel()
	panel:setSize(self:getSize())
	self:addChild(panel)

	self.grid = ScrollablePanel(GridLayout)
	self.grid:getInnerPanel():setUniformSize(
		true,
		WIDTH * (1 / 2) - ScrollablePanel.DEFAULT_SCROLL_SIZE - Nominomicon.PADDING * 2,
		Nominomicon.BUTTON_SIZE + Nominomicon.BUTTON_PADDING * 2)
	self.grid:getInnerPanel():setWrapContents(true)
	self.grid:getInnerPanel():setPadding(Nominomicon.BUTTON_PADDING)
	self.grid:setSize(WIDTH * (1 / 2), HEIGHT)
	self:addChild(self.grid)

	self.infoPanel = ScrollablePanel(GridLayout)
	self.infoPanel:getInnerPanel():setWrapContents(true)
	self.infoPanel:getInnerPanel():setPadding(0, 0)
	self.infoPanel:getInnerPanel():setSize(WIDTH * (1 / 2), 0)
	self.infoPanel:setPosition(WIDTH * (1 / 2), 0)
	self.infoPanel:setSize(WIDTH * (1 / 2), HEIGHT)
	self:addChild(self.infoPanel)

	self.closeButton = Button()
	self.closeButton:setSize(Nominomicon.BUTTON_SIZE, Nominomicon.BUTTON_SIZE)
	self.closeButton:setPosition(WIDTH - Nominomicon.BUTTON_SIZE, 0)
	self.closeButton:setText("X")
	self.closeButton.onClick:register(function()
		self:sendPoke("close", nil, {})
	end)
	self:addChild(self.closeButton)

	self.ready = false
	self.activeItem = false
	self.previousSelection = false
end

function SkillGuide:update(...)
	Interface.update(self, ...)

	if not self.ready then
		local state = self:getState()

		for i = 1, #state.quests do
			local quest = state.quests[i]

			local button = Button()
			button:setText(quest.name)
			button:setToolTip(
				ToolTip.Header(quest.name),
				ToolTip.Text(quest.description))

			button:setStyle(
				ButtonStyle(
					Nominomicon.INACTIVE_BUTTON_STYLE,
					self:getView():getResources()))

			self.grid:addChild(button)
		end
	end
end

function Nominomicon:selectItem(index, button)
	if self.previousSelection then
		self.previousSelection:setStyle(
			ButtonStyle(
				Nominomicon.INACTIVE_BUTTON_STYLE,
				self:getView():getResources()))
	end

	if self.previousSelection ~= button then
		button:setStyle(
			ButtonStyle(
				Nominomicon.ACTIVE_BUTTON_STYLE,
				self:getView():getResources()))

		self.activeItem = index
		self.previousSelection = button

		self:sendPoke("select", nil, { index = index })
	else
		self.activeItem = false
		self.previousSelection = false
		self:populateRequirements({
			requirements = {},
			inputs = {},
			outputs = {}
		})
	end
end

return Nominomicon