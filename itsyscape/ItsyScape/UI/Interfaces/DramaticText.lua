--------------------------------------------------------------------------------
-- ItsyScape/UI/Interfaces/DramaticText.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Tween = require "ItsyScape.Common.Math.Tween"
local Color = require "ItsyScape.Graphics.Color"
local Label = require "ItsyScape.UI.Label"
local LabelStyle = require "ItsyScape.UI.LabelStyle"
local Interface = require "ItsyScape.UI.Interface"
local Drawable = require "ItsyScape.UI.Drawable"

local DramaticText = Class(Interface)
DramaticText.CANVAS_WIDTH = 1920
DramaticText.CANVAS_HEIGHT = 1080
DramaticText.FADE_IN_DURATION = 0.5

function DramaticText:new(id, index, ui)
	Interface.new(self, id, index, ui)

	local w, h = love.graphics.getScaledMode()

	self.styles = {}
	local state = self:getState()
	for i = 1, #state.lines do
		local line = state.lines[i]
		local label = Label()
		local labelStyle = LabelStyle({
			color = line.color,
			font = line.font,
			fontSize = line.fontSize / DramaticText.CANVAS_HEIGHT * h,
			textShadow = line.textShadow,
			align = line.align,
			width = (line.width or 0) / DramaticText.CANVAS_WIDTH * w
		}, ui:getResources())
		label:setStyle(labelStyle)
		label:setSize(
			(line.width or 0) / DramaticText.CANVAS_WIDTH * w,
			(line.height or 0) / DramaticText.CANVAS_HEIGHT * h)
		label:setPosition(
			(line.x or 0) / DramaticText.CANVAS_WIDTH * w,
			(line.y or 0) / DramaticText.CANVAS_HEIGHT * h)
		label:setText(line.text)

		self:addChild(label)
		table.insert(self.styles, labelStyle)
	end
end

function DramaticText:getOverflow()
	return true
end

function DramaticText:update(delta)
	Interface.update(self, delta)

	self.time = (self.time or 0) + delta
	local mu = math.min(self.time / DramaticText.FADE_IN_DURATION, 1)
	local alpha = Tween.sineEaseOut(mu)
	for i = 1, #self.styles do
		local style = self.styles[i]
		local color = style.color
		style.color = Color(color.r, color.g, color.b, alpha)
	end
end

return DramaticText
