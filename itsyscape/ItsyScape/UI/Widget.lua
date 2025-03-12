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
local DebugStats = require "ItsyScape.Graphics.DebugStats"
local Property = require "ItsyScape.UI.Property"
local WidgetResourceManager = require "ItsyScape.UI.WidgetResourceManager"
local WidgetStyle = require "ItsyScape.UI.WidgetStyle"

local Widget = Class()

function Widget:new()
	self.onMousePress = Callback()
	self.onMouseRelease = Callback()
	self.onMouseEnter = Callback()
	self.onMouseLeave = Callback()
	self.onMouseMove = Callback()
	self.onMouseScroll = Callback()
	self.onFocus = Callback()
	self.onFocusChild = Callback()
	self.onBlur = Callback()
	self.onBlurChild = Callback()
	self.onKeyDown = Callback()
	self.onKeyUp = Callback()
	self.onType = Callback()
	self.onGamepadPress = Callback()
	self.onGamepadRelease = Callback()
	self.onGamepadAxis = Callback()
	self.onGamepadDirection = Callback()
	self.onZDepthChange = Callback()
	self.onStyleChange = Callback()
	self.id = false
	self.text = ""
	self.isFocused = false
	self.isChildFocused = false
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
	self.isClickThrough = false
	self.isVisible = true
end

function Widget:getRootParent()
	local current = self
	while current:getParent() do
		current = current:getParent()
	end

	return current
end

function Widget:getInputProvider()
	-- Cyclic dependency. RIP.
	local WidgetInputProvider = require "ItsyScape.UI.WidgetInputProvider"

	local root = self:getRootParent()
	if not root then
		return
	end


	local inputProvider = root:getData(WidgetInputProvider)
	if not Class.isCompatibleType(inputProvider, WidgetInputProvider) then
		return nil
	end

	return inputProvider
end

function Widget:getResourceManager()
	local root = self:getRootParent()
	if not root then
		return
	end

	local resources = root:getData(WidgetResourceManager)
	if not Class.isCompatibleType(resources, WidgetResourceManager) then
		return nil
	end

	return resources
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

function Widget:clearChildren()
	while self:getNumChildren() > 0 do
		self:removeChild(self:getChildAt(1))
	end
end

function Widget:getNumChildren()
	return #self.children
end

function Widget:getChildAt(index)
	return self.children[index]
end

function Widget:hasParent(p)
	local previous = p
	local current = self.parent
	while current do
		if current == p then
			return true, previous
		else
			previous = current
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

function Widget:setIsVisible(value)
	self.isVisible = value == nil and true or (not not value)
end

function Widget:getIsVisible()
	return self.isVisible
end

function Widget:isChildVisible(childWidget)
	return childWidget:getIsVisible()
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

function Widget:getIsDraggable()
	return false
end

function Widget:getIsClickThrough()
	return self.isClickThrough or (self:getParent() and self:getParent():getIsClickThrough())
end

function Widget:setIsClickThrough(value)
	self.isClickThrough = value or false
end

function Widget:performLayout()
	-- Nothing.
end

function Widget:getStyle()
	if not Class.isCompatibleType(self.style, WidgetStyle) and self.styleType then
		local resourceManager = self:getResourceManager()
		if not resourceManager then
			return false
		end

		self.style = self.styleType(self.style, resourceManager)
		self.styleType = nil

		self:onStyleChange(self.style)
	end

	return self.style
end

function Widget:setStyle(style, styleType)
	self.style = style or false
	self.styleType = styleType

	if self.style and Class.isCompatibleType(self.style, WidgetStyle) then
		self:onStyleChange(self.style)
	end
end

function Widget:getOverflow()
	return false
end

-- Returns true if the widget's bounding box should emit a size for
-- draw caching.
function Widget:getIsBlocking()
	return true
end

function Widget:getIsFocusable()
	return false
end

function Widget:getIsChildFocused()
	return self.isChildFocused
end

function Widget:getIsFocused()
	return self.isFocused
end

function Widget:mousePress(...)
	self:onMousePress(...)
	if self:getParent() then
		self:getParent():mousePress(...)
	end
end

function Widget:mouseRelease(...)
	self:onMouseRelease(...)
	if self:getParent() then
		self:getParent():mouseRelease(...)
	end
end

function Widget:mouseEnter(...)
	self:onMouseEnter(...)
end

function Widget:mouseLeave(...)
	self:onMouseLeave(...)
end

function Widget:mouseMove(...)
	self:onMouseMove(...)
end

function Widget:mouseScroll(...)
	self:onMouseScroll(...)
	if self:getParent() then
		self:getParent():mouseScroll(...)
	end
end

function Widget:focus(...)
	self.isFocused = true
	self.onFocus(self, ...)

	local parent = self:getParent()
	while parent do
		parent:onFocusChild(self, ...)
		parent = parent:getParent()
	end
end

function Widget:blur(...)
	self.isFocused = false
	self.onBlur(self, ...)

	local parent = self:getParent()
	while parent do
		parent:onBlurChild(self, ...)
		parent = parent:getParent()
	end
end

function Widget:keyDown(...)
	self:onKeyDown(...)
	if self:getParent()then
		self:getParent():keyDown(...)
	end
end

function Widget:keyUp(...)
	self:onKeyUp(...)
	if self:getParent()then
		self:getParent():keyUp(...)
	end
end

function Widget:type(...)
	self:onType(...)
	if self:getParent()then
		self:getParent():type(...)
	end
end

function Widget:gamepadPress(...)
	self:onGamepadPress(...)
	if self:getParent() then
		self:getParent():gamepadPress(...)
	end
end

function Widget:gamepadRelease(...)
	self:onGamepadRelease(...)
	if self:getParent() then
		self:getParent():gamepadRelease(...)
	end
end

function Widget:gamepadAxis(...)
	self:onGamepadAxis(...)
	if self:getParent() then
		self:getParent():gamepadAxis(...)
	end
end

function Widget:gamepadDirection(...)
	self:onGamepadDirection(...)
	if self:getParent() then
		self:getParent():gamepadDirection(...)
	end
end


function Widget:update(...)
	if _DEBUG == 'plus' then
		for i = 1, #self.children do
			DebugStats.GLOBAL:measure(self.children[i]:getDebugInfo().shortName, self.children[i].update, self.children[i], ...)
		end
	else
		local index = 1
		local count = #self.children
		while index <= #self.children do
			self.children[index]:update(...)

			if #self.children == count then
				index = index + 1
			end

			count = #self.children
		end

		if self:getResourceManager() and self.styleType then
			-- Force style update.
			self:getStyle()
		end
	end
end

return Widget
