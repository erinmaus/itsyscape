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
local Color = require "ItsyScape.Graphics.Color"
local WidgetStyle = require "ItsyScape.UI.WidgetStyle"
local patchy = require "patchy"

local PanelStyle = Class(WidgetStyle)
function PanelStyle:new(t, resources)
	if t.image then
		self.image = resources:load(patchy.load, t.image)
	else
		self.image = false
	end
end

function PanelStyle:draw(widget)
	if self.image then
		self.image:draw(0, 0, widget:getSize())
	end
end

return PanelStyle
