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
local StatBar = require "ItsyScape.UI.Interfaces.Components.StatBar"
local Widget = require "ItsyScape.UI.Widget"

local QuickCombatAction = Class(Widget)
QuickCombatAction.BUTTON_SIZE = 48
QuickCombatAction.CONTROL_SIZE = 32
QuickCombatAction.BUTTON_PADDING = 4
QuickCombatAction.STAT_BAR_HEIGHT = 8
QuickCombatAction.PADDING = 8
QuickCombatAction.EXPAND_SPEED_PIXELS_PER_SECOND = QuickCombatAction.BUTTON_SIZE * 8
QuickCombatAction.CONTROL_EXPAND_TIME_SECONDS = 1
QuickCombatAction.CONTROL_EXPAND_TIME_SHOW_SECONDS = 0.25

function QuickCombatAction:new()
	Widget.new(self)

	self.wrapper = Widget()
	self:addChild(self.wrapper)

	self.onExpand = Callback()
	self.onCollapse = Callback()
	self.onSizeUpdate = Callback()
	self.onActivate = Callback()

	self.onFocusChild:register(self._childFocused, self)
	self.onBlurChild:register(self._childBlurred, self)

	self.directionX = 0
	self.directionY = 1

	-- The control icon sits just outside
	self:setSize(
		QuickCombatAction.BUTTON_SIZE + self.BUTTON_PADDING * 4,
		QuickCombatAction.BUTTON_SIZE + self.BUTTON_PADDING * 4)
	self.wrapper:setSize(self:getSize())

	self.minWidth, self.minHeight = self:getSize()

	self.gamepadToolTip = GamepadToolTip()
	self.gamepadToolTip:setHasBackground(false)
	self.gamepadToolTip:setRowSize(
		math.huge,
		self.CONTROL_SIZE)
	self.gamepadToolTip:setPosition(
		-self.BUTTON_PADDING,
		self.BUTTON_SIZE + self.BUTTON_PADDING * 2 - self.CONTROL_SIZE + self.BUTTON_PADDING)

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

	self.isCollapsing = false
	self.isExpanding = false
	self.isExpanded = false
	self.isCollapsed = true

	self.controlName = false
	self.isControlDown = false
	self.controlDownTime = 0
	self.controlTimeStatBar = StatBar()
	self.controlTimeStatBar:setSize(
		self.BUTTON_SIZE,
		self.STAT_BAR_HEIGHT)
	self.controlTimeStatBar:setPosition(
		self.BUTTON_PADDING,
		self.BUTTON_SIZE + self.BUTTON_PADDING * 2 - self.STAT_BAR_HEIGHT - self.BUTTON_PADDING)
end

function QuickCombatAction:setControl(controlName)
	self.controlName = controlName
	self.gamepadToolTip:setControl(controlName)
end

function QuickCombatAction:getControl()
	return self.controlName
end

function QuickCombatAction:previewControlDown(control)
	Widget.previewControlDown(self, control)

	if control:is(self.controlName) and not (self.isExpanded or self.isExpanding) then
		self.isControlDown = true
		self.controlDownTime = 0
	end
end

function QuickCombatAction:previewControlUp(control)
	Widget.previewControlUp(self, control)

	if control:is(self.controlName) then
		self.isControlDown = false
		self:performLayout()

		if self.controlDownTime <= self.CONTROL_EXPAND_TIME_SHOW_SECONDS then
			self:onActivate(self:getChildAt(1))
		end
	end
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

	if self.isControlDown and self.controlDownTime > self.CONTROL_EXPAND_TIME_SHOW_SECONDS and self.controlTimeStatBar:getParent() ~= self then
		self:addChild(self.controlTimeStatBar)
	elseif not (self.isControlDown and self.controlDownTime > self.CONTROL_EXPAND_TIME_SHOW_SECONDS) and self.controlTimeStatBar:getParent() == self then
		self:removeChild(self.controlTimeStatBar)
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
			self.isExpanded = true
		end

		if self.isCollapsing then
			self:onCollapse(false)
			self.isCollapsing = false
			self.isCollapsed = true
		end
	else
		self.isExpanded = false
		self.isCollapsed = false
	end
end

function QuickCombatAction:_control(delta)
	if not self.isControlDown then
		return
	end

	self.controlDownTime = self.controlDownTime + delta
	if self.controlDownTime > self.CONTROL_EXPAND_TIME_SECONDS then
		local firstChild = self:getInnerPanel():getChildAt(1)
		if firstChild then
			firstChild:focus()
		end

		self.controlDownTime = 0
		self.isControlDown = false
	end

	if self.controlDownTime > self.CONTROL_EXPAND_TIME_SHOW_SECONDS then
		self.controlTimeStatBar:updateProgress(
			self.controlDownTime - self.CONTROL_EXPAND_TIME_SHOW_SECONDS,
			self.CONTROL_EXPAND_TIME_SECONDS - self.CONTROL_EXPAND_TIME_SHOW_SECONDS)
	end

	self:performLayout()
end

function QuickCombatAction:update(delta)
	Widget.update(self, delta)

	self:_control(delta)

	if self.isExpanding or self.isCollapsing then
		self:_fill(delta)
	end
end

return QuickCombatAction
