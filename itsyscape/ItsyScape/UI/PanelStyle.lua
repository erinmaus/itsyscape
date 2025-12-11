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

	if t.tile then
		self.tile = resources:load(love.graphics.newImage, t.tile)
		self.tile:setWrap("repeat")

		self.quad = love.graphics.newQuad(0, 0, self.tile:getWidth(), self.tile:getHeight(), self.tile:getWidth(), self.tile:getHeight())
	else
		self.tile = false
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
		if self.tile then
			self.quad:setViewport(0, 0, widget:getSize())
			itsyrealm.graphics.uncachedDraw(self.tile, self.quad)
		end

		self.image:draw(0, 0, widget:getSize())
	elseif self.color then
		local w, h = widget:getSize()

		love.graphics.setColor(unpack(self.color))
		itsyrealm.graphics.rectangle('fill', 0, 0, w, h, self.radius, self.radius)
		love.graphics.setColor(1, 1, 1, 1)
	end
end

return PanelStyle
