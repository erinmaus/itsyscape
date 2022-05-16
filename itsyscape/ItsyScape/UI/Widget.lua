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
	self.onMouseScroll = Callback()
	self.onFocus = Callback()
	self.onBlur = Callback()
	self.onKeyDown = Callback()
	self.onKeyUp = Callback()
	self.onType = Callback()
	self.onZDepthChange = Callback()
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
	self.zDepth = 1
	self.children = {}
	self.zSortedChildren = {}
	self.parent = false
	self.style = false
	self.properties = {}
	self.childProperties = {}
	self.data = {}
	self.toolTip = false
end

function Widget:getID()
	return self.id
end

function Widget:setID(value)
	self.id = value or false
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
		child.parent:removeChild(child)
		child.parent:_markZDepthDirty()
	end

	self.childProperties[child] = {}
	table.insert(self.children, child)
	child.onZDepthChange:register(self._onZDepthChange, self)
	child.parent = self

	self:_markZDepthDirty()
end

function Widget:removeChild(child)
	for i = 1, #self.children do
		if self.children[i] == child then
			table.remove(self.children, i)
			child.parent = nil
			child.onZDepthChange:unregister(self._onZDepthChange)
			self:_markZDepthDirty()
			self.childProperties[child] = nil
			return true
		end
	end

	return false
end

function Widget:setChildProperty(child, key, value)
	local p = self.childProperties[child]
	if p then
		p[key] = value
	end
end

function Widget:unsetChildProperty(child, key)
	self:setChildProperty(child, key, nil)
end

function Widget:getChildProperty(child, key, default)
	local p = self.childProperties[child]
	if p then
		return p[key] or default
	end

	return default
end

function Widget:zIterate()
	if self._zDepthDirty then
		local c = {}
		for index, child in self:iterate() do
			table.insert(c, {
				index = index,
				widget = child
			})
		end

		table.sort(c, function(a, b)
			local i = a.widget:getZDepth()
			local j = b.widget:getZDepth()
			if i < j then
				return true
			elseif i > j then
				return false
			elseif i == j then
				return a.index < b.index
			end
		end)

		table.clear(self.zSortedChildren)
		for i = 1, #c do
			table.insert(self.zSortedChildren, c[i].widget)
		end

		self._zDepthDirty = false
	end

	return ipairs(self.zSortedChildren)
end

function Widget:iterate()
	return ipairs(self.children)
end

function Widget:hasParent(p)
	local current = self.parent
	while current do
		if current == p then
			return true
		else
			current = current.parent
		end
	end

	return false
end

function Widget:isParentOf(widget)
	for _, child in self:iterate() do
		if child == widget or child:isParentOf(widget) then
			return true
		end
	end

	return false
end

function Widget:isSiblingOf(widget)
	if self.parent then
		for _, child in self.parent:iterate() do
			if child == widget then
				return true
			end
		end
	end

	return false
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

function Widget:getAbsolutePosition()
	local x, y = self.x, self.y
	local parent = self:getParent()
	while parent do
		local px, py = parent:getPosition()
		local sx, sy = parent:getScroll()
		x = x + px - sx
		y = y + py - sy
		parent = parent:getParent()
	end

	return x, y
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

	self.scrollWidth = math.max(w or self.scrollWidth, self.width)
	self.scrollHeight = math.max(h or self.scrollHeight, self.height)

	if oldScrollWidth ~= self.scrollWidth or
	   oldScrollHeight ~= self.scrollHeight
	then
		self:performLayout()
	end
end

function Widget:getZDepth()
	return self.zDepth
end

function Widget:_onZDepthChange(child, value)
	self._zDepthDirty = true
end

function Widget:_markZDepthDirty()
	self._zDepthDirty = true
end

function Widget:setZDepth(value)
	local oldValue = self.zDepth
	self.zDepth = value or self.zDepth
	if oldValue ~= self.zDepth then
		self:onZDepthChange(value)
	end
end

function Widget:getToolTip()
	if not self.toolTip then
		return false
	else
		return unpack(self.toolTip, 1, self.toolTip.n)
	end
end

function Widget:setToolTip(...)
	if select('#', ...) == 0 then
		self.toolTip = false
	else
		self.toolTip = { n = select('#', ...), ... }
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

function Widget:mouseScroll(...)
	self.onMouseScroll(self, ...)
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
	for i = 1, #self.children do
		self.children[i]:update(...)
	end
end

return Widget
