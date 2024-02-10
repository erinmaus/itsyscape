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
local Panel = require "ItsyScape.UI.Panel"
local PanelStyle = require "ItsyScape.UI.PanelStyle"
local Interface = require "ItsyScape.UI.Interface"
local Drawable = require "ItsyScape.UI.Drawable"

local DramaticText = Class(Interface)
DramaticText.CANVAS_WIDTH = 1920
DramaticText.CANVAS_HEIGHT = 1080
DramaticText.FADE_IN_DURATION = 0.5

function DramaticText:new(id, index, ui)
	Interface.new(self, id, index, ui)

	local w, h = love.graphics.getScaledMode()

	self.labelStyles = {}
	self.panelStyles = {}
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
			width = line.width and (line.width / DramaticText.CANVAS_WIDTH * w) or w
		}, ui:getResources())
		label:setStyle(labelStyle)
		label:setSize(
			line.width and (line.width / DramaticText.CANVAS_WIDTH * w) or w,
			line.height and (line.height / DramaticText.CANVAS_HEIGHT * h) or h)
		label:setPosition(
			line.x and (line.x / DramaticText.CANVAS_WIDTH * w) or 0,
			line.y and (line.y / DramaticText.CANVAS_HEIGHT * h) or (h / 2))
		label:setText(line.text)

		local panel = Panel()
		local panelStyle = PanelStyle({
			color = line.backgroundColor or { 0, 0, 0, 0.5 },
			radius = line.backgroundRadius
		}, ui:getResources())
		panel:setStyle(panelStyle)

		local width, lines = labelStyle.font:getWrap(line.text, labelStyle.width)
		panel:setSize(
			width + panelStyle.radius * 2,
			#lines * labelStyle.font:getHeight() * labelStyle.font:getLineHeight() + panelStyle.radius * 2)
		local labelX, labelY = label:getPosition()
		if labelStyle.align == "center" then
			local labelWidth = label:getSize()
			labelX = labelX + (labelWidth / 2 - width / 2)
		end
		panel:setPosition(labelX - panelStyle.radius, labelY - panelStyle.radius)

		self:addChild(panel)
		self:addChild(label)
		table.insert(self.labelStyles, labelStyle)
	end
end

function DramaticText:getOverflow()
	return true
end

function DramaticText:update(delta)
	Interface.update(self, delta)

	local state = self:getState()
	if state.maxDuration ~= math.huge then
		local fadeInDuration = math.min(state.maxDuration / 2, DramaticText.FADE_IN_DURATION)

		self.time = (self.time or 0) + delta

		local mu
		if self.time <= fadeInDuration then
			mu = math.min(self.time / fadeInDuration, 1)
		elseif self.time >= state.maxDuration - fadeInDuration then
			mu = math.min(self.time - (state.maxDuration - fadeInDuration) / fadeInDuration, 1)
		else
			mu = 1
		end

		local alpha = Tween.sineEaseOut(mu)
		do
			for i = 1, #self.labelStyles do
				local style = self.labelStyles[i]
				local color = style.color
				style.color = Color(color.r, color.g, color.b, alpha)
			end

			for i = 1, #self.panelStyles do
				local style = self.panelStyles[i]
				local line = state.lines[i]
				style.color[4] = (line.backgroundColor and line.backgroundColor[4] or 0.5) * alpha
			end
		end
	end
end

return DramaticText
