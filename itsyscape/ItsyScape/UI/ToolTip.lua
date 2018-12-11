--------------------------------------------------------------------------------
-- ItsyScape/UI/ToolTip.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Color = require "ItsyScape.Graphics.Color"
local Widget = require "ItsyScape.UI.Widget"

local ToolTip = Class(Widget)
ToolTip.Header = Class()
function ToolTip.Header:new(text, k)
	k = k or {}
	self.text = text or "Lorem Ipsum"
	self.color = k.color or Color(0, 0, 0, 1)
end

ToolTip.Text = Class()
function ToolTip.Text:new(text, k)
	k = k or {}
	self.text = text or "Lorem ipsum dolor sit amet, consectetur adipiscing elit."
	self.color = k.color or Color(0, 0, 0, 1)
end

ToolTip.Image = Class()
function ToolTip.Image:new(text, k)
	self.image = love.graphics.newImage(image)
	self.sizeX = k.sizeX or false
	self.sizeY = k.sizeY or false
	self.inline = k.inline or true
end

function ToolTip:new(...)
	Widget.new(self)
	self:setValues(...)

	self.duration = math.huge
end

function ToolTip:getOverflow()
	return true
end

function ToolTip:getValues()
	return self.values
end

function ToolTip:setValues(...)
	self.values = { n = select('#', ...), ... }
end

function ToolTip:getDuration(value)
	return self.duration
end

function ToolTip:setDuration(value)
	self.duration = value or math.huge
end

function ToolTip:update(delta, ...)
	Widget.update(self, delta, ...)

	self.duration = self.duration - delta
end

return ToolTip
