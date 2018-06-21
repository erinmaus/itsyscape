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
local TextInput = require "ItsyScape.UI.TextInput"
local WidgetStyle = require "ItsyScape.UI.WidgetStyle"
local patchy = require "patchy"

local TextButtonStyle = Class(WidgetStyle)
function TextButtonStyle:new(t, resources)
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
	loadStateStyle('active')
	loadStateStyle('hover')

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

	self.textShadow = t.textShadow or false
	self.selectionColor = Color(unpack(t.selectionColor)) or Color(0.5, 0.5, 0.5, 0.5)
	self.padding = t.padding or 4
end

function TextButtonStyle:draw(widget)
	local width, height = widget:getSize()

	if widget:getIsFocused() and self.states['active'] then
		self.states['active'](width, height)
	elseif widget.isMouseOver and self.states['hover'] then
		self.states['hover'](width, height)
	elseif self.states['inactive'] then
		self.states['inactive'](width, height)
	end

	do
		local x, y = love.graphics.getScissor()
		love.graphics.intersectScissor(
			x + self.padding, y + self.padding,
			width - self.padding * 2,
			height - self.padding * 2)
		love.graphics.translate(self.padding, self.padding)
	end

	if #widget:getText() > 0 then
		local previousFont = love.graphics.getFont()

		local font = self.font or previousFont
		if self.font then
			love.graphics.setFont(self.font)
		end

		local textX, textY
		local cursorX, cursorY
		local selectionX, selectionY, selectionWidth
		local textWidth
		do
			local leftCursor = widget:getLeftCursor()
			local rightCursor = widget:getRightCursor()
			local activeCursor

			if widget:getActiveCursor() == TextInput.CURSOR_RIGHT then
				activeCursor = rightCursor
			else
				activeCursor = leftCursor
			end

			local cursorPosition = font:getWidth(widget:getText():sub(1, activeCursor))

			if leftCursor == rightCursor then
				selectionWidth = 0
			else
				selectionWidth = font:getWidth(widget:getText():sub(leftCursor + 1, rightCursor))
			end

			selectionX = font:getWidth(widget:getText():sub(1, leftCursor))

			if cursorPosition > width / 2 then
				textX = -(cursorPosition - width / 2)
				cursorX = width / 2
				selectionX = selectionX + textX
			else
				textX = 0
				cursorX = cursorPosition
			end

			textY = height / 2 - font:getHeight() / 2
			cursorY = textY
			selectionY = textY

			textWidth = font:getWidth(widget:getText())
		end

		if selectionWidth > 0 then
			love.graphics.setColor(self.selectionColor:get())
			love.graphics.rectangle(
				'fill',
				selectionX, selectionY,
				selectionWidth, font:getHeight())
		end

		if self.textShadow then
			love.graphics.setColor(0, 0, 0, 1)
			love.graphics.printf(
				widget:getText(),
				textX + 1,
				textY + 1,
				textWidth,
				self.textAlign)
		end

		love.graphics.setColor(self.color:get())
		love.graphics.printf(
			widget:getText(),
			textX,
			textY,
			textWidth,
			self.textAlign)

		if widget:getIsFocused() then
			local alpha = math.abs(math.sin(love.timer.getTime() * math.pi))
			love.graphics.setColor(self.color.r, self.color.b, self.color.g, alpha)
			love.graphics.line(cursorX, cursorY, cursorX, cursorY + font:getHeight())
		end

		love.graphics.setFont(previousFont)
	end
end

return TextButtonStyle
