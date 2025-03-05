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
	self.font = love.graphics.newFont("Resources/Renderers/Widget/ItemIcon/Font.ttf", 22)
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
		self.icons[icon] = nil
	end
end

function ItemIconRenderer:draw(widget, state)
	self:visit(widget)

	local itemID = widget:get("itemID", state)
	if not itemID then
		return
	end

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

	local width, height = widget:getSize()
	local icon = self.icons[itemID]
	local count = math.max(widget:get("itemCount", state), 0)
	local color
	count, color = Utility.Item.getItemCountShorthand(count)
	local note = widget:get("itemIsNoted", state) and self.note
	local disabled = widget:get("isDisabled", state)
	local active = widget:get("isActive", state)

	local oldFont = love.graphics.getFont()

	love.graphics.setFont(self.font)
	love.graphics.setColor(widget:getColor():get())
	itsyrealm.graphics.drawItem(widget, width, height, icon, itemID, count, color, note, disabled, active)
	love.graphics.setColor(1, 1, 1, 1)

	love.graphics.setFont(oldFont)
end

return ItemIconRenderer
