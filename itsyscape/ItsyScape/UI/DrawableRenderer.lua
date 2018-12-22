--------------------------------------------------------------------------------
-- ItsyScape/UI/DrawableRenderer.lua
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

local DrawableRenderer = Class(WidgetRenderer)

function DrawableRenderer:draw(widget, state)
	self:visit(widget)

	widget:draw(self:getResources(), state)
end

return DrawableRenderer
