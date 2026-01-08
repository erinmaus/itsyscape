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
local MathCommon = require "ItsyScape.Common.Math.Common"
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
	self.far = 250
	self.verticalRotation = 0
	self.horizontalRotation = 0
	self.distance = 1
	self.up = Vector(0, 1, 0):keep()
	self.position = Vector(0, 0, 0):keep()
	self.rotation = Quaternion():keep()
	self.scale = Vector(1):keep()

	self.isWallHackEnabled = true

	self.hasReflection = false
	self.reflectionPoint = Vector.ZERO
	self.reflectionNormal = Vector.ZERO

	self.hasClip = false
	self.clipPoint = Vector.ZERO
	self.clipNormal = Vector.ZERO
	
	self.boundingSpherePosition = Vector(0):keep()
	self.boundingSphereRadius = math.huge
end

function ThirdPersonCamera:setIsWallHackEnabled(value)
	self.isWallHackEnabled = value
end

function ThirdPersonCamera:getIsWallHackEnabled(value)
	return self.isWallHackEnabled
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

do
	local projection = love.math.newTransform()
	local view = love.math.newTransform()
	local projectionView = love.math.newTransform()

	function ThirdPersonCamera:project(point, result)
		projection, view = self:getTransforms(projection, view)
		projectionView:reset()
		projectionView:apply(projection)
		projectionView:apply(view)

		local x, y, z = point:transform(projectionView, result):get()
		x = (x + 1) / 2 * self.width
		y = (y + 1) / 2 * self.height

		result = result or Vector()
		result:from(x, y, z)

		return result
	end
end

do
	local result = Vector()
	function ThirdPersonCamera:compare(a, b)
		local za = self:project(a, result).z
		local zb = self:project(b, result).z

		return za < zb
	end
end

do
	local result = Vector()
	function ThirdPersonCamera:depth(point)
		return self:toLinearDepth(self:project(point, result).z)
	end
end

function ThirdPersonCamera:toLinearDepth(z)
	return 2.0 * self.near * self.far / (self.far + self.near - z * (self.far - self.near))
end

do
	local projection = love.math.newTransform()
	local view = love.math.newTransform()
	local projectionView = love.math.newTransform()

	function ThirdPersonCamera:unproject(point, result)
		projection, view = self:getTransforms(projection, view)
		projectionView:reset()
		projectionView:apply(projection)
		projectionView:apply(view)

		result = result or Vector()
		return point:inverseTransform(projectionView, result)
	end
end

do
	local translationBefore = love.math.newTransform()
	local rotation = love.math.newTransform()
	local translationAfter = love.math.newTransform()
	local combinedRotation = Quaternion()
	local distance = Vector()

	function ThirdPersonCamera:getTransforms(projection, view)
		projection = projection or love.math.newTransform()
		do
			projection:reset()

			local f = 1 / math.tan(self.fieldOfView / 2)
			local aspect = self.width / self.height

			local m11, m12, m13, m14,
			      m21, m22, m23, m24,
			      m31, m32, m33, m34,
			      m41, m42, m43, m44 = 0, 0, 0, 0,
			                           0, 0, 0, 0,
			                           0, 0, 0, 0,
			                           0, 0, 0, 0

			m11 = -(f / aspect)
			m22 = f
			m33 = (self.far + self.near) / (self.near - self.far)
			m34 = (2 * self.far * self.near) / (self.near - self.far)
			m43 = -1

			projection:setMatrix(
				m11, m12, m13, m14,
				m21, m22, m23, m24,
				m31, m32, m33, m34,
				m41, m42, m43, m44)
		end

		view = view or love.math.newTransform()
		do
			view:reset()

			MathCommon.makeTranslationTransform(self:getPosition(), translationBefore)
			MathCommon.makeRotationTransform(self:getCombinedRotation(combinedRotation), rotation)
			MathCommon.makeTranslationTransform(distance:from(0, 0, self.distance), translationAfter)

			view:apply(translationBefore)
			view:apply(rotation)
			view:apply(translationAfter)
			MathCommon.makeInverseTransform(view)
		end

		return projection, view
	end
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

do
	local x = Quaternion()
	local y = Quaternion()
	function ThirdPersonCamera:getLocalRotation(result)
		Quaternion.fromAxisAngle(Vector.UNIT_X, self.horizontalRotation + math.pi, x):getNormal(x)
		Quaternion.fromAxisAngle(self.up, -self.verticalRotation + math.pi / 2, y):getNormal(y)

		result = result or Quaternion()
		return x:product(y, result):normalize(result)
	end
end

do
	local x = Quaternion()
	local y = Quaternion()
	function ThirdPersonCamera:getCombinedRotation(result)
		Quaternion.fromAxisAngle(Vector.UNIT_X, self.horizontalRotation + math.pi, x):getNormal(x)
		Quaternion.fromAxisAngle(self.up, -self.verticalRotation + math.pi / 2, y):getNormal(y)

		result = result or Quaternion()
		return x:product(self.rotation, result):product(y, result):normalize(result)
	end
end

function ThirdPersonCamera:setRotation(value)
	self.rotation = (value or Quaternion.IDENTITY):keep()
end

function ThirdPersonCamera:setScale(value)
	self.scale = (value or Vector.ONE):keep()
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
		self.up = value:getNormal():keep()
	end
end

function ThirdPersonCamera:getUp()
	return self.up
end

do
	local rotation = Quaternion()
	local inverseRotation = Quaternion()
	local forward = Vector()
	function ThirdPersonCamera:getForward(result)
		result = result or Vector()

		local rotation = self:getCombinedRotation(rotation):conjugate(inverseRotation)
		local transformedZ = inverseRotation:transformVector(-Vector.UNIT_Z, forward):normalize(forward)
		return transformedZ:negate(result)
	end
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
	self.position = (value or self.position):keep()
end

do
	local forward = Vector()
	local distance = Vector()
	function ThirdPersonCamera:getEye(result)
		self:getForward(forward)

		result = result or Vector()
		distance:from(self.distance)
		return forward:product(distance, result):add(self.position)
	end
end

do
	local projection = love.math.newTransform()
	local view = love.math.newTransform()

	function ThirdPersonCamera:apply()
		local projection, view = self:getTransforms(projection, view)

		love.graphics.projection(projection)
		love.graphics.replaceTransform(view)
	end
end

function ThirdPersonCamera:copy(parentCamera)
	self:setPosition(parentCamera:getPosition())
	self:setFieldOfView(parentCamera:getFieldOfView())
	self:setNear(parentCamera:getNear())
	self:setFar(parentCamera:getFar())
	self:setDistance(parentCamera:getDistance())
	self:setVerticalRotation(parentCamera:getVerticalRotation())
	self:setHorizontalRotation(parentCamera:getHorizontalRotation())
	self:setRotation(parentCamera:getRotation())
	self:setScale(parentCamera:getScale())
	self:setIsWallHackEnabled(parentCamera:getIsWallHackEnabled())

	if parentCamera:getMirrorPlane() then
		local _, normal, point = parentCamera:getMirrorPlane()
		self:setMirrorPlane(normal, point)
	else
		self:unsetMirrorPlane()
	end

	if parentCamera:getClipPlane() then
		local _, normal, point = parentCamera:getClipPlane()
		self:setClipPlane(normal, point)
	else
		self:unsetClipPlane()
	end
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
