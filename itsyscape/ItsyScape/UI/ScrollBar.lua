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
ScrollBar.MIN_HEIGHT = 16
ScrollBar.DISPLAY_PROGRESS_TIME = 0.5

ScrollBar.Button = Class(Button)
ScrollBar.UpButton = Class(ScrollBar.Button)
ScrollBar.DownButton = Class(ScrollBar.Button)

ScrollBar.DragButton = Class(DraggableButton)

function ScrollBar:new()
	Widget.new(self)

	self.onScroll = Callback()

	self.upButton = ScrollBar.UpButton()
	self.downButton = ScrollBar.DownButton()
	self.scrollButton = ScrollBar.DragButton()

	if _MOBILE then
		self:setIsSelfClickThrough(true)
	end

	self.scrollArea = 0
	self.scrollAreaStart = 0
	self.scrollAreaEnd = 0
	self.scrollTick = _MOBILE and 1 or 32
	self.target = false

	self.scrollTime = -math.huge

	self.upButton.onMousePress:register(self.scroll, self, -1)
	self.downButton.onMousePress:register(self.scroll, self, 1)
	self.scrollButton.onDrag:register(self.drag, self)
	self.scrollButton.onDrop:register(function()
		self.dragStart = false
	end)

	self._onScroll = function(_, x, y)
		self.scrollTime = love.timer.getTime()

		self:mouseScroll(x, y)
	end

	self.dragStart = false

	self.scrollButton:setDragDistance(0)

	self:addChild(self.upButton)
	self:addChild(self.downButton)
end

function ScrollBar:setIsSelfClickThrough(value)
	self.upButton:setIsSelfClickThrough(value)
	self.downButton:setIsSelfClickThrough(value)
	self.scrollButton:setIsSelfClickThrough(value)
	Widget.setIsSelfClickThrough(self, value)
end

function ScrollBar:mouseScroll(x, y)
	self:onMouseScroll(x, y)

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
	if self.target then
		self.target.onMouseScroll:unregister(self._onScroll)
	end

	if value then
		value.onMouseScroll:register(self._onScroll)
	end

	self.target = value or false
end

function ScrollBar:scroll(direction)
	self.scrollTime = love.timer.getTime()

	-- Clamp to -1, 0, or 1.
	if not _MOBILE then
		if direction < 0 then
			direction = -1
		elseif direction > 0 then
			direction = 1
		end
	end

	local p = self:getTarget()
	if p and p:getParent() then
		local parentWidth, parentHeight = p:getParent():getSize()
		local parentScrollSizeX, parentScrollSizeY = p:getScrollSize()
		parentScrollSizeX = parentScrollSizeX - parentWidth
		parentScrollSizeY = parentScrollSizeY - parentHeight
		local parentScrollX, parentScrollY = p:getScroll()
		if self:getIsVertical() and parentScrollSizeY ~= 0 then
			local y = parentScrollY + direction * self.scrollTick
			p:setScroll(parentScrollX, math.max(math.min(y, parentScrollSizeY), 0))
			self.onScroll(self, y / parentScrollSizeY)
		elseif self:getIsHorizontal() and parentScrollSizeX ~= 0 then
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
		if self:getIsVertical() and parentScrollSizeY ~= 0 and self.scrollArea > 0 then
			print(">>> scrooll area", self.scrollArea)
			if not self.dragStart then
				self.dragStart = (parentScrollY / parentScrollSizeY) * self.scrollArea
			end

			local s = math.max(math.min((y + self.dragStart) / self.scrollArea, 1), 0) * parentScrollSizeY
			p:setScroll(parentScrollX, s)
			self.onScroll(self, s / parentScrollY)
		elseif self:getIsHorizontal() and parentScrollSizeX ~= 0 and self.scrollArea > 0 then
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
	local currentTime = love.timer.getTime()

	if self:getIsVertical() then
		local buttonHeight = math.min(math.floor(height / 2), width)
		self.upButton:setSize(width, buttonHeight)
		self.upButton:setPosition(0, 0)
		self.downButton:setSize(width, buttonHeight)
		self.downButton:setPosition(0, height - buttonHeight)

		if buttonHeight < height then
			local p  = self:getParent()
			if p then
				local parentWidth, parentHeight = p:getSize()
				local parentScrollSizeX, parentScrollSizeY = p:getScrollSize()
				if parentScrollSizeY ~= 0 then
					local ratio = parentHeight / parentScrollSizeY

					local remainingHeight = height - buttonHeight * 2
					local scrollButtonHeight = math.max(
						remainingHeight * ratio,
						remainingHeight / 16,
						ScrollBar.MIN_HEIGHT)

					if not _MOBILE then
						self:addChild(self.scrollButton)
					end

					self.scrollButton:setSize(width, scrollButtonHeight)

					self.scrollAreaStart = buttonHeight
					self.scrollAreaEnd = height - buttonHeight - scrollButtonHeight
					self.scrollArea = self.scrollAreaEnd - self.scrollAreaStart
				end
			end
		else
			self:removeChild(self.scrollButton)
		end
	else
		local buttonWidth = math.min(math.floor(width / 2), height)
		self.upButton:setSize(buttonWidth, height)
		self.upButton:setPosition(0, 0)
		self.downButton:setSize(buttonWidth, height)
		self.downButton:setPosition(width - buttonWidth, 0)

		if buttonWidth < width then
			local p = self:getParent()
			if p then
				local parentWidth, parentHeight = p:getSize()
				local parentScrollSizeX, parentScrollSizeY = p:getScrollSize()
				if parentScrollSizeX ~= 0 then
					local ratio = parentHeight / parentScrollSizeX

					local remainingWidth = width - buttonWidth * 2
					local scrollButtonWidth = math.max(
						remainingWidth * ratio,
						remainingWidth / 16,
						1)

					if not _MOBILE then
						self:addChild(self.scrollButton)
					end

					self.scrollButton:setSize(scrollButtonWidth, height)

					self.scrollAreaStart = buttonWidth
					self.scrollAreaEnd = width - buttonWidth - scrollButtonWidth
					self.scrollArea = self.scrollAreaEnd - self.scrollAreaStart
				end
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
			if parentScrollY ~= 0 then
				local y = math.floor(parentScrollY / parentScrollSizeY * self.scrollArea) + self.scrollAreaStart
				self.scrollButton:setPosition(x, math.floor(y))
			elseif parentScrollY == 0 then
				self.scrollButton:setPosition(x, math.floor(self.scrollAreaStart))
			end
		else
			if parentScrollX ~= 0 then
				local x = math.floor(parentScrollX / parentScrollSizeX * self.scrollArea) + self.scrollAreaStart
				self.scrollButton:setPosition(math.floor(x), y)
			elseif parentScrollX == 0 then
				self.scrollButton:setPosition(math.floor(self.scrollAreaStart), x)
			end
		end

		if _MOBILE then
			local currentTime = love.timer.getTime()
			local displayScroll = self.scrollTime + ScrollBar.DISPLAY_PROGRESS_TIME > currentTime

			if self:getIsVertical() then
				local y = parentScrollY / parentScrollSizeY
				if y == 0 and not displayScroll then
					self:removeChild(self.upButton)
				else
					self:addChild(self.upButton)
				end

				if y >= 1 and not displayScroll then
					self:removeChild(self.downButton)
				else
					self:addChild(self.downButton)
				end
			else
				local x = parentScrollX / parentScrollSizeX
				if x == 0 and not displayScroll then
					self:removeChild(self.upButton)
				else
					self:addChild(self.upButton)
				end

				if x >= 1 and not displayScroll then
					self:removeChild(self.downButton)
				else
					self:addChild(self.downButton)
				end
			end

			local currentTime = love.timer.getTime()
			if self.scrollTime + ScrollBar.DISPLAY_PROGRESS_TIME > currentTime then
				self:addChild(self.scrollButton)
			else
				self:removeChild(self.scrollButton)
			end
		end
	end

	self:performLayout()
end

return ScrollBar
