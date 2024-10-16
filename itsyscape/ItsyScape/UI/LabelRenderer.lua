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
local WidgetRenderer = require "ItsyScape.UI.WidgetRenderer"
local LabelStyle = require "ItsyScape.UI.LabelStyle"

local LabelRenderer = Class(WidgetRenderer)

function LabelRenderer:new(resources)
	WidgetRenderer.new(self, resources)

	self.defaultStyle = LabelStyle({
		color = { 1, 1, 1, 1 },
		font = "Resources/Renderers/Widget/Common/DefaultSansSerif/Regular.ttf",
		fontSize = _MOBILE and 26 or 24,
		textShadow = true
	}, resources)
end

function LabelRenderer:draw(widget, state)
	self:visit(widget)

	local style = widget:getStyle()
	if style and Class.isCompatibleType(style, LabelStyle) then
		style:draw(widget, state)
	else
		self.defaultStyle:draw(widget, state)
	end
end

return LabelRenderer
