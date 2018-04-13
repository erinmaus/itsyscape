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

-- Command to blend from one animation to another.
--
-- This is a top-level command that takes the form:
-- Blend {
--   <<from/to> = "animation">, -- The name of the animation.
--   duration  = <float>        -- Duration of the blend in seconds.
-- }
local Blend = Class(Command)

-- Blends from the specified animation to this one.
Blend.TYPE_FROM = 1

-- Blends from this animation to the specified one.
Blend.TYPE_TO = 2

-- Constructs a new blend command.
--
-- See Blend type above for info about the t parameter.
function Blend:new(t)
	t = t or {}

	if t.from and t.to then
		error("expected just from or to, got both")
	elseif t.from then
		self.type = Blend.TYPE_FROM
		self.animation = t.from
	elseif t.to then
		self.type = Blend.TYPE_TO
		self.animation = t.to
	else
		error("expected from or to argument, got nothing")
	end

	self.duration = t.duration or 0
end

-- Gets the type of blend.
--
-- Returns Blend.TYPE_FROM or Blend.TYPE_TO, depending on the type of blend. 
function Blend:getType()
	return self.type
end

-- Gets the animation that's been blended.
function Blend:getAnimation()
	return self.animation
end

-- Gets the duration of the blend, in seconds.
function Blend:getDuration()
	return self.duration
end

return Blend
