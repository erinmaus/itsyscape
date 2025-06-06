--------------------------------------------------------------------------------
-- ItsyScape/UI/GamepadGridLayout.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Callback = require "ItsyScape.Common.Callback"
local Class = require "ItsyScape.Common.Class"
local Vector = require "ItsyScape.Common.Math.Vector"
local Config = require "ItsyScape.Game.Config"
local GamepadSink = require "ItsyScape.UI.GamepadSink"
local GridLayout = require "ItsyScape.UI.GridLayout"
local Widget = require "ItsyScape.UI.Widget"

local GamepadGridLayout = Class(GridLayout)

function GamepadGridLayout:new()
	GridLayout.new(self)

	self.onWrapFocus = Callback()
	self.wrapFocus = false

	self.onBlurChild:register(self._blurChild)
	self.onFocusChild:register(self._focusChild)
	self:setData(GamepadSink, GamepadSink())

	self.currentFocusedWidget = false
end

function GamepadGridLayout:setWrapFocus(value)
	self.wrapFocus = value or false
end

function GamepadGridLayout:getWrapFocus()
	return self.wrapFocus
end

function GamepadGridLayout:getIsFocusable()
	return true
end

function GamepadGridLayout:focus(reason)
	GridLayout.focus(self, reason)

	local inputProvider = self:getInputProvider()
	if not inputProvider then
		return
	end

	if self.previousFocusedWidget and self.previousFocusedWidget:getParent() == self then
		inputProvider:setFocusedWidget(self.previousFocusedWidget, reason)
	elseif self:getNumChildren() > 0 then
		for i = 1, self:getNumChildren() do
			local child = self:getChildAt(i)
			if child:getIsFocusable() then
				inputProvider:setFocusedWidget(child, reason)
				break
			end
		end
	end
end

function GamepadGridLayout:_blurChild(widget)
	self.previousFocusedWidget = self.currentFocusedWidget
	self.currentFocusedWidget = false
end

function GamepadGridLayout:_focusChild(widget)
	local previousParent = widget
	local currentParent = widget:getParent()
	while currentParent and currentParent ~= self do
		previousParent = currentParent
		currentParent = currentParent:getParent()
	end

	if currentParent ~= self then
		return
	end

	self.currentFocusedWidget = previousParent
	self:_tryScroll(self.currentFocusedWidget)
end

function GamepadGridLayout:_tryScroll(widget)
	local parent = self:getParent()
	if not parent then
		return
	end

	local parentWidth, parentHeight = parent:getSize()
	local scrollX, scrollY = self:getScroll()
	local scrollSizeX, scrollSizeY = parent:getScrollSize()

	local x, y = widget:getPosition()
	local width, height = widget:getSize()

	if scrollSizeX > parentWidth then
		scrollX = math.clamp(scrollX, x + width - parentWidth, x)
	end

	if scrollSizeY > parentHeight then
		scrollY = math.clamp(scrollY, y + height - parentHeight, y)
	end

	self:setScroll(scrollX, scrollY)
end

function GamepadGridLayout:gamepadDirection(directionX, directionY)
	GridLayout.gamepadDirection(self, directionX, directionY)

	local inputProvider = self:getInputProvider()
	if not inputProvider then
		return
	end

	if not self.currentFocusedWidget then
		inputProvider:setFocusedWidget(self:getChildAt(1), "select")
		return
	end

	local focusedWidgetX, focusedWidgetY = self.currentFocusedWidget:getAbsolutePosition()
	local focusedWidgetWidth, focusedWidgetHeight = self.currentFocusedWidget:getSize()

	local focusableWidget
	local focusableWidgetDistance = math.huge
	local oppositeFocusableWidget
	local oppositeFocusableWidgetEuclideanDistance = math.huge
	local oppositeFocusableWidgetManhattanDistance = 0
	for _, widget in self:iterate() do
		if widget:getIsFocusable() then
			local x, y = widget:getAbsolutePosition()
			local w, h = widget:getSize()

			local dx = (x + w / 2) - (focusedWidgetX + focusedWidgetWidth / 2)
			local dy = (y + h / 2) - (focusedWidgetY + focusedWidgetHeight / 2)

			if ((directionX ~= 0 and math.zerosign(dx) == directionX) or
			    (directionY ~= 0 and math.zerosign(dy) == directionY)) and
			   self.currentFocusedWidget ~= widget
			then
				local distance = math.sqrt(dx ^ 2 + dy ^ 2)

				if distance < focusableWidgetDistance then
					focusableWidgetDistance = distance
					focusableWidget = widget
				end
			end

			if ((directionX ~= 0 and math.zerosign(dx) == -directionX) or
			    (directionY ~= 0 and math.zerosign(dy) == -directionY)) and
			   self.currentFocusedWidget ~= widget
			then
				dx = math.floor(dx)
				dy = math.floor(dy)

				local euclideanDistance = math.sqrt(dx ^ 2 + dy ^ 2)
				local manhattanDistance = math.abs(directionX * dx) + math.abs(directionY * dy)

				if manhattanDistance > oppositeFocusableWidgetManhattanDistance or
				   (manhattanDistance == oppositeFocusableWidgetManhattanDistance and euclideanDistance < oppositeFocusableWidgetEuclideanDistance) then
					oppositeFocusableWidgetEuclideanDistance = euclideanDistance
					oppositeFocusableWidgetManhattanDistance = manhattanDistance
					oppositeFocusableWidget = widget
				end
			end
		end
	end

	if focusableWidget then
		inputProvider:setFocusedWidget(focusableWidget, "select")
	elseif oppositeFocusableWidget then
		if self.wrapFocus then
			inputProvider:setFocusedWidget(oppositeFocusableWidget, "select")
		end

		self:onWrapFocus(oppositeFocusableWidget, directionX, directionY)
	else
		self:onWrapFocus(nil, directionX, directionY)
	end
end

return GamepadGridLayout
