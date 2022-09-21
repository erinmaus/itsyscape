--------------------------------------------------------------------------------
-- ItsyScape/World/MapMeshMask.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local LayerTextureResource = require "ItsyScape.Graphics.LayerTextureResource"

local MapMeshMask = Class()

MapMeshMask.DEFAULT_SIZE = 128

MapMeshMask.MASK_FILENAME = "Resources/Game/TileSets/Common/Mask_Default.png"

-- A horizontal slice positioned on the top of the tile
MapMeshMask.TYPE_HORIZONTAL_TOP    = 1

-- A horizontal slice positioned on the bottom of the tile
MapMeshMask.TYPE_HORIZONTAL_BOTTOM = 2

-- A vertical slice positioned on the right side of the tile
MapMeshMask.TYPE_VERTICAL_RIGHT    = 3

-- A vertical slice positioned on the left side of the tile
MapMeshMask.TYPE_VERTICAL_LEFT     = 4

-- A corner positioned in the top left corner of the tile
MapMeshMask.TYPE_CORNER_TL         = 5

-- A corner positioned in the top right corner of the tile
MapMeshMask.TYPE_CORNER_TR         = 6

-- A corner positioned in the bottom left corner of the tile
MapMeshMask.TYPE_CORNER_BL         = 7

-- A corner positioned in the bottom right corner of the tile
MapMeshMask.TYPE_CORNER_BR         = 8

-- A fully visible tile
MapMeshMask.TYPE_UNMASKED          = 9

MapMeshMask.MAX_TYPE_COMBINATIONS  = 7

MapMeshMask.SEGMENT_OFFSETS = {
	[MapMeshMask.TYPE_HORIZONTAL_TOP]    = {    0, -128, 0,  1,  1,   0,   0 },
	[MapMeshMask.TYPE_HORIZONTAL_BOTTOM] = {    0,    0, 0,  1, -1,   0, 256 },
	[MapMeshMask.TYPE_VERTICAL_RIGHT]    = {    0,    0, 0, -1,  1, 256,   0 },
	[MapMeshMask.TYPE_VERTICAL_LEFT]     = { -128,    0, 0,  1,  1,   0,   0 },
	[MapMeshMask.TYPE_CORNER_TL]         = { -128, -128, 0,  1,  1,   0,   0 },
	[MapMeshMask.TYPE_CORNER_TR]         = {    0, -128, 0, -1,  1, 256,   0 },
	[MapMeshMask.TYPE_CORNER_BL]         = { -128,    0, 0,  1, -1,   0, 256 },
	[MapMeshMask.TYPE_CORNER_BR]         = {    0,    0, 0, -1, -1, 256, 256 },
	[MapMeshMask.TYPE_UNMASKED]          = {    0,    0, 0,  1,  1,   0,   0 }
}

function MapMeshMask:new()
	self.canvas = love.graphics.newCanvas(
		self.DEFAULT_SIZE, self.DEFAULT_SIZE, self.MAX_TYPE_COMBINATIONS)
end

function MapMeshMask:getCanvas()
	return self.canvas
end

function MapMeshMask:initializeCanvas()
	local texture = love.graphics.newImage(self.MASK_FILENAME)

	love.graphics.push("all")
	for i = 1, MapMeshMask.MAX_TYPE_COMBINATIONS do
		love.graphics.setCanvas(self.canvas, i)
		love.graphics.clear(0, 0, 0, 0)
		love.graphics.draw(texture, unpack(self.SEGMENT_OFFSETS[i]))
	end
end

function MapMeshMask:updateCanvas()
	-- Nothing.
end

function MapMeshMask:getTexture()
	if not self.texture then
		self:initializeCanvas()
		self.texture = LayerTextureResource(self.canvas)
	end

	self:updateCanvas()

	return self.texture
end

return MapMeshMask
