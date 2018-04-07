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
local Vector = require "ItsyScape.Common.Math.Vector"
local Camera = require "ItsyScape.Graphics.Camera"

local ThirdPersonCamera = Class(Camera)

function ThirdPersonCamera:new()
	Camera.new(self)

	self.width = 1
	self.height = 1
	self.fieldOfView = math.rad(30)
	self.near = 0.1
	self.far = 100
	self.verticalRotation = 0
	self.horizontalRotation = 0
	self.distance = 1
	self.up = Vector(0, 1, 0)
	self.position = Vector(0, 0, 0)
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
function ThirdPersonCamera:setVerticalRotation(value)
	self.verticalRotation = value or self.verticalRotation

	if self.verticalRotation > HALF_PI then
		self.verticalRotation = HALF_PI - math.pi / 128
	end

	if self.verticalRotation < -HALF_PI then
		self.verticalRotation = -HALF_PI + math.pi / 128
	end
end

function ThirdPersonCamera:getHorizontalRotation()
	return self.horizontalRotation
end

local TWO_PI = math.pi * 2
function ThirdPersonCamera:setHorizontalRotation(value)
	self.horizontalRotation = value or self.horizontalRotation

	while self.horizontalRotation >= TWO_PI do
		self.horizontalRotation = self.horizontalRotation - TWO_PI
	end

	while self.horizontalRotation < 0 do
		self.horizontalRotation = self.horizontalRotation + TWO_PI
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
	return self.up:cross(self:getStafeForward())
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
	love.graphics.perspective(
		self.fieldOfView,
		self.width / self.height,
		self.near, self.far)

	love.graphics.origin()

	local eye = self:getEye()
	love.graphics.lookAt(
		eye.x, eye.y, eye.z,
		self.position.x, self.position.y, self.position.z,
		self.up.x, self.up.y, self.up.z)
end

return ThirdPersonCamera
