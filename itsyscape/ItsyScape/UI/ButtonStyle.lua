--------------------------------------------------------------------------------
-- ItsyScape/UI/DraggablePanel.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Color = require "ItsyScape.Graphics.Color"
local WidgetStyle = require "ItsyScape.UI.WidgetStyle"
local patchy = require "patchy"

local ButtonStyle = Class(WidgetStyle)
function ButtonStyle:new(t, resources)
	self.images = {}
	if t.inactive then
		self.images['inactive'] = resources:load(patchy.load, t.inactive)
	else
		self.images['inactive'] = false
	end

	if t.hover then
		self.images['hover'] = resources:load(patchy.load, t.hover)
	else
		self.images['hover'] = false
	end

	if t.pressed then
		self.images['pressed'] = resources:load(patchy.load, t.pressed)
	else
		self.images['pressed'] = false
	end

	if t.color then
		self.color = Color(unpack(t.color))
	else
		self.color = Color(1, 1, 1, 1)
	end

	if t.font then
		self.font = resources:load(love.graphics.newFont, t.font, t.fontSize or 12)
	else
		self.font = false
	end

	self.textX = t.textX or 0.5
	self.textY = t.textY or 0.5

	if t.icon and type(t.icon) == 'table' and t.icon.filename then
		self.icon = resources:load(love.graphics.newImage, t.icon.filename)
		self.iconX = t.icon.x or 0.0
		self.iconY = t.icon.y or 0.5
		self.iconWidth = t.icon.width or self.icon:getWidth()
		self.iconHeight = t.icon.height or self.icon:getHeight()
	else
		self.icon = false
	end
end

function ButtonStyle:draw(widget)
	love.graphics.setColor(1, 1, 1, 1)

	local width, height = widget:getSize()
	if widget.isPressed and self.images['pressed'] then
		self.images['pressed']:draw(0, 0, width, height)
	elseif (widget.isMouseOver or widget:getIsFocused())
	       and self.images['hover']
	then
		self.images['hover']:draw(0, 0, width, height)
	elseif self.images['inactive'] then
		self.images['inactive']:draw(0, 0, width, height)
	end

	if self.icon then
		local x = width * self.iconX - self.iconWidth / 2
		local y = height * self.iconY - self.iconHeight / 2
		local scaleX = self.iconWidth / self.icon:getWidth()
		local scaleY = self.iconHeight / self.icon:getHeight()
		love.graphics.draw(self.icon, x, y, 0, scaleX, scaleY, self.iconWidth / 2, self.iconHeight / 2)
	end

	love.graphics.setColor(self.color:get())
	if #widget:getText() > 0 then
		local previousFont = love.graphics.getFont()
		local x = width * self.textX
		local y = height * self.textY

		local font = self.font or previousFont
		if self.font then
			love.graphics.setFont(self.font)
		end

		love.graphics.printf(
			widget:getText(),
			x - width / 2,
			y - font:getHeight() / 2,
			width,
			'center')
		love.graphics.setFont(previousFont)
	end
end

return ButtonStyle
