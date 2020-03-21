--------------------------------------------------------------------------------
-- ItsyScape/UI/Interfaces/Countdown.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Color = require "ItsyScape.Graphics.Color"
local Label = require "ItsyScape.UI.Label"
local LabelStyle = require "ItsyScape.UI.LabelStyle"
local Interface = require "ItsyScape.UI.Interface"
local Drawable = require "ItsyScape.UI.Drawable"

local Countdown = Class(Interface)
Countdown.PADDING_RATIO = 0.25
Countdown.Z_DEPTH = math.huge

Countdown.Number = Class(Drawable)
function Countdown.Number:new(interface)
	Drawable.new(self)

	self.interface = interface

	local resources = interface:getView():getResources()
	self.font = resources:load(
		love.graphics.newFont,
		"Resources/Renderers/Widget/Common/Serif/Bold.ttf",
		144)
end

function Countdown.Number:getOverflow()
	return true
end

function Countdown.Number:update(...)
	Drawable.update(self, ...)

	local state = self.interface:getState()
	if state.time ~= self.time then
		self.deltaStart = love.timer.getTime()
		self.time = state.time
	end
end

function Countdown.Number:draw()
	local state = self.interface:getState()

	local fractionalTime = love.timer.getTime() - self.deltaStart
	local time = math.max(state.time - fractionalTime, 0)
	local delta = time / state.totalTime
	local steppedDelta = math.max(math.floor(time), 0) / state.totalTime 
	local scale = math.min((1 - delta), 1) * 0.5 + 0.5
	local alpha = 1 - (state.time - math.floor(state.time) - fractionalTime)

	local message
	local finalColor
	if time == 0 then
		message = "GO!"
		finalColor = Color(0, 1, 0, 1)
		alpha = 1
	else
		message = tostring(math.floor(state.time) + 1)
		finalColor = Color(1, 0, 0, 1)
	end

	local width = self.font:getWidth(message)
	local height = self.font:getHeight()

	local currentFont = love.graphics.getFont()
	love.graphics.setFont(self.font)
	love.graphics.setColor(0, 0, 0, alpha)
	love.graphics.printf(
		message,
		2,
		-height / 2 * scale + 2,
		width,
		'left',
		0,
		scale,
		scale,
		width / 2,
		0)
	love.graphics.setColor(finalColor.r, finalColor.g, finalColor.b, alpha)
	love.graphics.printf(
		message,
		0,
		-height / 2 * scale,
		width,
		'left',
		0,
		scale,
		scale,
		width / 2,
		0)
	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.setFont(currentFont)
end

function Countdown:new(id, index, ui)
	Interface.new(self, id, index, ui)

	local w, h = love.window.getMode()
	local number = Countdown.Number(self)
	number:setPosition(w / 2, h / 2)
	self:addChild(number)

	self:setZDepth(Countdown.Z_DEPTH)
end

function Countdown:getOverflow()
	return true
end

return Countdown
