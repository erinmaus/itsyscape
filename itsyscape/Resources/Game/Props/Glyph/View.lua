--------------------------------------------------------------------------------
-- ItsyScape/Resources/Game/Props/ProjectedGlyph/View.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Vector = require "ItsyScape.Common.Math.Vector"
local Color = require "ItsyScape.Graphics.Color"
local OldOneGlyphInstance = require "ItsyScape.Graphics.OldOneGlyphInstance"
local PropView = require "ItsyScape.Graphics.PropView"
local TextureResource = require "ItsyScape.Graphics.TextureResource"
local QuadSceneNode = require "ItsyScape.Graphics.QuadSceneNode"

local ProjectedGlyph = Class(PropView)

ProjectedGlyph.RESOLUTION = 1024

function ProjectedGlyph:load()
	PropView.load(self)

	local root = self:getRoot()

	self.quad = QuadSceneNode()
	self.quad:setParent(root)

	self.canvas = love.graphics.newCanvas(self.RESOLUTION, self.RESOLUTION)
	self.texture = TextureResource(self.canvas)

	local material = self.quad:getMaterial()
	material:setTextures(self.texture)
	material:setIsTranslucent(true)
	material:setIsFullLit(true)
	material:setOutlineThreshold(-1)
	material:setIsShadowCaster(true)
	material:setGlassThickness(1)
end

function ProjectedGlyph:tick()
	PropView.tick(self)

	local state = self:getProp():getState()

	local glyph = state.glyph or 0
	if self:getIsEditor() and glyph == 0 then
		glyph = "Lorem ipsum."
	end

	if glyph ~= self.currentGlyph then
		local glyphManager = self:getGameView():getGlyphManager()

		if type(glyph) == "string" then
			self.glyphInstance = glyphManager:tokenize(glyph)
		else
			local g = glyphManager:get(glyph)
			self.glyphInstance = OldOneGlyphInstance(g, glyphManager)
		end

		self.currentGlyph = glyph
	end

	local nextTime = state.time or 0
	self.previousTime = self.currentTime or nextTime
	self.currentTime = nextTime
end

function ProjectedGlyph:_drawRite(glyph, projections, offset, color)
	local glyphManager = self:getGameView():getGlyphManager()
	local width, height = self.texture:getWidth(), self.texture:getHeight()

	love.graphics.push("all")
	love.graphics.setColor(color:get())
	love.graphics.setBlendMode("alpha")

	glyphManager:draw(
		glyph,
		projections,
		1, 1,
		width - 2, height - 2,
		math.max(width, height) / 4,
		offset)

	love.graphics.pop()
end

do
	local glowColor = Color()
	local glyphColor = Color()
	local outlineColor = Color()
	local defaultColor = {}

	function ProjectedGlyph:update()
		local state = self:getProp():getState()
		self.quad:getMaterial():setAlpha(state.alpha or 1)

		local time = math.lerp(self.previousTime or 0, self.currentTime or 0, _APP:getFrameDelta())

		glowColor:from(unpack(state.glowColor or defaultColor))
		glyphColor:from(unpack(state.glyphColor or defaultColor))
		outlineColor:from(unpack(state.outlineColor or defaultColor))

		local glyphManager = self:getGameView():getGlyphManager()
		local planeNormal, planeD = glyphManager:getStandardPlane(time)
		local projections = glyphManager:asyncProjectAll(self, self.glyphInstance, planeNormal, planeD, time)

		self._canvas = self._canvas or { stencil = true }
		self._canvas[1] = self.canvas

		love.graphics.push("all")
		love.graphics.setCanvas(self._canvas)
		love.graphics.clear(0, 0, 0, 0)

		self:_drawRite(
			self.glyphInstance,
			projections,
			math.abs(math.sin(time / 8 * math.pi)) * 0.5 + 1,
			glowColor,
			0.5)

		self:_drawRite(
			self.glyphInstance,
			projections,
			0.5,
			outlineColor,
			1)

		self:_drawRite(
			self.glyphInstance,
			projections,
			0,
			glyphColor,
			1)

		love.graphics.pop()
	end
end

return ProjectedGlyph
