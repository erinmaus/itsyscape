--------------------------------------------------------------------------------
-- ItsyScape/Game/ActionCommand/Rectangle.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Color = require "ItsyScape.Graphics.Color"
local Component = require "ItsyScape.Game.ActionCommands.Component"

local Rectangle = Class(Component)
Rectangle.TYPE = "rectangle"

function Rectangle:new()
	Component.new(self)

	self.color = Color(1, 0, 0)
	self.fillMode = "line"
	self.lineWidth = 1
	self.radius = 0
end

function Rectangle:getColor()
	return self.color
end

function Rectangle:setColor(value)
	self.color = value
end

function Rectangle:getFillMode()
	return self.fillMode
end

function Rectangle:setFillMode(value)
	self.fillMode = value
end

function Rectangle:getLineWidth()
	return self.lineWidth
end

function Rectangle:setLineWidth(value)
	self.lineWidth = value
end

function Rectangle:getRadius()
	return self.radius
end

function Rectangle:setRadius(value)
	self.radius = value
end

function Rectangle:serialize(t)
	Component.serialize(self, t)

	t.color = { self.color:get() }
	t.fillMode = self.fillMode
	t.lineWidth = self.lineWidth
	t.radius = self.radius
end

return Rectangle
