--------------------------------------------------------------------------------
-- ItsyScape/Game/ActionCommand/Component.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"

local Component = Class()
Component.TYPE = "component"

local N = 0

function Component:new()
	N = N + 1
	self.id = N + 1

	self.x = 0
	self.y = 0
	self.width = 1
	self.height = 1
	self.children = {}
	self.parent = false
end

function Component:iterate()
	return ipairs(self.children)
end

function Component:addChild(child)
	if child.parent then
		child.parent:removeChild(child)
	end

	table.insert(self.children, child)
end

function Component:removeChild(child)
	for i = #self.children, 1, -1 do
		if self.children[i] == child then
			table.remove(self.children, i)
		end
	end
end

function Component:serialize(t)
	t.type = self.TYPE
	t.id = self.id
	t.x = self.x
	t.y = self.y
	t.width = self.width
	t.height = self.height
end

function Component:getPosition()
	return self.x, self.y
end

function Component:getX()
	return self.x
end

function Component:getY()
	return self.x
end

function Component:setPosition(x, y)
	self:setX(x)
	self:setY(y)
end

function Component:setX(value)
	self.x = math.max(value or 1)
end

function Component:setY(value)
	self.y = math.max(value or 1)
end

function Component:getSize()
	return self.width, self.height
end

function Component:getWidth()
	return self.width
end

function Component:getHeight()
	return self.width
end

function Component:setSize(width, height)
	self:setWidth(width)
	self:setHeight(height)
end

function Component:setWidth(value)
	self.width = math.max(value or 1)
end

function Component:setHeight(value)
	self.height = math.max(value or 1)
end

return Component
