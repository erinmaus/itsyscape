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
		self.icons[icon] = nil
	end
end

function SpellIconRenderer:drawIcon(widget, state, x, y)
	local spellID = widget:get("spellID", state)
	if spellID then
		if not self.icons[spellID] then
			-- TODO async load
			local filename = string.format("Resources/Game/Spells/%s/Icon.png", spellID)
			self.icons[spellID] = love.graphics.newImage(filename)
		end
		self.unvisitedIcons[spellID] = nil

		local icon = self.icons[spellID]
		local scaleX, scaleY
		do
			local width, height = widget:getSize()
			scaleX = width / icon:getWidth()
			scaleY = height / icon:getHeight()
		end

		itsyrealm.graphics.draw(
			icon,
			(x or 0) * scaleX,
			(y or 0) * scaleY,
			0,
			scaleX, scaleY)
	end
end

function SpellIconRenderer:draw(widget, state)
	self:visit(widget)

	if widget:get("spellActive", state) then
		love.graphics.setColor(0, 0, 0, 0.5)
		for i = -1, 1 do
			for j = -1, 1 do
				self:drawIcon(widget, state, i, j)
			end
		end
	end

	if widget:get("spellEnabled", state) then
		love.graphics.setColor(1.0, 1.0, 1.0, 1)
	else
		love.graphics.setColor(0.5, 0.5, 0.5, 1)
	end

	self:drawIcon(widget, state)

	love.graphics.setColor(1, 1, 1, 1)
	if widget:get("spellActive", state) then
		love.graphics.setBlendMode('add')

		self:drawIcon(widget, state)
	
		love.graphics.setBlendMode('alpha')

		local LINE_WIDTH = 1.5
		love.graphics.setLineWidth(LINE_WIDTH)

		love.graphics.setColor(0, 1, 0, 1)
		local w, h = widget:getSize()
		itsyrealm.graphics.rectangle(
			'line',
			LINE_WIDTH, LINE_WIDTH,
			w - LINE_WIDTH * 2, h - LINE_WIDTH * 2,
			w / 8, h / 8)

		love.graphics.setLineWidth(1)
		love.graphics.setColor(1, 1, 1, 1)
	end
end

return SpellIconRenderer
