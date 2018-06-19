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

function PlayAnimationInstance:pending(time)
	if self.animation then
		return self.command:getRepeatAnimation() or
		       time < self.animation:getDuration()
	end
end

function PlayAnimationInstance:play(animatable, time)
	if self.command:getKeep() then
		time = math.min(time, self.animation:getDuration())
	end

	if self.animation then
		self.animation:computeTransforms(time, self.transforms)

		local bones = self.command:getBones()
		if #bones == 0 then
			animatable:setTransforms(self.transforms)
		else
			for i = 1, #bones do
				local boneIndex = self.skeleton:getBoneIndex(bones[i])
				if boneIndex then
					animatable:setTransform(boneIndex, self.transforms[boneIndex])
				end
			end
		end
	end
end

return PlayAnimationInstance
