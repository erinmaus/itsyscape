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

	local min = t.min or { 0, 0, 0 }
	local max = t.max or { 0, 0, map:getHeight() * map:getCellSize() + 1 }

	self.min = Vector(unpack(min))
	self.max = Vector(unpack(max))

	local axis = t.axis or { 0, 0, 1 }
	self.axis = Vector(unpack(axis))

	local points = t.points or {}
	local xPoints, yPoints, zPoints = {}, {}, {}
	self.points = {}
	for _, point in ipairs(t.points) do
		table.insert(xPoints, point[1])
		table.insert(xPoints, 0)

		table.insert(yPoints, point[2])
		table.insert(yPoints, 0)

		table.insert(zPoints, point[3])
		table.insert(zPoints, 0)

		table.insert(self.points, Vector(unpack(point)))
	end

	if #self.points >= 3 then
		self.xCurve = love.math.newBezierCurve(xPoints)
		self.xCurveDerivative = self.xCurve:getDerivative()

		self.yCurve = love.math.newBezierCurve(yPoints)
		self.yCurveDerivative = self.yCurve:getDerivative()

		self.zCurve = love.math.newBezierCurve(zPoints)
		self.zCurveDerivative = self.zCurve:getDerivative()
	end
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

function MapCurve:render(depth, result)
	result = result or {}

	local x, y, z = self.xCurve:render(depth), self.yCurve:render(depth), self.zCurve:render(depth)
	for i = 1, #x, 2 do
		local p = result[i] or Vector()

		p.x = x[i] or 0
		p.y = y[i] or 0
		p.z = z[i] or 0

		result[i] = p
	end

	return result, #x
end

function MapCurve:transform(point)
	local planarPoint = Vector(point.x, 0, point.z)
	local relativePoint = (planarPoint - self.min) / (self.max - self.min)
	local t = math.min(relativePoint:get())
	if t < 0 or t > 1 then
		return point
	end

	local t1 = t
	local t2 = math.clamp(t1 + 0.01)

	local tangent1 = Vector(self.xCurveDerivative:evaluate(t1), self.yCurveDerivative:evaluate(t1), self.zCurveDerivative:evaluate(t1)):getNormal()
	local tangent2 = Vector(self.xCurveDerivative:evaluate(t2), self.yCurveDerivative:evaluate(t2), self.zCurveDerivative:evaluate(t2)):getNormal()
	local axis = tangent2:cross(tangent1)
	local d = tangent1:dot(self.axis)
	local angle = math.acos(d)
	local rotation = Quaternion.fromAxisAngle(-axis, angle)
	return rotation:transformVector(point)
end

function MapCurve.transformAll(point, curve, ...)
	if curve then
		point = curve:transform(point)
		return MapCurve.transformAll(point, ...)
	end

	return point
end

return MapCurve
