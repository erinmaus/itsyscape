--------------------------------------------------------------------------------
-- ItsyScape/World/MapCurve.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local MathCommon = require "ItsyScape.Common.Math.Common"
local Vector = require "ItsyScape.Common.Math.Vector"
local Quaternion = require "ItsyScape.Common.Math.Quaternion"

local MapCurve = Class()
function MapCurve:new(map, t)
	t = t or {}

	self.width = map:getWidth()
	self.height = map:getHeight()
	self.mapSize = Vector(map:getWidth() * map:getCellSize(), 0, map:getHeight() * map:getCellSize())
	self.halfMapSize = self.mapSize / 2

	local min = t.min or { 0, 0, 0 }
	local max = t.max or { self.mapSize.x, 0, self.mapSize.z }

	self.min = Vector(unpack(min))
	self.max = Vector(unpack(max))

	local axis = t.axis or { 0, 0, 1 }
	self.axis = Vector(unpack(axis))
	self.oppositeAxis = Vector.UNIT_Y:cross(self.axis):getNormal()

	local points = t.points or {}
	local xPoints, yPoints, zPoints = {}, {}, {}
	self.points = {}
	for _, point in ipairs(points) do
		table.insert(xPoints, point[1])
		table.insert(xPoints, 0)

		table.insert(yPoints, point[2])
		table.insert(yPoints, 0)

		table.insert(zPoints, point[3])
		table.insert(zPoints, 0)

		table.insert(self.points, Vector(unpack(point)))
	end

	if #self.points >= 2 then
		self.xCurve = love.math.newBezierCurve(xPoints)
		self.yCurve = love.math.newBezierCurve(yPoints)
		self.zCurve = love.math.newBezierCurve(zPoints)
	end

	self.directions = self:_derivative(self.points)

	local rotations = t.rotations or {}
	self.rotations = {}
	for _, rotation in ipairs(rotations) do
		table.insert(self.rotations, Quaternion(unpack(rotation)))
	end

	local normals = t.normals or {}
	self.normals = {}
	for _, normal in ipairs(normals) do
		table.insert(self.normals, Vector(unpack(normal)))
	end
end

function MapCurve:_evaluate(p, t, lerp)
	local curve = {}
	for index, value in ipairs(p) do
		curve[index] = value
	end

	for i = 2, #curve do
		for j = 1, #curve - i + 1 do
			curve[j] = lerp(curve[j], curve[j + 1], t)
		end
	end

	return curve[1]
end

function MapCurve:_derivative(p)
	local result = {}
	for i = 1, #p - 1 do
		result[i] = p[i]
	end

	local degree = #p - 1
	for i in ipairs(result) do
		result[i] = (p[i + 1] - p[i]) * degree
	end

	return result
end

local slerp = function(a, b, t)
	return a:getNormal():slerp(b:getNormal(), t):getNormal()
end

function MapCurve:evaluateRotation(t)
	return self:_evaluate(self.rotations, t, slerp)
end

function MapCurve:evaluatePosition(t)
	return self:_evaluate(self.points, t, Vector.lerp)
end

function MapCurve:evaluateDirection(t)
	return self:_evaluate(self.directions, t, Vector.lerp) or Vector.UNIT_Z
end

function MapCurve:evaluateNormal(t)
	return self:_evaluate(self.normals, t, Vector.lerp)
end

function MapCurve:getMin()
	return self.min
end

function MapCurve:getMax()
	return self.max
end

function MapCurve:getAxis()
	return self.axis
end

function MapCurve:getPoints()
	return self.points
end

function MapCurve:getRotations()
	return self.rotations
end

function MapCurve:render(depth, result)
	result = result or {}

	local x, y, z = self.xCurve:render(depth), self.yCurve:render(depth), self.zCurve:render(depth)

	local index = 1
	for i = 1, #x, 2 do
		local p = result[index] or Vector()

		p.x = x[i] or 0
		p.y = y[i] or 0
		p.z = z[i] or 0

		result[index] = p
		index = index + 1
	end

	return result, index
end

function MapCurve:transform(point)
	if #self.points < 2 then
		return point
	end

	local planarPoint = Vector(point.x, 0, point.z)
	local relativePoint = (planarPoint - self.min) / (self.max - self.min):max(Vector.ONE)
	local t = math.min(relativePoint:get())
	if t < 0 or t > 1 then
		return point
	end

	local position = self:evaluatePosition(t)
	local rotation = self:evaluateRotation(t):getNormal()
	local normal = self:evaluateNormal(t):getNormal()

	local oppositeAxis = self.oppositeAxis
	local up = Vector(point.y) * normal
	local center = self.halfMapSize * oppositeAxis
	local p = oppositeAxis * point - center + up

	return rotation:transformVector(p) + position
end

function MapCurve:getCurveTexture()
	if self.texture then
		return self.texture
	end

	local length
	if self.axis == Vector.UNIT_X then
		length = self.width
	else
		length = self.height
	end

	local positions = {}
	local normals = {}
	local rotations = {}

	local previousUp = Vector.UNIT_Y
	local previousPosition = self.points[i] 
	for i = 1, length do
		local t = (i - 1) / (length - 1)

		positions[i] = self:evaluatePosition(t)
		rotations[i] = self:evaluateRotation(t):getNormal()
		--normals[i] = rotations[i]:transformVector(self:evaluateNormal(t):getNormal()):getNormal()
		normals[i] = self:evaluateNormal(t):getNormal()
	end

	local image = love.image.newImageData(length, 3, "rgba32f")
	self.texture = image

	self.texture:mapPixel(function(x)
		return positions[x + 1].x, positions[x + 1].y, positions[x + 1].z, 1
	end, 0, 0, length, 1)

	self.texture:mapPixel(function(x)
		return normals[x + 1].x, normals[x + 1].y, normals[x + 1].z, 1
	end, 0, 1, length, 1)

	self.texture:mapPixel(function(x)
		return rotations[x + 1].x, rotations[x + 1].y, rotations[x + 1].z, rotations[x + 1].w
	end, 0, 2, length, 1)

	return self.texture
end

function MapCurve.transformAll(point, curve, ...)
	if curve then
		point = curve:transform(point)
		return MapCurve.transformAll(point, ...)
	end

	return point
end

return MapCurve
