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
local TextInputStyle = require "ItsyScape.UI.TextInputStyle"

local TextInputRenderer = Class(WidgetRenderer)

function TextInputRenderer:new(resources)
	WidgetRenderer.new(self, resources)

	self.defaultStyle = TextInputStyle({
		inactive = "Resources/Game/UI/TextInputs/Default-Inactive.png",
		active = "Resources/Game/UI/TextInputs/Default-Active.png",
		hover = "Resources/Game/UI/TextInputs/Default-Hover.png",
		font = "Resources/Renderers/Widget/Common/DefaultSansSerif/Regular.ttf",
		fontSize = 32,
		color = { 0.2, 0.2, 0.2, 0.2 },
		align = "center",
		textShadow = true
	}, resources)
end

function TextInputRenderer:draw(widget)
	self:visit(widget)

	local style = widget:getStyle()
	if style and Class.isCompatibleType(style, TextInputStyle) then
		style:draw(widget)
	else
		self.defaultStyle:draw(widget)
	end
end

return TextInputRenderer
