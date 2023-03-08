--------------------------------------------------------------------------------
-- ItsyScape/Game/Animation/Commands/PlaySoundInstance.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local CommandInstance = require "ItsyScape.Game.Animation.Commands.CommandInstance"

local PlaySoundInstance = Class(CommandInstance)

function PlaySoundInstance:new(command)
	self.command = command or false
	self.played = false
end

function PlaySoundInstance:bind(animatable)
	-- Nothing.
end

function PlaySoundInstance:pending(time, windingDown)
	return windingDown or not self.played
end

function PlaySoundInstance:play(animatable, time)
	if not self.played and self.command then
		local s = animatable:playSound(self.command:getFilename(), self.command:getAttenuation())
		s:setPitch(math.random() * (self.command:getMaxPitch() - self.command:getMinPitch()) + self.command:getMinPitch())
		s:seek(0)
		s:play()
	end

	self.played = true
end

return PlaySoundInstance
