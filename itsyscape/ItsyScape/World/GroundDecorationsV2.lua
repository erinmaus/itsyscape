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

function GroundDecorationsV2:new(id)
	self.decoration = Decoration({
		tileSetID = id
	})

	self.tileSetID = id
	self.tileFunctions = {}
end

function GroundDecorationsV2:getDecoration()
	return self.decoration
end

function GroundDecorationsV2:addFeature(id, position, rotation, scale, color, texture)
	return self.decoration:add(id, position, rotation, scale, color, texture)
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
end 

return GroundDecorationsV2
