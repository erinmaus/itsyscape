--------------------------------------------------------------------------------
-- ItsyScape/Editor/Map/Gizmo.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Callback = require "ItsyScape.Common.Callback"
local Class = require "ItsyScape.Common.Class"
local Quaternion = require "ItsyScape.Common.Math.Quaternion"
local Vector = require "ItsyScape.Common.Math.Vector"
local Color = require "ItsyScape.Graphics.Color"

local Gizmo = Class()

Gizmo.DEFAULT_HOVER_DISTANCE = 16
Gizmo.SNAP_DISTANCE  = 64

Gizmo.OPERATION_TRANSLATION = "translation"
Gizmo.OPERATION_ROTATION    = "rotation"
Gizmo.OPERATION_SCALE       = "scale"
Gizmo.OPERATION_BOUNDS      = "bounds"

Gizmo.Operation = Class()
Gizmo.Operation.MODE_NONE   = "none"
Gizmo.Operation.MODE_HOVER  = "hover"
Gizmo.Operation.MODE_ACTIVE = "active"

function Gizmo.Operation:new()
	self.lines = {}
	self.linesConnected = true
	self.shape = {}
	self.shapeStart = Vector.ZERO
	self.shapeRotate = false
	self.color = Color(1)
end

function Gizmo.Operation:setColor(color)
	self.color = color
end

function Gizmo.Operation:move(currentX, currentY, previousX, previousY, camera, sceneNode, snap)
	return false
end

function Gizmo.Operation:distance(x, y, camera, sceneNode)
	local p = Vector(x, y, 0)
	local l = self:_getTransformedLines(self.lines, camera, sceneNode)

	local minDistance = math.huge

	local step = -2
	if self.linesConnected then
		step = 2
	end

	for i = 1, #l + step, 2 do
		local x1, y1 = l[i], l[i + 1]
		local x2, y2 = l[(i + 2 - 1) % #l + 1], l[(i + 3 - 1) % #l + 1]
		local v1 = Vector(x1, y1, 0)
		local v2 = Vector(x2, y2, 0)

		local lengthSquared = (v2 - v1):getLengthSquared()
		if lengthSquared == 0 then
			minDistance = math.min(minDistance, (v1 - p):getLengthSquared())
		else
			local t = math.clamp((p - v1):dot(v2 - v1) / lengthSquared)
			local projection = v1 + t * (v2 - v1)
			minDistance = math.min(minDistance, (p - projection):getLengthSquared())
		end
	end


	if minDistance == math.huge then
		return minDistance
	end

	return math.sqrt(minDistance)
end

function Gizmo.Operation:setLines(connected, lines)
	self.linesConnected = connected
	self.lines = lines
end

function Gizmo.Operation:setShape(start, rotate, shape)
	self.shapeRotate = rotate
	self.shapeStart = start
	self.shape = shape
end

function Gizmo.Operation:_getTransformedLines(lines, camera, sceneNode)
	local world = sceneNode:getTransform():getGlobalTransform()
	local offset = sceneNode:getTransform():getLocalOffset()
	local center = Vector(world:transformPoint(offset:get()))

	local l = {}
	do
		for _, point in ipairs(lines) do
			local x, y = camera:project(point + center):get()

			table.insert(l, x)
			table.insert(l, y)
		end
	end

	return l
end

function Gizmo.Operation:_getTransformedShape(shape, camera, sceneNode)
	local world = sceneNode:getTransform():getGlobalTransform()
	local offset = sceneNode:getTransform():getLocalOffset()
	local center = Vector(world:transformPoint(offset:get()))

	local rotation = Quaternion.IDENTITY
	if self.shapeRotate then
		local p1 = camera:project(center)
		p1 = Vector(p1.x, p1.y, 0)

		local p2 = camera:project(center + self.shapeStart)
		p2 = Vector(p2.x, p2.y, 0)

		local difference = p2 - p1
		local angle = math.atan2(difference.y, difference.x)
		rotation = Quaternion.fromAxisAngle(Vector.UNIT_Z, angle)
	end

	local l = {}
	do
		for _, point in ipairs(shape) do
			local x, y = camera:project(center + self.shapeStart):get()
			point = rotation:transformVector(point)

			table.insert(l, x + point.x)
			table.insert(l, y + point.y)
		end
	end

	return l
end

function Gizmo.Operation:draw(camera, sceneNode, mode)
	local l = self:_getTransformedLines(self.lines, camera, sceneNode)
	local s = self:_getTransformedShape(self.shape, camera, sceneNode)

	local color, lineWidth
	do
		if mode == self.MODE_NONE then
			color = self.color
			lineWidth = 2
		elseif mode == self.MODE_HOVER then
			local h, s, l = self.color:toHSL()
			color = Color.fromHSL(h, s, l + 0.25)
			lineWidth = 4
		elseif mode == self.MODE_ACTIVE then
			local h, s, l = self.color:toHSL()
			color = Color.fromHSL(h, s, l - 0.1)
			lineWidth = 4
		end
	end

	love.graphics.push("all")
	love.graphics.setLineWidth(lineWidth or 2)
	love.graphics.setLineJoin("bevel")
	love.graphics.setColor((color or self.color):get())

	if #l >= 2 then
		if self.linesConnected then
			love.graphics.line(l)
		else
			for i = 1, #l, 4 do
				love.graphics.line(l[i], l[i + 1], l[i + 2], l[i + 3])
			end
		end
	end

	if #s >= 3 then
		love.graphics.polygon("fill", s)
	end

	love.graphics.pop()
end

Gizmo.BoundingBoxOperation = Class(Gizmo.Operation)

function Gizmo.BoundingBoxOperation:new()
	Gizmo.Operation.new(self)

	self:setColor(Color(0.5))
end

function Gizmo.BoundingBoxOperation:update(sceneNode, size)
	self:buildMesh(sceneNode, size)
end

function Gizmo.BoundingBoxOperation:buildMesh(sceneNode, size)
	local world = sceneNode:getTransform():getGlobalTransform()
	local center = Vector(world:transformPoint(0, 0, 0))

	local halfSize = size / 2
	local min = Vector(-halfSize.x, 0, -halfSize.z) 
	local max = Vector(halfSize.x, size.y, halfSize.z)
	local lines = {
		-- Top
		Vector(min.x, max.y, min.z), Vector(max.x, max.y, min.z),
		Vector(max.x, max.y, min.z), Vector(max.x, max.y, max.z),
		Vector(max.x, max.y, max.z), Vector(min.x, max.y, max.z),
		Vector(min.x, max.y, max.z), Vector(min.x, max.y, min.z),

		-- Bottom
		Vector(min.x, min.y, min.z), Vector(max.x, min.y, min.z),
		Vector(max.x, min.y, min.z), Vector(max.x, min.y, max.z),
		Vector(max.x, min.y, max.z), Vector(min.x, min.y, max.z),
		Vector(min.x, min.y, max.z), Vector(min.x, min.y, min.z),

		-- Sides
		Vector(min.x, max.y, min.z), Vector(min.x, min.y, min.z),
		Vector(max.x, max.y, min.z), Vector(max.x, min.y, min.z),
		Vector(max.x, max.y, max.z), Vector(max.x, min.y, max.z),
		Vector(min.x, max.y, max.z), Vector(min.x, min.y, max.z),
 	}

 	self:setLines(false, lines)
end

Gizmo.TranslationAxisOperation = Class(Gizmo.Operation)
Gizmo.TranslationAxisOperation.LENGTH = 2
Gizmo.TranslationAxisOperation.SHAPE_SIZE = 16
Gizmo.TranslationAxisOperation.MOVE_DISTANCE = 32
Gizmo.TranslationAxisOperation.SNAP_DISTANCE = 0.25

function Gizmo.TranslationAxisOperation:new(axis, x, y, z)
	Gizmo.Operation.new(self)

	self.axis = axis
	self.xAxis = x or Vector.UNIT_X
	self.yAxis = y or Vector.UNIT_Z

	self:setColor(Color((self.axis:abs() * (3 / 4)):get()))
end

function Gizmo.TranslationAxisOperation:update(sceneNode, size)
	self:buildMesh(sceneNode, size)
end

function Gizmo.TranslationAxisOperation:move(currentX, currentY, previousX, previousY, camera, sceneNode, snap)
	local distance, axis
	do
		local world = sceneNode:getTransform():getGlobalTransform()
		local center = Vector(world:transformPoint(sceneNode:getTransform():getLocalOffset():get()))
		local v1 = camera:project(center)
		local v2 = camera:project(center + self.axis * self.LENGTH)
		local axisDirection = (v2 - v1):getNormal()

		local currentPoint = Vector(currentX, currentY, 0)
		local previousPoint = Vector(previousX, previousY, 0)
		local movementDirection = (currentPoint - previousPoint):getNormal()

		distance = (currentPoint - previousPoint):getLength() * math.sign(-movementDirection:dot(axisDirection)) / self.MOVE_DISTANCE

		if self.axis:getLengthSquared() > 1 then
			axis = -(self.xAxis * Vector(movementDirection.x) + self.yAxis * Vector(movementDirection.y))
			distance = math.abs(distance)
		else
			axis = self.axis
		end
	end

	if snap then
		distance = math.sign(distance) * math.floor(math.abs(distance) / self.SNAP_DISTANCE) * self.SNAP_DISTANCE
	end

	if snap and math.abs(distance) == 0 then
		return false
	elseif snap then
		distance = -distance
	end

	local transform = sceneNode:getTransform()
	local offset = axis * distance
	local translation
	if snap then
		translation = (transform:getLocalTranslation() * axis / Vector(self.SNAP_DISTANCE)):floor() * Vector(self.SNAP_DISTANCE) + offset
	else
		translation = transform:getLocalTranslation() * axis + offset
	end
	local invertAxis = Vector.ONE - axis

	transform:setLocalTranslation(invertAxis * transform:getLocalTranslation() + translation)

	return true
end

function Gizmo.TranslationAxisOperation:buildMesh(sceneNode, size)
	local endPoint = (self.axis:getNormal()) * self.LENGTH

	self:setLines(false, {
		Vector(0),
		endPoint
	})

	self:setShape(
		endPoint,
		true,
		{
			Vector(-0.5, -0.5, 0) * self.SHAPE_SIZE,
			Vector(1, 0, 0) * self.SHAPE_SIZE,
			Vector(-0.5, 0.5, 0) * self.SHAPE_SIZE
		})
end

Gizmo.RotationAxisOperation = Class(Gizmo.Operation)
Gizmo.RotationAxisOperation.SEGMENTS = 32
Gizmo.RotationAxisOperation.STEP_ANGLE = math.rad(45)
Gizmo.RotationAxisOperation.MOVE_DISTANCE = 64

function Gizmo.RotationAxisOperation:new(axis)
	Gizmo.Operation.new(self)

	self.axis = axis
	self:setColor(Color((self.axis:abs() * (3 / 4)):get()))
end

function Gizmo.RotationAxisOperation:update(sceneNode, size)
	self:buildMesh(sceneNode, size)
end

function Gizmo.RotationAxisOperation:move(currentX, currentY, previousX, previousY, camera, sceneNode, snap)
	local angle
	do
		local world = sceneNode:getTransform():getGlobalTransform()
		local center = Vector(world:transformPoint(sceneNode:getTransform():getLocalOffset():get()))
		local centerX, centerY = camera:project(center):get()
		local differenceCurrentX, differenceCurrentY = centerX - currentX, centerY - currentY
		local differencePreviousX, differencePreviousY = centerX - previousX, centerY - previousY
		local currentAngle = math.atan2(differenceCurrentY, differenceCurrentX)
		local previousAngle = math.atan2(differencePreviousY, differencePreviousX)

		if snap then
			angle = currentAngle - previousAngle
		else
			angle = previousAngle - currentAngle
		end
	end

	if snap then
		angle = math.sign(angle) * math.floor(math.abs(angle) / self.STEP_ANGLE) * self.STEP_ANGLE
	end

	if snap and math.abs(angle) == 0 then
		return false
	else
		angle = -angle
	end

	local transform = sceneNode:getTransform()
	local currentRotation
	if snap then
		local currentXYZ = Vector(transform:getLocalRotation():getNormal():getEulerXYZ())
		local invertAxis = Vector.ONE - self.axis
		local snappedXYZ = (currentXYZ * self.axis / self.STEP_ANGLE):floor() * self.STEP_ANGLE
		currentRotation = Quaternion.fromEulerXYZ((invertAxis * currentXYZ + snappedXYZ):get())
	else
		currentRotation = transform:getLocalRotation()
	end

	local axis = (-currentRotation):getNormal():transformVector(self.axis)
	local rotation = Quaternion.fromAxisAngle(axis, angle)
	transform:setLocalRotation((currentRotation * rotation):getNormal())

	return true
end

function Gizmo.RotationAxisOperation:buildMesh(sceneNode, size)
	local rotation = sceneNode:getTransform():getLocalRotation()

	if not size then
		local min, max = sceneNode:getBounds()
		local size = max - min
	else
		size = size:min(Vector(5, 5, 5))
	end
	size = size * 2
	size = math.max(size:get())
	size = size + Vector(0, 1, 2)

	local v
	if self.axis == Vector.UNIT_X then
		v = Vector.UNIT_Y
	else
		v = Vector.UNIT_X
	end

	local lines = {}
	for i = 1, self.SEGMENTS do
		local delta = (i - 1) / (self.SEGMENTS - 1)
		local angle = math.pi * 2 * delta

		local pointRotation = Quaternion.fromAxisAngle(self.axis, angle)
		local point = pointRotation:transformVector(size * v)

		table.insert(lines, point)
	end

	self:setLines(true, lines)
end

Gizmo.ScaleAxisOperation = Class(Gizmo.Operation)
Gizmo.ScaleAxisOperation.LENGTH = 2
Gizmo.ScaleAxisOperation.SHAPE_SIZE = 16
Gizmo.ScaleAxisOperation.MOVE_DISTANCE = 32
Gizmo.ScaleAxisOperation.SNAP_DISTANCE = 0.25

function Gizmo.ScaleAxisOperation:new(axis)
	Gizmo.Operation.new(self)

	self.axis = axis
	self:setColor(Color((self.axis:abs() * (3 / 4)):get()))
end

function Gizmo.ScaleAxisOperation:update(sceneNode, size)
	self:buildMesh(sceneNode, size)
end

function Gizmo.ScaleAxisOperation:move(currentX, currentY, previousX, previousY, camera, sceneNode, snap)
	local distance
	do
		local world = sceneNode:getTransform():getGlobalTransform()
		local center = Vector(world:transformPoint(sceneNode:getTransform():getLocalOffset():get()))
		local v1 = camera:project(center)
		local v2 = camera:project(center + self.axis * self.LENGTH)
		local axisDirection = (v2 - v1):getNormal()

		local currentPoint = Vector(currentX, currentY, 0)
		local previousPoint = Vector(previousX, previousY, 0)
		local movementDirection = (currentPoint - previousPoint):getNormal()

		distance = (currentPoint - previousPoint):getLength() * math.sign(-movementDirection:dot(axisDirection)) / self.MOVE_DISTANCE
	end

	if snap then
		distance = math.sign(distance) * math.floor(math.abs(distance) / self.SNAP_DISTANCE) * self.SNAP_DISTANCE
	end

	if snap and math.abs(distance) == 0 then
		return false
	elseif snap then
		distance = -distance
	end

	local transform = sceneNode:getTransform()
	local offset = axis * distance
	local scale
	if snap then
		scale = (transform:getLocalTranslation() * axis / Vector(self.SNAP_DISTANCE)):floor() * Vector(self.SNAP_DISTANCE) + offset
	else
		scale = transform:getLocalTranslation() * axis + offset
	end
	local invertAxis = Vector.ONE - axis
	transform:setLocalScale(sceneNode:getTransform():getLocalScale() + scale)

	return true
end

function Gizmo.ScaleAxisOperation:buildMesh(sceneNode, size)
	local endPoint = (self.axis:getNormal()) * self.LENGTH

	self:setLines(false, {
		Vector(0),
		endPoint
	})

	self:setShape(
		endPoint,
		false,
		{
			Vector(-0.5, -0.5, 0) * self.SHAPE_SIZE,
			Vector(-0.5, 0.5, 0) * self.SHAPE_SIZE,
			Vector(0.5, 0.5, 0) * self.SHAPE_SIZE,
			Vector(0.5, -0.5, 0) * self.SHAPE_SIZE,
		})
end

function Gizmo:new(target, ...)
	self.target = target
	self.operations = { ... }
	self.operationModes = {}
	self.isMultiAxis = false
	self.hoverDistance = self.DEFAULT_HOVER_DISTANCE
end

function Gizmo:setTarget(value)
	self.target = value or self.target
end

function Gizmo:getTarget()
	return self.target
end

function Gizmo:getIsActive()
	for _, mode in ipairs(self.operationModes) do
		if mode ~= Gizmo.Operation.MODE_NONE then
			return true
		end
	end

	return false
end

function Gizmo:setIsMultiAxis(value)
	self.isMultiAxis = value or false
end

function Gizmo:getIsMultiAxis(value)
	return self.isMultiAxis
end

function Gizmo:setHoverDistance(value)
	self.hoverDistance = value or self.DEFAULT_HOVER_DISTANCE
end

function Gizmo:getHoverDistance(value)
	return self.hoverDistance
end

function Gizmo:hover(x, y, camera, sceneNode)
	local isGrabbed = false

	if self.isMultiAxis then
		for index, operation in ipairs(self.operations) do
			local distance = operation:distance(x, y, camera, sceneNode)
			if distance < self.hoverDistance then
				self.operationModes[index] = love.mouse.isDown(1) and Gizmo.Operation.MODE_ACTIVE or Gizmo.Operation.MODE_HOVER
				isGrabbed = true
			else
				self.operationModes[index] = Gizmo.Operation.MODE_NONE
			end
		end
	else
		local minDistance = math.huge
		local operationIndex
		for index, operation in ipairs(self.operations) do
			local distance = operation:distance(x, y, camera, sceneNode)
			if distance < minDistance and distance < self.hoverDistance then
				distance = minDistance
				operationIndex = index
			end

			self.operationModes[index] = Gizmo.Operation.MODE_NONE
		end

		if operationIndex then
			self.operationModes[operationIndex] = love.mouse.isDown(1) and Gizmo.Operation.MODE_ACTIVE or Gizmo.Operation.MODE_HOVER
			isGrabbed = true
		end
	end

	return isGrabbed
end

function Gizmo:move(currentX, currentY, previousX, previousY, camera, sceneNode, snap)
	local success = true

	for index, operation in ipairs(self.operations) do
		local isActive = self.operationModes[index] == Gizmo.Operation.MODE_ACTIVE
		if isActive then
			success = success and operation:move(currentX, currentY, previousX, previousY, camera, sceneNode, snap)
		end
	end

	return success
end

function Gizmo:update(sceneNode, size)
	for _, operation in ipairs(self.operations) do
		operation:update(sceneNode, size)
	end
end

function Gizmo:draw(camera, sceneNode)
	for index, operation in ipairs(self.operations) do
		operation:draw(camera, sceneNode, self.operationModes[index])
	end
end

return Gizmo
