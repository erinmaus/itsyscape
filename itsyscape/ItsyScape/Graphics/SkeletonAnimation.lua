--------------------------------------------------------------------------------
-- ItsyScape/Graphics/SkeletonAnimation.lua
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
local NSkeletonKeyFrame = require "nbunny.skeletonkeyframe"

local SkeletonAnimation = Class()
SkeletonAnimation.KeyFrame = Class()

-- Constructs a new KeyFrame with the specified time, rotation (r), scale (s),
-- and translation (t) values.
--
--  * time defaults to 0
--  * s defaults to { 1, 1, 1 }
--  * r defaults to an identity quaternion
--  * t defaults to { 0, 0, 0 }
function SkeletonAnimation.KeyFrame:new(time, s, r, t)
	self.time = time or 0
	self.scale = s or Vector(1)
	self.rotation = r or Quaternion()
	self.translation = t or Vector(0)

	self._handle = NSkeletonKeyFrame()
	self._handle:setTime(time)
	self._handle:setScale(self.scale.x, self.scale.y, self.scale.z)
	self._handle:setRotation(self.rotation.x, self.rotation.y, self.rotation.z, self.rotation.w)
	self._handle:setTranslation(self.translation.x, self.translation.y, self.translation.z)
	self._transform = love.math.newTransform()
end

-- Interpolates this key frame with another, storing the result in 'transform'.
function SkeletonAnimation.KeyFrame:interpolate(other, time, transform)
	self._transform:setMatrix(self._handle:interpolate(other._handle, time))
	transform:apply(self._transform)

	return transform
end

function SkeletonAnimation:new(d, skeleton)
	self.duration = 0

	if type(d) == 'string' then
		self:loadFromFile(d, skeleton)
	elseif type(d) == 'table' then
		self:loadFromTable(d, skeleton)
	else
		error(("expected table or filename (string), got %s"):format(type(d)))
	end
end

function SkeletonAnimation:loadFromFile(filename, skeleton)
	local data = "return " .. love.filesystem.read(filename)
	local chunk = assert(loadstring(data))
	local result = setfenv(chunk, {})()

	self:loadFromTable(result, skeleton)
end

function SkeletonAnimation:loadFromTable(t, skeleton)
	self.bones = {}

	local duration = 0
	local function addFrame(boneName)
		local boneFramesDefinition = t[boneName]
		if not boneFramesDefinition then
			boneFramesDefinition = {
				translation = { { time = 0, 0, 0, 0 } },
				rotation = { { time = 0, 0, 0, 0, 1 } },
				scale = { { time = 0, 1, 1, 1 } }
			}
		end

		assert(#boneFramesDefinition.translation == #boneFramesDefinition.rotation and
		       #boneFramesDefinition.rotation == #boneFramesDefinition.scale,
		       "Properties must have same number of frames (because NYI)")

		local boneFrames = {}
		local count = #boneFramesDefinition.translation
		for i = 1, count do
			assert(boneFramesDefinition.scale[i].time == boneFramesDefinition.rotation[i].time and
			       boneFramesDefinition.rotation[i].time == boneFramesDefinition.translation[i].time,
			       "Frames must have same time (because NYI)")

			local time = boneFramesDefinition.translation[i].time
			local scale = Vector(unpack(boneFramesDefinition.scale[i]))
			local rotation = Quaternion(unpack(boneFramesDefinition.rotation[i]))
			local translation = Vector(unpack(boneFramesDefinition.translation[i]))

			self.duration = math.max(self.duration, time)

			local keyFrame = SkeletonAnimation.KeyFrame(time, scale, rotation, translation)
			table.insert(boneFrames, keyFrame)

			duration = math.max(duration, time)
		end

		self.bones[boneName] = boneFrames
	end

	if skeleton then
		for index, bone in skeleton:iterate() do
			addFrame(bone:getName())
		end
	else
		for name in pairs(t) do
			addFrame(name)
		end
	end

	self.skeleton = skeleton or false
	self.duration = duration
end

function SkeletonAnimation:getDuration()
	return self.duration
end

function SkeletonAnimation:computeTransforms(time, transforms, localOnly)
	for index = 1, self.skeleton:getNumBones() do
		self:computeTransform(time, transforms, index, localOnly)
	end

	if not localOnly then
		for index = 1, self.skeleton:getNumBones() do
			self:applyBindPose(time, transforms, index)
		end
	end
end

function SkeletonAnimation:computeTransform(time, transforms, index, localOnly)
	local bone = self.skeleton:getBoneByIndex(index)
	local name = bone:getName()
	local boneFrame = self.bones[name]
	local transform = transforms[index] or love.math.newTransform()
	transform:reset()

	if bone:getParent() and not localOnly then
		local parentIndex = bone:getParentIndex()
		transform:apply(transforms[parentIndex])
	end

	local duration = self:getDuration()
	local wrappedTime
	if duration ~= 0 then
		if time > duration then
			wrappedTime = time % duration
		else
			wrappedTime = time
		end
	else
		wrappedTime = 0
	end

	local currentFrameIndex = 1
	for i = 1, #boneFrame do
		if wrappedTime > boneFrame[i].time then
			currentFrameIndex = i
		else
			break
		end
	end

	local nextFrameIndex = currentFrameIndex % #boneFrame + 1
	local currentFrame = boneFrame[currentFrameIndex]
	local nextFrame = boneFrame[nextFrameIndex]
	currentFrame:interpolate(nextFrame, wrappedTime, transform)

	transforms[index] = transform
end

function SkeletonAnimation:applyBindPose(time, transforms, index)
	local bone = self.skeleton:getBoneByIndex(index)
	local transform = transforms[index]
	transform:apply(bone:getInverseBindPose())
end

return SkeletonAnimation
