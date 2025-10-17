--------------------------------------------------------------------------------
-- ItsyScape/Graphics/GlyphManager.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local OldOneGlyph = require "ItsyScape.Graphics.OldOneGlyph"
local OldOneGlyphInstance = require "ItsyScape.Graphics.OldOneGlyphInstance"

local GlyphManager = Class()

function GlyphManager:new(t)
	self.t = t or OldOneGlyph.DEFAULT_CONFIG
	self.projectionRadiusScale = 0.5

	self.radius = math.max(self:getDimensions())

	self.glyphs = {}
end

function GlyphManager:getProjectionRadiusScale()
	return self.projectionRadiusScale
end

function GlyphManager:getDimensions()
	return self.t.maxWidth or OldOneGlyph.DEFAULT_CONFIG.maxWidth,
		self.t.maxHeight or OldOneGlyph.DEFAULT_CONFIG.maxHeight,
		self.t.maxDepth or OldOneGlyph.DEFAULT_CONFIG.maxDepth
end

function GlyphManager:get(character)
	assert(type(character) == "number", "expected 'code point' as number - did you pass in a string?")

	local glyph = self.glyphs[character]
	if not glyph then
		glyph = OldOneGlyph()

		if character > 0 then
			glyph:fromNoise(character, self.t)
		end

		self.glyphs[character] = glyph
	end

	return glyph
end

function GlyphManager:tokenize(message)
	local sentences = {}

	for text in message:gmatch("([^.!?,]*)[.!?,]*") do
		local sanitized = text:gsub("[^%d%w][.!?]+", " "):gsub("^(%s*)", ""):gsub("(%s*)$", "")
		if #sanitized > 0 then
			print(sanitized)
			table.insert(sentences, love.data.hash("sha256", sanitized))
		end
	end

	local tokens = table.concat(sentences, "")
	local instances = {}

	for glyph, theta, phi, parent in tokens:gmatch("....") do
		local glyphIndex = glyph:bytes() + 1

		-- This should create a nice property where most glyphs are (within some distribution) closer to the top
		-- rather than leaves.
		local parentIndex = #glyphs > 0 and parent:bytes() % #glyphs + 1

		-- theta must be 0 <= theta < 2pi.
		-- since "byte" would be between 0 .. 255, we divide by 256 to leave a small gap before 2pi
		local thetaRadians = glyph:bytes() / 255 * math.pi * 2

		-- phi must be between -1/2pi <= phi <= +1/2pi
		local phiRadians = glyph:bytes() / 256 * math.pi - math.pi / 2

		local instance = OldOneGlyphInstance(self:get(glyphIndex), self)
		instance:setPhi(phiRadians)
		instance:setTheta(thetaRadians)

		if parentIndex then
			instance:setParent(glyphs[parentIndex])
		end

		table.insert(instances, instance)
	end

	return instances[1], instances
end

function GlyphManager:projectAll(root, normal, d, axis)
end

return GlyphManager
