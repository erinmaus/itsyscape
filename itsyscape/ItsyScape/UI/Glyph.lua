--------------------------------------------------------------------------------
-- ItsyScape/UI/Glyph.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Color = require "ItsyScape.Graphics.Color"
local OldOneGlyphInstance = require "ItsyScape.Graphics.OldOneGlyphInstance"
local Drawable = require "ItsyScape.UI.Drawable"

local Glyph = Class(Drawable)
Glyph.DEFAULT_SIZE = 192

function Glyph:new()
	Drawable.new(self)

	self.glyphValue = 0

	self.alpha = 1
	self.glyphColor = Color.fromHexString("463779")
	self.glowColor = Color.fromHexString("f26722")
	self.outlineColor = Color.fromHexString("000000")

	self.currentTime = false
	self.previousTime = false

	self:setSize(Glyph.DEFAULT_SIZE, Glyph.DEFAULT_SIZE)
end

function Glyph:updateTime(time)
	self.previousTime = self.currentTime or time
	self.currentTime = time
end

function Glyph:setGlyph(value)
	self.glyphValue = value or 0

	self.glyph = nil
	self.glyphInstance = nil
end

function Glyph:getGlyph()
	return self.glyphValue
end

function Glyph:getGlyphColor()
	return self.glyphColor
end

function Glyph:setGlyphColor(value)
	self.glyphColor = value
end

function Glyph:getGlowColor()
	return self.glowColor
end

function Glyph:setGlowColor(value)
	self.glowColor = value
end

function Glyph:getOutlineColor()
	return self.outlineColor
end

function Glyph:setOutlineColor(value)
	self.outlineColor = value
end

function Glyph:getAlpha()
	return self.alpha
end

function Glyph:setAlpha(value)
	self.alpha = value
end

function Glyph:getGlyphInstance()
	if self.glyphInstance then
		return self.glyphInstance
	end

	local uiView = self:getUIView()
	if not uiView then
		return nil
	end

	local glyphManager = uiView:getGameView():getGlyphManager()

	if type(self.glyphValue) == "string" then
		self.glyphInstance = glyphManager:tokenize(self.glyphValue)
		self.glyphInstance:layout()
	else
		self.glyph = glyphManager:get(self.glyphValue)
		self.glyphInstance = OldOneGlyphInstance(self.glyph, glyphManager)
		self.glyphInstance:layout()
	end

	return self.glyphInstance
end

function Glyph:_drawRite(glyph, projections, blendMode, offset, color, alpha)
	local uiView = self:getUIView()
	if not uiView then
		return
	end

	local glyphManager = uiView:getGameView():getGlyphManager()
	local width, height = self:getSize()

	love.graphics.push("all")
	love.graphics.setBlendMode(blendMode, "alphamultiply")

	local r, g, b = color:get()
	love.graphics.setColor(r, g, b, self.alpha * alpha)

	glyphManager:draw(
		glyph,
		projections,
		0, 0,
		width, height,
		math.max(width, height) / 2,
		offset)

	love.graphics.pop()
end

function Glyph:draw(resources, state)
	local uiView = self:getUIView()
	if not uiView then
		return
	end

	local glyphManager = uiView:getGameView():getGlyphManager()
	local glyph = self:getGlyphInstance()

	local previousTime = self.previousTime or 0
	local currentTime = self.currentTime or 0
	local time = math.lerp(previousTime, currentTime, _APP:getFrameDelta())

	local planeNormal = glyphManager:getStandardPlane(time)
	local planeD = -(math.sin(time / math.pi / 8) * 0.5 - 0.5)

	local projections = glyphManager:projectAll(glyph, planeNormal, planeD)

	itsyrealm.graphics.pushCallback(
		self._drawRite, self,
		glyph, projections,
		"add",
		math.abs(math.sin(time / 8 * math.pi)) * 0.5 + 0.5,
		self.glowColor,
		0.5)

	itsyrealm.graphics.pushCallback(
		self._drawRite, self,
		glyph, projections,
		"alpha",
		0.5,
		self.outlineColor,
		1)

	itsyrealm.graphics.pushCallback(
		self._drawRite, self,
		glyph, projections,
		"alpha",
		0,
		self.glyphColor,
		1)
end

return Glyph
