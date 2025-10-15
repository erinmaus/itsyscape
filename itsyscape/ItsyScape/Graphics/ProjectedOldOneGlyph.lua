--------------------------------------------------------------------------------
-- ItsyScape/Graphics/ProjectedOldOneGlyph.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Vector = require "ItsyScape.Common.Math.Vector"

local ProjectedOldOneGlyph = Class()

ProjectedOldOneGlyph.Cell = Class()
function ProjectedOldOneGlyph.Cell:new(i, j)
	self.i = i
	self.j = j
	self.position = Vector(0):keep()
	self.radius = 0
	self.point = false
end

function ProjectedOldOneGlyph.Cell:project(position, radius, point)
	if (radius < self.radius and radius > 0) or self.radius == 0 then
		self.position = position:keep(self.position)
		self.radius = radius
		self.point = point
	end
end

function ProjectedOldOneGlyph.Cell:getIsFilled()
	return self.radius > 0
end

function ProjectedOldOneGlyph.Cell:reset()
	self.position = Vector(0):keep(self.position)
	self.radius = 0
	self.point = false
end

function ProjectedOldOneGlyph.Cell:getIndices()
	return self.i, self.j
end

function ProjectedOldOneGlyph.Cell:getPosition()
	return self.position
end

function ProjectedOldOneGlyph.Cell:getRadius()
	return self.radius
end

function ProjectedOldOneGlyph.Cell:getPoint()
	return self.point
end

ProjectedOldOneGlyph.Polygon = Class()
function ProjectedOldOneGlyph.Polygon:new()
	self.points = {}
end

function ProjectedOldOneGlyph.Polygon:reset()
	table.clear(self.points)
end

function ProjectedOldOneGlyph.Polygon:makeCenter(center)
	local centerRadius = center:getRadius()
	local centerPosition = center:getPosition()

	for i = 1, 4 do
		local angle = (i - 1) / 4 * math.pi * 2
		local x = math.cos(angle) * centerRadius + centerPosition.x
		local y = math.sin(angle) * centerRadius + centerPosition.y

		table.insert(self.points, x)
		table.insert(self.points, y)
	end
end

function ProjectedOldOneGlyph.Polygon:makeLeftLeaf(center, top, bottom)
	local centerRadius = center:getRadius()
	local centerPosition = center:getPosition()
	local topPosition = top:getPosition()
	local bottomPosition = bottom:getPosition()

	local x1 = math.cos(math.rad(-135)) * centerRadius + centerPosition.x
	local y1 = math.sin(math.rad(-135)) * centerRadius + centerPosition.y
	local x2 = math.cos(math.rad(135)) * centerRadius + centerPosition.x
	local y2 = math.sin(math.rad(135)) * centerRadius + centerPosition.y

	self.points[1] = x1
	self.points[2] = y1
	self.points[3] = x2
	self.points[4] = y2
	self.points[5] = centerPosition.x
	self.points[6] = centerPosition.y
end

function ProjectedOldOneGlyph.Polygon:makeRightLeaf(center, top, bottom)
	local centerRadius = center:getRadius()
	local centerPosition = center:getPosition()
	local topPosition = top:getPosition()
	local bottomPosition = bottom:getPosition()

	local x1 = math.cos(math.rad(-45)) * centerRadius + centerPosition.x
	local y1 = math.sin(math.rad(-45)) * centerRadius + centerPosition.y
	local x2 = math.cos(math.rad(45)) * centerRadius + centerPosition.x
	local y2 = math.sin(math.rad(45)) * centerRadius + centerPosition.y

	self.points[1] = x1
	self.points[2] = y1
	self.points[3] = x2
	self.points[4] = y2
	self.points[5] = centerPosition.x
	self.points[6] = centerPosition.y
end

function ProjectedOldOneGlyph.Polygon:makeTopLeaf(center, left, right)
	local centerRadius = center:getRadius()
	local centerPosition = center:getPosition()
	local leftPosition = left:getPosition()
	local rightPosition = right:getPosition()

	local x1 = math.cos(math.rad(135)) * centerRadius + centerPosition.x
	local y1 = math.sin(math.rad(135)) * centerRadius + centerPosition.y
	local x2 = math.cos(math.rad(45)) * centerRadius + centerPosition.x
	local y2 = math.sin(math.rad(45)) * centerRadius + centerPosition.y

	self.points[1] = x1
	self.points[2] = y1
	self.points[3] = x2
	self.points[4] = y2
	self.points[5] = centerPosition.x
	self.points[6] = centerPosition.y
end

function ProjectedOldOneGlyph.Polygon:makeBottomLeaf(center, right, left)
	local centerRadius = center:getRadius()
	local centerPosition = center:getPosition()
	local leftPosition = left:getPosition()
	local rightPosition = right:getPosition()

	local x1 = math.cos(math.rad(-135)) * centerRadius + centerPosition.x
	local y1 = math.sin(math.rad(-135)) * centerRadius + centerPosition.y
	local x2 = math.cos(math.rad(-45)) * centerRadius + centerPosition.x
	local y2 = math.sin(math.rad(-45)) * centerRadius + centerPosition.y

	self.points[1] = x1
	self.points[2] = y1
	self.points[3] = x2
	self.points[4] = y2
	self.points[5] = centerPosition.x
	self.points[6] = centerPosition.y
end

function ProjectedOldOneGlyph.Polygon:makeHorizontalEdge(left, right)
	local leftRadius = left:getRadius()
	local leftPosition = left:getPosition()
	local rightRadius = right:getRadius()
	local rightPosition = right:getPosition()

	local leftX1 = math.cos(math.rad(-45)) * leftRadius + leftPosition.x
	local leftY1 = math.sin(math.rad(-45)) * leftRadius + leftPosition.y
	local leftX2 = math.cos(math.rad(45)) * leftRadius + leftPosition.x
	local leftY2 = math.sin(math.rad(45)) * leftRadius + leftPosition.y

	local rightX1 = math.cos(math.rad(-135)) * rightRadius + rightPosition.x
	local rightY1 = math.sin(math.rad(-135)) * rightRadius + rightPosition.y
	local rightX2 = math.cos(math.rad(135)) * rightRadius + rightPosition.x
	local rightY2 = math.sin(math.rad(135)) * rightRadius + rightPosition.y

	self.points[1] = leftX1
	self.points[2] = leftY1
	self.points[3] = rightX1
	self.points[4] = rightY1
	self.points[5] = rightPosition.x
	self.points[6] = rightPosition.y
	self.points[7] = rightX2
	self.points[8] = rightY2
	self.points[9] = leftX2
	self.points[10] = leftY2
	self.points[11] = leftPosition.x
	self.points[12] = leftPosition.y
end

function ProjectedOldOneGlyph.Polygon:makeVerticalEdge(bottom, top)
	local bottomRadius = bottom:getRadius()
	local bottomPosition = bottom:getPosition()
	local topRadius = top:getRadius()
	local topPosition = top:getPosition()

	local bottomX1 = math.cos(math.rad(-135)) * bottomRadius + bottomPosition.x
	local bottomY1 = math.sin(math.rad(-135)) * bottomRadius + bottomPosition.y
	local bottomX2 = math.cos(math.rad(-45)) * bottomRadius + bottomPosition.x
	local bottomY2 = math.sin(math.rad(-45)) * bottomRadius + bottomPosition.y

	local topX1 = math.cos(math.rad(135)) * topRadius + topPosition.x
	local topY1 = math.sin(math.rad(135)) * topRadius + topPosition.y
	local topX2 = math.cos(math.rad(45)) * topRadius + topPosition.x
	local topY2 = math.sin(math.rad(45)) * topRadius + topPosition.y

	self.points[1] = topX1
	self.points[2] = topY1
	self.points[3] = topPosition.x
	self.points[4] = topPosition.y
	self.points[5] = topX2
	self.points[6] = topY2
	self.points[7] = bottomX2
	self.points[8] = bottomY2
	self.points[9] = bottomPosition.x
	self.points[10] = bottomPosition.y
	self.points[11] = bottomX1
	self.points[12] = bottomY1
end

function ProjectedOldOneGlyph.Polygon:draw()
	love.graphics.polygon("fill", self.points)
end

function ProjectedOldOneGlyph:new(w, h, radiusScale)
	self.width = w
	self.height = h
	self.radiusScale = radiusScale or 1

	self.cells = {}

	for j = 1, h do
		for i = 1, w do
			local cell = ProjectedOldOneGlyph.Cell(i, j)
			local index = (i - 1) * h + (j - 1) + 1

			self.cells[index] = cell
		end
	end

	self.polygons = {}
	self.polygonCount = 0
end

function ProjectedOldOneGlyph:getCell(i, j)
	if i <= 0 or i > self.width or j <= 0 or j > self.height then
		return nil
	end

	local index = (i - 1) * self.height + (j - 1) + 1
	return self.cells[index]
end

function ProjectedOldOneGlyph:reset()
	self.polygonCount = 0

	for _, cell in ipairs(self.cells) do
		cell:reset()
	end
end

function ProjectedOldOneGlyph:_newPolygon()
	local i = self.polygonCount + 1
	local polygon = self.polygons[i]

	if not polygon then
		polygon = ProjectedOldOneGlyph.Polygon()
		self.polygons[i] = polygon
	else
		polygon:reset()
	end

	self.polygonCount = i
	return polygon
end

function ProjectedOldOneGlyph:add(position, radius, point)
	local i = math.floor(point:getPosition().x + self.width / 2) + 1
	local j = math.floor(point:getPosition().z + self.height / 2) + 1

	local cell = self:getCell(i, j)
	if cell then
		cell:project(position, math.max(radius * self.radiusScale, 0), point)
	end
end

function ProjectedOldOneGlyph:polygonize()
	for i = 1, self.width do
		for j = 1, self.height do
			local center = self:getCell(i, j)

			if center:getIsFilled() then
				local left = self:getCell(i - 1, j)
				local right = self:getCell(i + 1, j)
				local top = self:getCell(i, j - 1)
				local bottom = self:getCell(i, j + 1)

				if not ((left and left:getIsFilled()) or (right and right:getIsFilled()) or (top and top:getIsFilled()) or (bottom and bottom:getIsFilled())) then
					local polygon = self:_newPolygon()
					polygon:makeCenter(center)
				end

				if left and left:getIsFilled() then
					local polygon = self:_newPolygon()
					polygon:makeHorizontalEdge(left, center)
				end

				if (top and top:getIsFilled()) and (bottom and bottom:getIsFilled()) and not (left and left:getIsFilled()) then
					local polygon = self:_newPolygon()
					polygon:makeLeftLeaf(center, top, bottom)
				end

				if (top and top:getIsFilled()) and (bottom and bottom:getIsFilled()) and not (right and right:getIsFilled()) then
					local polygon = self:_newPolygon()
					polygon:makeRightLeaf(center, top, bottom)
				end

				if top and top:getIsFilled() then
					local polygon = self:_newPolygon()
					polygon:makeVerticalEdge(top, center)
				end

				if (right and right:getIsFilled()) and (left and left:getIsFilled()) and not (top and top:getIsFilled()) then
					local polygon = self:_newPolygon()
					polygon:makeTopLeaf(center, left, right)
				end

				if (right and right:getIsFilled()) and (left and left:getIsFilled()) and not (bottom and bottom:getIsFilled()) then
					local polygon = self:_newPolygon()
					polygon:makeBottomLeaf(center, left, right)
				end
			end
		end
	end
end

function ProjectedOldOneGlyph:draw()
	for i = 1, self.polygonCount do
		local polygon = self.polygons[i]
		polygon:draw()
	end
end

return ProjectedOldOneGlyph