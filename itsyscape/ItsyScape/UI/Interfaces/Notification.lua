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
local Panel = require "ItsyScape.UI.Panel"
local PanelStyle = require "ItsyScape.UI.PanelStyle"
local ScrollablePanel = require "ItsyScape.UI.ScrollablePanel"
local GridLayout = require "ItsyScape.UI.GridLayout"
local Widget = require "ItsyScape.UI.Widget"
local ConstraintsPanel = require "ItsyScape.UI.Interfaces.Common.ConstraintsPanel"

local Notification = Class(Interface)
Notification.WIDTH = 240
Notification.MAX_HEIGHT = 480
Notification.PADDING = 4
Notification.BOTTOM = 16

function Notification:new(id, index, ui)
	Interface.new(self, id, index, ui)

	local w, h = love.graphics.getScaledMode()
	local x, y = love.graphics.getScaledPoint(love.mouse.getPosition())

	local panel = Panel()
	panel:setStyle(PanelStyle({
		image = "Resources/Renderers/Widget/Panel/Notification.9.png"
	}, self:getView():getResources()))
	self:addChild(panel)

	local state = self:getState()

	local requirements = ConstraintsPanel(self:getView())
	requirements:setText("Requirements")
	requirements:setData("skillAsLevel", true)
	requirements:setSize(Notification.WIDTH + Notification.PADDING * 2)
	requirements:setConstraints(state.requirements)

	local inputs = ConstraintsPanel(self:getView())
	inputs:setText("Inputs")
	inputs:setConstraints(state.inputs)
	inputs:setSize(Notification.WIDTH + Notification.PADDING * 2)
	inputs:setConstraints(state.inputs)

	local innerPannel = ScrollablePanel(GridLayout)
	innerPannel:getInnerPanel():setPadding(0, 0)
	innerPannel:getInnerPanel():setWrapContents(true)
	innerPannel:setSize(Notification.WIDTH, 0)
	innerPannel:setPosition(Notification.PADDING, Notification.PADDING)
	self:addChild(innerPannel)

	local width, height = 0, 0
	do
		local w1, h1 = requirements:getSize()
		local w2, h2 = inputs:getSize()

		if #state.requirements > 0 then
			innerPannel:addChild(requirements)
			requirements:setPosition(Notification.PADDING, Notification.PADDING)
			requirements:setSize(w1, h1 + Notification.PADDING)
			height = h1 + Notification.PADDING
		end

		if #state.inputs > 0 then
			innerPannel:addChild(inputs)
			inputs:setPosition(Notification.PADDING, h1 + Notification.PADDING * 2)
			inputs:setSize(w1, h2 + Notification.PADDING)
			height = height + h2 + Notification.PADDING
		end

		width = Notification.WIDTH
		height = math.min(height, Notification.MAX_HEIGHT)

		innerPannel:setSize(width, height)
	end

	self:setSize(width, height + Notification.BOTTOM)
	panel:setSize(self:getSize())

	self:setPosition(
		x + Notification.PADDING,
		y - Notification.PADDING - height - Notification.BOTTOM)

	self:setSize(0, 0)
end

function Notification:getOverflow()
	return true
end

return Notification
