--------------------------------------------------------------------------------
-- ItsyScape/UI/DraggablePanel.lua
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

local DraggablePanel = Class(Widget)

function DraggablePanel:new()
	Widget.new(self)
	self.onClick = Callback()
	self.dragMouseX = 0
	self.dragMouseY = 0
	self.dragButton = 1
	self.isDragging = false
end

function DraggablePanel:getDragButton()
	return self.dragButton
end

function DraggablePanel:setDragButton(value)
	self.dragButton = value or self.dragButton
end

function DraggablePanel:mousePress(x, y, button, ...)
	if button == self.dragButton then
		self.isDragging = true
		self.dragMouseX = x
		self.dragMouseY = y
	end

	Widget.mousePress(self, x, y, button, ...)
end

function DraggablePanel:mouseRelease(x, y, button, ...)
	if button == self.dragButton then
		self.isDragging = false
	end
end

function DraggablePanel:mouseMove(x, y)
	if self.isDragging then
		local dx = x - self.dragMouseX
		local dy = y - self.dragMouseY
		self:setPosition(self.x + dx, self.y + dy)
		self.dragMouseX = x
		self.dragMouseY = y
	end
end

return DraggablePanel
