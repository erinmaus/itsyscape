--------------------------------------------------------------------------------
-- ItsyScape/UI/IconRenderer.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local WidgetRenderer = require "ItsyScape.UI.WidgetRenderer"
local Utility = require "ItsyScape.Game.Utility"

local IconRenderer = Class(WidgetRenderer)

function IconRenderer:new(resources)
	WidgetRenderer.new(self, resources)

	self.icons = {}
end

function IconRenderer:start()
	WidgetRenderer.start(self)

	self.unvisitedIcons = {}

	for icon in pairs(self.icons) do
		self.unvisitedIcons[icon] = true
	end
end

function IconRenderer:stop()
	WidgetRenderer.stop(self)

	for icon in pairs(self.unvisitedIcons) do
		self.icons[icon]:release()
		self.icons[icon] = nil
	end
end

function IconRenderer:draw(widget, state)
	self:visit(widget)

	love.graphics.setColor(widget:getColor():get())

	local icon = widget:get("icon", state)
	if icon then
		if not self.icons[icon] then
			self.icons[icon] = love.graphics.newImage(icon)
		end
		self.unvisitedIcons[icon] = nil

		local icon = self.icons[icon]
		local scaleX, scaleY
		do
			local width, height = widget:getSize()
			scaleX = width / icon:getWidth()
			scaleY = height / icon:getHeight()
		end

		love.graphics.draw(icon, 0, 0, 0, scaleX, scaleY)
	end

	love.graphics.setColor(1, 1, 1, 1)
end

return IconRenderer
