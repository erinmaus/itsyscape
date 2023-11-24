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

	if t.color then
		self.color = t.color
	else
		self.color = false
	end

	if t.radius then
		self.radius = t.radius
	else
		self.radius = 16
	end
end

function PanelStyle:draw(widget)
	if self.image then
		self.image:draw(0, 0, widget:getSize())
	elseif self.color then
		local w, h = widget:getSize()

		love.graphics.setColor(unpack(self.color))
		itsyrealm.graphics.rectangle('fill', 0, 0, w, h, self.radius, self.radius)
		love.graphics.setColor(1, 1, 1, 1)
	end
end

return PanelStyle
