--------------------------------------------------------------------------------
-- ItsyScape/Game/Skills/Antilogika/DimensionBuilder.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Cell = require "ItsyScape.Game.Skills.Antilogika.Cell"
local Zone = require "ItsyScape.Game.Skills.Antilogika.Zone"

local DimensionBuilder = Class()

function DimensionBuilder:new(seed, scale)
	self.width = scale * 2 + 1
	self.height = scale * 2 + 1

	self.seed = seed
	self.rng = love.math.newRandomGenerator(seed:toSeed())

	self.zone = Zone()

	self:_initializeCells()
end

function DimensionBuilder:_initializeCells()
	self.cells = {}

	for i = 1, self.width do
		for j = 1, self.height do
			local index = j * self.width + i

			local rng = love.math.newRandomGenerator(
				(2 ^ 32 - 1) * self.rng:random(),
				(2 ^ 32 - 1) * self.rng:random())

			self.cells[index] = Cell(i, j, rng)
		end
	end
end

function DimensionBuilder:getWidth()
	return self.width
end

function DimensionBuilder:getHeight()
	return self.height
end

function DimensionBuilder:getSeed()
	return self.seed
end

function DimensionBuilder:getCell(i, j)
	return self.cells[j * self.width + i]
end

function DimensionBuilder:getZone(x, z)
	return self.zone
end

return DimensionBuilder
