--------------------------------------------------------------------------------
-- ItsyScape/UI/ToolTip.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Callback = require "ItsyScape.Common.Callback"
local Class = require "ItsyScape.Common.Class"
local Color = require "ItsyScape.Graphics.Color"
local Widget = require "ItsyScape.UI.Widget"

local ToolTip = Class(Widget)
ToolTip.Component = Class()

function ToolTip.Component:new()
	-- Nothing.
end

ToolTip.Header = Class(ToolTip.Component)
function ToolTip.Header:new(text, k)
	ToolTip.Component.new(self)

	k = k or {}
	self.text = text or "Lorem Ipsum"
	self.color = k.color or Color(1, 1, 1, 1)
	self.shadow = k.shadow == nil and true or k.shadow
end

ToolTip.Text = Class(ToolTip.Component)
function ToolTip.Text:new(text, k)
	ToolTip.Component.new(self)

	k = k or {}
	self.text = text or "Lorem ipsum dolor sit amet, consectetur adipiscing elit."
	self.color = k.color or Color(1, 1, 1, 1)
	self.shadow = k.shadow == nil and true or k.shadow
end

ToolTip.Image = Class(ToolTip.Component)
function ToolTip.Image:new(text, k)
	ToolTip.Component.new(self)

	self.image = love.graphics.newImage(image)
	self.sizeX = k.sizeX or false
	self.sizeY = k.sizeY or false
	self.inline = k.inline or true
end

function ToolTip:new(...)
	Widget.new(self)
	self:setValues(...)

	self.onLayout = Callback()

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
