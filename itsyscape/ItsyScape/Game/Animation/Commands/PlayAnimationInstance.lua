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
local CommandInstance = require "ItsyScape.Game.Animation.Commands.CommandInstance"

local PlayAnimationInstance = Class(CommandInstance)

function PlayAnimationInstance:new(command)
	self.command = command or false
	self.transforms = {}
end

function PlayAnimationInstance:bind(animatable)
	if self.command then
		local skeleton = animatable:getSkeleton()
		self.skeleton = skeleton
		self.animation = self.command:load(skeleton)
	end
end

function PlayAnimationInstance:pending(time, windingDown)
	if self.animation then
		return (self.command:getRepeatAnimation() and not windingDown) or
		       time < self.animation:getDuration()
	end
end

function PlayAnimationInstance:getDuration(windingDown)
	if self.command:getRepeatAnimation() then
		return math.huge
	else
		return self.command:getDuration()
	end
end

function PlayAnimationInstance:play(animatable, time)
	if self.command:getKeep() then
		time = math.min(time, self.animation:getDuration())
	end

	if self.command:getReverse() then
		if time > self.animation:getDuration() then
			time = time % self.animation:getDuration()
		end

		time = self.animation:getDuration() - time
	end

	if self.animation then
		self.animation:computeTransforms(time, self.transforms, true)

		local bones = self.command:getBones()
		if #bones == 0 then
			animatable:setTransforms(self.transforms, self.animation, time)
		else
			for i = 1, #bones do
				local boneIndex = self.skeleton:getBoneIndex(bones[i])
				if boneIndex then
					animatable:setTransform(boneIndex, self.transforms[boneIndex], self.animation, time)
				end
			end
		end
	end
end

return PlayAnimationInstance
