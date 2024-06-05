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
local Vector = require "ItsyScape.Common.Math.Vector"
local Quaternion = require "ItsyScape.Common.Math.Quaternion"

local MapCurve = Class()
function MapCurve:new(map, t)
	t = t or {}

	self.mapSize = Vector(map:getWidth() * map:getCellSize(), 0, map:getHeight() * map:getCellSize())
	self.halfMapSize = self.mapSize / 2

	local min = t.min or { 0, 0, 0 }
	local max = t.max or { 0, 0, self,mapSize.z }

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

	if #self.points >= 3 then
		self.xCurveDerivative = self.xCurve:getDerivative()
		self.yCurveDerivative = self.yCurve:getDerivative()
		self.zCurveDerivative = self.zCurve:getDerivative()
	end

	local rotations = t.rotations or {}
	self.rotations = {}
	for _, rotation in ipairs(rotations) do
		table.insert(self.rotations, Quaternion(unpack(rotation)))
	end
end

function MapCurve:_evaluate(p, t, lerp)
	local curve = {}
	for index, value in ipairs(p) do
		curve[index] = value
	end

	for i = 1, #curve do
		for j = 1, #curve - i do
			curve[j] = lerp(curve[j], curve[j + 1], t)
		end
	end

	return curve[1]
end

function MapCurve:evaluateRotation(t)
	return self:_evaluate(self.rotations, t, Quaternion.slerp)
end

function MapCurve:evaluatePosition(t)
	return self:_evaluate(self.points, t, Vector.lerp)
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
	if #self.points < 3 then
		return point
	end

	local planarPoint = Vector(point.x, 0, point.z)
	local relativePoint = (planarPoint - self.min) / (self.max - self.min)
	local t = math.min(relativePoint:get())
	if t < 0 or t > 1 then
		return point
	end

	local position = self:evaluatePosition(t)
	local rotation = self:evaluateRotation(t):getNormal()

	local direction
	if #self.points == 2 then
		direction = (self.points[1] - self.points[2]):getNormal()
	else
		direction = Vector(self.xCurveDerivative:evaluate(t), self.yCurveDerivative:evaluate(t), self.zCurveDerivative:evaluate(t)):getNormal()
	end

	local oppositeAxis = self.oppositeAxis
	local upAxis = self.axis:cross(direction)
	local orientation = Quaternion(upAxis.x, upAxis.y, upAxis.z, 1 + self.axis:dot(direction)):getNormal()
	local up = orientation:transformVector(Vector(0, point.y, 0))
	local center = self.halfMapSize * oppositeAxis
	local relativePoint = oppositeAxis * point + up - center
	return rotation:transformVector(relativePoint) + position
end

function MapCurve.transformAll(point, curve, ...)
	if curve then
		point = curve:transform(point)
		return MapCurve.transformAll(point, ...)
	end

	return point
end

return MapCurve
