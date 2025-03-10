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

	self.onBlurChild:register(self._blurChild)
	self.onFocusChild:register(self._focusChild)
	self:setData(GamepadSink, GamepadSink())

	self.currentFocusedWidget = false
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

	if self.currentFocusedWidget and self.currentFocusedWidget:getParent() == self then
		inputProvider:setFocusedWidget(self.currentFocusedWidget, reason)
	elseif self:getNumChildren() > 0 then
		inputProvider:setFocusedWidget(self:getChildAt(1), reason)
	end
end

function GamepadGridLayout:_blurChild(widget)
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
end

function GamepadGridLayout:gamepadDirection(directionX, directionY)
	GridLayout.gamepadDirection(self, directionX, directionY)

	local inputProvider = self:getInputProvider()
	if not inputProvider then
		return
	end

	if not self.currentFocusedWidget then
		inputProvider:setFocus(self:getChildAt(1), "select")
		return
	end

	local focusedWidgetX, focusedWidgetY = self.currentFocusedWidget:getAbsolutePosition()
	local focusedWidgetWidth, focusedWidgetHeight = self.currentFocusedWidget:getSize()

	local focusableWidget
	local focusableWidgetDistance = math.huge
	local oppositeFocusableWidget
	local oppositeFocusableWidgetDistance = 0
	for _, widget in self:iterate() do
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
			local distance = math.sqrt(dx ^ 2 + dy ^ 2)

			if distance > oppositeFocusableWidget then
				oppositeFocusableWidgetDistance = distance
				oppositeFocusableWidget = widget
			end
		end
	end

	if focusableWidget then
		inputProvider:setFocusedWidget(focusableWidget, "select")
	elseif oppositeFocusableWidget then
		inputProvider:setFocusedWidget(oppositeFocusableWidget, "select")
		self:onWrapFocus(oppositeFocusableWidget, directionX, directionY)
	end
end

return GamepadGridLayout
