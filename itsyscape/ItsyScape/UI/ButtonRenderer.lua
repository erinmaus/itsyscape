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
local ButtonStyle = require "ItsyScape.UI.ButtonStyle"

local ButtonRenderer = Class(WidgetRenderer)

function ButtonRenderer:new(resources)
	WidgetRenderer.new(self, resources)

	self.defaultStyle = ButtonStyle({
		inactive = "Resources/Game/UI/Buttons/Button-Default.png",
		pressed = "Resources/Game/UI/Buttons/Button-Pressed.png",
		hover = "Resources/Game/UI/Buttons/Button-Hover.png",
		color = { 1, 1, 1, 1 },
		font = "Resources/Renderers/Widget/Common/DefaultSansSerif/Regular.ttf",
		fontSize = _MOBILE and 28 or 24,
		textShadow = true,
		padding = 4
	}, resources)
end

function ButtonRenderer:draw(widget)
	self:visit(widget)

	local style = widget:getStyle()
	if style and Class.isCompatibleType(style, ButtonStyle) then
		style:draw(widget)
	else
		self.defaultStyle:draw(widget)
	end
end

return ButtonRenderer
