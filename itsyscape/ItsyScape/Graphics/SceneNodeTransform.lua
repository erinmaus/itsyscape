--------------------------------------------------------------------------------
-- ItsyScape/Graphics/SceneNodeTransform.lua
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

-- Represents a hierarchal transform of a SceneNode.
local SceneNodeTransform = Class()

-- Constructs an identity scene transform.
function SceneNodeTransform:new()
	self.translation = Vector.ZERO
	self.scale = Vector.ONE
	self.rotation = Quaternion.IDENTITY
	self.previousTranslation = false
	self.previousScale = false
	self.previousRotation = false
	self.isTransformDirty = false
	self.localTransform = love.math.newTransform()
	self.localDeltaTransform = love.math.newTransform()
	self.globalTransform = love.math.newTransform()
	self.globalDeltaTransform = love.math.newTransform()
	self.globalDeltaTransformDirty = true

	self.parentTransform = false
end

-- Gets the parent transform.
--
-- If there is no parent, this method returns false.
function SceneNodeTransform:getParentTransform()
	return self.parentTransform
end

-- Sets the parent transform.
--
-- If parent is falsey, unsets the parent transform.
function SceneNodeTransform:setParentTransform(parent)
	if not parent then
		self.parentTransform = false
	else
		self.parentTransform = parent
	end
end

-- Sets the local translation.
--
-- Does nothing if value is nil.
function SceneNodeTransform:setLocalTranslation(value)
	self.translation = value or self.translation
	self.isTransformDirty = true
end

-- Gets the local translation.
function SceneNodeTransform:getLocalTranslation()
	return self.translation
end

-- Sets the local rotation.
--
-- value is expected to be a Quaternion. If nil, rotation remains unchanged.
function SceneNodeTransform:setLocalRotation(value)
	self.rotation = value or self.rotation
	self.isTransformDirty = true
end

-- Gets the local rotation, as a quaternion.
function SceneNodeTransform:getLocalRotation()
	return self.rotation
end

-- Sets the local scale.
--
-- Does nothing if value is nil.
function SceneNodeTransform:setLocalScale(value)
	self.scale = value or self.scale
	self.isTransformDirty = true
end

-- Gets the local scale.
function SceneNodeTransform:getLocalScale()
	return self.scale
end

-- Sets the previous transform in the order of translation, rotation, and scale.
--
-- And values not provided default to the current previous value.
-- (What a confusing description.)
--
-- Generally this is only called when an instantaneous event occurs, like
-- teleporting.
function SceneNodeTransform:setPreviousTransform(translation, rotation, scale)
	self.previousTranslation = translation or self.previousTranslation or false
	self.previousRotation = rotation or self.previousRotation or false
	self.previousScale = scale or self.previousScale or false
end

-- Rotates the transform by the axis angle.
function SceneNodeTransform:rotateByAxisAngle(axis, angle)
	self.rotation = self.rotation * Quaternion.fromAxisAngle(axis, angle)
	self.isTransformDirty = true
end

-- Translates the transform by direction * scale.
--
-- * direction defaults to Vector.ZERO.
-- * scale defaults to 1
function SceneNodeTransform:translate(direction, scale)
	scale = scale or 1
	local offset = (direction or Vector.ZERO) * scale

	self.translation = self.translation + offset
	self.isTransformDirty = true
end

-- Scales the transform by value.
--
-- value defaults to 1.
function SceneNodeTransform:scale(value)
	value = value or 1

	self.scale = self.scale * value
	self.isTransformDirty = true
end

-- Gets a Love2D transform representing the local transform.
function SceneNodeTransform:getLocalTransform()
	if self.isTransformDirty then
		self.localTransform:reset()
		self.localTransform:translate(
			self.translation.x,
			self.translation.y,
			self.translation.z)
		self.localTransform:applyQuaternion(
			self.rotation.x,
			self.rotation.y,
			self.rotation.z,
			self.rotation.w)
		self.localTransform:scale(
			self.scale.x,
			self.scale.y,
			self.scale.z)

		self.isTransformDirty = false
	end

	return self.localTransform
end

function SceneNodeTransform:getLocalDeltaTransform(delta)
	local previousScale = self.previousScale or self.scale
	local previousTranslation = self.previousTranslation or self.translation
	local previousRotation = self.previousRotation or self.rotation

	local scale = previousScale:lerp(self.scale, delta)
	local translation = previousTranslation:lerp(self.translation, delta)
	local rotation = previousRotation:slerp(self.rotation, delta)

	self.localDeltaTransform:reset()
	do
		self.localDeltaTransform:translate(
			translation.x,
			translation.y,
			translation.z)
		self.localDeltaTransform:scale(
			scale.x,
			scale.y,
			scale.z)
		self.localDeltaTransform:applyQuaternion(
			rotation.x,
			rotation.y,
			rotation.z,
			rotation.w)
	end

	return self.localDeltaTransform
end

-- Gets a Love2D transform representing the global transform.
function SceneNodeTransform:getGlobalTransform()
	local localTransform = self:getLocalTransform()

	self.globalTransform:reset()
	do
		if self.parentTransform then
			local parentGlobalTransform = self.parentTransform:getGlobalTransform()
			self.globalTransform:apply(parentGlobalTransform)
		end

		self.globalTransform:apply(localTransform)
	end
	return self.globalTransform
end

function SceneNodeTransform:getGlobalDeltaTransform(delta)
	if self.globalDeltaTransformDirty then
		local localDeltaTransform = self:getLocalDeltaTransform(delta)

		self.globalDeltaTransform:reset()
		do
			if self.parentTransform then
				local parentGlobalDeltaTransform = self.parentTransform:getGlobalDeltaTransform(delta)
				self.globalDeltaTransform:apply(parentGlobalDeltaTransform)
			end
		end
		self.globalDeltaTransform:apply(localDeltaTransform)
		self.globalDeltaTransformDirty = false
	end

	return self.globalDeltaTransform 
end

function SceneNodeTransform:tick()
	self.previousRotation = self.rotation
	self.previousScale = self.scale
	self.previousTranslation = self.translation
end

function SceneNodeTransform:frame(delta)
	self.globalDeltaTransformDirty = true
end

return SceneNodeTransform
