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

MapCurve.Value = Class()

function MapCurve.Value:new(Type, ...)
	self.type = Type
	self.value = Type(...)
	self.index = false
end

function MapCurve.Value:setIndex(value)
	self.index = value or false
end

function MapCurve.Value:getIndex()
	return self.index
end

function MapCurve.Value:getValue()
	return self.value
end

function MapCurve.Value:evaluate(currentValue, nextValue, t)
	return Class.ABSTRACT()
end

function MapCurve.Value:derive(otherValue, degree)
	return Class.ABSTRACT()
end

function MapCurve.Value:split(previousValue, nextValue, t)
	return Class.ABSTRACT()
end

function MapCurve.Value:get()
	return self.value:get()
end

MapCurve.Position = Class(MapCurve.Value)

function MapCurve.Position:new(...)
	MapCurve.Value.new(self, Vector, ...)
end

function MapCurve.Position:evaluate(currentValue, nextValue, t)
	return currentValue:lerp(nextValue, t)
end

function MapCurve.Position:split(previousValue, nextValue, t)
	local a, b
	if nextValue then
		a = self:getValue()
		b = nextValue:getValue()
	elseif previousValue then
		a = self:getValue()
		b = previousValue:getValue()
		t = -t
	else
		a = self:getValue()
		b = self:getValue()
	end


	local difference = b - a
	local distance = difference:getLength()

	local normal
	if distance > 0 then
		normal = difference / distance
	else
		normal = Vector.UNIT_Y
		distance = 4
	end

	distance = distance * t
	local value = a + normal * distance

	return MapCurve.Position(value:get())
end

function MapCurve.Position:derive(nextValue, degree)
	local value = (nextValue - self:getValue()) * degree
	return MapCurve.Position(value:get())
end

MapCurve.Scale = Class(MapCurve.Value)

function MapCurve.Scale:new(...)
	MapCurve.Value.new(self, Vector, ...)
end

function MapCurve.Scale:evaluate(currentValue, nextValue, t)
	return currentValue:lerp(nextValue, t)
end

function MapCurve.Scale:split(previousValue, nextValue, t)
	local a, b
	if nextValue then
		a = self:getValue()
		b = nextValue:getValue()
	elseif previousValue then
		a = self:getValue()
		b = previousValue:getValue()
		t = -t
	else
		a = self:getValue()
		b = self:getValue()
	end


	local difference = b - a
	local distance = difference:getLength()

	local normal
	if distance > 0 then
		normal = difference / distance
	else
		return MapCurve.Scale(self:getValue():get())
	end

	distance = distance * t
	local value = a + normal * distance

	return MapCurve.Scale(value:get())
end

function MapCurve.Scale:derive(nextValue, degree)
	local value = (nextValue - self:getValue()) * degree
	return MapCurve.Scale(value:get())
end

MapCurve.Rotation = Class(MapCurve.Value)

function MapCurve.Rotation:new(...)
	MapCurve.Value.new(self, Quaternion, Quaternion(...):get())
end

function MapCurve.Rotation:evaluate(currentValue, nextValue, t)
	return currentValue:getNormal():slerp(nextValue:getNormal(), t):getNormal()
end

-- This might not work as expected...?
-- Why would you do this anyway...
function MapCurve.Rotation:derive(nextValue, degree)
	local inverseValue = self:getValue():inverse() * nextValue * Quaternion(t, t, t, t)

	return MapCurve.Rotation(inverseValue:getNormal():get())
end

function MapCurve.Rotation:split(previousValue, nextValue, t)
	local a, b
	if nextValue then
		a = self:getValue()
		b = nextValue:getValue()
	elseif previousValue then
		a = previousValue:getValue()
		b = self:getValue()
	else
		a = self:getValue()
		b = self:getValue()
	end

	return MapCurve.Rotation(a:slerp(b, t):getNormal():get())
end

MapCurve.Normal = Class(MapCurve.Value)

function MapCurve.Normal:new(...)
	MapCurve.Value.new(self, Vector, Vector(...):getNormal():get())
end

function MapCurve.Normal:evaluate(currentValue, nextValue, t)
	return currentValue:getNormal():lerp(nextValue:getNormal(), t):getNormal()
end

function MapCurve.Normal:derive(nextValue, degree)
	local value = (nextValue - self:getValue()) * degree
	return MapCurve.Position(value:getNormal():get())
end

function MapCurve.Normal:split(previousValue, nextValue, t)
	local a, b
	if nextValue then
		a = self:getValue()
		b = nextValue:getValue():getNormal()
	elseif previousValue then
		a = previousValue:getValue():getNormal()
		b = self:getValue()
	else
		a = self:getValue()
		b = self:getValue()
	end

	return MapCurve.Normal(a:lerp(b, t):get())
end

MapCurve.Curve = Class()

function MapCurve.Curve:new(Type, values, getFunc)
	getFunc = getFunc or unpack

	self.type = Type

	self.values = {}
	for i, value in ipairs(values) do
		local v = Type(getFunc(value))
		v:setIndex(i)

		table.insert(self.values, v)
	end

	self.derivative = {}
	self.isDirty = true

	self.renderCurves = {}
end

function MapCurve.Curve:toConfig()
	local result = {}
	for _, value in ipairs(self.values) do
		table.insert(result, { value:getValue():get() })
	end

	return result
end

function MapCurve.Curve:getDegree()
	return #self.values
end

function MapCurve.Curve:split(index)
	local newIndex = index + 1

	if #self.values == 0 then
		table.insert(self.values, self.type():split(nil, nil, 0.5))
		newIndex = 1
	elseif index == #self.values then
		table.insert(self.values, self.values[#self.values]:split(self.values[index - 1], nil, 0.5))
	elseif index >= 1 then
		table.insert(self.values, newIndex, self.values[index]:split(nil, self.values[index + 1], 0.5))
	end

	for i, value in ipairs(self.values) do
		value:setIndex(i)
	end

	self.isDirty = true
end

function MapCurve.Curve:length()
	return #self.values
end

function MapCurve.Curve:get(index)
	local value = self.values[index]
	return value or self.type()
end

function MapCurve.Curve:set(index, value)
	assert(value:getType() == self.type)

	if self.values[index] and self.values[index]:getValue() ~= value:getValue() then
		self.values[index] = self.type(value:get())
		self.values[index]:setIndex(index)
		self.isDirty = true
	end
end

function MapCurve.Curve:insert(index, value)
	assert(value:getType() == self.type)

	if index >= 1 and index <= #self.values + 1 then
		table.insert(self.values, index, self.type(value:get()))

		for i, value in ipairs(self.values) do
			value:setIndex(i)
		end

		self.isDirty = true
	end
end

function MapCurve.Curve:remove(index)
	if self.values[index] then
		table.remove(self.values, index)
		self.isDirty = true
	end

	for i, value in ipairs(self.values) do
		value:setIndex(i)
	end
end

function MapCurve.Curve:_evaluate(values, t)
	local curve = {}
	for index, value in ipairs(values) do
		curve[index] = value:getValue()
	end

	for i = 2, #curve do
		for j = 1, #curve - i + 1 do
			curve[j] = self.values[j]:evaluate(curve[j], curve[j + 1], t)
		end
	end

	return curve[1] or self.type():getValue()
end

function MapCurve.Curve:evaluate(t)
	return self:_evaluate(self.values, t)
end

function MapCurve.Curve:_updateDerivative()
	local degree = self:getDegree() - 1

	table.clear(self.derivative)
	for i = 1, degree do
		self.derivative[i] = self.values[i]:derive(self.values[i + 1]:getValue(), degree)
	end
end

function MapCurve.Curve:_updateRenderCurves()
	table.clear(self.renderCurves)

	local result = {}
	for _, value in ipairs(self.values) do
		local subValues = { value:get() }

		for i, subValue in ipairs(subValues) do
			local curve = result[i] or {}

			table.insert(curve, subValue)
			table.insert(curve, 0)

			result[i] = curve
		end
	end

	assert(#result >= 1, "no component sub-curves")

	local n = #result[1]
	assert(n ~= nil)

	for i, r in ipairs(result) do
		assert(#r == n, string.format("component %d number of points mismatch; all component sub-curves must have same number of points", i))
	end

	for i, r in ipairs(result) do
		local curve = love.math.newBezierCurve(r)
		self.renderCurves[i] = curve
	end
end

function MapCurve.Curve:_update()
	self:_updateDerivative()
	self:_updateRenderCurves()

	self.isDirty = false
end

function MapCurve.Curve:evaluateDerivative(t)
	if self.isDirty then
		self:_update()
	end

	return self:_evaluate(self.derivative, t)
end

function MapCurve.Curve:render(depth, result)
	result = result or {}
	table.clear(result)

	if self.isDirty then
		self:_update()
	end

	local components = {}
	for i, curve in ipairs(self.renderCurves) do
		components[i] = curve:render(depth)
	end

	local v = {}
	for i = 1, #components[1], 2 do
		table.clear(v)

		for _, component in ipairs(components) do
			table.insert(v, component[i])
		end

		table.insert(result, self.type(unpack(v)):getValue())
	end

	return result
end

function MapCurve:new(map, t)
	t = t or {}

	self.width = (map and map:getWidth()) or t.width or 0
	self.height = (map and map:getHeight()) or t.height or 0
	self.unit = (map and map:getCellSize()) or t.unit or 1
	self.mapSize = Vector(self.width * self.unit, 0, self.height * self.unit)
	self.halfMapSize = self.mapSize / 2

	local min = t.min or { 0, 0, 0 }
	local max = t.max or { self.mapSize.x, 0, self.mapSize.z }

	self.min = Vector(unpack(min))
	self.max = Vector(unpack(max))

	local axis = t.axis or { 0, 0, 1 }
	self.axis = Vector(unpack(axis))
	self.oppositeAxis = Vector.UNIT_Y:cross(self.axis):getNormal()

	self.positionCurve = MapCurve.Curve(MapCurve.Position, t.positions or {})
	self.rotationCurve = MapCurve.Curve(MapCurve.Rotation, t.rotations or {})
	self.normalCurve = MapCurve.Curve(MapCurve.Normal, t.normals or {})
	self.scaleCurve = MapCurve.Curve(MapCurve.Scale, t.scales or {})
end

function MapCurve:evaluateRotation(t)
	return self.rotationCurve:evaluate(t)
end

function MapCurve:evaluatePosition(t)
	return self.positionCurve:evaluate(t)
end

function MapCurve:evaluateDirection(t)
	return self.positionCurve:evaluateDerivative(t)
end

function MapCurve:evaluateNormal(t)
	return self.normalCurve:evaluate(t)
end

function MapCurve:evaluateScale(t)
	return self.scaleCurve:evaluate(t)
end

function MapCurve:setMin(value)
	self.min = value
end

function MapCurve:getMin()
	return self.min
end

function MapCurve:setMax(value)
	self.max = value
end

function MapCurve:getMax()
	return self.max
end

function MapCurve:setAxis(value)
	self.axis = value
	self.oppositeAxis = Vector.UNIT_Y:cross(self.axis):getNormal()
end

function MapCurve:getAxis()
	return self.axis
end

function MapCurve:getPositions()
	return self.positionCurve
end

function MapCurve:getRotations()
	return self.rotationCurve
end

function MapCurve:getNormals()
	return self.normalCurve
end

function MapCurve:getScales()
	return self.scaleCurve
end

function MapCurve:render(depth, result)
	return self.positionCurve:render(depth, result)
end

function MapCurve:transform(point, rotation)
	if self.positionCurve:length() <= 1 then
		return point
	end

	local planarPoint = Vector(point.x, 0, point.z)
	local relativePoint = (planarPoint - self.min) / (self.max - self.min):max(Vector.ONE) * self.axis
	local t = math.max(relativePoint:get())
	if t < 0 or t > 1 then
		return point
	end

	local curvePosition = self:evaluatePosition(t)
	local curveRotation = self:evaluateRotation(t):getNormal()
	local curveNormal = self:evaluateNormal(t):getNormal()
	local curveScale = self:evaluateScale(t)

	local oppositeAxis = self.oppositeAxis
	local up = Vector(point.y) * curveNormal
	local center = self.halfMapSize * oppositeAxis
	local p = oppositeAxis * point - center + up
	point = curveRotation:transformVector(p) * curveScale + curvePosition

	if rotation then
		local upRotation = Quaternion.lookAt(Vector.ZERO, curveNormal, Vector.UNIT_Y)
		rotation = upRotation * curveRotation * rotation
	end

	return point, rotation
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

	length = math.min(length * 8, 1024)

	local positions = {}
	local normals = {}
	local rotations = {}

	for i = 1, length do
		local t = (i - 1) / (length - 1)

		positions[i] = self:evaluatePosition(t)
		rotations[i] = self:evaluateRotation(t):getNormal()
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

function MapCurve.transformAll(point, rotation, curves)
	if not curves then
		return point, rotation
	end

	for _, curve in ipairs(curves) do
		point, rotation = curve:transform(point, rotation)
	end

	return point, rotation
end

function MapCurve:toConfig()
	return {
		width = self.width,
		height = self.height,
		unit = self.unit,
		min = { self.min:get() },
		max = { self.max:get() },
		axis = { self.axis:get() },
		positions = self.positionCurve:toConfig(),
		rotations = self.rotationCurve:toConfig(),
		normals = self.normalCurve:toConfig(),
		scales = self.scaleCurve:toConfig()
	}
end

return MapCurve
