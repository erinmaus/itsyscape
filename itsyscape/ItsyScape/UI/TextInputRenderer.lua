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

function TextInputRenderer:draw(widget)
	self:visit(widget)

	local style = widget:getStyle()
	if style and Class.isCompatibleType(style, TextInputStyle) then
		style:draw(widget)
	end
end

return TextInputRenderer
