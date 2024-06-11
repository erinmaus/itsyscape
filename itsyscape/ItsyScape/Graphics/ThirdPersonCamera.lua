--------------------------------------------------------------------------------
-- ItsyScape/Graphics/ThirdPersonCamera.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Quaternion = require "ItsyScape.Common.Math.Quaternion"
local Vector = require "ItsyScape.Common.Math.Vector"
local Camera = require "ItsyScape.Graphics.Camera"

local ThirdPersonCamera = Class(Camera)

function ThirdPersonCamera:new()
	Camera.new(self)

	self.width = 1
	self.height = 1
	self.fieldOfView = math.rad(30)
	self.near = 0.1
	self.far = 128
	self.verticalRotation = 0
	self.horizontalRotation = 0
	self.distance = 1
	self.up = Vector(0, 1, 0)
	self.position = Vector(0, 0, 0)
	self.rotation = Quaternion.IDENTITY
	self.scale = Vector.ONE

	self.hasReflection = false
	self.reflectionPoint = Vector.ZERO
	self.reflectionNormal = Vector.ZERO

	self.hasClip = false
	self.clipPoint = Vector.ZERO
	self.clipNormal = Vector.ZERO
	
	self.boundingSpherePosition = Vector(0)
	self.boundingSphereRadius = math.huge
end

function ThirdPersonCamera:setBoundingSphere(position, radius)
	self.boundingSpherePosition = position
	self.boundingSphereRadius = radius
end

function ThirdPersonCamera:unsetBoundingSphere()
	self.boundingSpherePosition = Vector(0)
	self.boundingSphereRadius = math.huge
end

function ThirdPersonCamera:getBoundingSphere()
	return self.boundingSpherePosition, self.boundingSphereRadius
end

function ThirdPersonCamera:setMirrorPlane(normal, position)
	self.hasReflection = true
	self.reflectionPoint = position
	self.reflectionNormal = normal
end

function ThirdPersonCamera:unsetMirrorPlane()
	self.hasReflection = false
	self.reflectionPoint = Vector.ZERO
	self.reflectionNormal = Vector.ZERO
end

function ThirdPersonCamera:getMirrorPlane()
	return self.hasReflection, self.reflectionNormal, self.reflectionPoint
end

function ThirdPersonCamera:setClipPlane(normal, position)
	self.hasClip = true
	self.clipPoint = position
	self.clipNormal = normal
end

function ThirdPersonCamera:unsetClipPlane()
	self.hasClip = false
	self.clipPoint = Vector.ZERO
	self.clipNormal = Vector.ZERO
end

function ThirdPersonCamera:getClipPlane()
	return self.hasClip, self.clipNormal, self.clipPoint
end

function ThirdPersonCamera:_getMirrorMatrix()
	local transform = love.math.newTransform()

	if not self.hasReflection then
		return transform
	end

	local planeNormal = self.reflectionNormal:getNormal()
	local planeD = -planeNormal:dot(self.reflectionPoint)

	transform:setMatrix(
		"column",
		-2 * planeNormal.x * planeNormal.x + 1, -2 * planeNormal.y * planeNormal.x,     -2 * planeNormal.z * planeNormal.x,        0,
		-2 * planeNormal.x * planeNormal.y,     -2 * planeNormal.y * planeNormal.y + 1, -2 * planeNormal.z * planeNormal.y,        0,
		-2 * planeNormal.x * planeNormal.z,     -2 * planeNormal.y * planeNormal.z,     -2 * planeNormal.z * planeNormal.z + 1,    0,
		-2 * planeNormal.x * planeD,            -2 * planeNormal.y * planeD,            -2 * planeNormal.z * planeD,               1)

	return transform
end

function ThirdPersonCamera:project(point)
	local projection, view = self:getTransforms()
	local projectionView = projection * view
	local x, y, z = projectionView:transformPoint(point:get())
	x = (x + 1) / 2 * self.width
	y = (y + 1) / 2 * self.height

	return Vector(x, y, z)
end

function ThirdPersonCamera:getTransforms(projection, view)
	projection = projection or love.math.newTransform()
	do
		projection:reset()

		local halfTan = math.tan(self.fieldOfView / 2)
		local aspect = self.width / self.height

		local m = { projection:getMatrix() }
		m[1] = 1 / (halfTan * aspect)
		m[6] = 1 / halfTan
		m[11] = (self.far + self.near) / (self.far - self.near)
		m[12] = 1
		m[15] = -(2 * self.far * self.near) / (self.far - self.near)
		m[16] = 0

		projection:setMatrix("column", unpack(m))
	end

	view = view or love.math.newTransform()
	do
		view:reset()

		local mirrorMatrix = self:_getMirrorMatrix()
		local rotation = self:getCombinedRotation()

		view:scale(self.scale:get())
		view:translate(0, 0, self.distance)
		view:applyQuaternion(rotation:get())
		view:translate((-self.position):get())
		view:apply(mirrorMatrix)
	end

	return projection, view
end

function ThirdPersonCamera:getWidth()
	return self.width
end

function ThirdPersonCamera:setWidth(value)
	self.width = value or self.width
end

function ThirdPersonCamera:getHeight()
	return self.height
end

function ThirdPersonCamera:setHeight(value)
	self.height = value or self.height
end

function ThirdPersonCamera:getFieldOfView()
	return self.fieldOfView
end

function ThirdPersonCamera:setFieldOfView(value)
	self.fieldOfView = value or self.fieldOfView
end

function ThirdPersonCamera:getVerticalRotation()
	return self.verticalRotation
end

function ThirdPersonCamera:setHorizontalRotation(value)
	self.horizontalRotation = value or self.horizontalRotation
end

function ThirdPersonCamera:getHorizontalRotation()
	return self.horizontalRotation
end

function ThirdPersonCamera:getRotation()
	return self.rotation
end

function ThirdPersonCamera:getCombinedRotation()
	local y = Quaternion.fromAxisAngle(self.up, self.verticalRotation + math.pi / 2):getNormal()
	local x = Quaternion.fromAxisAngle(Vector.UNIT_X, -self.horizontalRotation + math.pi):getNormal()
	local lookAt = (x * y):getNormal()

	return (lookAt * self.rotation):getNormal()
end

function ThirdPersonCamera:setRotation(value)
	self.rotation = value or Quaternion.IDENTITY
end

function ThirdPersonCamera:setScale(value)
	self.scale = value or Vector.ONE
end

function ThirdPersonCamera:getScale()
	return self.scale
end

function ThirdPersonCamera:setVerticalRotation(value)
	self.verticalRotation = value or self.verticalRotation
end

function ThirdPersonCamera:getNear()
	return self.near
end

function ThirdPersonCamera:setNear(value)
	self.near = value or self.near
end

function ThirdPersonCamera:getFar()
	return self.far
end

function ThirdPersonCamera:setFar(value)
	self.far = value or self.far
end

function ThirdPersonCamera:getDistance()
	return self.distance
end

function ThirdPersonCamera:setDistance(value)
	self.distance = value or self.distance
end

function ThirdPersonCamera:setUp(value)
	if value then
		self.up = value:getNormal()
	end
end

function ThirdPersonCamera:getUp()
	return self.up
end

function ThirdPersonCamera:getForward()
	local rotation = self:getCombinedRotation()
	return rotation:transformVector(Vector.UNIT_Z):getNormal()
end

function ThirdPersonCamera:getStrafeForward()
	local result = Vector()
	local phi = self.horizontalRotation
	local theta = self.verticalRotation

	result.x = math.cos(phi) * math.cos(theta)
	result.y = 0
	result.z = math.cos(phi) * math.sin(theta)
	result = self.rotation:transformVector(result)

	return result:getNormal()
end

function ThirdPersonCamera:getLeft()
	return self.up:cross(self:getForward()):getNormal()
end

function ThirdPersonCamera:getStrafeLeft()
	return self.up:cross(self:getStrafeForward()):getNormal()
end

function ThirdPersonCamera:getPosition()
	return self.position
end

function ThirdPersonCamera:setPosition(value)
	self.position = value or self.position
end

function ThirdPersonCamera:getEye()
	return -self.distance * self:getForward() + self.position
end

function ThirdPersonCamera:apply()
	local projection, view = self:getTransforms()

	love.graphics.projection(projection)
	love.graphics.replaceTransform(view)
end

function ThirdPersonCamera:mirror(parentCamera, rootPosition, rootRotation, mirrorNormal)
	local eyeNormal = parentCamera:getForward()
	local transformedMirrorNormal = rootRotation:getNormal():transformVector(mirrorNormal):getNormal()
	local clipPlaneNormal = rootRotation:getNormal():transformVector(-mirrorNormal):getNormal()
	local reflectionNormal = eyeNormal:reflect(transformedMirrorNormal):getNormal()

	self:setPosition(rootPosition)
	self:setFieldOfView(parentCamera:getFieldOfView())
	self:setNear(parentCamera:getNear())
	self:setFar(parentCamera:getFar())
	self:setVerticalRotation(parentCamera:getVerticalRotation())
	self:setHorizontalRotation(parentCamera:getHorizontalRotation())
	self:setRotation(parentCamera:getRotation())
	self:setScale(parentCamera:getScale())
	self:setMirrorPlane(transformedMirrorNormal, rootPosition)
	self:setClipPlane(clipPlaneNormal, rootPosition + clipPlaneNormal)
end

return ThirdPersonCamera
