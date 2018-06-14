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
		self.animation = self.command:load(animatable:getSkeleton())
	end
end

function PlayAnimationInstance:pending(time)
	if self.animation then
		return self.command:getRepeatAnimation() or
		       time < self.animation:getDuration()
	end
end

function PlayAnimationInstance:play(animatable, time)
	if self.animation then
		self.animation:computeTransforms(time, self.transforms)

		local bones = self.command:getBones()
		if #bones == 0 then
			animatable:setTransforms(self.transforms)
		else
			for i = 1, #bones do
				local boneIndex = self.skeleton:getBoneIndex(bones[i])
				if boneIndex then
					animatable:setTransform(boneIndex, self.transforms[i])
				end
			end
		end
	end
end

return PlayAnimationInstance
