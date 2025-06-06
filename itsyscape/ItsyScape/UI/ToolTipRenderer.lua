--------------------------------------------------------------------------------
-- ItsyScape/UI/ToolTipRenderer.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Color = require "ItsyScape.Graphics.Color"
local WidgetRenderer = require "ItsyScape.UI.WidgetRenderer"
local PanelStyle = require "ItsyScape.UI.PanelStyle"
local ToolTip = require "ItsyScape.UI.ToolTip"
local patchy = require "patchy"

local ToolTipRenderer = Class(WidgetRenderer)
ToolTipRenderer.OFFSET_X = 32
ToolTipRenderer.OFFSET_Y = 32

function ToolTipRenderer:new(resources)
	WidgetRenderer.new(self, resources)

	self.toolTipBorder = resources:load(patchy.load, "Resources/Game/UI/Panels/ToolTip.png")
	self.headerFont = resources:load(love.graphics.newFont, "Resources/Renderers/Widget/Common/DefaultSansSerif/SemiBold.ttf", 24)
	self.textFont = resources:load(love.graphics.newFont, "Resources/Renderers/Widget/Common/DefaultSansSerif/Regular.ttf", 22)
	self.maxWidth = 320
	self.padding = 8
end

function ToolTipRenderer:layout(widget)
	local result = {}

	local maxWidth = 0

	local y = 0
	local values = widget:getValues()
	for i = 1, values.n do
		local value = values[i]
		if Class.isType(value, ToolTip.Header) then
			local width, lines = self.headerFont:getWrap(value.text, self.maxWidth)
			maxWidth = math.min(math.max(width, maxWidth), self.maxWidth)

			local textY = y
			table.insert(result, function()
				love.graphics.setFont(self.headerFont)
				if value.shadow then
					love.graphics.setColor(0, 0, 0, 1)
					itsyrealm.graphics.printf(value.text, 1, textY + 1, maxWidth)
				end
				love.graphics.setColor(value.color:get())
				itsyrealm.graphics.printf(value.text, 0, textY, maxWidth)
			end)

			height = #lines * self.headerFont:getLineHeight() * self.headerFont:getHeight()
			y = y + height + self.padding
		elseif Class.isType(value, ToolTip.Text) or type(value) == 'string' then
			local text, shadow, color
			if type(value) == 'string' then
				text = value
				shadow = false
				color = Color(1, 1, 1, 1)
			else
				text = value.text
				shadow = value.shadow
				color = value.color
			end

			local width, lines = self.textFont:getWrap(text, self.maxWidth)
			maxWidth = math.min(math.max(width, maxWidth), self.maxWidth)

			local textY = y
			table.insert(result, function()
				love.graphics.setFont(self.textFont)
				if shadow then
					love.graphics.setColor(0, 0, 0, 1)
					itsyrealm.graphics.printf(text, 1, textY + 1, maxWidth)
				end
				love.graphics.setColor(color:get())
				itsyrealm.graphics.printf(text, 0, textY, maxWidth, 'left')
			end)

			height = #lines * self.textFont:getLineHeight() * self.textFont:getHeight()
			y = y + height + self.padding
		end
	end

	return result, maxWidth, y
end

function ToolTipRenderer:draw(widget, state)
	self:visit(widget)

	local previousFont = love.graphics.getFont()

	local draw, width, height = self:layout(widget)
	width = width + self.padding * 2
	height = height + self.padding * 2

	local currentWidth, currentHeight = widget:getSize()
	if currentWidth == 0 and currentHeight == 0 then
		widget:setSize(width, height)
		widget:onLayout()
	end

	local screenWidth, screenHeight, scale = love.graphics.getScaledMode()
	local sx, sy = itsyrealm.graphics.transformPoint(ToolTipRenderer.OFFSET_X, ToolTipRenderer.OFFSET_Y)
	sx = sx / scale
	sy = sy / scale

	if sx + width > screenWidth then
		itsyrealm.graphics.translate(screenWidth - (sx + width), 0)
	end
	if sy + height > screenHeight then
		itsyrealm.graphics.translate(0, screenHeight - (sy + height))
	end

	itsyrealm.graphics.translate(ToolTipRenderer.OFFSET_X, ToolTipRenderer.OFFSET_Y)

	local image
	do
		local style = widget:getStyle()
		if style and Class.isType(style, PanelStyle) then
			image = style.image
		else
			image = self.toolTipBorder
		end
	end

	itsyrealm.graphics.translate(-self.padding, -self.padding)
	itsyrealm.graphics.pushInterface(width, height)

	image:draw(0, 0, width, height)

	itsyrealm.graphics.translate(self.padding, self.padding)

	for i = 1, #draw do
		draw[i]()
	end

	love.graphics.setFont(previousFont)
	love.graphics.setColor(1, 1, 1, 1)

	if sx + width > screenWidth then
		itsyrealm.graphics.translate(-(screenWidth - (sx + width)), 0)
	end
	if sy + height > screenHeight then
		itsyrealm.graphics.translate(0, -(screenHeight - (sy + height)))
	end

	itsyrealm.graphics.translate(-ToolTipRenderer.OFFSET_X, -ToolTipRenderer.OFFSET_Y)
end

return ToolTipRenderer
