--------------------------------------------------------------------------------
-- ItsyScape/UI/Interfaces/Common/ConstraintsPanel.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Curve = require "ItsyScape.Game.Curve"
local Icon = require "ItsyScape.UI.Icon"
local ItemIcon = require "ItsyScape.UI.ItemIcon"
local GridLayout = require "ItsyScape.UI.GridLayout"
local Label = require "ItsyScape.UI.Label"
local LabelStyle = require "ItsyScape.UI.LabelStyle"
local Panel = require "ItsyScape.UI.Panel"
local PanelStyle = require "ItsyScape.UI.PanelStyle"
local Widget = require "ItsyScape.UI.Widget"

local ConstraintsPanel = Class(Widget)
ConstraintsPanel.DEFAULT_WIDTH = 120
ConstraintsPanel.DEFAULT_PADDING = 4
ConstraintsPanel.TITLE_SIZE = 16

function ConstraintsPanel:new(view)
	Widget.new(self)

	self.view = view

	self.padding = ConstraintsPanel.DEFAULT_PADDING
	self.constraints = {}

	self.panel = Panel()
	self.panel:setStyle(PanelStyle({ image = false }, view:getResources()))
	self.panel:setSize(ConstraintsPanel.DEFAULT_WIDTH, ConstraintsPanel.TITLE_SIZE + ConstraintsPanel.DEFAULT_PADDING)

	self.titleLabel = Label()
	self.titleLabel:setStyle(LabelStyle({
		fontSize = 16,
		font = "Resources/Renderers/Widget/Common/DefaultSansSerif/Bold.ttf",
		textShadow = true
	}, view:getResources()))
	self.panel:addChild(self.titleLabel)

	self:addChild(self.panel)
end

function ConstraintsPanel:setText(...)
	Widget.setText(self, ...)

	self.titleLabel:setText(...)
end

function ConstraintsPanel:setPadding(value)
	self.padding = padding or value
	self.layout:setPadding(value)
	self:performLayout(true)
end

function ConstraintsPanel:setConstraints(value)
	self.constraints = value or self.constraints
	self:performLayout(true)
end

function ConstraintsPanel:getConstraints()
	return self.constraints
end

function ConstraintsPanel:performLayout(doLogic)
	Widget.performLayout(self)

	if not doLogic then
		return
	end

	if self.layout then
		self.panel:removeChild(self.layout)
	end

	local width, height = self:getSize()

	self.layout = GridLayout()
	self.layout:setWrapContents(true)
	self.layout:setPadding(self.padding)
	self.layout:setPosition(self.padding, self.padding + self.TITLE_SIZE)
	self.layout:setSize(width, 0)
	self.panel:addChild(self.layout)

	local leftWidth = 32
	local rightWidth = width - leftWidth - self.padding * 3
	local rowHeight = 32
	for i = 1, #self.constraints do
		local c = self.constraints[i]

		local left
		if c.type:lower() == 'skill' then
			left = Icon()
			left:setSize(leftWidth, rowHeight)
			left:setIcon(string.format("Resources/Game/UI/Icons/Skills/%s.png", c.resource))
		elseif c.type:lower() == 'item' then
			left = ItemIcon()
			left:setSize(leftWidth, rowHeight)
			left:setItemID(c.resource)
		else
			left = Widget()
			left:setSize(leftWidth, rowHeight)
		end
		self.layout:addChild(left)

		local right = Label()
		right:setStyle(LabelStyle({
			fontSize = 16,
			font = "Resources/Renderers/Widget/Common/DefaultSansSerif/Regular.ttf",
			width = rightWidth
		}, self.view:getResources()))
		if c.type:lower() == 'skill' then
			if self:getData('skillAsLevel', false) then
				local level = Curve.XP_CURVE:getLevel(c.count, 120)
				local text = string.format("Lvl %d %s", level, c.name)
				right:setText(text)
			else
				local text = string.format("+%d %s XP", math.floor(c.count), c.name)
				right:setText(text)
			end
		elseif c.type:lower() == 'item' then
			local text
			if c.count <= 1 then
				text = c.name
			else
				text = string.format("%dx %s", c.count, c.name)
			end
			right:setText(text)
		elseif c.type:lower() == 'keyitem' then
			right:setText(c.description or c.name)
		else
			local text
			if c.count <= 1 then
				text = c.name
			else
				text = string.format("%d %s", c.count, c.name)
			end
			right:setText(text)
		end
		do
			local _, lines = right:getStyle().font:getWrap(right:getText(), rightWidth)
			right:setSize(rightWidth, #lines * right:getStyle().font:getHeight())
		end

		self.layout:addChild(right)
	end

	do
		local layoutWidth, layoutHeight = self.layout:getSize()
		self:setSize(layoutWidth, layoutHeight + ConstraintsPanel.TITLE_SIZE * 2)
		self.panel:setSize(self:getSize())
	end
end

return ConstraintsPanel
