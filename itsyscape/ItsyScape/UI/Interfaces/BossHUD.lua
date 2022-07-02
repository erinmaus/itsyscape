--------------------------------------------------------------------------------
-- ItsyScape/UI/Interfaces/BossHUD.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Color = require "ItsyScape.Graphics.Color"
local HUD = require "ItsyScape.UI.Interfaces.HUD"
local Drawable = require "ItsyScape.UI.Drawable"
local Icon = require "ItsyScape.UI.Icon"
local Panel = require "ItsyScape.UI.Panel"
local Label = require "ItsyScape.UI.Label"
local LabelStyle = require "ItsyScape.UI.LabelStyle"
local ToolTip = require "ItsyScape.UI.ToolTip"

local BossHUD = Class(HUD)
BossHUD.BIG_STAT_WIDTH = 640
BossHUD.BIG_STAT_HEIGHT = 64
BossHUD.BIG_STAT_PADDING = 8
BossHUD.TOP = 48 -- account for strategy bar
BossHUD.BIG_STAT_LEFT_LABEL_STYLE = {
	font = "Resources/Renderers/Widget/Common/Serif/Bold.ttf",
	color = { 1, 1, 1, 1 },
	fontSize = 24,
	textShadow = true
}
BossHUD.BIG_STAT_RIGHT_LABEL_STYLE = {
	font = "Resources/Renderers/Widget/Common/Serif/Bold.ttf",
	color = { 1, 1, 1, 1 },
	fontSize = 24,
	textShadow = true,
	align = 'right'
}

BossHUD.LITTLE_STAT_WIDTH = 160
BossHUD.LITTLE_STAT_HEIGHT = 32
BossHUD.LITTLE_STAT_ICON_SIZE = 48
BossHUD.LITTLE_STAT_PADDING = 16

BossHUD.StatBar = Class(Drawable)
BossHUD.StatBar.BORDER_THICKNESS = 4
function BossHUD.StatBar:new()
	Drawable.new(self)

	self.current = 0
	self.max = 1
	self.inColor = Color(0, 1, 0, 1)
	self.outColor = Color(1, 0, 0, 1)
end

function BossHUD.StatBar:getCurrent()
	return self.current
end

function BossHUD.StatBar:setCurrent(value)
	self.current = value or self.current
end

function BossHUD.StatBar:getMax()
	return self.max
end

function BossHUD.StatBar:setMax(value)
	self.max = value or self.max
end

function BossHUD.StatBar:getInColor()
	return self.inColor
end

function BossHUD.StatBar:setInColor(value)
	self.inColor = value or self.inColor
end

function BossHUD.StatBar:getOutColor()
	return self.outColor
end

function BossHUD.StatBar:setOutColor(value)
	self.outColor = value or self.outColor
end

function BossHUD.StatBar:draw(resources, state)
	local w, h = self:getSize()
	local cornerRadius = math.min(w, h) / 4

	love.graphics.setColor(self.inColor:get())
	itsyrealm.graphics.rectangle('fill', 0, 0, w, h, cornerRadius)

	local outWidth = w * (1 - (self.current / self.max))
	if outWidth >= 1 then
		love.graphics.setColor(self.outColor:get())
		itsyrealm.graphics.rectangle('fill', w - outWidth, 0, outWidth, h, cornerRadius)
	end

	love.graphics.setLineWidth(self.BORDER_THICKNESS)
	love.graphics.setColor(0, 0, 0, 0.5)
	itsyrealm.graphics.rectangle('line', 0, 0, w, h, cornerRadius)

	love.graphics.setLineWidth(1)
	love.graphics.setColor(1, 1, 1, 1)
end

function BossHUD:new(id, index, ui)
	HUD.new(self, id, index, ui)

	self.littleStats = {}
	self.bigStats = {}

	self.spawned = false
end

function BossHUD:populateStats()
	local state = self:getState()

	local resources = self:getView():getResources()

	local y = BossHUD.BIG_STAT_PADDING * 4 + BossHUD.TOP
	do
		local big = state.bigStats
		local w, h = love.graphics.getScaledMode()

		for i = 1, #big do
			local panel = Panel()
			panel:setSize(BossHUD.BIG_STAT_WIDTH, BossHUD.BIG_STAT_HEIGHT)
			panel:setPosition(w / 2 - BossHUD.BIG_STAT_WIDTH / 2, y)

			self:addChild(panel)

			y = y + BossHUD.BIG_STAT_HEIGHT + BossHUD.BIG_STAT_PADDING * 2

			local statBar = BossHUD.StatBar()
			statBar:setSize(
				BossHUD.BIG_STAT_WIDTH - BossHUD.BIG_STAT_PADDING * 2,
				BossHUD.BIG_STAT_HEIGHT - BossHUD.BIG_STAT_PADDING * 2)
			statBar:setPosition(
				BossHUD.BIG_STAT_PADDING,
				BossHUD.BIG_STAT_PADDING)
			statBar:setInColor(Color(unpack(big[i].inColor)))
			statBar:setOutColor(Color(unpack(big[i].outColor)))
			panel:addChild(statBar)

			if big[i].text then
				local text = Label()
				text:setStyle(LabelStyle(BossHUD.BIG_STAT_LEFT_LABEL_STYLE, resources))
				text:setText(big[i].text)
				text:setPosition(
					BossHUD.BIG_STAT_PADDING * 2,
					BossHUD.BIG_STAT_HEIGHT / 2 - BossHUD.BIG_STAT_LEFT_LABEL_STYLE.fontSize / 2 - BossHUD.BIG_STAT_PADDING)

				panel:addChild(text)
			end

			local statLabel = Label()
			statLabel:setStyle(LabelStyle(BossHUD.BIG_STAT_RIGHT_LABEL_STYLE, resources))
			statLabel:setText(big[i].statLabel)
			statLabel:setPosition(
				-BossHUD.BIG_STAT_PADDING * 2,
				BossHUD.BIG_STAT_HEIGHT / 2 - BossHUD.BIG_STAT_RIGHT_LABEL_STYLE.fontSize / 2 - BossHUD.BIG_STAT_PADDING)

			panel:addChild(statLabel)

			table.insert(self.bigStats, {
				statBar = statBar,
				statLabel = statLabel
			})
		end
	end
	do
		local little = state.littleStats

		for i = 1, #little do
			local statBar, icon

			if not little[i].isBoolean then
				statBar = BossHUD.StatBar()
				statBar:setSize(
					BossHUD.LITTLE_STAT_WIDTH,
					BossHUD.LITTLE_STAT_HEIGHT)
				statBar:setPosition(
					BossHUD.LITTLE_STAT_PADDING * 2 + BossHUD.LITTLE_STAT_ICON_SIZE,
					y + BossHUD.LITTLE_STAT_ICON_SIZE / 2 - BossHUD.LITTLE_STAT_HEIGHT / 2)
				statBar:setInColor(Color(unpack(little[i].inColor)))
				statBar:setOutColor(Color(unpack(little[i].outColor)))
				self:addChild(statBar)
			end

			if little[i].icon then
				icon = Icon()
				icon:setIcon(little[i].icon)
				icon:setPosition(BossHUD.LITTLE_STAT_PADDING, y)

				self:addChild(icon)

				if little[i].text then
					icon:setToolTip(ToolTip.Text(little[i].text))
				end
			end

			table.insert(self.littleStats, {
				statBar = statBar,
				icon = icon
			})

			y = y + BossHUD.LITTLE_STAT_HEIGHT + BossHUD.LITTLE_STAT_PADDING * 2
		end
	end
end

function BossHUD:updateStats()
	local state = self:getState()

	do
		local big = state.bigStats
		for i = 1, #big do
			local stat = self.bigStats[i].statBar
			stat:setCurrent(big[i].current)
			stat:setMax(big[i].max)

			local label = self.bigStats[i].statLabel
			label:setText(string.format("%d/%d", big[i].current, big[i].max))
		end
	end
	do
		local little = state.littleStats
		for i = 1, #little do
			if little[i].isBoolean and little[i].current == 0 then
				self:removeChild(self.littleStats[i].icon)
			else
				self:addChild(self.littleStats[i].icon)
			
				local stat = self.littleStats[i].statBar
				if stat then
					stat:setCurrent(little[i].current)
					stat:setMax(little[i].max)
				end
			end
		end
	end
end

function BossHUD:update(...)
	HUD.update(self, ...)

	if not self.spawned then
		self:populateStats()

		self.spawned = true
	end

	self:updateStats()
end

return BossHUD
