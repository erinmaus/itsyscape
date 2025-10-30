--------------------------------------------------------------------------------
-- ItsyScape/UI/Interfaces/RiteCircle.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Color = require "ItsyScape.Graphics.Color"
local Interface = require "ItsyScape.UI.Interface"
local Drawable = require "ItsyScape.UI.Drawable"

local RiteCircle = Class(Interface)
RiteCircle.DURATION = 2
RiteCircle.RITE_COLOR = Color.fromHexString("463779")
RiteCircle.GLOW_COLOR = Color.fromHexString("f26722")
RiteCircle.OUTLINE_COLOR = Color.fromHexString("000000")
RiteCircle.MAX_ALPHA = 1
RiteCircle.TIME_MULTIPLIER = 4

RiteCircle.Widget = Class(Drawable)

function RiteCircle.Widget:new(rootGlyph, glyphManager)
	Drawable.new(self)

	self.rootGlyph = rootGlyph
	self.glyphManager = glyphManager
	self.alpha = 0
end

function RiteCircle.Widget:tick(time)
	time = time * RiteCircle.TIME_MULTIPLIER

	self.previousTime = self.currentTime or time
	self.currentTime = time
end

function RiteCircle.Widget:getAlpha()
	return self.alpha
end

function RiteCircle.Widget:setAlpha(value)
	self.alpha = value
end

function RiteCircle.Widget:getOverflow()
	return true
end

function RiteCircle.Widget:_drawRite(projections, blendMode, offset, color, alpha)
	local width, height = self:getSize()

	love.graphics.push("all")
	love.graphics.setBlendMode(blendMode, "alphamultiply")

	local r, g, b = color:get()
	love.graphics.setColor(r, g, b, self.alpha * alpha)

	self.glyphManager:draw(
		self.rootGlyph,
		projections,
		0, 0,
		width, height,
		200,
		offset)

	love.graphics.pop()
end

function RiteCircle.Widget:draw()
	local time = math.lerp(self.previousTime, self.currentTime, _APP:getFrameDelta())
	local planeNormal, planeD = self.glyphManager:getStandardPlane(time)

	local projections = self.glyphManager:projectAll(self.rootGlyph, planeNormal, planeD)

	itsyrealm.graphics.pushCallback(
		RiteCircle.Widget._drawRite,
		self,
		projections,
		"add",
		math.abs(math.sin(time / 8 * math.pi)) * 0.5 + 0.25,
		RiteCircle.GLOW_COLOR,
		0.5)

	itsyrealm.graphics.pushCallback(
		RiteCircle.Widget._drawRite,
		self,
		projections,
		"alpha",
		0.25,
		RiteCircle.OUTLINE_COLOR,
		1)

	itsyrealm.graphics.pushCallback(
		RiteCircle.Widget._drawRite,
		self,
		projections,
		"alpha",
		0,
		RiteCircle.RITE_COLOR,
		1)
end

function RiteCircle:new(id, index, ui)
	Interface.new(self, id, index, ui)

	local glyphManager = self:getView():getGameView():getGlyphManager()

	local state = self:getState()
	self.rootGlyph = glyphManager:tokenize(state.description or "Lorem ipsum.")

	self:setIsSelfClickThrough(true)
	self:setAreChildrenClickThrough(true)

	self.riteWidget = RiteCircle.Widget(self.rootGlyph, glyphManager)
	self.riteWidget:tick(state.time)
	self:addChild(self.riteWidget)

	self:setZDepth(-1000)
	self:performLayout()

	self.duration = self.DURATION
end

function RiteCircle:performLayout()
	Interface.performLayout(self)

	local w, h = itsyrealm.graphics.getScaledMode()
	self:setPosition(0, 0)
	self:setSize(w, h)

	self.riteWidget:setSize(w, h)
	self.riteWidget:setPosition(0)
end

function RiteCircle:tick()
	Interface.tick(self)

	local state = self:getState()
	self.riteWidget:tick(state.time)
end

function RiteCircle:getOverflow()
	return true
end

function RiteCircle:update(delta)
	Interface.update(self, delta)

	self.duration = self.duration - delta
	if self.duration < 0 then
		self.duration = 0
		self:sendPoke("close", nil, {})
	end

	local alpha = math.clamp(math.sin(self.duration / self.DURATION * math.pi) * 1.5) * self.MAX_ALPHA
	self.riteWidget:setAlpha(alpha)
end

return RiteCircle
