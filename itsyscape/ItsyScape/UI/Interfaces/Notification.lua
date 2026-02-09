--------------------------------------------------------------------------------
-- ItsyScape/UI/Interfaces/Notification.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Interface = require "ItsyScape.UI.Interface"
local InputScheme = require "ItsyScape.UI.InputScheme"
local Panel = require "ItsyScape.UI.Panel"
local PanelStyle = require "ItsyScape.UI.PanelStyle"
local ScrollablePanel = require "ItsyScape.UI.ScrollablePanel"
local GridLayout = require "ItsyScape.UI.GridLayout"
local Widget = require "ItsyScape.UI.Widget"
local Theme = require "ItsyScape.UI.Interfaces.Theme"
local ConstraintsPanel = require "ItsyScape.UI.Interfaces.Common.ConstraintsPanel"

local Notification = Class(Interface)
Notification.WIDTH = 240
Notification.MAX_HEIGHT = 480

function Notification:new(id, index, ui)
	Interface.new(self, id, index, ui)

	self.panel = Panel()
	self.panel:setStyle(Theme.ERROR_NOTIFICATION_PANEL_STYLE, PanelStyle)
	self:addChild(self.panel)

	local state = self:getState()

	local requirements = ConstraintsPanel(self:getView(), Theme.STANDARD_CONSTRAINTS_CONFIG)
	requirements:setText("Requirements")
	requirements:setData("skillAsLevel", true)
	requirements:setSize(Theme.calculateSizeWithPadding(Theme.DEFAULT_OUTER_PADDING, self.WIDTH))
	requirements:setConstraints(state.requirements)

	local inputs = ConstraintsPanel(self:getView(), Theme.STANDARD_CONSTRAINTS_CONFIG)
	inputs:setText("Inputs")
	inputs:setConstraints(state.inputs)
	inputs:setSize(Theme.calculateSizeWithPadding(Theme.DEFAULT_OUTER_PADDING, self.WIDTH))
	inputs:setConstraints(state.inputs)

	local innerPannel = ScrollablePanel(GridLayout)
	innerPannel:getInnerPanel():setPadding(0, 0)
	innerPannel:getInnerPanel():setWrapContents(true)
	innerPannel:setSize(Notification.WIDTH, 0)
	innerPannel:setPosition(Theme.DEFAULT_OUTER_PADDING, Theme.DEFAULT_OUTER_PADDING)
	self:addChild(innerPannel)

	local width, height = 0, 0
	do
		local w1, h1 = requirements:getSize()
		local w2, h2 = inputs:getSize()

		if #state.requirements > 0 then
			innerPannel:addChild(requirements)
			requirements:setPosition(Theme.DEFAULT_OUTER_PADDING, Theme.DEFAULT_OUTER_PADDING)
			requirements:setSize(w1, h1 + Theme.DEFAULT_OUTER_PADDING)
			height = h1 + Theme.DEFAULT_OUTER_PADDING
		end

		if #state.inputs > 0 then
			innerPannel:addChild(inputs)
			inputs:setPosition(Theme.DEFAULT_OUTER_PADDING, h1 + Theme.DEFAULT_OUTER_PADDING * 2)
			inputs:setSize(w1, h2 + Theme.DEFAULT_OUTER_PADDING)
			height = height + h2 + Theme.DEFAULT_OUTER_PADDING
		end

		width = Notification.WIDTH
		height = math.min(height + Theme.DEFAULT_OUTER_PADDING, Notification.MAX_HEIGHT)

		innerPannel:setSize(width, height)
	end

	self:setSize(width, height)
	self.panel:setSize(self:getSize())

	self:setIsSelfClickThrough(true)
	self:setAreChildrenClickThrough(true)
end

function Notification:attach()
	Interface.attach(self)
	self:performLayout()
end

function Notification:performLayout()
	local x, y
	if self:getView():getCurrentInputScheme() == InputScheme.INPUT_SCHEME_GAMEPAD then
		local screenWidth, screenHeight = love.graphics.getScaledMode()
		x = (screenWidth - Notification.WIDTH) / 2
		y = screenHeight / 2 + screenHeight / 4
	else
		x, y = itsyrealm.graphics.getScaledPoint(itsyrealm.mouse.getPosition())
	end

	local width, height = self:getSize()
	self:setPosition(
		x + Theme.DEFAULT_OUTER_PADDING,
		y - Theme.DEFAULT_OUTER_PADDING - height)
	self:push()
end

function Notification:push()
	local x, y  = self:getPosition()
	local width, height = self.panel:getSize()

	local screenWidth, screenHeight = love.graphics.getScaledMode()

	if x < Theme.DEFAULT_OUTER_PADDING then
		x = Theme.DEFAULT_OUTER_PADDING
	end

	if y < Theme.DEFAULT_OUTER_PADDING then
		y = Theme.DEFAULT_OUTER_PADDING
	end

	if x + width > screenWidth then
		x = screenWidth - width - Theme.DEFAULT_OUTER_PADDING
	end

	if y + height > screenHeight then
		y = screenHeight - height - Theme.DEFAULT_OUTER_PADDING
	end

	self:setPosition(x, y)
end

return Notification
