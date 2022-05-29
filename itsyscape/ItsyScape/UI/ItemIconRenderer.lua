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
	self.note = love.graphics.newImage("Resources/Game/Items/Note.png")
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

	local itemID = widget:get("itemID", state)
	if itemID then
		if not self.icons[itemID] then
			local filename = string.format("Resources/Game/Items/%s/Icon.png", itemID)

			local s, r = pcall(love.graphics.newImage, filename)
			if not s then
				Log.warn("Couldn't load item icon for '%s'; using Null.", filename)
				r = love.graphics.newImage("Resources/Game/Items/Null/Icon.png")
			end

			self.icons[itemID] = r
		end
		self.unvisitedIcons[itemID] = nil

		local icon = self.icons[itemID]
		local scaleX, scaleY
		local itemScaleX, itemScaleY
		local x, y
		local originX, originY
		do
			local width, height = widget:getSize()
			scaleX = width / icon:getWidth()
			scaleY = height / icon:getHeight()
			x, y = width / 2 * scaleX, height / 2 * scaleY
			originX = width / 2
			originY = height / 2
		end

		if widget:get("itemIsNoted", state) then
			itemScaleX = scaleX * 0.8
			itemScaleY = scaleY * 0.8

			itsyrealm.graphics.draw(
				self.note,
				originX, originY,
				0,
				scaleX, scaleY,
				originX, originY)
		else
			itemScaleX = scaleX
			itemScaleY = scaleY
		end

		local isDisabled = widget:get("isDisabled", state)
		if isDisabled then
			love.graphics.setColor(0.3, 0.3, 0.3, 1)
		end

		itsyrealm.graphics.draw(self.icons[itemID], x, y, 0, itemScaleX, itemScaleY, originX, originY)

		if isDisabled then
			love.graphics.setColor(1, 1, 1, 1)
		end
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
