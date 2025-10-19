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

function GlyphManager:getRadius()
	return self.radius
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
			table.insert(sentences, love.data.hash("sha1", sanitized))
			table.insert(sentences, string.char(#sanitized % 255))
		end
	end

	local tokens = table.concat(sentences, "")
	local instances = {}

	for glyph, theta, parent in tokens:gmatch("(.)(.)(.)") do
		local glyphIndex = glyph:byte() + 1

		-- This should create a nice property where most glyphs are (within some distribution) closer to the top
		-- rather than leaves.
		local parentIndex
		if #instances > 0 then
			for i = 1, #instances + 1 do
				parentIndex = (parent:byte() + i - 1) % #instances + 1
				if instances[parentIndex]:getDepth() < 4 then
					break
				end
			end
		end

		local thetaRadians = glyph:byte() / 256 * math.pi / 16

		local instance = OldOneGlyphInstance(self:get(glyphIndex), self)
		instance:setTheta(thetaRadians)

		if parentIndex then
			instance:setParent(instances[parentIndex])
		end

		table.insert(instances, instance)
	end

	instances[1]:layout()

	return instances[1], instances
end

function GlyphManager:_projectAll(root, normal, d, axis, r)
	root:project(normal, d, axis)
	table.insert(r, { root, root:getProjection() })

	for _, child in root:iterate() do
		self:_projectAll(child, normal, d, axis, r)
	end

	return r
end

function GlyphManager:projectAll(root, normal, d, axis)
	return self:_projectAll(root, normal, d, axis, {})
end

return GlyphManager
