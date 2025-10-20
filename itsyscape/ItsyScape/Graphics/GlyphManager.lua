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
local Quaternion = require "ItsyScape.Common.Math.Quaternion"
local Vector = require "ItsyScape.Common.Math.Vector"
local OldOneGlyph = require "ItsyScape.Graphics.OldOneGlyph"
local OldOneGlyphInstance = require "ItsyScape.Graphics.OldOneGlyphInstance"
local PostProcessPass = require "ItsyScape.Graphics.PostProcessPass"

local GlyphManager = Class()

function GlyphManager:new(t, gameView)
	self.t = t or OldOneGlyph.DEFAULT_CONFIG
	self.projectionRadiusScale = 0.5
	self.maxDepth = 2
	self.rotationSpeed = math.pi / 32

	self.radius = math.max(self:getDimensions())
	self.transform = love.math.newTransform()

	self.glyphs = {}

	self.gameView = gameView
	self.shaderCache = PostProcessPass(gameView:getRenderer(), 0)
	self.shaderCache:load(gameView:getResourceManager())
	self.shakyShader = self.shaderCache:loadPostProcessShader("ShakyVertex")
end

function GlyphManager:getRadius()
	return self.radius
end

function GlyphManager:getProjectionRadiusScale()
	return self.projectionRadiusScale
end

function GlyphManager:getRotationSpeed()
	return self.rotationSpeed
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
				if instances[parentIndex]:getDepth() <= self.maxDepth then
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

local _stencilProjections, _stencilGlyphManager
local function _stencil()
	for _, p in ipairs(_stencilProjections) do
		local glyph, projection = unpack(p)
		if not projection:getIsEmpty() then
			love.graphics.circle("fill", projection:getPosition().x, projection:getPosition().y, _stencilGlyphManager:getRadius() * 1.5)
		end
	end
end

function GlyphManager:getStandardPlane(time)
	local planeD = -(math.sin(time / math.pi / 8) * 2 - 1)
	local planeAxis = Vector(
		math.cos(time / math.pi / 8),
		1,
		math.sin(time / math.pi / 8)):getNormal()
	local planeRotation = Quaternion.fromAxisAngle(planeAxis, math.sin(time / math.pi / 8) * math.pi / 8)
	local planeNormal = planeRotation:getNormal():transformVector(Vector.UNIT_Y)

	return planeNormal, planeD
end

function GlyphManager:draw(root, projections, x, y, w, h, size, offset)
	offset = offset or 0

	love.graphics.push("all")

	local maxSize = math.max(w, h)
	local baseScale = maxSize / size
	local extraScale = size / (root:getRadius() * baseScale)

	self.transform:setTransformation(x + w / 2, y + h / 2, 0, baseScale * extraScale, -baseScale * extraScale)
	love.graphics.applyTransform(self.transform)

	local lineWidth = 1 / 2 + offset
	love.graphics.setLineWidth(lineWidth)

	local minX, minY = math.huge, math.huge
	local maxX, maxY = -math.huge, -math.huge

	love.graphics.setColorMask(false, false, false, false)
	love.graphics.clear(false, false, 0)

	love.graphics.setDepthMode("always", true)

	for _, p in ipairs(projections) do
		local glyph, projection = unpack(p)

		if not glyph:getParent() then
			local scale = glyph:getRadius() / self.radius
			projection:polygonize(1 / scale * 2)
		else
			projection:polygonize()
		end
	end

	self.shaderCache:bindShader(
		self.shakyShader,
		"scape_Time", self.gameView:getRenderer():getTime(),
		"scape_Scale", 5,
		"scape_Interval", 1 / 8)

	_stencilProjections = projections
	_stencilGlyphManager = self

	love.graphics.push("all")
	love.graphics.setDepthMode("always", false)
	love.graphics.stencil(_stencil, "replace", 1, false)
	love.graphics.pop()

	love.graphics.setStencilTest("notequal", 1)
	for _, p in ipairs(projections) do
		local glyph, projection = unpack(p)
		local position = projection:getPosition()

		if not projection:getIsEmpty() and glyph:getHasChildren() then
			love.graphics.circle("line",  position.x, position.y, glyph:getRadius())
		end

		local topLeftX, topLeftY = love.graphics.transformPoint(
			position.x - glyph:getRadius() - lineWidth - 5,
			position.y - glyph:getRadius() - lineWidth - 5)
		local bottomRightX, bottomRightY = love.graphics.transformPoint(
			position.x + glyph:getRadius() + lineWidth + 5,
			position.y + glyph:getRadius() + lineWidth + 5)

		minX = math.min(minX, topLeftX, bottomRightX)
		minY = math.min(minY, topLeftY, bottomRightY)
		maxX = math.max(maxX, topLeftX, bottomRightX)
		maxY = math.max(maxY, topLeftY, bottomRightY)
	end

	love.graphics.setStencilTest()
	for _, p in ipairs(projections) do
		local glyph, projection = unpack(p)
		local position = projection:getPosition()

		if not projection:getIsEmpty() and glyph:getParent() then
			local scale = 1
			if not glyph:getHasChildren() then
				scale = 1.5
			end

			love.graphics.circle("line", position.x, position.y, self.radius * 1.5)
		end
	end

	love.graphics.setShader()

	for _, p in ipairs(projections) do
		local glyph, projection = unpack(p)

		local scale
		if not glyph:getParent() then
			scale = glyph:getRadius() / self.radius
		else
			scale = 2
		end

		local position = projection:getPosition()
		self.transform:setTransformation(position.x, position.y, 0, scale, scale, position.x, position.y)

		love.graphics.push()
		love.graphics.applyTransform(self.transform)
		projection:draw(offset / scale)
		love.graphics.pop()
	end

	love.graphics.origin()
	love.graphics.setColorMask(true, true, true, true)
	love.graphics.setDepthMode("equal", true)
	love.graphics.rectangle("fill", minX, minY, maxX - minX, maxY - minY)

	love.graphics.pop()
end

return GlyphManager
