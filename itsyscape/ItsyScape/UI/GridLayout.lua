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
end

function GridLayout:layoutChild(child)
	if self.uniformSize then
		child:setSize(self.uniformSizeX, self.uniformSizeY)
	end

	local width, height = self:getSize()
	local childWidth, childHeight = child:getSize()

	local x = self.currentX or self.paddingX
	local y = self.currentY or self.paddingY
	if self.currentX then
		if x + childWidth + self.paddingX > width then
			self.currentX = childWidth + self.paddingX * 2
			x = self.paddingX

			y = (self.currentY or self.paddingY) + self.paddingY
			if self.uniformSize then
				y = y + self.uniformSizeY
				self.currentY = y + self.uniformSizeY
			else
				y = y + (self.maxRowHeight or 0)
			end

			self.currentY = y
			self.maxRowHeight = childHeight
		else
			self.currentX = x + childWidth + self.paddingX
			self.maxRowHeight = math.max(self.maxRowHeight or 0, childHeight)
		end
	else
		self.currentX = childWidth + self.paddingX * 2
		self.maxRowHeight = math.max(self.maxRowHeight or 0, childHeight)
	end

	child:setPosition(x, y)

	if self.wrapContents then
		self.height = math.max(y + childHeight, self.height)
		self.scrollHeight = self.height
	end
end

function GridLayout:performLayout()
	self.currentX = false
	self.currentY = false
	self.maxRowHeight = false

	if self.wrapContents then
		self.height = 0
	end

	for _, child in self:iterate() do
		self:layoutChild(child)
	end

	if self.wrapContents then
		self.height = self.height + self.paddingY + self.paddingY
		self.scrollHeight = self.height
	end
end

return GridLayout
