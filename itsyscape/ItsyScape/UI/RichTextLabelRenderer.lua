--------------------------------------------------------------------------------
-- ItsyScape/UI/TextInputStyle.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local devi = require "devi"
local Class = require "ItsyScape.Common.Class"
local Color = require "ItsyScape.Graphics.Color"
local TextInput = require "ItsyScape.UI.TextInput"
local WidgetRenderer = require "ItsyScape.UI.WidgetRenderer"
local patchy = require "patchy"

local RichTextLabelRenderer = Class(WidgetRenderer)
RichTextLabelRenderer.Draw = Class()

function RichTextLabelRenderer.Draw:new(renderer, blocks, resources, style, width)
	self.renderer = renderer
	self.blocks = blocks
	self.resources = resources
	self.x = 0
	self.y = 0
	self.left = 0
	self.height = 0
	self.width = width
	self.fonts = {
		header = style and style.header or renderer.fonts.header,
		text = style and style.text or renderer.fonts.text,
	}
	self.text = {
		[self.fonts.header] = love.graphics.newText(self.fonts.header),
		[self.fonts.text] = love.graphics.newText(self.fonts.text)
	}
end

function RichTextLabelRenderer.Draw:pushText(font, text, x, y)
	local t = self.text[font]
	if t then
		t:add({ { love.graphics.getColor() }, text }, x, y)
	end
end

function RichTextLabelRenderer.Draw:doDrawText(text, parent, font)
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
			snippet:gsub("([^%s]+)", function(s)
				table.insert(words, s)
			end)

			for j = 1, #words do
				local word = words[j]
				local width = font:getWidth(word)

				local needsSpace = (j < #words)
				if width + self.x > self.width then
					self.y = self.y + lineHeight
					self.x = self.left

					self.height = lineHeight
				end

				self:pushText(font, word, self.x, self.y)
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
			self.height = lineHeight

			love.graphics.setColor(1, 1, 1, 1)
		else
			self:drawBlock(snippet, text)
		end
	end

	self.y = self.y + lineHeight
end

function RichTextLabelRenderer.Draw:drawText(text, parent)
	if type(text) == 'string' then
		text = {
			t = 'text',
			text
		}
	end

	local font = self.fonts.text
	love.graphics.setFont(font)

	self:doDrawText(text, parent, font)
end

function RichTextLabelRenderer.Draw:drawHeader(text, parent)
	if type(text) == 'string' then
		text = {
			t = 'text',
			text
		}
	end

	local font = self.fonts.header
	if text ~= self.blocks[1] then
		self.y = self.y + font:getHeight()
	end

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

	local mouseX, mouseY = itsyrealm.mouse.getPosition()

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
	self:pushText(font, block.text, self.x, self.y)

	self.x = self.x + width

	if hover and self.renderer.wasMouseDown and not self.renderer.isMouseDown then
		love.system.openURL(block.destination)
	end

	love.graphics.setColor(1, 1, 1, 1)
end

function RichTextLabelRenderer.Draw:drawList(block, parent)
	love.graphics.setColor(1, 1, 1, 1)

	local font = self.fonts.text

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
	local image
	if type(block.resource) == "string" then
		local resource = block.resource
		local key = "image://" .. resource

		image = self.resources[key]
		if not image then
			local success

			success, image = pcall(devi.newImage, resource)
			if not success then
				success, image = pcall(love.graphics.newImage, resource)
				image = success and image
			end

			self.resources[resource] = image
		end
	elseif block.resource then
		local resource = block.resource
		image = self.resources[resource]
		if not image then
			local success

			success, image = pcall(devi.newImage, resource)
			if not success then
				success, image = pcall(love.graphics.newImage, resource)
				image = success and image
			end

			self.resources[resource] = image
		end
	end

	if not image then
		return
	end

	if type(image) == "table" then
		-- it's a devi image
		image:update()
		image = image:getTexture()
	end

	if image then
		self.x = self.left
		self.y = self.y + self.height

		local scale = 1
		local maxWidth = self.width - self.x
		if image:getWidth() > maxWidth then
			scale = maxWidth / image:getWidth()
		end

		if block.align == "center" then
			itsyrealm.graphics.uncachedDraw(image, self.x + (self.width / 2 - (image:getWidth() * scale) / 2), self.y, 0, scale, scale)
		else
			itsyrealm.graphics.uncachedDraw(image, self.x, self.y, 0, scale, scale)
		end

		self.y = self.y + image:getHeight() * scale + self.fonts.text:getHeight()
	end
end

function RichTextLabelRenderer.Draw:drawBlock(block, parent)
	if block.scroll then
		self.scrollY = self.y
	end

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

	self.y = self.y + self.height + self.fonts.text:getHeight()

	for _, text in pairs(self.text) do
		itsyrealm.graphics.uncachedDraw(text)
	end
end

function RichTextLabelRenderer:new(t, resources)
	WidgetRenderer.new(self, resources)

	self.fonts = {
		text = love.graphics.newFont("Resources/Renderers/Widget/Common/DefaultSansSerif/Regular.ttf", _MOBILE and 22 or 16),
		header = love.graphics.newFont("Resources/Renderers/Widget/Common/Serif/Bold.ttf", _MOBILE and 26 or 22)
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

function RichTextLabelRenderer:isSame(widget)
	local text = self.texts[widget]
	if not text then
		return false
	end

	local oldX, oldY, oldWidth, oldHeight, oldText, oldStyle = unpack(text)

	local currentX, currentY = widget:getAbsolutePosition()
	local currentWidth, currentHeight = widget:getSize()
	local currentText, currentStyle = widget:getText(), widget:getStyle()

	return oldX == currentX and
	       oldY == currentY and
	       oldWidth == currentWidth and
	       oldHeight == currentHeight and
	       oldText == currentText and
	       oldStyle == currentStyle
end

function RichTextLabelRenderer:draw(widget, state)
	self:visit(widget)

	if not self:isSame(widget) then
		local text = self.texts[widget]
		local t = widget:getText()
		if type(t) == 'string' then
			t = { { t = 'text', t } }
		end

		local currentX, currentY = widget:getAbsolutePosition()
		local currentWidth, currentHeight = widget:getSize()
		local currentText, currentStyle = widget:getText(), widget:getStyle()

		text = {
			t = t,
			y = 0,
			resources = {},

			currentX,
			currentY,
			currentWidth,
			currentHeight,
			currentText,
			currentStyle
		}

		self.texts[widget] = text

		local w, h = widget:getSize()
		text.replay = itsyrealm.graphics.startRecording()
		local renderer = RichTextLabelRenderer.Draw(self, text.t, text.resources, widget:getStyle(), w)
		renderer:draw()
		itsyrealm.graphics.stopRecording()

		if widget:getWrapParentContents() then
			local p = widget:getParent()
			if p then
				p:setSize(w, renderer.y + renderer.height)
			end
		end

		if widget:getWrapContents() and text.y ~= renderer.y then
			widget:setSize(w, renderer.y)
			widget:onSize()

			text.y = renderer.y
		end

		if text.scrollY ~= renderer.scrollY then
			widget:onScroll(renderer.scrollY)
			text.scrollY = renderer.scrollY
		end
	else
		itsyrealm.graphics.replay(self.texts[widget].replay)
	end
end

return RichTextLabelRenderer
