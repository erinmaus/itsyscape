--------------------------------------------------------------------------------
-- ItsyScape/UI/TextInputStyle.lua
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
local WidgetRenderer = require "ItsyScape.UI.WidgetRenderer"
local patchy = require "patchy"

local RichTextLabelRenderer = Class(WidgetRenderer)
RichTextLabelRenderer.Draw = Class()

function RichTextLabelRenderer.Draw:new(renderer, blocks, resources, width)
	self.renderer = renderer
	self.blocks = blocks
	self.resources = resources
	self.x = 0
	self.y = 0
	self.left = 0
	self.height = 0
	self.width = width
end

function RichTextLabelRenderer.Draw:doDrawText(text, parent, font)
	if not parent then
		self.y = self.y + self.height
		self.height = 0
	end

	local lineHeight = font:getHeight()
	self.height = math.max(self.height, lineHeight)

	if text.color then
		love.graphics.setColor(unpack(text.color))
	else
		love.graphics.setColor(1, 1, 1, 1)
	end

	for i = 1, #text do
		local snippet = text[i]
		if type(snippet) == 'string' then
			local words = {}
			snippet:gsub("([^%s]*)", function(s)
				table.insert(words, s)
			end)

			for j = 1, #words do
				local word = words[j]
				local width = font:getWidth(word)

				local needsSpace = j < #words
				if width + self.x > self.width then
					self.y = self.y + lineHeight
					self.x = self.left

					self.height = lineHeight
					needsSpace = false
				end

				itsyrealm.graphics.print({ word }, self.x, self.y)
				self.x = self.x + width

				if needsSpace then
					local space = font:getWidth(" ")
					if space + self.x > self.width then
						self.y = self.y + lineHeight
						self.x = self.left

						self.height = lineHeight
					else
						self.x = self.x + space
					end
				end
			end

			self.x = self.left
			self.y = self.y + self.height
			self.height = lineHeight
		else
			self:drawBlock(snippet, text)
		end
	end
end

function RichTextLabelRenderer.Draw:drawText(text, parent)
	if type(text) == 'string' then
		text = {
			t = 'text',
			text
		}
	end

	local font = self.renderer.fonts.text
	love.graphics.setFont(font)

	self:doDrawText(text, parent, font)

	self.y = self.y + self.height
	self.height = 0
end

function RichTextLabelRenderer.Draw:drawHeader(text, parent)
	if type(text) == 'string' then
		text = {
			t = 'text',
			text
		}
	end

	local font = self.renderer.fonts.header
	love.graphics.setFont(font)

	self:doDrawText(text, parent, font)
end

function RichTextLabelRenderer.Draw:drawLink(block, parent)
	local font = love.graphics.getFont()
	local width = font:getWidth(block.text)
	local height = self.height

	if self.x + width > self.width then
		self.x = self.left
		self.y = self.y + self.height
	end

	local screenX, screenY = itsyrealm.graphics.transformPoint(0, 0)
	screenX = screenX + self.x
	screenY = screenY + self.y

	local mouseX, mouseY = love.mouse.getPosition()

	local hover
	if mouseX > screenX and mouseX < screenX + width and
	   mouseY > screenY and mouseY < screenY + height
	then
		hover = true
	else
		hover = false
	end

	local color
	if hover then
		color = { 0.84, 0.93, 0.97, 1.0 }
	else
		color = { 0.22, 0.67, 0.78, 1.0 }
	end

	love.graphics.setColor(color)
	itsyrealm.graphics.print({ block.text }, self.x, self.y)

	self.x = self.x + width

	if hover and self.renderer.wasMouseDown and not self.renderer.isMouseDown then
		love.system.openURL(block.destination)
	end

	love.graphics.setColor(1, 1, 1, 1)
end

function RichTextLabelRenderer.Draw:drawList(block, parent)
	love.graphics.setColor(1, 1, 1, 1)

	local font = self.renderer.fonts.text

	local bulletX = self.x

	local oldLeft = self.left
	self.left = self.left + font:getHeight()
	self.x = self.x + font:getHeight()

	for i = 1, #block do
		local line = block[i]

		itsyrealm.graphics.circle(
			'fill',
			bulletX + font:getHeight() / 2,
			self.y + font:getHeight() / 2,
			font:getHeight() / 4)

		if type(line) == 'text' then
			self:drawText(line, self)
		else
			self:drawBlock(line, self)
		end
	end

	self.left = oldLeft
end

function RichTextLabelRenderer.Draw:drawImage(block, parent)
	local resource = block.resource
	local key = "image://" .. resource

	local image = self.resources[key]
	if not image then
		image = love.graphics.newImage(resource)
		self.resources[key] = image
	end

	self.x = self.left
	self.y = self.y + self.height

	itsyrealm.graphics.draw(image, self.x, self.y)

	self.height = image:getHeight()
end

function RichTextLabelRenderer.Draw:drawBlock(block, parent)
	if type(block) == 'string' or block.t == 'text' then
		self:drawText(block, parent)
	elseif block.t == 'header' then
		self:drawHeader(block, parent)
	elseif block.t == 'list' then
		self:drawList(block, parent)
	elseif block.t == 'link' then
		self:drawLink(block, parent)
	elseif block.t == 'image' then
		self:drawImage(block, parent)
	end
end

function RichTextLabelRenderer.Draw:draw()
	for i = 1, #self.blocks do
		local block = self.blocks[i]
		self:drawBlock(block)
		self.x = self.left
	end

	self.y = self.y + self.height
end

function RichTextLabelRenderer:new(t, resources)
	WidgetRenderer.new(self, resources)

	self.fonts = {
		text = love.graphics.newFont("Resources/Renderers/Widget/Common/DefaultSansSerif/Regular.ttf", 16),
		header = love.graphics.newFont("Resources/Renderers/Widget/Common/Serif/Bold.ttf", 18)
	}
	self.texts = {}
end

function RichTextLabelRenderer:start()
	WidgetRenderer.start(self)

	local mouseDown = love.mouse.isDown(1)
	self.wasMouseDown = self.isMouseDown or false
	self.isMouseDown = mouseDown
end

function RichTextLabelRenderer:drop(widget)
	WidgetRenderer.drop(self, widget)

	self.texts[widget] = nil
end

function RichTextLabelRenderer:draw(widget, state)
	local text = self.texts[widget]
	if not text or text.t ~= widget:getText() then
		local t = widget:getText()
		if type(t) == 'string' then
			t = { { t = 'text', t } }
		end

		text = {
			t = t,
			resources = {}
		}

		self.texts[widget] = text
	end

	local w, h = widget:getSize()
	local renderer = RichTextLabelRenderer.Draw(self, text.t, text.resources, w)
	renderer:draw()

	if widget:getWrapContents() then
		widget:setSize(w, renderer.y)
	end

	if widget:getWrapParentContents() then
		local p = widget:getParent()
		if p then
			p:setSize(w, renderer.y)

			p = p:getParent()
			if p then
				p:setScrollSize(w, renderer.y)
			end
		end
	end
end

return RichTextLabelRenderer
