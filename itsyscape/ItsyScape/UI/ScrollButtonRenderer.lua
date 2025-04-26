--------------------------------------------------------------------------------
-- ItsyScape/UI/ScrollButtonRenderer.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Color = require "ItsyScape.Graphics.Color"
local ButtonRenderer = require "ItsyScape.UI.ButtonRenderer"
local ButtonStyle = require "ItsyScape.UI.ButtonStyle"
local ScrollBar = require "ItsyScape.UI.ScrollBar"
local GamepadSink = require "ItsyScape.UI.GamepadSink"

local ScrollButtonRenderer = Class(ButtonRenderer)

ScrollButtonRenderer.OTHER_STYLE = function(icon)
	return {
		pressed = Color(0, 0, 0, 0.25),
		inactive = Color(0, 0, 0, 0.25),
		hover = Color(0, 0, 0, 0.25),
		icon = {
			filename = icon,
			x = 0.5,
			y = 0.5,
			width = 8,
			height = 8
		},
		padding = 4
	}
end

ScrollButtonRenderer.MOUSE_STYLE = function(icon)
	return {
		pressed = "Resources/Game/UI/Buttons/Button-Pressed.png",
		inactive = "Resources/Game/UI/Buttons/Button-Default.png",
		hover = "Resources/Game/UI/Buttons/Button-Hover.png",
		icon = {
			filename = icon,
			x = 0.5,
			y = 0.5,
			width = 8,
			height = 8
		},
		padding = 4
	}
end

function ScrollButtonRenderer:new(resources)
	ButtonRenderer.new(self, resources)

	self.otherUpStyle = ButtonStyle(ScrollButtonRenderer.OTHER_STYLE("Resources/Game/UI/Icons/Common/ScrollUp.png"), resources)
	self.otherDownStyle = ButtonStyle(ScrollButtonRenderer.OTHER_STYLE("Resources/Game/UI/Icons/Common/ScrollDown.png"), resources)
	self.otherDragStyle = ButtonStyle(ScrollButtonRenderer.OTHER_STYLE(), resources)

	self.mouseUpStyle = ButtonStyle(ScrollButtonRenderer.MOUSE_STYLE("Resources/Game/UI/Icons/Common/ScrollUp.png"), resources)
	self.mouseDownStyle = ButtonStyle(ScrollButtonRenderer.MOUSE_STYLE("Resources/Game/UI/Icons/Common/ScrollDown.png"), resources)
	self.mouseDragStyle = ButtonStyle(ScrollButtonRenderer.MOUSE_STYLE(), resources)
end

function ScrollButtonRenderer:draw(widget)
	self:visit(widget)

	local isTouch = _MOBILE

	local style = widget:getStyle()
	if style and Class.isCompatibleType(style, ButtonStyle) then
		style:draw(widget)
	else
		if Class.isCompatibleType(widget, ScrollBar.UpButton) then
			if isTouch then
				self.otherUpStyle:draw(widget)
			else
				self.mouseUpStyle:draw(widget)
			end
		elseif Class.isCompatibleType(widget, ScrollBar.DownButton) then
			if isTouch then
				self.otherDownStyle:draw(widget)
			else
				self.mouseDownStyle:draw(widget)
			end
		else
			if isTouch then
				self.otherDragStyle:draw(widget)
			else
				self.mouseDragStyle:draw(widget)
			end
		end
	end
end

return ScrollButtonRenderer
