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

-- Styles a widget.
--
-- For example, a button style could be called ButtonStyle, etc.
local WidgetStyle = Class()

function WidgetStyle:new()
	-- Nothing.
end

-- Draws a widget. (0, 0) is assumed to be the top-left corner of the widget.
function WidgetStyle:draw(widget)
	Class.ABSTRACT()
end

return WidgetStyle
