--------------------------------------------------------------------------------
-- ItsyScape/UI/Interfaces/Components/QuickCombatAction.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Callback = require "ItsyScape.Common.Callback"
local Class = require "ItsyScape.Common.Class"
local GamepadToolTip = require "ItsyScape.UI.GamepadToolTip"
local GamepadGridLayout = require "ItsyScape.UI.GamepadGridLayout"
local Widget = require "ItsyScape.UI.Widget"

local QuickCombatAction = Class(Widget)
QuickCombatAction.BUTTON_SIZE = 48
QuickCombatAction.BUTTON_PADDING = 4
QuickCombatAction.PADDING = 8
QuickCombatAction.EXPAND_SPEED_PIXELS_PER_SECOND = QuickCombatAction.BUTTON_SIZE * 8

function QuickCombatAction:new()
	Widget.new(self)

	self.wrapper = Widget()
	self:addChild(self.wrapper)

	self.onExpand = Callback()
	self.onCollapse = Callback()
	self.onSizeUpdate = Callback()

	self.onFocusChild:register(self._childFocused, self)
	self.onBlurChild:register(self._childBlurred, self)

	self.directionX = 0
	self.directionY = 1

	-- The control icon sits just outside.
	self:setSize(
		QuickCombatAction.BUTTON_SIZE + self.BUTTON_PADDING * 4,
		QuickCombatAction.BUTTON_SIZE + self.BUTTON_PADDING * 4)
	self.wrapper:setSize(self:getSize())

	self.minWidth, self.minHeight = self:getSize()

	self.gamepadToolTip = GamepadToolTip()
	self.gamepadToolTip:setHasBackground(false)
	self.gamepadToolTip:setRowSize(
		math.huge,
		math.floor(self.BUTTON_SIZE / 2))
	self.gamepadToolTip:setPosition(
		-self.BUTTON_PADDING,
		self.BUTTON_SIZE + self.BUTTON_PADDING * 2 - math.floor(self.BUTTON_SIZE / 2) + self.BUTTON_PADDING)

	self.gridLayout = GamepadGridLayout()
	self.gridLayout:setWrapScroll(false)
	self.gridLayout:setWrapContents(true)
	self.gridLayout:setPadding(0, self.PADDING)
	self.gridLayout:setSize(self.BUTTON_SIZE + self.BUTTON_PADDING * 2, 0)
	self.gridLayout:setUniformSize(
			true,
			self.BUTTON_SIZE + self.BUTTON_PADDING * 2,
			self.BUTTON_SIZE + self.BUTTON_PADDING * 2)
	self:addChild(self.gridLayout)

	self.wrapper:addChild(self.gridLayout)
	self:addChild(self.gamepadToolTip)

	self.isExpanded = false
	self.isCollapsing = false
	self.isExpanding = false
end

function QuickCombatAction:setDirection(x, y)
	self.directionX = (x and y) and x or 0
	self.directionY = (x and y) and y or -1

	self:performLayout()
end

function QuickCombatAction:performLayout()
	local wrapperWidth, wrapperHeight = self.wrapper:getSize()
	local width, height = 0, 0
	local paddingX, paddingY = 0
	local wrapperPositionX, wrapperPositionY = 0, 0

	if self.directionX < 0 or self.directionY < 0 then
		self.gridLayout:setIsReversed(true)
	else
		self.gridLayout:setIsReversed(false)
	end

	local n = self.gridLayout:getNumChildren()
	local s = self.BUTTON_SIZE + self.BUTTON_PADDING * 2
	local p = self.PADDING
	do
		local size = n * s + (n + 1) * p

		if math.abs(self.directionX) > 0 then
			paddingX = self.PADDING

			width = size
			height = s

			if self.directionX < 0 then
				wrapperPositionX = -(wrapperWidth - s - p)
			elseif self.directionX > 0 then
				wrapperPositionX = 0
			end
		end

		if math.abs(self.directionY) > 0 then
			paddingY = self.PADDING

			width = s
			height = size

			if self.directionY < 0 then
				wrapperPositionY = -(wrapperHeight - s - p)
			elseif self.directionY > 0 then
				wrapperPositionY = 0
			end
		end
	end

	self.wrapper:setPosition(wrapperPositionX, wrapperPositionY)
	self.gridLayout:setPadding(paddingX, paddingY)
	self.gridLayout:setSize(width, height)
	self.gridLayout:performLayout()

	if self.directionX < 0 then
		self.gridLayout:setPosition(wrapperWidth - width, 0)
	elseif self.directionX > 0 then
		self.gridLayout:setPosition(0, 0)
	end

	if self.directionY < 0 then
		self.gridLayout:setPosition(0, wrapperHeight - height)
	elseif self.directionY > 0 then
		self.gridLayout:setPosition(0, 0)
	end

	self.wrapper:setScrollSize(self.gridLayout:getSize())
end

function QuickCombatAction:getOverflow()
	return true
end

function QuickCombatAction:getInnerPanel()
	return self.gridLayout
end

function QuickCombatAction:getGamepadToolTip()
	return self.gamepadToolTip
end

function QuickCombatAction:_childFocused()
	if self.isCollapsing then
		self:onCollapse(false)
		self.isCollapsing = false
	end

	self.isExpanding = true
	self:onExpand(true)
end

function QuickCombatAction:_childBlurred()
	if self.isExpanding then
		self:onExpand(false)
		self.isExpanding = false
	end

	self.isCollapsing = true
	self:onCollapse(true)
end

function QuickCombatAction:_fill(delta)
	self:performLayout()

	local direction = (self.isCollapsing and -1) or (self.isExpanding and 1) or 0
	local pixels = direction * delta * self.EXPAND_SPEED_PIXELS_PER_SECOND

	local gridSizeX, gridSizeY = self.gridLayout:getSize()
	local oldWidth, oldHeight = self.wrapper:getSize()
	local scrollX, scrollY = 0, 0
	local isDoneFilling = false

	local width, height
	if math.abs(self.directionX) > 0 then
		width = math.clamp(oldWidth + pixels, self.minWidth, gridSizeX)
		height = gridSizeY

		if self.isCollapsing and width == self.minWidth then
			isDoneFilling = true
		elseif self.isExpanding and width == gridSizeX then
			isDoneFilling = true
		end
	end

	if math.abs(self.directionY) > 0 then
		width = gridSizeX
		height = math.clamp(oldHeight + pixels, self.minHeight, gridSizeY)

		if self.isCollapsing and height == self.minHeight then
			isDoneFilling = true
		elseif self.isExpanding and height == gridSizeY then
			isDoneFilling = true
		end
	end

	if not (width == oldWidth and height == oldHeight) then
		self:onSizeUpdate()
	end

	self.wrapper:setSize(width, height)
	self:performLayout()

	if isDoneFilling then
		if self.isExpanding then
			self:onExpand(false)
			self.isExpanding = false
		end

		if self.isCollapsing then
			self:onCollapse(false)
			self.isCollapsing = false
		end
	end
end

function QuickCombatAction:update(delta)
	Widget.update(self, delta)

	if self.isExpanding or self.isCollapsing then
		self:_fill(delta)
	else
		self:_fill(0)
	end
end

return QuickCombatAction
