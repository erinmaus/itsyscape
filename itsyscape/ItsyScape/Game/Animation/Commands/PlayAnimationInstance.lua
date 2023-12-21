--------------------------------------------------------------------------------
-- ItsyScape/Game/Animation/Commands/PlayAnimationInstance.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local SkeletonAnimation = require "ItsyScape.Graphics.SkeletonAnimation"
local CommandInstance = require "ItsyScape.Game.Animation.Commands.CommandInstance"

local PlayAnimationInstance = Class(CommandInstance)

function PlayAnimationInstance:new(command)
	self.command = command or false
	self.transforms = {}
end

function PlayAnimationInstance:bind(animatable, animationInstance)
	if self.command then
		local skeleton = animatable:getSkeleton()
		self.skeleton = skeleton
		self.animation = self.command:load(skeleton)

		self.filter = skeleton:createFilter()
		local bones = self.command:getBones()
		if #bones == 0 then
			self.filter:enableAllBones()
		else
			for i = 1, #bones do
				local boneIndex = skeleton:getBoneIndex(bones[i])
				self.filter:enableBoneAtIndex(boneIndex)
			end
		end

		self.animationInstance = animationInstance

		self.blendDuration = 0
		self:_tryBindBlend(animatable)
	end
end

function PlayAnimationInstance:_tryBindBlend(animatable)
	local animations = { animatable:getPlayingAnimations() }

	for _, previousAnimationInstance in ipairs(animations) do
		local blendDuration = self.animationInstance:getAnimationDefinition():getFromBlendDuration(previousAnimationInstance:getAnimationDefinition():getName())
		if blendDuration > 0 then
			local lastInstance = previousAnimationInstance:getLastCommandOfType(PlayAnimationInstance)
			local currentInstance, currentInstanceTime = previousAnimationInstance:getCurrentCommand()

			if lastInstance and lastInstance == currentInstance or lastInstance.command:getKeep() then
				self.blendDuration = blendDuration
				self:_buildBlendAnimation(blendDuration, lastInstance, currentInstanceTime)

				break
			end
		end
	end
end

function PlayAnimationInstance:_buildBlendAnimation(blendDuration, currentInstance, currentInstanceTime)
	currentInstanceTime = math.min(currentInstance.animation:getDuration(), currentInstanceTime or 0)

	if currentInstance.command:getReverse() then
		currentInstanceTime = currentInstance.animation:getDuration() - currentInstanceTime
	end

	local definition = { _version = 2 }


	for i = 1, self.skeleton:getNumBones() do
		local bone = self.skeleton:getBoneByIndex(i)
		local boneName = bone:getName()

		local previousBoneFrame = currentInstance.animation:getInterpolatedBoneFrameAtTime(boneName, currentInstanceTime)
		local currentBoneFrame = self.animation:getInterpolatedBoneFrameAtTime(boneName, 0)

		if previousBoneFrame or currentBoneFrame then
			previousBoneFrame = previousBoneFrame or currentBoneFrame
			currentBoneFrame = currentBoneFrame or previousBoneFrame

			local blendFrame = {
				translation = {
					{ time = 0, previousBoneFrame:getTranslation():get() },
					{ time = self.blendDuration, currentBoneFrame:getTranslation():get() }
				},

				rotation = {
					{ time = 0, previousBoneFrame:getRotation():get() },
					{ time = self.blendDuration, currentBoneFrame:getRotation():get() }
				},

				scale = {
					{ time = 0, previousBoneFrame:getScale():get() },
					{ time = self.blendDuration, currentBoneFrame:getScale():get() }
				}
			}

			definition[boneName] = blendFrame
		end
	end

	self.previousAnimation = SkeletonAnimation(definition, self.skeleton)
end

function PlayAnimationInstance:_getBlendDuration()
	return self.blendDuration
end

function PlayAnimationInstance:pending(time, windingDown)
	if self.animation then
		return (self.command:getRepeatAnimation() and not windingDown) or
		       time < ((self.command:getDurationOverride() or self.animation:getDuration()) + self.blendDuration)
	end
end

function PlayAnimationInstance:getDuration(windingDown)
	if self.command:getRepeatAnimation() then
		return math.huge
	else
		return (self.command:getDurationOverride() or self.animation:getDuration()) + self.blendDuration
	end
end

function PlayAnimationInstance:play(animatable, time)
	if self.command:getKeep() then
		time = math.min(time, self.animation:getDuration() + self.blendDuration)
	end

	if self.command:getReverse() then
		if time > self.animation:getDuration() then
			time = time % self.animation:getDuration()
		end

		time = self.animation:getDuration() - time
	end

	local animation, relativeTime
	if time >= self.blendDuration then
		animation = self.animation
		relativeTime = time - self.blendDuration
	else
		animation = self.previousAnimation
		relativeTime = time
	end

	if animation then
		animation:computeFilteredTransforms(relativeTime, animatable:getTransforms(), self.filter)
	end
end

return PlayAnimationInstance
