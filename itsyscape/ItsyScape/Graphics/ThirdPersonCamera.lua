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
	self.far = 1000
	self.verticalRotation = 0
	self.horizontalRotation = 0
	self.distance = 1
	self.up = Vector(0, 1, 0)
	self.position = Vector(0, 0, 0)
	self.rotation = Quaternion.IDENTITY
end

function ThirdPersonCamera:getTransforms(projection, view)
	projection = projection or love.math.newTransform()
	do
		projection:reset()
		projection:perspective(
			self.fieldOfView,
			self.width / self.height,
			self.near, self.far)
	end

	view = view or love.math.newTransform()
	do
		view:reset()

		local eye = self:getEye()

		local y = Quaternion.fromAxisAngle(self.up, -(self.verticalRotation - math.pi / 2)):getNormal()
		local x = Quaternion.fromAxisAngle(Vector.UNIT_X, self.horizontalRotation):getNormal()
		local lookAt = (x * y):getNormal()

		view:translate(0, 0, -self.distance)
		view:applyQuaternion(lookAt:get())
		view:applyQuaternion(self.rotation:get())
		view:translate(self.position:get())
		view:scale(-1, -1, -1)
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

local HALF_PI = math.pi / 2
function ThirdPersonCamera:setHorizontalRotation(value)
	self.horizontalRotation = value or self.horizontalRotation

	if self.horizontalRotation > HALF_PI then
		self.horizontalRotation = HALF_PI - math.pi / 128
	end

	if self.horizontalRotation < -HALF_PI then
		self.horizontalRotation = -HALF_PI + math.pi / 128
	end
end

function ThirdPersonCamera:getHorizontalRotation()
	return self.horizontalRotation
end

function ThirdPersonCamera:getRotation()
	return self.rotation
end

function ThirdPersonCamera:setRotation(value)
	self.rotation = value or Quaternion.IDENTITY
end

local TWO_PI = math.pi * 2
function ThirdPersonCamera:setVerticalRotation(value)
	self.verticalRotation = value or self.verticalRotation

	while self.verticalRotation >= TWO_PI do
		self.verticalRotation = self.verticalRotation - TWO_PI
	end

	while self.verticalRotation < 0 do
		self.verticalRotation = self.verticalRotation + TWO_PI
	end
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
	local result = Vector()
	local phi = self.horizontalRotation
	local theta = self.verticalRotation

	result.x = math.cos(phi) * math.cos(theta)
	result.y = math.sin(phi)
	result.z = math.cos(phi) * math.sin(theta)

	return result:getNormal()
end

function ThirdPersonCamera:getStrafeForward()
	local result = Vector()
	local phi = self.horizontalRotation
	local theta = self.verticalRotation

	result.x = math.cos(phi) * math.cos(theta)
	result.y = 0
	result.z = math.cos(phi) * math.sin(theta)

	return result:getNormal()
end

function ThirdPersonCamera:getLeft()
	return self.up:cross(self:getForward())
end

function ThirdPersonCamera:getStrafeLeft()
	return self.up:cross(self:getStrafeForward())
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

return ThirdPersonCamera
