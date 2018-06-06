--------------------------------------------------------------------------------
-- ItsyScape/UI/Widget.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Callback = require "ItsyScape.Common.Callback"
local Property = require "ItsyScape.UI.Property"

local Widget = Class()

function Widget:new()
	self.onMousePress = Callback()
	self.onMouseRelease = Callback()
	self.onMouseEnter = Callback()
	self.onMouseLeave = Callback()
	self.onMouseMove = Callback()
	self.onFocus = Callback()
	self.onBlur = Callback()
	self.onKeyDown = Callback()
	self.onKeyUp = Callback()
	self.onType = Callback()
	self.id = false
	self.text = ""
	self.isFocused = false
	self.x = 0
	self.y = 0
	self.width = 0
	self.height = 0
	self.scrollX = 0
	self.scrollY = 0
	self.scrollWidth = 0
	self.scrollHeight = 0
	self.children = {}
	self.parent = false
	self.style = false
	self.properties = {}
	self.data = {}
end

-- Binds 'property' to the path.
function Widget:bind(property, path)
	self.properties[property] = {
		property = Property(path),
		default = function(d)
			if self[property] ~= nil then
				return self[property]
			else
				return d
			end
		end
	}
end

-- Gets a property.
--
-- 'p' is some data source that has overriden properties.
--
-- 'd' is the default value, or nil if there is none. This value is used if the
-- property does not exist in 'p' and in the widget.
function Widget:get(property, p, d)
	local binding = self.properties[property]
	if binding then
		return binding.property:get(p, self.data, binding.default(d))
	else
		if self[property] ~= nil then
			return self[property]
		else
			return nil
		end
	end
end

function Widget:setData(key, value)
	self.data[key] = value
end

function Widget:unsetData(key)
	self:setData(key, nil)
end

function Widget:getData(key)
	return self.data[key]
end

function Widget:deserialize(t)
	t = t or {}

	self.id = t.id or false
	self.text = t.text or ""
	self:setPosition(t.x or self.x, t.y or self.y)
	self:setScroll(t.scrollX or self.scrollX, t.scrollY or self.scrollY)
	self:setScrollSize(t.scrollWidth or self.scrollWidth, t.scrollHeight or self.scrollHeight)
	self:setSize(t.width or self.width, t.height or self.height)
	self:setStyle(t.style or self.style)
end

function Widget:find(id, after, e)
	e = e or false

	for i = 1, #self.children do
		if self.children[i].id == id then
			if self.children[i] == after then
				e = true
			elseif e or after == nil then
				return self.children[i]
			end
		end

		local result = self.children:find(id, after, e)
		if result then
			return result
		end
	end
end

function Widget:findAll(id)
	local current = nil
	return function()
		local c = self:find(id, current)
		if c then
			current = c
		end

		return c
	end
end

function Widget:addChild(child)
	if child.parent then
		local c = child.parent.children
		for i = 1, #c do
			if c[i] == child then
				table.remove(c, i)
				break
			end
		end
	end

	table.insert(self.children, child)
	child.parent = self
end

function Widget:removeChild(child)
	for i = 1, #self.children do
		if self.children[i] == child then
			table.remove(self.children, i)
			return true
		end
	end

	return false
end

function Widget:iterate()
	return ipairs(self.children)
end

function Widget:getParent()
	return self.parent
end

function Widget:getID()
	return self.id
end

function Widget:getText()
	return self.text
end

function Widget:setText(value)
	self.text = value or self.text
end

function Widget:getPosition()
	return self.x, self.y
end

function Widget:setPosition(x, y)
	self.x = x or self.x
	self.y = y or self.y
end

function Widget:getSize()
	return self.width, self.height
end

function Widget:setSize(w, h)
	self.width = w or self.width
	self.height = h or self.height

	self:setScrollSize(
		math.max(self.scrollWidth, self.width),
		math.max(self.scrollHeight, self.height))
end

function Widget:getScroll()
	return self.scrollX, self.scrollY
end

function Widget:setScroll(x, y)
	self.scrollX = x or self.scrollX
	self.scrollY = y or self.scrollY
end

function Widget:getScrollSize()
	return self.scrollWidth, self.scrollHeight
end

function Widget:setScrollSize(w, h)
	local oldScrollWidth = self.scrollWidth
	local oldScrollHeight = self.scrollHeight

	self.scrollWidth = w or self.scrollWidth
	self.scrollHeight = h or self.scrollHeight

	if oldScrollWidth ~= self.scrollWidth or
	   oldScrollHeight ~= self.scrollHeight
	then
		self:performLayout()
	end
end

function Widget:performLayout()
	-- Nothing.
end

function Widget:getStyle()
	return self.style
end

function Widget:setStyle(style)
	self.style = style or false
end

function Widget:getOverflow()
	return false
end

function Widget:getIsFocusable()
	return false
end

function Widget:getIsFocused()
	return self.isFocused
end

function Widget:mousePress(...)
	self.onMousePress(self, ...)
end

function Widget:mouseRelease(...)
	self.onMouseRelease(self, ...)
end

function Widget:mouseEnter(...)
	self.onMouseEnter(self, ...)
end

function Widget:mouseLeave(...)
	self.onMouseLeave(self, ...)
end

function Widget:mouseMove(...)
	self.onMouseMove(self, ...)
end

function Widget:focus(...)
	self.onFocus(self, ...)
	self.isFocused = true
end

function Widget:blur(...)
	self.onBlur(self, ...)
	self.isFocused = false
end

function Widget:keyDown(...)
	self.onKeyDown(self, ...)
	return false
end

function Widget:keyUp(...)
	self.onKeyUp(self, ...)
	return false
end

function Widget:type(...)
	self.onType(self, ...)
end

function Widget:update(...)
	-- Nothing.
end

return Widget
