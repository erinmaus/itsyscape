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
	self.time = 0
end

function PlaySoundInstance:bind(animatable)
	-- Nothing.
end

function PlaySoundInstance:pending(time, windingDown)
	local repeatSound = self.command and self.command:getRepeatSound()
	return not windingDown and (not self.played or repeatSound)
end

function PlaySoundInstance:play(animatable, time)
	local repeatSound = self.command and self.command:getRepeatSound()
	if (not self.played or repeatSound) and self.command and time >= self.time then
		local s = animatable:playSound(self.command:getFilename(), self.command:getAttenuation())
		s:setPitch(love.math.random() * (self.command:getMaxPitch() - self.command:getMinPitch()) + self.command:getMinPitch())
		s:seek(0)
		s:play()

		self.time = self.time + math.lerp(self.command:getMinDuration(), self.command:getMaxDuration(), love.math.random())
	end

	self.played = true
end

return PlaySoundInstance
