--------------------------------------------------------------------------------
-- ItsyScape/World/GroundDecorations.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Callback = require "ItsyScape.Common.Callback"
local Decoration = require "ItsyScape.Graphics.Decoration"
local MultiTileSet = require "ItsyScape.World.MultiTileSet"

local GroundDecorations = Class()
GroundDecorations.FUDGE = 50.3385959375047693

function GroundDecorations:new(id)
	self.decoration = Decoration({
		tileSetID = id
	})

	self.tileSetID = id
	self.tileFunctions = {}
end

function GroundDecorations:noise(octaves, ...)
	local sum = 0
	local average = 0
	for i = 1, octaves do
		local args = { ... }
		for i = 1, #args do
			args[i] = args[i] * self.FUDGE + i ^ 2
		end

		sum = sum + 1 / i * love.math.noise(unpack(args))
		average = average + 1 / i
	end

	return sum / average
end

function GroundDecorations:getDecoration()
	return self.decoration
end

function GroundDecorations:addFeature(id, position, rotation, scale, color)
	return self.decoration:add(id, position, rotation, scale, color)
end

function GroundDecorations:registerTile(name, func, ...)
	self.tileFunctions[name] = self.tileFunctions[name] or Callback()
	self.tileFunctions[name]:register(func, self, ...)
end

function GroundDecorations:emit(tileSet, map, i, j)
	local mapTile = map:getTile(i, j)

	local tileSetTile, actualTileSet
	do
		if Class.isCompatibleType(tileSet, MultiTileSet) then
			actualTileSet = tileSet:getTileSetByID(mapTile.tileSetID)
		else
			actualTileSet = tileSet
		end

		tileSetTile = actualTileSet:getTile(mapTile.flat)
	end

	if tileSetTile and mapTile.tileSetID == self.tileSetID then
		local name = tileSetTile.name
		local tileFunction = self.tileFunctions[name]
		if tileFunction then
			tileFunction(actualTileSet, map, i, j, tileSetTile, mapTile)
		end
	end
end

function GroundDecorations:emitAll(tileSet, map)
	for i = 1, map:getWidth() do
		for j = 1, map:getHeight() do
			self:emit(tileSet, map, i, j)
		end
	end
end 

return GroundDecorations
