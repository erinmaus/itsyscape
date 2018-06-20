--------------------------------------------------------------------------------
-- ItsyScape/UI/SpellIconRenderer.lua
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

local SpellIconRenderer = Class(WidgetRenderer)

function SpellIconRenderer:new(resources)
	WidgetRenderer.new(self, resources)

	self.icons = {}
end

function SpellIconRenderer:start()
	WidgetRenderer.start(self)

	self.unvisitedIcons = {}

	for icon in pairs(self.icons) do
		self.unvisitedIcons[icon] = true
	end
end

function SpellIconRenderer:stop()
	WidgetRenderer.stop(self)

	for icon in pairs(self.unvisitedIcons) do
		self.icons[icon]:release()
		self.icons[icon] = nil
	end
end

function SpellIconRenderer:draw(widget, state)
	self:visit(widget)

	if widget:get("spellEnabled", state) then
		love.graphics.setColor(1, 1, 1, 1)
	else
		love.graphics.setColor(0.5, 0.5, 0.5, 1)
	end

	local spellID = widget:get("spellID", state)
	if spellID then
		if not self.icons[spellID] then
			-- TODO async load
			local filename = string.format("Resources/Game/Spells/%s/Icon.png", spellID)
			self.icons[spellID] = love.graphics.newImage(filename)
		end
		self.unvisitedIcons[spellID] = false

		local icon = self.icons[spellID]
		local scaleX, scaleY
		do
			local width, height = widget:getSize()
			scaleX = width / icon:getWidth()
			scaleY = height / icon:getHeight()
		end

		love.graphics.draw(self.icons[spellID], 0, 0, 0, scaleX, scaleY)
	end

	if widget:get("spellActive", state) then
		love.graphics.setColor(0, 1, 0, 1)
		
		local width, height = widget:getSize()
		love.graphics.rectangle('line', 0, 0, width, height)
	end
end

return SpellIconRenderer
