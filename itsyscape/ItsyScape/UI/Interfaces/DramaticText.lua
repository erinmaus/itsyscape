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

	local state = self:getState()
	self.time = -(state.time - math.floor(state.time))

	self:setZDepth(10000)
end

function DramaticText:attach()
	local w, h = love.graphics.getScaledMode()

	self.labels = {}
	self.panels = {}
	self.labelStyles = {}
	self.panelStyles = {}
	local state = self:getState()
	for i = 1, #state.lines do
		local line = state.lines[i]
		local label = Label()
		local labelStyle = {
			color = line.color,
			font = line.font,
			fontSize = line.fontSize / DramaticText.CANVAS_HEIGHT * h,
			textShadow = line.textShadow,
			align = line.align,
			width = line.width and (line.width / DramaticText.CANVAS_WIDTH * w) or w
		}
		label:setStyle(labelStyle, LabelStyle)
		label:setSize(
			line.width and (line.width / DramaticText.CANVAS_WIDTH * w) or w,
			line.height and (line.height / DramaticText.CANVAS_HEIGHT * h) or h)
		label:setPosition(
			line.x and (line.x / DramaticText.CANVAS_WIDTH * w) or 0,
			line.y and (line.y / DramaticText.CANVAS_HEIGHT * h) or (h / 2))
		label:setText(line.text)
		self:addChild(label)
		label:updateStyle()

		local panel = Panel()
		local panelStyle = {
			color = line.backgroundColor or { 0, 0, 0, 0.5 },
			radius = line.backgroundRadius
		}
		panel:setStyle(panelStyle, PanelStyle)
		self:addChild(panel)
		panel:updateStyle()

		local width, lines = label:getStyle().font:getWrap(line.text, label:getStyle().width)
		panel:setSize(
			width + panel:getStyle().radius * 2,
			#lines * label:getStyle().font:getHeight() * label:getStyle().font:getLineHeight() + panel:getStyle().radius * 2)
		local labelX, labelY = label:getPosition()
		if label:getStyle().align == "center" then
			local labelWidth = label:getSize()
			labelX = labelX + (labelWidth / 2 - width / 2)
		end
		panel:setPosition(labelX - panel:getStyle().radius, labelY - panel:getStyle().radius)

		table.insert(self.labels, label)
		table.insert(self.panels, panel)
		table.insert(self.labelStyles, labelStyle)
		table.insert(self.panelStyles, panelStyle)
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

		self.time = self.time + delta

		local mu
		if self.time < 0 then
			mu = 0
		elseif self.time >= state.maxDuration then
			mu = 0
			self:sendPoke("close", nil, {})
		elseif self.time <= fadeInDuration then
			mu = math.min(self.time / fadeInDuration, 1)
		elseif self.time >= state.maxDuration - fadeInDuration then
			mu = 1 - math.min((self.time - (state.maxDuration - fadeInDuration)) / fadeInDuration, 1)
		else
			mu = 1
		end

		local alpha = Tween.sineEaseOut(mu)
		do
			for i = 1, #self.labelStyles do
				local style = self.labelStyles[i]
				local color = style.color
				style.color = { color.r, color.g, color.b, alpha }

				self.labels[i]:setStyle(style, LabelStyle)
			end

			for i = 1, #self.panelStyles do
				local style = self.panelStyles[i]
				local line = state.lines[i]
				style.color[4] = (line.backgroundColor and line.backgroundColor[4] or 0.5) * alpha

				self.panels[i]:setStyle(style, LabelStyle)
			end
		end
	end
end

return DramaticText
