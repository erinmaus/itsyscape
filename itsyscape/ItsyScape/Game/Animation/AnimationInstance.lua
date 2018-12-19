--------------------------------------------------------------------------------
-- ItsyScape/Game/Animation/AnimationInstance.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"

local AnimationInstance = Class()
function AnimationInstance:new(animation, animatable)
	self.animation = animation
	self.animatable = animatable

	self.channels = {}
	self:addChannel(animation:getTargetChannel())
	for i = 1, animation:getNumChannels() do
		self:addChannel(animation:getChannel(i))
	end

	self.times = {}
end

function AnimationInstance:addChannel(channel)
	local c = { current = 1, previous = 0 }
	for i = 1, channel:getNumCommands() do
		local commandInstance = channel:getCommand(i):instantiate()
		commandInstance:bind(self.animatable)
		table.insert(c, commandInstance)
	end

	table.insert(self.channels, c)
end

function AnimationInstance:stop()
	-- Nothing.
end

-- Returns true if the animation is done, false otherwise.
--
-- This does not take into account animation that repeat...
function AnimationInstance:isDone(time, windingDown)
	return time > self.animation:getDuration(windingDown)
end

function AnimationInstance:play(time, windingDown)
	local isDone = true

	for i = 1, #self.channels do
		local channel = self.channels[i]
		local relativeTime = self.times[channel]
		if not relativeTime then
			relativeTime = 0
			self.times[channel] = time
		else
			relativeTime = time - relativeTime
		end

		for j = channel.current, #channel do
			local command = channel[j]

			if windingDown then
				local duration = command:getDuration(true)
				if duration > 0 and relativeTime > duration then
					relativeTime = relativeTime % duration
				end
			end

			if command:pending(relativeTime, windingDown) then
				if command.previous ~= j then
					command:start(animatable)
					command.previous = j

					self.times[channel] = time
				end

				command:play(self.animatable, relativeTime, windingDown)

				channel.current = j
				break
			else
				-- We only want to stop the previous animation if it actually
				-- played.
				if channel.previous == j then
					command:stop(self.animatable)
				end

				if channel.current ~= #channel then
					relativeTime = 0
				end
			end
		end

		if channel.current < #channel or
		   channel[channel.current]:pending(relativeTime, windingDown)
		then
			isDone = false
		end
	end

	return isDone
end

return AnimationInstance
