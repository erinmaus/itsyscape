--------------------------------------------------------------------------------
-- ItsyScape/Graphics/OldOneGlyph.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Vector = require "ItsyScape.Common.Math.Vector"
local MathCommon = require "ItsyScape.Common.Math.Common"
local Noise = require "ItsyScape.Graphics.Noise"

local OldOneGlyph = Class()

OldOneGlyph.DEFAULT_CONFIG = {
	cellSize = 1,

	minWidth = 3,
	maxWidth = 3,
	minHeight = 4,
	maxHeight = 4,
	minDepth = 4,
	maxDepth = 4,

	minPointRadius = 0.5,
	maxPointRadius = 0.75,
	minPointOffset = 0,
	maxPointOffset = 0,

	pointThreshold = 0.5,

	pointThresholdNoise = Noise {
		scale = 712,
		octaves = 2,
		attenuation = -2
	},

	pointOffsetNoise = Noise {
		scale = 8732,
		octaves = 2,
		attenuation = -2
	},

	pointRadiusNoise = Noise {
		scale = 1777,
		octaves = 1,
		attenuation = 0
	}
}

OldOneGlyph.Point = Class()

function OldOneGlyph.Point:new(id, position, radius)
	self.id = id
	self.position = Vector(position:get()):keep()
	self.radius = radius
end

function OldOneGlyph.Point:getID()
	return self.id
end

function OldOneGlyph.Point:getPosition()
	return self.position
end

function OldOneGlyph.Point:getRadius()
	return self.radius
end

function OldOneGlyph:new()
	self.points = {}
end

function OldOneGlyph:add(position, radius)
	table.insert(self.points, OldOneGlyph.Point(#self.points + 1, position, radius))
end

function OldOneGlyph:iterate()
	return ipairs(self.points)
end

local function _buildT(t, otherT, ...)
	t = t or _buildT({}, OldOneGlyph.DEFAULT_CONFIG)

	if not otherT then
		return t
	end

	for k, v in pairs(otherT) do
		t[k] = v
	end

	return _buildT(t, ...)
end

function OldOneGlyph:fromNoise(i, t, ...)
	t = _buildT(nil, t, ...)

	local rng = love.math.newRandomGenerator(i)
	local width = rng:random() * (t.maxWidth - t.minWidth) + t.minWidth
	local height = rng:random() * (t.maxHeight - t.minHeight) + t.minHeight
	local depth = rng:random() * (t.maxDepth - t.minDepth) + t.minDepth
	local time = rng:randomNormal()

	for i = 0, width - t.cellSize, t.cellSize do
		for j = 0, height - t.cellSize, t.cellSize do
			for k = 0, depth - t.cellSize, t.cellSize do
				local x, y, z = i / width - 0.5, j / height - 0.5, k / depth - 0.5

				local threshold = t.pointThresholdNoise:sample4D(x, y, z, time)
				if threshold > t.pointThreshold then
					local offsetX = t.pointOffsetNoise:sample4D(x, y, z, time) * (t.maxPointOffset - t.minPointOffset) + t.minPointOffset
					local offsetY = t.pointOffsetNoise:sample4D(x, y, z, 1 + time) * (t.maxPointOffset - t.minPointOffset) + t.minPointOffset
					local offsetZ = t.pointOffsetNoise:sample4D(x, y, z, 2 + time) * (t.maxPointOffset - t.minPointOffset) + t.minPointOffset
					--local radius = t.pointRadiusNoise:sample4D(x, y, z, time) * (t.maxPointRadius - t.minPointRadius) + t.minPointRadius
					local radius = rng:random() * (t.maxPointRadius - t.minPointRadius) + t.minPointRadius

					self:add(Vector(x * width + offsetX, y * height + offsetY, z * depth + offsetZ), radius)
				end
			end
		end
	end
end

function OldOneGlyph:project(projection, normal, d, transform, axis)
	projection:reset()

	for _, point in self:iterate() do
		local position = point:getPosition():transform(transform)
		local distance = Vector.dot(normal, position) + d

		local projectedPosition = MathCommon.transformPointFromPlaneToAxis(position + distance * normal, normal, d, axis)
		local radius = 0

		if distance >= -point:getRadius() and distance <= point:getRadius() then
			radius = math.sqrt(point:getRadius() ^ 2 - distance ^ 2)
		end

		projection:add(projectedPosition, radius, point)
	end

	return projection
end

return OldOneGlyph
