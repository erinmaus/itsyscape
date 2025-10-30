--------------------------------------------------------------------------------
-- ItsyScape/UI/GridLayout.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Callback = require "ItsyScape.Common.Callback"
local Layout = require "ItsyScape.UI.Layout"
local PanelStyle = require "ItsyScape.UI.PanelStyle"

local GridLayout = Class(Layout)
GridLayout.DEFAULT_PADDING = 8

function GridLayout:new()
	Layout.new(self)

	self.paddingX = GridLayout.DEFAULT_PADDING
	self.paddingY = GridLayout.DEFAULT_PADDING
	self.uniformSize = false
	self.uniformSizeX = 0
	self.uniformSizeY = 0
	self.currentX = false
	self.currentY = false
	self.maxRowHeight = false
	self.wrapContents = false
	self.currentHeight = 0
	self.edgePaddingX = true
	self.edgePaddingY = true
	self.reverse = false
end

function GridLayout:getPadding()
	return self.paddingX, self.paddingY
end

function GridLayout:setPadding(paddingX, paddingY)
	paddingX = paddingX or self.paddingX
	paddingY = paddingY or self.paddingY

	if paddingX ~= self.paddingX or paddingY ~= self.paddingY then
		self.paddingX = paddingX
		self.paddingY = paddingY

		self:performLayout()
	end
end

function GridLayout:setEdgePadding(x, y)
	self.edgePaddingX = x or false
	self.edgePaddingY = y or false
end

function GridLayout:setIsReversed(value)
	self.reverse = not not value
end

function GridLayout:getIsReversed()
	return self.reverse
end

function GridLayout:getEdgePadding()
	return self.edgePaddingX, self.edgePaddingY
end

function GridLayout:getUniformSize()
	return self.uniformSize, self.uniformSizeX, self.uniformSizeY
end

function GridLayout:setUniformSize(flag, x, y)
	if flag then
		x = math.max(x or self.uniformSizeX, 0)
		y = math.max(y or self.uniformSizeY, 0)

		if not self.uniformSize
		   or x ~= self.uniformSizeX
		   or y ~= self.uniformSizeY
		then
			self.uniformSize = true
			self.uniformSizeX = x
			self.uniformSizeY = y

			self:performLayout()
		end
	else
		self.uniformSize = false
	end
end

function GridLayout:getWrapContents()
	return self.wrapContents
end

function GridLayout:setWrapContents(value)
	if value then
		self.wrapContents = true
	else
		self.wrapContents = false
	end
end

function GridLayout:addChild(child)
	Layout.addChild(self, child)

	self:layoutChild(child)

	if self.wrapContents then
		self.height = self.currentHeight
		self.scrollHeight = self.height
	end
end

function GridLayout:layoutChild(child)
	if self.uniformSize then
		local selfWidth, selfHeight = self:getSize()
		local targetWidth, targetHeight = child:getSize()

		if self.uniformSizeX > 0 then
			if self.uniformSizeX <= 1 then
				targetWidth = math.floor(self.uniformSizeX * selfWidth)

				local padding = (math.max(math.floor(selfWidth / targetWidth), 1) + 1) * self.paddingX
				targetWidth = math.floor((selfWidth - padding) * self.uniformSizeX)
			else
				targetWidth = self.uniformSizeX
			end
		end

		if self.uniformSizeY > 0 then
			if self.uniformSizeY <= 1 then
				targetHeight = self.uniformSizeY * selfHeight - self.paddingY * 2

				local padding = (math.max(math.floor(selfHeight / targetHeight), 1) + 1) * self.paddingY
				targetHeight = math.floor((selfHeight - padding) * self.uniformSizeY)
			else
				targetHeight = self.uniformSizeY
			end
		end

		child:setSize(targetWidth, targetHeight)
		child:performLayout()
	end

	local width, height = self:getSize()
	local childWidth, childHeight = child:getSize()

	local edgePaddingX = self.edgePaddingX and self.paddingX or 0
	local edgePaddingY = self.edgePaddingY and self.paddingY or 0

	local x = self.currentX or edgePaddingX
	local y = self.currentY or edgePaddingY
	if self.currentX then
		if x + childWidth > width then
			self.currentX = childWidth + self.paddingX + edgePaddingX
			x = edgePaddingX

			y = y + self.paddingY
			y = y + (self.maxRowHeight or 0)

			self.currentY = y
			self.maxRowHeight = childHeight
		else
			self.currentX = x + childWidth + self.paddingX
			self.maxRowHeight = math.max(self.maxRowHeight or 0, childHeight)
		end
	else
		self.currentX = childWidth + self.paddingX + edgePaddingX
		self.maxRowHeight = math.max(self.maxRowHeight or 0, childHeight)
	end

	child:setPosition(x, y)

	if self.wrapContents then
		self.currentHeight = math.max(y + childHeight, self.currentHeight)
	end
end

function GridLayout:performLayout()
	self.currentX = false
	self.currentY = false
	self.maxRowHeight = false

	if self.wrapContents then
		self.currentHeight = 0
	end

	local start = self.reverse and self:getNumChildren() or 1
	local stop = self.reverse and 1 or self:getNumChildren()
	local n = self.reverse and -1 or 1

	for i = start, stop, n do
		self:layoutChild(self:getChildAt(i))
	end

	if self.wrapContents then
		self.height = self.currentHeight + self.paddingY
		self.scrollHeight = self.height
	end
end

return GridLayout
