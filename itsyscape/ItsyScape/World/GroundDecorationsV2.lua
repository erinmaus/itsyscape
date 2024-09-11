--------------------------------------------------------------------------------
-- ItsyScape/World/GroundDecorationsV2.lua
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

local GroundDecorationsV2 = Class()

-- In world units
GroundDecorationsV2.CELL_WIDTH = 8
GroundDecorationsV2.CELL_DEPTH = 8

function GroundDecorationsV2:new(id)
	self.decorationsByGroup = {}
	self.decorations = {}

	self.tileSetID = id
	self.tileFunctions = {}
end

function GroundDecorationsV2:getDecorationCount()
	return #self.decorations
end

function GroundDecorationsV2:getDecorationAtIndex(index)
	if type(index) ~= "number" or index < 1 or index > #self.decorations then
		return nil, nil
	end

	local decoration = self.decorations[index]
	return decoration.decoration, decoration.name
end

function GroundDecorationsV2:_getDecoration(group, position)
	local x = math.floor(position.x / self.CELL_WIDTH)
	local z = math.floor(position.z / self.CELL_DEPTH)

	local decorations = self.decorationsByGroup[group] or {}
	local decorationRow = decorations[x] or {}
	local decoration = decorationRow[z] or {}

	if not decoration then
		decoration = {
			name = group,
			decoration = Decoration({
				tileSetID = self.tileSetID
			})
		}

		decorationsRow[z] = decoration
		decorations[x] = decorationRow

		table.insert(self.decorations, decoration)
	end

	self.decorationsByGroup[group] = decorations

	return decoration
end

function GroundDecorationsV2:addFeature(group, id, position, rotation, scale, color, texture)
	local decoration = self:_getDecoration(group, position)
	return decoration.decoration:add(id, position, rotation, scale, color, texture)
end

function GroundDecorationsV2:registerTile(name, func, ...)
	self.tileFunctions[name] = self.tileFunctions[name] or Callback()
	self.tileFunctions[name]:register(func, self, ...)
end

function GroundDecorationsV2:emit(method, tileSet, map, i, j)
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
			tileFunction(method, actualTileSet, map, i, j, tileSetTile, mapTile)
		end
	end
end

function GroundDecorationsV2:_emitAll(method, tileSet, map)
	-- Needs to emit left to right first, then top to bottom
	for j = 1, map:getHeight() do
		for i = 1, map:getWidth() do
			self:emit(method, tileSet, map, i, j)
		end

		if coroutine.running() then
			coroutine.yield()
		end
	end
end

function GroundDecorationsV2:emitAll(tileSet, map)
	self:_emitAll("cache", tileSet, map)
	self:_emitAll("draw", tileSet, map)

	print(">>> decos", #self.decorations)
end 

return GroundDecorationsV2
