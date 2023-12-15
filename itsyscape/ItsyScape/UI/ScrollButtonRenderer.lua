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

local ScrollButtonRenderer = Class(ButtonRenderer)

if _MOBILE then
	ScrollButtonRenderer.STYLE = function(icon)
		return {
			pressed = Color(0, 0, 0, 0.25),
			inactive = Color(0, 0, 0, 0.25),
			hover = Color(0, 0, 0, 0.25),
			icon = {
				filename = icon,
				x = 0.5,
				y = 0.5,
				width = 32,
				height = 32
			},
			padding = 4
		}
	end
else
	ScrollButtonRenderer.STYLE = function(icon)
		return {
			pressed = "Resources/Renderers/Widget/Button/Default-Pressed.9.png",
			inactive = "Resources/Renderers/Widget/Button/Default-Inactive.9.png",
			hover = "Resources/Renderers/Widget/Button/Default-Hover.9.png",
			icon = {
				filename = icon,
				x = 0.5,
				y = 0.5,
				width = 32,
				height = 32
			},
			padding = 4
		}
	end
end

function ScrollButtonRenderer:new(resources)
	ButtonRenderer.new(self, resources)

	self.upStyle = ButtonStyle(ScrollButtonRenderer.STYLE("Resources/Game/UI/Icons/Common/ScrollUp.png"), resources)
	self.downStyle = ButtonStyle(ScrollButtonRenderer.STYLE("Resources/Game/UI/Icons/Common/ScrollDown.png"), resources)
	self.dragStyle = ButtonStyle(ScrollButtonRenderer.STYLE(), resources)
end

function ScrollButtonRenderer:draw(widget)
	self:visit(widget)

	local style = widget:getStyle()
	if style and Class.isCompatibleType(style, ButtonStyle) then
		style:draw(widget)
	else
		if Class.isCompatibleType(widget, ScrollBar.UpButton) then
			self.upStyle:draw(widget)
		elseif Class.isCompatibleType(widget, ScrollBar.DownButton) then
			self.downStyle:draw(widget)
		else
			self.dragStyle:draw(widget)
		end
	end
end

return ScrollButtonRenderer
