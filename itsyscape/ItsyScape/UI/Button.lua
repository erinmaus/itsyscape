--------------------------------------------------------------------------------
-- ItsyScape/UI/Button.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Callback = require "ItsyScape.Common.Callback"
local Widget = require "ItsyScape.UI.Widget"

local Button = Class(Widget)

function Button:new()
	Widget.new(self)
	self.onClick = Callback()
	self.isMouseOver = false
	self.isPressed = false
end

function Button:getIsFocusable()
	return true
end

function Button:mouseEnter(...)
	self.isMouseOver = true
	Widget.mouseEnter(self, ...)
end

function Button:mouseLeave(...)
	self.isMouseOver = false
	Widget.mouseLeave(self, ...)
end

function Button:mousePress(x, y, button)
	if button == 1 then
		self.isPressed = true
	end
end

function Button:mouseRelease(x, y, button, ...)
	if self.isPressed and self.isMouseOver then
		self.onClick(self)
		self:blur()
	end

	self.isPressed = false

	Widget.mouseRelease(self, x, y, button, ...)
end

function Button:keyUp(key, ...)
	if key == 'enter' or key == 'space' then
		self.onClick(self)
	end

	Widget.keyUp(self, key, ...)
end

return Button
