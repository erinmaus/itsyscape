--------------------------------------------------------------------------------
-- ItsyScape/UI/Interfaces/DebugNavigation.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Color = require "ItsyScape.Graphics.Color"
local Button = require "ItsyScape.UI.Button"
local ButtonStyle = require "ItsyScape.UI.ButtonStyle"
local CloseButton = require "ItsyScape.UI.CloseButton"
local Drawable = require "ItsyScape.UI.Drawable"
local GamepadGridLayout = require "ItsyScape.UI.GamepadGridLayout"
local Interface = require "ItsyScape.UI.Interface"
local Label = require "ItsyScape.UI.Label"
local LabelStyle = require "ItsyScape.UI.LabelStyle"
local Panel = require "ItsyScape.UI.Panel"
local PanelStyle = require "ItsyScape.UI.PanelStyle"
local ScrollablePanel = require "ItsyScape.UI.ScrollablePanel"
local Theme = require "ItsyScape.UI.Interfaces.Theme"
local Widget = require "ItsyScape.UI.Widget"

local DebugNavigation = Class(Interface)

DebugNavigation.WIDTH  = 800
DebugNavigation.HEIGHT = 600
DebugNavigation.TITLE_HEIGHT = 48

DebugNavigation.Map = Class(Drawable)

function DebugNavigation.Map:new()
	Drawable.new(self)

	self.points = {}
	self.edges = {}
	self.triangles = {}
	self.path = {}

	self.panX, self.panY = 0, 0
	self.isPanning = false
	self.zoom = 16

	self.currentX, self.currentY = false, false
	self.pathStartX, self.pathStartY = 0, 0
	self.pathEndX, self.pathEndY = 0, 0
	self.path = {}
	self.isPathing = false
	self.pathMoved = false
end

function DebugNavigation.Map:getIsFocusable()
	return true
end

function DebugNavigation.Map:setLayer(layerInfo, layer)
	self.layerInfo = layerInfo
	self.points = layer.points
	self.edges = layer.edges
	self.triangles = layer.triangles
	self.panX, self.panY = 0, 0
	self.isPanning = false

	self.pathStartX, self.pathStartY = 0, 0
	self.pathEndX, self.pathEndY = 0, 0
	self.path = {}
	self.isPathing = false

	self.zoom = 16
end

function DebugNavigation.Map:setPath(path, debugInfo)
	self.path = path
	self.debugInfo = debugInfo
end

function DebugNavigation.Map:mousePress(x, y, button, ...)
	Drawable.mouseMove(self, x, y, button, ...)

	if button == 1 then
		self.isPanning = true
		self.clickX = x
		self.clickY = y

		self:focus()
	elseif button == 2 then
		self.isPathing = true

		local absoluteX, absoluteY = self:getAbsolutePosition()
		local relativeX, relativeY = x - absoluteX - self.panX, y - absoluteY - self.panY

		self.pathStartX, self.pathStartY = relativeX, relativeY
	end
end

function DebugNavigation.Map:mouseMove(x, y, ...)
	if self.isPanning then
		self.panX = self.panX - (self.clickX - x)
		self.panY = self.panY - (self.clickY - y)

		self.clickX = x
		self.clickY = y
	end

	local absoluteX, absoluteY = self:getAbsolutePosition()
	local relativeX, relativeY = x - absoluteX, y - absoluteY
	self.currentX, self.currentY = relativeX - self.panX, relativeY - self.panY

	if self.isPathing then
		self.pathEndX, self.pathEndY = self.currentX, self.currentY
		self.pathMoved = true
	end

end

function DebugNavigation.Map:mouseRelease(x, y, button)
	Drawable.mouseRelease(self, x, y, button)

	if button == 1 and self.isPanning then
		self.isPanning = false
	end

	if button == 2 and self.isPathing then
		self.isPathing = false
		self.pathMoved = false
	end
end

function DebugNavigation.Map:mouseLeave(x, y)
	self.currentX, self.currentY = false, false
end

function DebugNavigation.Map:mouseScroll(x, y)
	Drawable.mouseScroll(self, x, y)

	self.zoom = math.clamp(self.zoom + y, 4, 32)
end

function DebugNavigation.Map:tick()
	if self.isPathing and self.pathMoved then
		local parent = self:getParentOfType(Interface)
		if parent then
			local p = {
				startX = self.pathStartX / self.zoom,
				startY = self.pathStartY / self.zoom,
				endX = self.pathEndX / self.zoom,
				endY = self.pathEndY / self.zoom,
				group = self.layerInfo.group,
				localLayer = self.layerInfo.localLayer
			}

			if love.keyboard.isDown("lctrl") or love.keyboard.isDown("rctrl") then
				p.startX = (math.floor((p.startX / 2)) + 0.5) * 2
				p.startY = (math.floor((p.startY / 2)) + 0.5) * 2
				p.endX = (math.floor((p.endX / 2)) + 0.5) * 2
				p.endY = (math.floor((p.endY / 2)) + 0.5) * 2
			end

			parent:sendPoke("path", nil, p)
		end

		self.pathMoved = false
	end
end

function DebugNavigation.Map:_draw()
	love.graphics.push("all")

	local x, y = self:getAbsolutePosition()
	local w, h = self:getSize()

	love.graphics.setScissor(x, y, w, h)

	love.graphics.setColor(0, 0, 0, 1)
	love.graphics.rectangle("fill", 0, 0, w, h)

	if self.currentX and self.currentY then
		local s = self.currentX / self.zoom
		local t = self.currentY / self.zoom

		love.graphics.setColor(0, 1, 1, 1)
		love.graphics.print(string.format("xz: %0.2f, %0.2f\nij: %d, %d\nzoom: %dx", s, t, math.floor(s / 2) + 1, math.floor(t / 2) + 1, self.zoom))
	end

	love.graphics.translate(self.panX, self.panY)
	love.graphics.setColor(1, 1, 1, 1)

	love.graphics.setColor(1, 1, 1, 0.1)
	for _, triangle in ipairs(self.triangles) do
		local i, j, k = unpack(triangle.indices)

		local x1, y1 = unpack(self.points, (i - 1) * 2 + 1, (i - 1) * 2 + 2)
		local x2, y2 = unpack(self.points, (j - 1) * 2 + 1, (j - 1) * 2 + 2)
		local x3, y3 = unpack(self.points, (k - 1) * 2 + 1, (k - 1) * 2 + 2)

		love.graphics.polygon("fill",
			x1 * self.zoom, y1 * self.zoom,
			x2 * self.zoom, y2 * self.zoom,
			x3 * self.zoom, y3 * self.zoom)
	end

	if self.zoom >= 24 then
		for _, triangle in ipairs(self.triangles) do
			local i, j, k = unpack(triangle.indices)

			local x1, y1 = unpack(self.points, (i - 1) * 2 + 1, (i - 1) * 2 + 2)
			local x2, y2 = unpack(self.points, (j - 1) * 2 + 1, (j - 1) * 2 + 2)
			local x3, y3 = unpack(self.points, (k - 1) * 2 + 1, (k - 1) * 2 + 2)

			local centerX = (x1 + x2 + x3) / 3
			local centerY = (y1 + y2 + y3) / 3

			local text = tostring(triangle.index)
			local width = love.graphics.getFont():getWidth(text)
			love.graphics.setColor(1, 1, 1, 1)
			love.graphics.print(text, centerX * self.zoom - width / 2, centerY * self.zoom - 4)

			for _, index in ipairs(triangle.indices) do
				local text = tostring(index)
				local width = love.graphics.getFont():getWidth(text)

				local x, y = unpack(self.points, (index - 1) * 2 + 1, (index - 1) * 2 + 2)
				love.graphics.setColor(0, 1, 1, 0.5)
				love.graphics.print(text, x * self.zoom - width / 2, y * self.zoom - 4)
			end
		end
	end

	love.graphics.setLineStyle("rough")
	love.graphics.setLineJoin("none")

	for _, triangle in ipairs(self.triangles) do
		for index, i in ipairs(triangle.indices) do
			local j = triangle.indices[math.wrapIndex(index, 1, #triangle.indices)]
			local userdata = triangle.userdata[index]

			local isWall = false
			local isDoor = false
			if userdata then
				for _, tile in ipairs(userdata) do
					if tile.flags["door"] then
						isDoor = true
					elseif tile.flags["impassable"] then
						isWall = true
					end
				end
			end

			if isDoor then
				love.graphics.setLineWidth(4)
				love.graphics.setColor(0, 0, 1, 1)
			elseif isWall then
				love.graphics.setLineWidth(1)
				love.graphics.setColor(1, 0, 0, 1)
			else
				love.graphics.setLineWidth(1)
				love.graphics.setColor(1, 1, 1, 0.25)
			end

			local x1, y1 = unpack(self.points, (i - 1) * 2 + 1, (i - 1) * 2 + 2)
			local x2, y2 = unpack(self.points, (j - 1) * 2 + 1, (j - 1) * 2 + 2)

			love.graphics.line(x1 * self.zoom, y1 * self.zoom, x2 * self.zoom, y2 * self.zoom)
		end
	end

	if self.debugInfo and self.debugInfo.visited then
		love.graphics.setColor(1, 0, 1, 0.25)
		love.graphics.setLineWidth(1)

		for _, edge in ipairs(self.debugInfo.visited) do
			love.graphics.line(
				edge[1] * self.zoom,
				edge[2] * self.zoom,
				edge[3] * self.zoom,
				edge[4] * self.zoom)
		end
	end

	local numPathPoints = math.floor(#self.path / 2)
	local path = {}
	for index = 1, numPathPoints do
		local i = (index - 1) * 2 + 1 
		local j = i + 1

		local x = self.path[i] * self.zoom
		local y = self.path[j] * self.zoom

		table.insert(path, x)
		table.insert(path, y)
	end

	love.graphics.setColor(1, 1, 0, 1)
	love.graphics.setLineWidth(2)

	if numPathPoints >= 2 then
		love.graphics.line(path)
	end

	love.graphics.setColor(1, 0, 0, 1)
	love.graphics.setPointSize(8)
	love.graphics.points(path)

	if self.currentX and self.currentY then
		love.graphics.setColor(0, 1, 0, 0.5)
		love.graphics.setLineWidth(1)
		love.graphics.circle("line", self.currentX, self.currentY, 0.5 * self.zoom)

		love.graphics.setColor(0, 1, 0, 1)
		love.graphics.setLineWidth(2)
		love.graphics.circle("line", self.currentX, self.currentY, 0.75 * self.zoom)
	end

	love.graphics.pop()
end

function DebugNavigation.Map:draw()
	Drawable.draw(self)

	itsyrealm.graphics.pushCallback(self._draw, self)
end

function DebugNavigation:new(id, index, ui)
	Interface.new(self, id, index, ui)

	self:setSize(self.WIDTH, self.HEIGHT)

	local titlePanel = Panel()
	titlePanel:setStyle(Theme.WINDOW_TITLE_PANEL_STYLE, PanelStyle)
	titlePanel:setPosition(0, 0)
	titlePanel:setSize(self.WIDTH, self.TITLE_HEIGHT + Theme.DEFAULT_OUTER_PADDING * 2)
	self:addChild(titlePanel)

	self.closeButton = Theme.newCloseButton(titlePanel)

	local titleLabel = Label()
	titleLabel:setStyle(Theme.WINDOW_TITLE_LABEL_STYLE, LabelStyle)
	titleLabel:setText("Navigation Debugger")
	titleLabel:setPosition(Theme.DEFAULT_OUTER_PADDING, Theme.DEFAULT_OUTER_PADDING)
	titlePanel:addChild(titleLabel)

	local contentPanel = Theme.newContentPanel(
		self,
		self.WIDTH,
		self.HEIGHT - self.TITLE_HEIGHT - Theme.DEFAULT_OUTER_PADDING * 2,
		titlePanel)
	local contentWidth, contentHeight = contentPanel:getSize()

	self.layerGrid = ScrollablePanel(GamepadGridLayout)
	self.layerGrid:setSize(contentWidth / 3, contentHeight - Theme.DEFAULT_OUTER_PADDING)
	contentPanel:addChild(self.layerGrid)

	self.map = DebugNavigation.Map()
	self.map:setSize(
		Theme.calculateRemainingSizeWithPadding(Theme.DEFAULT_OUTER_PADDING, contentWidth, self.WIDTH / 3),
		Theme.calculateRemainingSizeWithPadding(Theme.DEFAULT_OUTER_PADDING, contentHeight))
	self.map:setPosition(contentWidth / 3 + Theme.DEFAULT_OUTER_PADDING, Theme.DEFAULT_OUTER_PADDING)
	contentPanel:addChild(self.map)

	local state = self:getState()
	if state and state.layers then
		self:populateLayers(state.layers)
	end

	self:performLayout()
end

function DebugNavigation:performLayout()
	Interface.performLayout(self)

	local width, height = itsyrealm.graphics.getScaledMode()
	local selfWidth, selfHeight = self:getSize()
	self:setPosition((width - selfWidth) / 2, (height - selfHeight) / 2)
end

function DebugNavigation:attach()
	self:focusChild(self.layerGrid:getInnerPanel())
end

function DebugNavigation:restoreFocus()
	self:focusChild(self.layerGrid:getInnerPanel())
end

function DebugNavigation:populateLayers(layers)
	local gridWidth, gridHeight = self.layerGrid:getSize()

	self.layerGrid:clearChildren()
	for index, layerInfo in ipairs(layers) do
		local button = Button()

		local label = Label()
		label:setStyle(Theme.BUTTON_LABEL_STYLE, LabelStyle)
		label:setText(string.format("%s@%d", layerInfo.resource, layerInfo.localLayer))
		button:addChild(label)

		button.onClick:register(self.selectLayer, self, layerInfo)

		self.layerGrid:addChild(button)
	end

	self.layerGrid:getInnerPanel():setPadding(Theme.DEFAULT_INNER_PADDING, Theme.DEFAULT_INNER_PADDING)
	self.layerGrid:getInnerPanel():setUniformSize(true, gridWidth - Theme.DEFAULT_INNER_PADDING * 2, Theme.DEFAULT_BUTTON_SIZE + Theme.DEFAULT_INNER_PADDING * 2)
	self.layerGrid:getInnerPanel():performLayout()

	local scrollableWidth, scrollableHeight = self.layerGrid:getInnerPanel():getSize()
	if scrollableHeight > gridHeight then
		self.layerGrid:getInnerPanel():setUniformSize(
			gridWidth - ScrollablePanel.DEFAULT_SCROLL_SIZE - Theme.DEFAULT_INNER_PADDING * 2,
			Theme.DEFAULT_BUTTON_SIZE + Theme.DEFAULT_INNER_PADDING * 2)
		scrollableWidth, scrollableHeight = self.layerGrid:getInnerPanel():getSize()
	end

	self.layerGrid:getInnerPanel():setScrollSize(scrollableWidth, scrollableHeight)
end

function DebugNavigation:selectLayer(layer, button, index)
	if index ~= 1 then
		return
	end

	if self.activeButton then
		self.activeButton:setStyle(Theme.DEFAULT_INACTIVE_BUTTON_STYLE, ButtonStyle)
	end

	self.activeButton = button
	button:setStyle(Theme.DEFAULT_ACTIVE_BUTTON_STYLE, ButtonStyle)

	self:sendPoke("select", nil, { group = layer.group, localLayer = layer.localLayer })
end

function DebugNavigation:showPath(path, debugInfo)
	self.map:setPath(path, debugInfo)
end

function DebugNavigation:showLayer(layerInfo, layer)
	self.map:setLayer(layerInfo, layer)
	self:focusChild(self.map)
end

function DebugNavigation:tick()
	Interface.tick(self)

	self.map:tick()
end

return DebugNavigation
