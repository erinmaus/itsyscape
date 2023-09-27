--------------------------------------------------------------------------------
-- ItsyScape/UI/Interfaces/MapInfo.lua
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

local MapInfo = Class(Interface)
MapInfo.PADDING = 96
MapInfo.Z_DEPTH = -100
MapInfo.WIDTH = 640
MapInfo.HEIGHT = 16

MapInfo.Line = Class(Drawable)
MapInfo.Line.NUM_ANCHOR_POINTS = 15
MapInfo.Line.COLOR = Color.fromHexString("ffcc00", 1)
MapInfo.Line.WIDTH = 4
MapInfo.Line.PADDING = 16
MapInfo.Line.ALPHA_MULTIPLIER = 2.25

function MapInfo.Line:new(interface)
	Drawable.new(self)

	self.interface = interface
	self.alphaTime = love.timer.getTime()

	local resources = interface:getView():getResources()
	self.fontTitle = resources:load(
		love.graphics.newFont,
		"Resources/Renderers/Widget/Common/Serif/Bold.ttf",
		32)
	self.fontDescription = resources:load(
		love.graphics.newFont,
		"Resources/Renderers/Widget/Common/Serif/Bold.ttf",
		16)

	self.offsets = {}
	for i = 1, self.NUM_ANCHOR_POINTS do
		self.offsets[i] = (love.math.random() - 0.5) * 2 * math.pi
	end
end

function MapInfo.Line:getOverflow()
	return true
end

function MapInfo.Line:update(...)
	Drawable.update(self, ...)

	local w, h = self:getSize()

	local points = {}
	for i = 1, self.NUM_ANCHOR_POINTS do
		local horizontalDelta = (i - 1) / (self.NUM_ANCHOR_POINTS - 1)
		local verticalDelta = math.abs(math.sin(love.timer.getTime() * math.pi + self.offsets[i]))

		local x = w * horizontalDelta
		local y = Tween.expEaseInOut(verticalDelta) * h

		table.insert(points, x)
		table.insert(points, y)
	end

	self.curve = love.math.newBezierCurve(points)
end

function MapInfo.Line:draw()
	local r, g, b = self.COLOR:get()
	local a = math.min(math.abs(math.sin(math.min((love.timer.getTime() - self.alphaTime) / (self.interface:getState().time or 1), 1) * math.pi)) * self.ALPHA_MULTIPLIER, 1)

	local title = self.interface:getState().title or ""
	local description = self.interface:getState().description or ""

	local oldFont = love.graphics.getFont()

	love.graphics.setFont(self.fontTitle)
	love.graphics.setColor(0, 0, 0, a)
	itsyrealm.graphics.print({ title }, MapInfo.WIDTH / 2 - self.fontTitle:getWidth(title) / 2 + 2, -(self.fontTitle:getHeight() + self.fontDescription:getHeight() + self.PADDING) + 2)
	love.graphics.setColor(1, 1, 1, a)
	itsyrealm.graphics.print({ title }, MapInfo.WIDTH / 2 - self.fontTitle:getWidth(title) / 2 + 0, -(self.fontTitle:getHeight() + self.fontDescription:getHeight() + self.PADDING))

	love.graphics.setFont(self.fontDescription)
	love.graphics.setColor(0, 0, 0, a)
	itsyrealm.graphics.print({ description }, MapInfo.WIDTH / 2 - self.fontDescription:getWidth(description) / 2 + 2, -self.fontDescription:getHeight() + 2)
	love.graphics.setColor(1, 1, 1, a)
	itsyrealm.graphics.print({ description }, MapInfo.WIDTH / 2 - self.fontDescription:getWidth(description) / 2 + 0, -self.fontDescription:getHeight())

	love.graphics.setFont(oldFont)

	love.graphics.setLineWidth(self.WIDTH + a * self.WIDTH)
	love.graphics.setColor(r, g, b, a)

	itsyrealm.graphics.line(self.curve:render())

	love.graphics.setLineWidth(1)
	love.graphics.setColor(1, 1, 1, 1)
end

function MapInfo:new(id, index, ui)
	Interface.new(self, id, index, ui)

	local w, h = love.graphics.getScaledMode()
	local line = MapInfo.Line(self)
	line:setSize(self.WIDTH, self.HEIGHT)
	line:setPosition(w / 2 - self.WIDTH / 2, h - self.HEIGHT / 2 - self.PADDING)
	self:addChild(line)

	self:setZDepth(MapInfo.Z_DEPTH)
end

function MapInfo:getOverflow()
	return true
end

return MapInfo
