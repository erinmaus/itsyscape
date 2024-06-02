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

Gizmo.Operation = Class()
Gizmo.Operation.MODE_NONE   = "none"
Gizmo.Operation.MODE_HOVER  = "hover"
Gizmo.Operation.MODE_ACTIVE = "active"

function Gizmo.Operation:new()
	self.lines = {}
	self.color = Color(1)
end

function Gizmo.Operation:setColor(color)
	self.color = color
end

function Gizmo.Operation:distance(x, y, camera, sceneNode)
	local p = Vector(x, y, 0)
	local l = self:_getTransformedLines(camera, sceneNode)

	local minDistance = math.huge
	for i = 1, #l + 2, 2 do
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

function Gizmo.Operation:setLines(lines)
	self.lines = lines
end

function Gizmo.Operation:_getTransformedLines(camera, sceneNode)
	local world = sceneNode:getTransform():getGlobalTransform()
	local center = Vector(world:transformPoint(0, 0, 0))

	local projectionView
	do
		local p, v = camera:getTransforms()
		projectionView = p * v
	end

	local w, h = love.window.getMode()

	local l = {}
	do
		for _, point in ipairs(self.lines) do
			local x, y, z = projectionView:transformPoint((point + center):get())
			x = (x + 1) / 2 * w
			y = (y + 1) / 2 * h

			table.insert(l, x)
			table.insert(l, y)
		end
	end

	return l
end

function Gizmo.Operation:draw(camera, sceneNode, mode)
	local l = self:_getTransformedLines(camera, sceneNode)

	local color
	do
		if mode == self.MODE_NONE then
			color = self.color
		elseif mode == self.MODE_HOVER then
			local h, s, l = self.color:toHSL()
			color = Color.fromHSL(h, s, l + 0.25)
		elseif mode == self.MODE_ACTIVE then
			local h, s, l = self.color:toHSL()
			color = Color.fromHSL(h, s, l - 0.25)
		end
	end

	love.graphics.push("all")
	love.graphics.setLineWidth(2)
	love.graphics.setLineJoin("bevel")
	love.graphics.setColor((color or self.color):get())
	love.graphics.line(l)
	love.graphics.pop()
end

Gizmo.RotationAxisOperation = Class(Gizmo.Operation)
Gizmo.RotationAxisOperation.SEGMENTS = 32

function Gizmo.RotationAxisOperation:new(axis)
	Gizmo.Operation.new(self)

	self.axis = axis

	self:setColor(Color((self.axis * (3 / 4)):get()))
end

function Gizmo.RotationAxisOperation:update(sceneNode, size)
	self:buildMesh(sceneNode, size)
end

function Gizmo.RotationAxisOperation:buildMesh(sceneNode, size)
	local rotation = sceneNode:getTransform():getLocalRotation()

	if not size then
		local min, max = sceneNode:getBounds()
		local size = max - min
	else
		size = size
	end
	size = size * 2
	size = math.max(size:get())
	size = size * Vector(1, 1.25, 1.5)

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

		local pointRotation = rotation * Quaternion.fromAxisAngle(self.axis, angle)
		local point = pointRotation:transformVector(size * v)

		table.insert(lines, point)
	end

	self:setLines(lines)
end

function Gizmo:new(...)
	self.operations = { ... }
	self.operationModes = {}
end

function Gizmo:hover(x, y, minDistance, camera, sceneNode)
	for index, operation in ipairs(self.operations) do
		local distance = operation:distance(x, y, camera, sceneNode)
		if distance < minDistance then
			self.operationModes[index] = love.mouse.isDown(1) and Gizmo.Operation.MODE_ACTIVE or Gizmo.Operation.MODE_HOVER
		else
			self.operationModes[index] = Gizmo.Operation.MODE_NONE
		end
	end
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
