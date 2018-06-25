--------------------------------------------------------------------------------
-- ItsyScape/World/MapGridMesh.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Vector = require "ItsyScape.Common.Math.Vector"
local Color = require "ItsyScape.Graphics.Color"

MapGridMesh = Class()
MapGridMesh.FORMAT = {
    { "VertexPosition", 'float', 3 },
    { "VertexColor", 'float', 4 }
}

function MapGridMesh:new(map, motion, left, right, top, bottom)
	self.vertices = {}
	self.map = map
	self.motion = motion

	left = math.min(math.max(left or 1, 1), map.width)
	right = math.max(math.min(right or map.width, map.width), left)
	top = math.min(math.max(top or 1, 1), map.height)
	bottom = math.max(math.min(bottom or map.height, map.height), top)

	self:buildMesh(left, right, top, bottom)
end

-- Frees underlying resources.
--
-- Drawing is prohibited.
function MapGridMesh:release()
	self.mesh:release()
end

function MapGridMesh:buildMesh(left, right, top, bottom)
	for j = top, bottom do
		for i = left, right do
			local tile = self.map:getTile(i, j)
			local l = (i - 1) * self.map:getCellSize()
			local r = l + self.map:getCellSize()
			local t = (j - 1) * self.map:getCellSize()
			local b = t + self.map:getCellSize()
			local color = Color(1, 1, 1, 0.5)

			self:addVertex(Vector(l, tile.topLeft, t), color)
			self:addVertex(Vector(r, tile.topRight, t), color)
			self:addVertex(Vector(r, tile.topRight, t), color)
			self:addVertex(Vector(r, tile.bottomRight, b), color)
			self:addVertex(Vector(r, tile.bottomRight, b), color)
			self:addVertex(Vector(l, tile.bottomLeft, b), color)
			self:addVertex(Vector(l, tile.bottomLeft, b), color)
			self:addVertex(Vector(l, tile.topLeft, t), color)
		end
	end

	if self.motion then
		local tile, i, j = self.motion:getTile()
		local l = (i - 1) * self.map:getCellSize()
		local r = l + self.map:getCellSize()
		local t = (j - 1) * self.map:getCellSize()
		local b = t + self.map:getCellSize()
		local w = r - l
		local h = b - t
		local color = Color(1, 1, 1, 1)

		local corners = {}
		local count
		do
			local c = { self.motion:getCorners() }
			for index = 1, #c do
				corners[c[index]] = true
			end

			count = #c
		end

		local function addCorner(a, b, w, h, c, c1, c2)
			local corner1 = Vector(a, c, b)
			local corner2 = Vector(a + w / 3, c + (c1 - c) / 3, b)
			local corner3 = Vector(a, c + (c2 - c) / 3, b + h / 3)

			self:addVertex(corner1, color)
			self:addVertex(corner2, color)
			self:addVertex(corner1, color)
			self:addVertex(corner3, color)
		end

		if count == 1 then
			if corners["topLeft"] then
				addCorner(l, t, w, h, tile.topLeft, tile.topRight, tile.bottomLeft)
			elseif corners["topRight"] then
				addCorner(r, t, -w, h, tile.topRight, tile.topLeft, tile.bottomRight)
			elseif corners["bottomLeft"] then
				addCorner(l, b, w, -h, tile.bottomLeft, tile.bottomRight, tile.topLeft)
			elseif corners["bottomRight"] then
				addCorner(r, b, -w, -h, tile.bottomRight, tile.bottomLeft, tile.topRight)
			end
		elseif count == 2 then
			for corner in pairs(corners) do
				if corner == "topLeft" then
					self:addVertex(Vector(l, tile.topLeft, t), color)
				elseif corner == "topRight" then
					self:addVertex(Vector(r, tile.topRight, t), color)
				elseif corner == "bottomLeft" then
					self:addVertex(Vector(l, tile.bottomLeft, b), color)
				elseif corner == "bottomRight" then
					self:addVertex(Vector(r, tile.bottomRight, b), color)
				end
			end
		elseif count == 4 then
			self:addVertex(Vector(l, tile.topLeft, t), color)
			self:addVertex(Vector(r, tile.topRight, t), color)
			self:addVertex(Vector(r, tile.topRight, t), color)
			self:addVertex(Vector(r, tile.bottomRight, b), color)
			self:addVertex(Vector(r, tile.bottomRight, b), color)
			self:addVertex(Vector(l, tile.bottomLeft, b), color)
			self:addVertex(Vector(l, tile.bottomLeft, b), color)
			self:addVertex(Vector(l, tile.topLeft, t), color)
		end
	end

	-- Create mesh and enable all attributes.
	self.mesh = love.graphics.newMesh(MapGridMesh.FORMAT, self.vertices, 'lines', 'static')
	for i = 1, #MapGridMesh.FORMAT do
		self.mesh:setAttributeEnabled(MapGridMesh.FORMAT[i][1], true)
	end
end

function MapGridMesh:addVertex(position, color)
	local vertex = {
		position.x, position.y, position.z,
		color.r, color.g, color.b, color.a
	}

	table.insert(self.vertices, vertex)
end

-- Draws the mesh.
function MapGridMesh:draw(...)
	love.graphics.draw(self.mesh, ...)
end

return MapGridMesh
