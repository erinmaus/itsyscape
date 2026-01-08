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
local NSceneNodeTransform = require "nbunny.optimaus.scenenodetransform"

-- Represents a hierarchal transform of a SceneNode.
local SceneNodeTransform = Class()

-- Constructs an identity scene transform.
function SceneNodeTransform:new(node)
	self._handle = node:getHandle():getTransform()
	self.translation = Vector()
	self.rotation = Quaternion()
	self.scale = Vector()
	self.offset = Vector()
	self.previousTranslation = Vector()
	self.previousScale = Vector()
	self.previousRotation = Quaternion()
	self.previousOffset = Vector()
	self.localTransform = love.math.newTransform()
	self.localDeltaTransform = love.math.newTransform()
	self.globalTransform = love.math.newTransform()
	self.globalDeltaTransform = love.math.newTransform()

	self.parentTransform = false
end

function SceneNodeTransform:getHandle(node)
	return self._handle
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
	if not value then
		return
	end

	self.translation:from(value:get())
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
	if not value then
		return
	end

	self.rotation:from(value:get())
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
	if not value then
		return
	end

	self.scale:from(value:get())
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
	if not value then
		return
	end

	self.offset:from(value:get())
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
	if translation then
		self._handle:setPreviousTranslation(translation.x, translation.y, translation.z)
	end

	if rotation then
		self._handle:setPreviousRotation(rotation.x, rotation.y, rotation.z, rotation.w)
	end

	if scale then
		self._handle:setPreviousScale(scale.x, scale.y, scale.z)
	end

	if offset then
		self._handle:setPreviousOffset(offset.x, offset.y, offset.z)
	end
end

function SceneNodeTransform:getPreviousTransform()
	self.previousTranslation:from(self._handle:getPreviousTranslation())
	self.previousRotation:from(self._handle:getPreviousRotation())
	self.previousScale:from(self._handle:getPreviousScale())
	self.previousOffset:from(self._handle:getPreviousOffset())

	return self.previousTranslation, self.previousRotation, self.previousScale, self.previousOffset
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
	self._handle:getLocalDeltaTransform(0.0, self.localTransform)
	self._handle:getGlobalDeltaTransform(0.0, self.globalTransform)
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
	self._handle:getLocalDeltaTransform(delta, self.localDeltaTransform)
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
	self._handle:getGlobalDeltaTransform(delta, self.globalDeltaTransform)
	return self.globalDeltaTransform
end

function SceneNodeTransform:tick(frameDelta)
	self._handle:tick(frameDelta)

	self.previousRotation = self.rotation
	self.previousScale = self.scale
	self.previousTranslation = self.translation
end

return SceneNodeTransform
