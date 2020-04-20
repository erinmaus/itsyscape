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
local NSceneNodeTransform = require "nbunny.scenenodetransform"

-- Represents a hierarchal transform of a SceneNode.
local SceneNodeTransform = Class()

-- Constructs an identity scene transform.
function SceneNodeTransform:new(node)
	self._handle = node._handle:getTransform()
	self.translation = Vector.ZERO
	self.scale = Vector.ONE
	self.rotation = Quaternion.IDENTITY
	self.offset = Vector.ZERO
	self.previousTranslation = false
	self.previousScale = false
	self.previousRotation = false
	self.previousOffset = Vector.ZERO
	self.localTransform = love.math.newTransform()
	self.localDeltaTransform = love.math.newTransform()
	self.globalTransform = love.math.newTransform()
	self.globalDeltaTransform = love.math.newTransform()

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

	self.isTransformDirty = true
end

-- Sets the local translation.
--
-- Does nothing if value is nil.
function SceneNodeTransform:setLocalTranslation(value)
	self.translation = value or self.translation
	self._handle:setCurrentTranslation(
		self.translation.x,
		self.translation.y,
		self.translation.z)

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
	self._handle:setCurrentRotation(
		self.rotation.x,
		self.rotation.y,
		self.rotation.z,
		self.rotation.w)

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
	self._handle:setCurrentScale(
		self.scale.x,
		self.scale.y,
		self.scale.z)

	self.isTransformDirty = true
end

-- Gets the local scale.
function SceneNodeTransform:getLocalScale()
	return self.scale
end

-- Sets the local offset.
--
-- Does nothing if value is nil.
function SceneNodeTransform:setLocalOffset(value)
	self.offset = value or self.offset
	self._handle:setCurrentOffset(
		self.offset.x,
		self.offset.y,
		self.offset.z)

	self.isTransformDirty = true
end

-- Gets the local offset.
function SceneNodeTransform:getLocalOffset()
	return self.offset
end

-- Sets the previous transform in the order of translation, rotation, and scale.
--
-- And values not provided default to the current previous value.
-- (What a confusing description.)
--
-- Generally this is only called when an instantaneous event occurs, like
-- teleporting.
function SceneNodeTransform:setPreviousTransform(translation, rotation, scale, offset)
	self.previousTranslation = translation or self.previousTranslation or false
	self.previousRotation = rotation or self.previousRotation or false
	self.previousScale = scale or self.previousScale or false
	self.previousOffset = offset or self.previousOffset or false

	if self.previousTranslation then
		self._handle:setPreviousTranslation(self.previousTranslation.x, self.previousTranslation.y, self.previousTranslation.z)
	end

	if self.previousRotation then
		self._handle:setPreviousRotation(self.previousRotation.x, self.previousRotation.y, self.previousRotation.z, self.previousRotation.w)
	end

	if self.previousScale then
		self._handle:setPreviousScale(self.previousScale.x, self.previousScale.y, self.previousScale.z)
	end

	if self.previousOffset then
		self._handle:setPreviousOffset(self.previousOffset.x, self.previousOffset.y, self.previousOffset.z)
	end
end

-- Rotates the transform by the axis angle.
function SceneNodeTransform:rotateByAxisAngle(axis, angle)
	self:setLocalRotation(self.rotation * Quaternion.fromAxisAngle(axis, angle))
end

-- Translates the transform by direction * scale.
--
-- * direction defaults to Vector.ZERO.
-- * scale defaults to 1
function SceneNodeTransform:translate(direction, scale)
	scale = scale or 1
	local offset = (direction or Vector.ZERO) * scale

	self:setLocalTranslation(self.translation + offset)
end

-- Scales the transform by value.
--
-- value defaults to 1.
function SceneNodeTransform:scale(value)
	value = value or 1

	self:setLocalScale(self.scale * value)
end

function SceneNodeTransform:updateTransform()
	self.localTransform:setMatrix(self._handle:getLocalDeltaTransform(0.0))
	self.globalTransform:setMatrix(self._handle:getGlobalDeltaTransform(0.0))
	self.isTransformDirty = false
end

-- Gets a Love2D transform representing the local transform.
function SceneNodeTransform:getLocalTransform()
	if self.isTransformDirty then
		self:updateTransform()
	end

	return self.localTransform
end

function SceneNodeTransform:getLocalDeltaTransform(delta)
	self.localDeltaTransform:setMatrix(self._handle:getLocalDeltaTransform(delta))
	return self.localDeltaTransform
end

-- Gets a Love2D transform representing the global transform.
function SceneNodeTransform:getGlobalTransform()
	if self.isTransformDirty then
		self:updateTransform()
	end

	return self.globalTransform
end

function SceneNodeTransform:getGlobalDeltaTransform(delta)
	self.globalDeltaTransform:setMatrix(self._handle:getGlobalDeltaTransform(delta))
	return self.globalDeltaTransform
end

function SceneNodeTransform:tick()
	self._handle:tick()

	self.previousRotation = self.rotation
	self.previousScale = self.scale
	self.previousTranslation = self.translation
end

function SceneNodeTransform:frame(delta)
	-- Nothing.
end

return SceneNodeTransform
