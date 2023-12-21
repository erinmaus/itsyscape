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
	self.stopping = {}
end

function AnimationInstance:getAnimationDefinition()
	return self.animation
end

function AnimationInstance:addChannel(channel)
	local c = { current = 1, previous = 0 }
	for i = 1, channel:getNumCommands() do
		local commandInstance = channel:getCommand(i):instantiate()
		commandInstance:bind(self.animatable, self)
		table.insert(c, commandInstance)
	end

	table.insert(self.channels, c)
end

function AnimationInstance:stop()
	for index in ipairs(self.channels) do
		local currentCommand = self:getCurrentCommand(index)
		if currentCommand then
			currentCommand:stop(self.animatable)
		end
	end
end

-- Returns true if the animation is done, false otherwise.
--
-- This does not take into account animation that repeat...
function AnimationInstance:isDone(time, windingDown)
	return time > self.animation:getDuration(windingDown)
end

function AnimationInstance:getCurrentCommand(channelIndex)
	channelIndex = channelIndex or 1

	local channel = self.channels[channelIndex]
	if channel then
		local command = channel[channel.current] or channel[1]
		return command, self.times[channel]
	end

	return nil
end

function AnimationInstance:getLastCommandOfType(Type, channelIndex)
	channelIndex = channelIndex or 1

	local channel = self.channels[channelIndex]
	if channel then
		local current = channel[channel.current] or channel[1]
		if current then
			local currentIndex = 0
			do
				repeat
					currentIndex = currentIndex + 1
				until not channel[currentIndex] or channel[currentIndex] == current

				currentIndex = math.min(currentIndex, #channel)
			end

			for i = currentIndex, 1, -1 do
				if channel[currentIndex]:isCompatibleType(Type) then
					return channel[currentIndex]
				end
			end
		end
	end

	return nil
end

function AnimationInstance:play(time, windingDown)
	local isDone = true

	for i = 1, #self.channels do
		local channel = self.channels[i]
		local relativeTime = self.times[channel]
		if not relativeTime then
			relativeTime = time
			self.times[channel] = 0
		else
			relativeTime = time - relativeTime
		end

		for j = channel.current, #channel do
			local command = channel[j]

			-- if windingDown and not self.stopping[command] then
			-- 	local duration = command:getDuration(true)
			-- 	if duration > 0 and relativeTime > duration then
			-- 		relativeTime = 0
			-- 		self.times[channel] = time
			-- 		self.stopping[command] = true
			-- 	end
			-- end

			if command:pending(relativeTime, windingDown) then
				if channel.previous ~= j then
					command:start(self.animatable)
					channel.previous = j
					channel.stopped = false
				end

				command:play(self.animatable, relativeTime, windingDown)

				channel.current = j
				break
			else
				-- We only want to stop the previous animation if it actually
				-- played.
				if channel.previous == j and not channel.stopped then
					command:stop(self.animatable)
					channel.stopped = true
				end

				if channel.current ~= #channel then
					self.times[channel] = relativeTime
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
