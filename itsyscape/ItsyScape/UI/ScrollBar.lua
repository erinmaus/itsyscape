--------------------------------------------------------------------------------
-- ItsyScape/UI/ScrollBar.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Callback = require "ItsyScape.Common.Callback"
local Button = require "ItsyScape.UI.Button"
local ButtonStyle = require "ItsyScape.UI.ButtonStyle"
local DraggableButton = require "ItsyScape.UI.DraggableButton"
local Widget = require "ItsyScape.UI.Widget"

local ScrollBar = Class(Widget)

function ScrollBar:new()
	Widget.new(self)

	self.onScroll = Callback()

	self.upButton = Button()
	self.downButton = Button()
	self.scrollButton = DraggableButton()
	self.scrollArea = 0
	self.scrollAreaStart = 0
	self.scrollAreaEnd = 0
	self.scrollTick = 8
	self.target = false

	self.upButton.onMousePress:register(self.scroll, self, -1)
	self.downButton.onMousePress:register(self.scroll, self, 1)
	self.scrollButton.onDrag:register(self.drag, self)
	self.scrollButton.onDrop:register(function()
		self.dragStart = false
	end)

	self.dragStart = false

	self.scrollButton:setDragDistance(0)

	self:addChild(self.upButton)
	self:addChild(self.downButton)
end

function ScrollBar:mouseScroll(x, y)
	Widget.mouseScroll(self, x, y)

	if self:getIsVertical() then
		self:scroll(-y)
	else
		self:scroll(x)
	end
end

function ScrollBar:getTarget()
	return self.target or self:getParent()
end

function ScrollBar:setTarget(value)
	self.target = value or false
end

function ScrollBar:scroll(direction)
	-- Clamp to -1, 0, or 1.
	if direction < 0 then
		direction = -1
	elseif direction > 0 then
		direction = 1
	end

	local p = self:getTarget()
	if p then
		local parentWidth, parentHeight = self:getParent():getSize()
		local parentScrollSizeX, parentScrollSizeY = p:getScrollSize()
		parentScrollSizeX = parentScrollSizeX - parentWidth
		parentScrollSizeY = parentScrollSizeY - parentHeight
		local parentScrollX, parentScrollY = p:getScroll()
		if self:getIsVertical() then
			local y = parentScrollY + direction * self.scrollTick
			p:setScroll(parentScrollX, math.max(math.min(y, parentScrollSizeY), 0))
			self.onScroll(self, y / parentScrollSizeY)
		else
			local x = parentScrollX + direction * self.scrollTick
			p:setScroll(math.max(math.min(x, parentScrollSizeX), 0), parentScrollY)
			self.onScroll(self, x / parentScrollSizeX)
		end
	end
end

function ScrollBar:drag(button, x, y)
	local p = self:getTarget()
	if p then
		local parentWidth, parentHeight = self:getParent():getSize()
		local parentScrollSizeX, parentScrollSizeY = p:getScrollSize()
		parentScrollSizeX = parentScrollSizeX - parentWidth
		parentScrollSizeY = parentScrollSizeY - parentHeight
		local parentScrollX, parentScrollY = p:getScroll()
		if self:getIsVertical() then
			if not self.dragStart then
				self.dragStart = (parentScrollY / parentScrollSizeY) * self.scrollArea
			end

			local s = math.max(math.min((y + self.dragStart) / self.scrollArea, 1), 0) * parentScrollSizeY
			p:setScroll(parentScrollX, s)
			self.onScroll(self, s / parentScrollY)
		else
			if not self.dragStart then
				self.dragStart = (parentScrollX / parentScrollSizeX) * self.scrollArea
			end

			local s = math.max(math.min((x + self.dragStart) / self.scrollArea, 1), 0) * parentScrollSizeX
			p:setScroll(s, parentScrollY)
			self.onScroll(self, s / parentScrollX)
		end
	end
end

-- Gets the pixels moved per scroll event.
function ScrollBar:getScrollTick()
	return self.scrollTick
end

-- Sets the pixels moved per scroll event.
function ScrollBar:setScrollTick(value)
	self.scrollTick = value or self.scrollTick
end

-- Returns true if the scroll bar is vertical, false otherwise.
--
-- A scrollbar is vertical if the height is greater than or equal to width. Thus
-- a scroll scrollbar is considered vertical.
--
-- So don't make horizontal, square scrollbars, doofus!
function ScrollBar:getIsVertical()
	local width, height = self:getSize()
	return height >= width
end

-- Returns true if the scroll bar is horizontal, false otherwise.
--
-- A scrollbar is horizontal if the width is greater than height.
function ScrollBar:getIsHorizontal()
	local width, height = self:getSize()
	return width > height
end

function ScrollBar:performLayout()
	local width, height = self:getSize()

	if self:getIsVertical() then
		local buttonHeight = math.min(math.floor(height / 2), width)
		self.upButton:setSize(width, buttonHeight)
		self.upButton:setPosition(0, 0)
		self.upButton:setText("^")
		self.downButton:setSize(width, buttonHeight)
		self.downButton:setPosition(0, height - buttonHeight)
		self.downButton:setText("v")

		if buttonHeight < height then
			local p  = self:getParent() --= self:getTarget()
			if p and self:getParent() then
				local parentWidth, parentHeight = self:getParent():getSize()
				local parentScrollSizeX, parentScrollSizeY = p:getScrollSize()

				local ratio = parentHeight / parentScrollSizeY

				local remainingHeight = height - buttonHeight * 2
				local scrollButtonHeight = math.max(
					remainingHeight * ratio,
					remainingHeight / 16,
					1)

				self:addChild(self.scrollButton)
				self.scrollButton:setSize(width, scrollButtonHeight)

				self.scrollAreaStart = buttonHeight
				self.scrollAreaEnd = height - buttonHeight - scrollButtonHeight
				self.scrollArea = self.scrollAreaEnd - self.scrollAreaStart
			end
		else
			self:removeChild(self.scrollButton)
		end
	else
		local buttonWidth = math.min(math.floor(width / 2), height)
		self.upButton:setSize(buttonWidth, height)
		self.upButton:setPosition(0, 0)
		self.upButton:setText("<")
		self.downButton:setSize(buttonWidth, height)
		self.downButton:setPosition(width - buttonWidth, 0)
		self.downButton:setText(">")

		if buttonWidth < width then
			local p = self:getParent()
			if p then
				local parentWidth, parentHeight = self:getParent():getSize()
				local parentScrollSizeX, parentScrollSizeY = p:getScrollSize()
				local ratio = parentHeight / parentScrollSizeX

				local remainingWidth = width - buttonWidth * 2
				local scrollButtonWidth = math.max(
					remainingWidth * ratio,
					remainingWidth / 16,
					1)

				self:addChild(self.scrollButton)
				self.scrollButton:setSize(scrollButtonWidth, height)

				self.scrollAreaStart = buttonWidth
				self.scrollAreaEnd = width - buttonWidth - scrollButtonWidth
				self.scrollArea = self.scrollAreaEnd - self.scrollAreaStart
			end
		else
			self:removeChild(self.scrollButton)
		end
	end
end

function ScrollBar:update(...)
	Widget.update(self, ...)

	local p = self:getTarget()
	if p then
		local parentWidth, parentHeight = self:getParent():getSize()
		local parentScrollSizeX, parentScrollSizeY = p:getScrollSize()
		parentScrollSizeX = parentScrollSizeX - parentWidth
		parentScrollSizeY = parentScrollSizeY - parentHeight
		local parentScrollX, parentScrollY = p:getScroll()
		if self:getIsVertical() then
			local y = math.floor(parentScrollY / parentScrollSizeY * self.scrollArea) + self.scrollAreaStart
			self.scrollButton:setPosition(x, math.floor(y))
		else
			local x = math.floor(parentScrollX / parentScrollSizeX * self.scrollArea) + self.scrollAreaStart
			self.scrollButton:setPosition(math.floor(x), y)
		end
	end

	self:performLayout()
end

return ScrollBar
