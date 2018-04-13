--------------------------------------------------------------------------------
-- ItsyScape/Game/Animation/Commands.PlayAnimation.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Command = require "ItsyScape.Game.Animation.Commands.Command"
local PlayAnimationInstance = require "ItsyScape.Game.Animation.Commands.PlayAnimationInstance"
local SkeletonAnimation = require "ItsyScape.Graphics.SkeletonAnimation"

-- Command to play an animation (lanim).
--
-- Takes the form:
--
-- PlayAnimation "<filename>" {
--   [repeatAnimation = boolean (false)] -- Whether to repeat the animation.
--   [bones = { <bone 1>, <bone N> }]    -- Bones to play this animation on.
-- }
local PlayAnimation, Metatable = Class(Command)

-- Constructs a new PlayAnimation command.
--
-- filename is the name of the lanim. At this point, no skeleton is bound;
-- it's a property of the target or channel.
function PlayAnimation:new(filename)
	self.animationFilename = filename
	self.repeatAnimation = false
	self.bones = {}

end

-- Sets some properties. See type description above. 
function Metatable:__call(t)
	t = t or {}

	self:setRepeatAnimation(t.repeatAnimation)
	self:setBones(t.bones)

	return self
end

-- Gets the filename of the lanim.
function PlayAnimation:getFilename()
	return self.animationFilename
end

-- Returns true if the animation should repeat, false otherwise.
--
-- The default value is false.
function PlayAnimation:getRepeatAnimation()
	return self.repeatAnimation
end

-- Sets a boolean indicating if the animation should repeat.
function PlayAnimation:setRepeatAnimation(value)
	self.repeatAnimation = value or false
end

-- Gets the bones this animation applies to.
function PlayAnimation:getBones()
	return self.bones
end

-- Sets the bones this animation applies to.
--
-- bones is an array of strings corresponding to the named bones in the
-- skeleton.
function PlayAnimation:setBones(value)
	value = value or {}

	self.bones = {}
	for i = 1, #value do
		self.bones[i] = value[i]
	end
end

-- Loads the animation, binding it to skeleton.
--
-- Returns the skeleton.
function PlayAnimation:load(skeleton)
	return SkeletonAnimation(self.animationFilename, skeleton)
end

function PlayAnimation:instantiate()
	return PlayAnimationInstance(self)
end

return PlayAnimation
