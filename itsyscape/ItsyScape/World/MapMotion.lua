--------------------------------------------------------------------------------
-- ItsyScape/World/MapMotion.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

local Class = require "ItsyScape.Common.Class"
local Ray = require "ItsyScape.Common.Math.Ray"
local Vector = require "ItsyScape.Common.Math.Vector"
local Map = require "ItsyScape.World.Map"
local Tile = require "ItsyScape.World.Tile"

MapMotion = Class()

function MapMotion:new(map)
	self.map = map
	self.isDragging = false
end

function MapMotion:getReferenceY(e)
	local y = e.y / 30

	return -y
end

function MapMotion:beginPerform(e)
	-- Nothing.
end

function MapMotion:endPerform(e)
	-- Nothing.
end

-- Called when the mouse is pressed.
--
-- Finds the tile under the cursor and selects the nearest corners.
--
-- e is a MouseEvent-like structure.
function MapMotion:onMousePressed(e)
	-- TODO:
	--   1. Allow button customization (instead of left/primary mouse button)
	--   2. Raise entire tile if position is close to center (< cellSize / 2?)
	local tiles = self.map:testRay(e.ray)
	table.sort(tiles, function(a, b) return a[2].z > b[2].z end)

	if #tiles >= 1 and e.button == 1 then
		local v = e.ray.origin:cross(e.forward)
		self.isDragging = true
		self.referenceY = math.floor(self:getReferenceY(e))
		self.tile = tiles[1][Map.RAY_TEST_RESULT_TILE]
		self.tileI = tiles[1][Map.RAY_TEST_RESULT_I]
		self.tileJ = tiles[1][Map.RAY_TEST_RESULT_J]

		local tileCenter = self.map:getTileCenter(
			tiles[1][Map.RAY_TEST_RESULT_I],
			tiles[1][Map.RAY_TEST_RESULT_J])
		local distanceFromTileCenter
		do
			local difference = tileCenter - tiles[1][Map.RAY_TEST_RESULT_POSITION]
			distanceFromTileCenter = difference:getLength()
		end

		if distanceFromTileCenter < self.map:getCellSize() / 4 then
			self.corners ={
				"topLeft",
				"topRight",
				"bottomLeft",
				"bottomRight"
			}
		else
			self.corners = {}
			local _, _, corners = self.tile:findNearestCorner(
				tiles[1][Map.RAY_TEST_RESULT_POSITION],
				tiles[1][Map.RAY_TEST_RESULT_I], tiles[1][Map.RAY_TEST_RESULT_J],
				self.map.cellSize)
			for i = 1, #corners do
				local c = corners[i]
				local distance = c[Tile.NEAREST_CORNER_RESULT_DISTANCE]
				if distance < self.map.cellSize * (2 / 3) then
					table.insert(
						self.corners,
						corners[i][Tile.NEAREST_CORNER_RESULT_CORNER])
				end
			end
		end
		
		self:beginPerform(e)
	end
end

function MapMotion:getCorners()
	return unpack(self.corners or {})
end

function MapMotion:getTile()
	return self.tile, self.tileI or 1, self.tileJ or 1
end

function MapMotion:getMap()
	return self.map
end

-- Called when the mouse is released.
--
-- Cancels the current action.
--
-- e is a MouseEvent-like structure.
function MapMotion:onMouseReleased(e)
	if self.isDragging then
		self.isDragging = false
		self:endPerform()
	end
end

-- Called when the mouse is moved.
--
-- Moves the corners of the tile, if any, by a constant amount when necessary.
--
-- Returns true if the tile has been modified, false otherwise.
--
-- e is a MouseEvent-like structure.
function MapMotion:onMouseMoved(e)
	if self.isDragging then
		-- Using the Z-axis as the reference point, compute how far along
		-- the Y-axis the ray has moved and adjust corners by amount.
		local y = math.floor(self:getReferenceY(e))
		local distance = y - self.referenceY

		if math.abs(distance) >= 1 then
			self:perform(e, distance)
			self.referenceY = y

			return true
		end
	end

	return false
end

-- Raises the corner of a tile. Default action.
function MapMotion:perform(e, distance)
	for i = 1, #self.corners do
		self.tile[self.corners[i]] = self.tile[self.corners[i]] + distance
	end

	if distance < 0 then
		self.tile:snapCorners('min')
	else
		self.tile:snapCorners('max')
	end
end

return MapMotion
