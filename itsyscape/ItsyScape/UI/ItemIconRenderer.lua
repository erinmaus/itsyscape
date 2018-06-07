--------------------------------------------------------------------------------
-- ItsyScape/UI/ItemIconRenderer.lua
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

local ItemIconRenderer = Class(WidgetRenderer)

function ItemIconRenderer:new(resources)
	WidgetRenderer.new(self, resources)

	self.icons = {}
	self.font = love.graphics.newFont("Resources/Renderers/Widget/ItemIcon/Font.ttf", 18)
end

function ItemIconRenderer:start()
	WidgetRenderer.start(self)

	self.unvisitedIcons = {}

	for icon in pairs(self.icons) do
		self.unvisitedIcons[icon] = true
	end
end

function ItemIconRenderer:stop()
	WidgetRenderer.stop(self)

	for icon in pairs(self.unvisitedIcons) do
		self.icons[icon]:release()
		self.icons[icon] = nil
	end
end

function ItemIconRenderer:draw(widget, state)
	self:visit(widget)

	love.graphics.setColor(1, 1, 1, 1)

	if widget:get("itemIsNoted", state) then
		-- TODO note icon
		love.graphics.setColor(0.9, 0.82, 0.5)
		love.graphics.rectangle('fill', 0, 0, widget:getSize())
		love.graphics.setColor(1, 1, 1, 1)
	end

	local itemID = widget:get("itemID", state)
	if itemID then
		if not self.icons[itemID] then
			-- TODO async load
			local filename = string.format("Resources/Game/Items/%s/Icon.png", itemID)
			self.icons[itemID] = love.graphics.newImage(filename)
		end
		self.unvisitedIcons[itemID] = false

		local icon = self.icons[itemID]
		local scaleX, scaleY
		do
			local width, height = widget:getSize()
			scaleX = width / icon:getWidth()
			scaleY = height / icon:getHeight()
		end

		love.graphics.draw(self.icons[itemID], 0, 0, 0, scaleX, scaleY)
	end

	local count = widget:get("itemCount", state)
	if count > 1 then
		local oldFont = love.graphics.getFont()
		love.graphics.setFont(self.font)

		local text, color = Utility.Item.getItemCountShorthand(count)
		local icon = self.icons[itemID]
		local width = widget:getSize()
		local scaleX = width / icon:getWidth()
		local textWidth = self.font:getWidth(text) * scaleX

		love.graphics.setColor(0, 0, 0, 1)
		love.graphics.print(text, width - textWidth, 2 * scaleX, 0, scaleX, scaleX)

		love.graphics.setColor(unpack(color))
		love.graphics.print(text, width - textWidth - 2 * scaleX, 0, 0, scaleX, scaleX)

		love.graphics.setFont(oldFont)
		love.graphics.setColor(1, 1, 1, 1)
	end
end

return ItemIconRenderer
