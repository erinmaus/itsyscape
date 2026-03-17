--------------------------------------------------------------------------------
-- ItsyScape/Graphics/GlyphManagerProxy.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local OldOneGlyph = require "ItsyScape.Graphics.OldOneGlyph"

local GlyphManagerProxy = Class()

function GlyphManagerProxy:new(glyphManager)
	self.t = glyphManager:getConfig()
	self.projectionRadiusScale = glyphManager:getProjectionRadiusScale()
	self.minDepth, self.maxDepth = glyphManager:getDepth()
	self.rotationSpeed = glyphManager:getRotationSpeed()
	self.radius = glyphManager:getRadius()
	self.width, self.height, self.depth = glyphManager:getDimensions()

	self.glyphs = {}
	self.indices = {}
	for character, glyph in glyphManager:iterate() do
		self.glyphs[character] = glyph
		self.indices[glyph] = character
	end
end

function GlyphManagerProxy:getConfig()
	return self.t
end

function GlyphManagerProxy:getDepth()
	return self.minDepth, self.maxDepth
end

function GlyphManagerProxy:getRadius()
	return self.radius
end

function GlyphManagerProxy:getProjectionRadiusScale()
	return self.projectionRadiusScale
end

function GlyphManagerProxy:getRotationSpeed()
	return self.rotationSpeed
end

function GlyphManagerProxy:getDimensions()
	return self.width, self.height, self.depth
end

function GlyphManagerProxy:iterate()
	return pairs(self.glyphs)
end

function GlyphManagerProxy:get(character)
	return self.glyphs[character] or OldOneGlyph()
end

function GlyphManagerProxy:index(glyph)
	return self.indices[glyph] or -1
end

return GlyphManagerProxy
