--------------------------------------------------------------------------------
-- ItsyScape/UI/TextInputStyle.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local utf8 = require "utf8"
local Class = require "ItsyScape.Common.Class"
local Config = require "ItsyScape.Game.Config"
local Color = require "ItsyScape.Graphics.Color"
local TextInput = require "ItsyScape.UI.TextInput"
local WidgetStyle = require "ItsyScape.UI.WidgetStyle"
local patchy = require "patchy"

local LabelStyle = Class(WidgetStyle)
function LabelStyle:new(t, resources)
	if t.color then
		self.color = Color(unpack(t.color))
	else
		self.color = Color(1, 1, 1, 1)
	end

	if t.font then
		self.font = resources:load(love.graphics.newFont, t.font, t.fontSize or 12)
		if t.lineHeight then
			self.font:setLineHeight(t.lineHeight)
		end
	else
		self.font = false
	end

	if t.width then
		self.width = t.width
	end

	self.textShadow = t.textShadow or false
	self.spaceLines = t.spaceLines or false
	self.minJustifyLineWidthPercent = t.minJustifyLineWidthPercent or 0.75

	self.align = t.align or "left"
	self.shrink = t.shrink or false
	self.center = t.center or false
end

function LabelStyle:draw(widget, state)
	local text = widget:get("text", state, "")

	if type(text) ~= "string" and type(text) ~= "table" then
		text = tostring(text)
	end

	if #text > 0 then
		local previousFont = love.graphics.getFont()

		local font = self.font or previousFont
		if self.font then
			love.graphics.setFont(self.font)
		end

		local width, height = widget:getSize()
		if width == 0 and height == 0 then
			local p = widget:getParent()
			if p then
				width, height = p:getSize()
			end
		end

		if type(text) == "table" then
			local result = {}

			for i = 1, #text, 2 do
				if type(text[i]) == "string" then
					table.insert(result, {
						Color.fromHexString(Config.get("Config", "COLOR", "color", text[i]) or text[i]):get()
					})
				else
					table.insert(result, text[i])
				end

				table.insert(result, text[i + 1])
			end

			text = result
		end

		local x, y = 0, 0
		if width == 0 then
			local r
			if type(text) == "table" then
				for i = 2, #text, 2 do
					r = (r or "") .. text[i]
				end
			end

			width = font:getWidth(r or text)

			if self.align == "center" then
				x = -width / 2
			end
		end

		if self.center then
			local _, numLines = font:getWrap(text, width)
			y = y + (height - (#numLines * (font:getHeight() * font:getLineHeight()))) / 2
		end

		local maxWidth = self.width or width
		local oldLineHeight = font:getLineHeight()
		local newLines = {}
		if self.spaceLines then
			local prespacedText = text
			if type(text) == "string" then
				prespacedText = { { 1, 1, 1, 1 }, text }
			end

			local transformedText = {}
			for i = 1, #prespacedText, 2 do
				local transformedSequence = prespacedText[i + 1]:gsub("([ ]+)", " ")
				for _, code in utf8.codes(transformedSequence) do
					local c = utf8.char(code)
					if c:match("\n") then
						table.insert(newLines, #transformedText)
					end

					table.insert(transformedText, prespacedText[i])
					table.insert(transformedText, utf8.char(code))
				end
			end

			local wrappedWidth, wrappedText = font:getWrap(transformedText, maxWidth)
			local currentIndex = 0

			local commonAlign = #wrappedText == 1 and self.align or "justify"
			local finalAlign = self.align

			local newLineHeight
			if #wrappedText == 1 then
				newLineHeight = font:getHeight()
			else
				newLineHeight = math.min(height / #wrappedText, font:getHeight() * 1.5)
			end

			local yOffset = (newLineHeight - font:getHeight()) / 2

			local wordX = 0
			local wordY = height / 2 - (newLineHeight * #wrappedText) / 2
			local words = {}
			local currentIndex = 0
			for index, line in ipairs(wrappedText) do
				local length = utf8.len(line)

				table.clear(words)
				wrappedText[index]:gsub("([^ ]+)", function(s)
					if utf8.len(s) > 0 then
						table.insert(words, s)
					end
				end)

				local lineLength = 0
				for _, w in ipairs(words) do
					lineLength = lineLength + font:getWidth(w)
				end

				local spaceLength
				if lineLength < maxWidth * self.minJustifyLineWidthPercent then
					spaceLength = self.font:getWidth(" ")
					wordX = (maxWidth - (spaceLength * (#words - 1) + lineLength)) / 2
				else
					spaceLength = (maxWidth - lineLength) / (#words - 1)
				end

				for _, w in ipairs(words) do
					local word = {}
					for i in utf8.codes(w) do
						for i = #newLines, 1, -1 do
							if (currentIndex + i) * 2 > newLines[i] then
								table.remove(newLines, i)
								currentIndex = currentIndex + 1
							end
						end

						table.insert(word, transformedText[(currentIndex + i) * 2 - 1])
						table.insert(word, transformedText[(currentIndex + i) * 2])
					end
					currentIndex = currentIndex + utf8.len(w) + 1

					if self.textShadow then
						love.graphics.setColor(0, 0, 0, self.color.a)
						itsyrealm.graphics.print(word, math.floor(x + wordX + 2), math.floor(y + wordY + 2))
					end

					love.graphics.setColor(self.color:get())
					itsyrealm.graphics.print(word, math.floor(x + wordX), math.floor(y + wordY))

					wordX = wordX + font:getWidth(w) + spaceLength
				end

				wordY = wordY + newLineHeight
				wordX = 0
			end
		else
			if self.shrink then
				local t

				if type(text) == "string" then
					t = text
				else
					t = {}
					for i = 2, #t, 2 do
						table.insert(t, t[i])
					end

					t = table.concat(t)
				end

				local textWidth = self.font:getWidth(t)
				local selfWidth, selfHeight = widget:getSize()
				if selfWidth == 0 and widget:getParent() then
					selfWidth, selfHeight = widget:getParent():getSize()
				end

				local scale
				if selfWidth > 0 then
					scale = selfWidth / textWidth
				else
					scale = 1
				end

				local ox = textWidth / 2
				local oy = self.font:getHeight() / 2

				if self.textShadow then
					love.graphics.setColor(0, 0, 0, self.color.a)
					itsyrealm.graphics.print(text, x + selfWidth / 2 + 2, y + selfHeight / 2 + 2, 0, scale, scale, ox, oy)
				end

				love.graphics.setColor(self.color:get())
				itsyrealm.graphics.print(text, x + selfWidth / 2, y + selfHeight / 2, 0, scale, scale, ox, oy)
			else
				if self.textShadow then
					love.graphics.setColor(0, 0, 0, self.color.a)
					itsyrealm.graphics.printf(text, x + 2, y + 2, maxWidth, self.align)
				end

				love.graphics.setColor(self.color:get())
				itsyrealm.graphics.printf(text, x, y, maxWidth, self.align)
			end
		end

		love.graphics.setFont(previousFont)

		oldLineHeight = font:setLineHeight(oldLineHeight)
	end

	love.graphics.setColor(1, 1, 1, 1)
end

return LabelStyle
