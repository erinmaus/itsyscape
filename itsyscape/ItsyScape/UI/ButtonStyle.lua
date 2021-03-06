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
	self.colors = {}
	self.states = {}

	local function loadStateStyle(state)
		if t[state] then
			if Class.isType(t[state], Color) then
				self.colors[state] = Color(t[state]:get())
				self.states[state] = function(width, height)
					love.graphics.setColor(self.colors[state]:get())
					love.graphics.rectangle('fill', 0, 0, width, height)
				end
			elseif type(t[state]) == 'string' then
				self.images[state] = resources:load(patchy.load, t[state])
				self.states[state] = function(width, height)
					self.images[state]:draw(0, 0, width, height)
				end
			else
				self.states[state] = function() --[[ Nothing. ]] end
			end
		end
	end

	loadStateStyle('inactive')
	loadStateStyle('hover')
	loadStateStyle('pressed')

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
	self.textAlign = t.textAlign or 'center'
	self.textShadow = t.textShadow or false

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

	local isPressed
	do
		if type(widget.isPressed) == 'boolean' then
			isPressed = widget.isPressed
		elseif type(widget.isPressed) == 'table' then
			isPressed = #widget.isPressed > 0
		else
			isPressed = false
		end
	end

	local width, height = widget:getSize()
	if isPressed and self.states['pressed'] then
		self.states['pressed'](width, height)
	elseif (widget.isMouseOver or widget:getIsFocused())
	       and self.states['hover']
	then
		self.states['hover'](width, height)
	elseif self.states['inactive'] then
		self.states['inactive'](width, height)
	end

	if self.icon then
		local x = width * self.iconX
		local y = height * self.iconY
		local scaleX = self.iconWidth / self.icon:getWidth()
		local scaleY = self.iconHeight / self.icon:getHeight()
		love.graphics.draw(
			self.icon,
			x, y,
			0,
			scaleX, scaleY,
			self.icon:getWidth() / 2, self.icon:getHeight() / 2)
	end

	if #widget:getText() > 0 then
		local previousFont = love.graphics.getFont()
		local x = width * self.textX
		local y = height * self.textY

		local font = self.font or previousFont
		if self.font then
			love.graphics.setFont(self.font)
		end

		y = y - font:getHeight() / 2

		if self.textAlign == 'center' then
			x = x - width / 2
		elseif self.textAlign == 'right' then
			x = x - width
		else
			-- Nothing needed for 'left'.
		end

		if self.textShadow then
			love.graphics.setColor(0, 0, 0, 1)
			love.graphics.printf(
				widget:getText(),
				x + 1,
				y + 1,
				width,
				self.textAlign)
		end

		love.graphics.setColor(self.color:get())
		love.graphics.printf(
			widget:getText(),
			x,
			y,
			width,
			self.textAlign)

		love.graphics.setFont(previousFont)
	end
end

return ButtonStyle
