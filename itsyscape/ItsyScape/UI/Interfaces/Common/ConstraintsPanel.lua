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
ConstraintsPanel.BLACKLIST = {
	['prop'] = true
}

local function formatQuantity(number)
  local i, j, minus, int, fraction = tostring(number):find('([-]?)(%d+)([.]?%d*)')
  int = int:reverse():gsub("(%d%d%d)", "%1,")
  return minus .. int:reverse():gsub("^,", "") .. fraction
end

function ConstraintsPanel:new(view, config)
	Widget.new(self)

	self.view = view
	self.config = config or {}

	self.padding = ConstraintsPanel.DEFAULT_PADDING
	self.constraints = {}

	self.panel = Panel()
	self.panel:setStyle(PanelStyle({ image = false }, view:getResources()))
	self.panel:setSize(
		ConstraintsPanel.DEFAULT_WIDTH,
		(self.config.headerFontSize or ConstraintsPanel.TITLE_SIZE) + ConstraintsPanel.DEFAULT_PADDING)

	self.titleLabel = Label()
	self.titleLabel:setStyle(LabelStyle({
		fontSize = self.config.headerFontSize or ConstraintsPanel.TITLE_SIZE,
		font = "Resources/Renderers/Widget/Common/DefaultSansSerif/Bold.ttf",
		color = self.config.headerColor or { 1, 1, 1, 1 },
		textShadow = self.config.headerShadow == nil or self.config.headerShadow
	}, view:getResources()))
	self.panel:addChild(self.titleLabel)

	local _, lines = self.titleLabel:getStyle().font:getWrap(self.titleLabel:getText(), self:getSize())
	self.titleHeight = self.titleLabel:getStyle().font:getHeight() * #lines

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

	local _, titleLines = self.titleLabel:getStyle().font:getWrap(self.titleLabel:getText(), self:getSize())
	self.titleHeight = self.titleLabel:getStyle().font:getHeight() * #titleLines

	self.layout = GridLayout()
	self.layout:setWrapContents(true)
	self.layout:setPadding(self.padding)
	self.layout:setPosition(self.padding, self.padding + self.titleHeight)
	self.layout:setSize(width, 0)
	self.panel:addChild(self.layout)

	local leftWidth = 32
	local rightWidth = width - leftWidth - self.padding * 7
	local rowHeight = self.config.constraintFontSize * 2
	for i = 1, #self.constraints do
		local c = self.constraints[i]
		local isBlacklisted = ConstraintsPanel.BLACKLIST[c.type:lower()]

		if not isBlacklisted then
			local left
			if c.type:lower() == 'skill' then
				left = Icon()
				left:setIcon(string.format("Resources/Game/UI/Icons/Skills/%s.png", c.resource))
			elseif c.type:lower() == 'item' or c.type:lower() == 'ingredient' then
				left = ItemIcon()
				left:setItemID(c.resource)
			elseif c.type:lower() == 'quest' then
				left = Icon()
				left:setIcon("Resources/Game/UI/Icons/Things/Compass.png")
			elseif c.type:lower() == 'sailingitem' then
				left = Icon()
				left:setIcon(string.format("Resources/Game/SailingItems/%s/Icon.png", c.resource))
			else
				left = Widget()
			end
			self.layout:addChild(left)

			local right = Label()
			right:setStyle(LabelStyle({
				fontSize = self.config.constraintFontSize,
				font = "Resources/Renderers/Widget/Common/DefaultSansSerif/Regular.ttf",
				color = self.config.constraintColor,
				textShadow = self.config.constraintShadow == nil or false,
				width = rightWidth
			}, self.view:getResources()))
			if c.type:lower() == 'skill' then
				if self:getData('skillAsLevel', false) then
					local level = Curve.XP_CURVE:getLevel(c.count, 120)
					local text = string.format("Lvl %d %s", level, c.name)
					right:setText(text)
				else
					local text = string.format("+%s %s XP", formatQuantity(math.floor(c.count)), c.name)
					right:setText(text)
				end
			elseif c.type:lower() == 'item' then
				local text
				if c.count <= 1 then
					text = c.name
				else
					text = string.format("%s %s", formatQuantity(math.floor(c.count)), c.name)
				end
				right:setText(text)
			elseif c.type:lower() == 'keyitem' then
				right:setText(c.description or c.name)
			else
				local text
				if c.count <= 1 then
					text = c.name
				else
					text = string.format("%s %s", formatQuantity(c.count), c.name)
				end
				right:setText(text)
			end

			do
				local _, lines = right:getStyle().font:getWrap(right:getText(), rightWidth)
				right:setSize(rightWidth, #lines * right:getStyle().font:getHeight())
			end

			self.layout:addChild(right)
		end
	end

	do
		local layoutWidth, layoutHeight = self.layout:getSize()
		self:setSize(layoutWidth, layoutHeight + self.titleHeight)
		self.panel:setSize(self:getSize())
	end
end

return ConstraintsPanel
