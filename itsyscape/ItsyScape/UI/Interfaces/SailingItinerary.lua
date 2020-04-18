--------------------------------------------------------------------------------
-- ItsyScape/UI/Interfaces/SailingItinerary.lua
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
local Interface = require "ItsyScape.UI.Interface"
local Label = require "ItsyScape.UI.Label"
local LabelStyle = require "ItsyScape.UI.LabelStyle"
local Panel = require "ItsyScape.UI.Panel"
local PanelStyle = require "ItsyScape.UI.PanelStyle"
local ScrollablePanel = require "ItsyScape.UI.ScrollablePanel"
local ToolTip = require "ItsyScape.UI.ToolTip"
local Widget = require "ItsyScape.UI.Widget"

local SailingItinerary = Class(Interface)
SailingItinerary.WIDTH = 320

SailingItinerary.BUTTON_WIDTH  = 96
SailingItinerary.BUTTON_HEIGHT = 64

SailingItinerary.BUTTON_DISABLED = {
	inactive = "Resources/Renderers/Widget/Button/Disabled-Inactive.9.png",
	hover = "Resources/Renderers/Widget/Button/Disabled-Hover.9.png",
	pressed = "Resources/Renderers/Widget/Button/Disabled-Pressed.9.png",
	color = { 1, 1, 1, 1 },
	font = "Resources/Renderers/Widget/Common/DefaultSansSerif/Regular.ttf",
	fontSize = 24,
	textShadow = true,
	padding = 4
}

SailingItinerary.BUTTON_NORMAL = {
	inactive = "Resources/Renderers/Widget/Button/Default-Inactive.9.png",
	hover = "Resources/Renderers/Widget/Button/Default-Hover.9.png",
	pressed = "Resources/Renderers/Widget/Button/Default-Pressed.9.png",
	color = { 1, 1, 1, 1 },
	font = "Resources/Renderers/Widget/Common/DefaultSansSerif/Regular.ttf",
	fontSize = 24,
	textShadow = true,
	padding = 4
}

SailingItinerary.DESTINATION_STYLE = {
	font = "Resources/Renderers/Widget/Common/Serif/Bold.ttf",
	fontSize = 26,
	color = { 1, 1, 1, 1 },
	textShadow = true,
	width = SailingItinerary.WIDTH
}

SailingItinerary.DESTINATION_HEIGHT = 48

SailingItinerary.PADDING = 8

function SailingItinerary:new(id, index, ui)
	Interface.new(self, id, index, ui)

	local w, h = love.window.getMode()
	self:setPosition(w - SailingItinerary.WIDTH, 0)
	self:setSize(SailingItinerary.WIDTH, h)

	self.panel = Panel()
	self.panel:setSize(self:getSize())
	self:addChild(self.panel)

	self.destinationList = ScrollablePanel(GridLayout)
	self.destinationList:getInnerPanel():setWrapContents(true)
	self.destinationList:getInnerPanel():setPadding(0, SailingItinerary.PADDING)
	self.destinationList:getInnerPanel():setUniformSize(
		true,
		SailingItinerary.WIDTH - ScrollablePanel.DEFAULT_SCROLL_SIZE,
		SailingItinerary.DESTINATION_HEIGHT)
	self.destinationList:setSize(
		SailingItinerary.WIDTH,
		h - SailingItinerary.PADDING * 2 - SailingItinerary.BUTTON_HEIGHT)
	self:addChild(self.destinationList)

	self.actions = GridLayout()
	self.actions:setWrapContents(true)
	self.actions:setPadding(SailingItinerary.PADDING)
	self.actions:setUniformSize(
		true,
		SailingItinerary.BUTTON_WIDTH,
		SailingItinerary.BUTTON_HEIGHT)
	self.actions:setPosition(
		0,
		h - SailingItinerary.PADDING * 2 - SailingItinerary.BUTTON_HEIGHT)
	self.actions:setSize(
		SailingItinerary.WIDTH,
		SailingItinerary.BUTTON_HEIGHT)
	self:addChild(self.actions)

	self.saveButton = Button()
	self.saveButton.onClick:register(self.save, self)
	self.saveButton:setText("Save")
	self.saveButton:setToolTip(
		ToolTip.Text("Save the voyage itinerary and leave the map table."))
	self.actions:addChild(self.saveButton)

	self.sailButton = Button()
	self.sailButton.onClick:register(self.sail, self)
	self.sailButton:setText("Sail")
	self.sailButton:setToolTip(
		ToolTip.Text("Immediately begin the voyage."))
	self.actions:addChild(self.sailButton)

	self.discardButton = Button()
	self.discardButton.onClick:register(self.discard, self)
	self.discardButton:setText("Discard")
	self.discardButton:setToolTip(
		ToolTip.Text("Discard the current voyage itinerary."))
	self.actions:addChild(self.discardButton)

	self.destinations = {}

	self.canSail = nil
end

function SailingItinerary:update(...)
	Interface.update(self, ...)

	local state = self:getState()
	local numButtons = #state.destinations
	if numButtons < #self.destinations then
		while #self.destinations > numButtons do
			self.destinationList:removeChild(self.destinations[#self.destinations])
			table.remove(self.destinations, #self.destinations)
		end
	elseif numButtons > #self.destinations then
		while numButtons > #self.destinations do
			self:addDestination(#self.destinations + 1)
		end
	end

	if state.canSail ~= self.canSail then
		self.canSail = state.canSail

		if self.canSail then
			self.sailButton:setStyle(
				ButtonStyle(SailingItinerary.BUTTON_NORMAL,
				self:getView():getResources()))
		else
			self.sailButton:setStyle(
				ButtonStyle(SailingItinerary.BUTTON_DISABLED,
				self:getView():getResources()))
		end
	end
end

function SailingItinerary:addDestination(index)
	local panel = Panel()

	panel:setStyle(PanelStyle({
		image = false
	}), self:getView():getResources())

	local label = Label()
	label:setStyle(LabelStyle(SailingItinerary.DESTINATION_STYLE, self:getView():getResources()))
	label:setData("index", index)
	label:bind("text", "destinations[{index}].name")
	label:setPosition(SailingItinerary.PADDING, 0)
	panel:addChild(label)

	self.destinationList:addChild(panel)
	self.destinationList:setScrollSize(self.destinationList:getInnerPanel():getSize())

	table.insert(self.destinations, panel)
end

function SailingItinerary:save()
	self:sendPoke("save", nil, {})
end

function SailingItinerary:sail()
	self:sendPoke("sail", nil, {})
end

function SailingItinerary:discard()
	self:sendPoke("discard", nil, {})

	self.destinationList:setScroll(0, 0)
	self.destinationList:getInnerPanel():setScroll(0, 0)
end

return SailingItinerary
