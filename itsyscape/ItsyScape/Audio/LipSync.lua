--------------------------------------------------------------------------------
-- ItsyScape/Audio/LipSync.lua
--
-- This file is a part of ItsyScape.
--
-- This file is a C#-to-Lua translation of https://github.com/hecomi/uLipSync;
-- it is licensed underr the MIT license.
--------------------------------------------------------------------------------
local ffi = require "ffi"
local Class = require "ItsyScape.Common.Class"
local Callback = require "ItsyScape.Common.Callback"

local LipSync = Class()
LipSync.DEFAULT_CONFIG = {
	sampleRate = 16000,
	sampleCount = 2048,
	mfccLength = 12,
	melFilterBankChannels = 30
}

function LipSync:new(phonemes, config)
	self:updatePhonemes(phonemes)

	self.config = config or LipSync.DEFAULT_CONFIG

	self.inputChannel, self.outputChannel = love.thread.newChannel(), love.thread.newChannel()
	self.job = love.thread.newThread(
		"ItsyScape/Audio/LipSyncJob.lua")

	-- self.inputChannel is messages received from the job, but for the job it is outputs send from the job
	-- Same for self.outputChannel; this is for events sent to the job, but for the job it is inputs received from the client
	self.job:start({
		input = self.outputChannel,
		output = self.inputChannel
	})

	local sampleCount = self.config.sampleCount or LipSync.DEFAULT_CONFIG.sampleCount
	self.buffer = love.data.newByteData(sampleCount * ffi.sizeof("float"))
	self.index = 0

	self.onResult = Callback()
end

function LipSync:updatePhonemes(phonemes)
	phonemes = phonemes or {}

	self.phonemes = {}
	for i = 1, #phonemes do
		local p = {}

		for j = 1, #phonemes[i] do
			p[j] = phonemes[i][j]
		end

		self.phonemes[i] = p
	end
end

function LipSync:_updateBuffer(soundData)
	local bufferData = ffi.cast("float*", self.buffer:getFFIPointer())
	local bufferSize = self.buffer:getSize() / ffi.sizeof("float")
	local oldIndex = self.index
	local bufferIndex = self.index % bufferSize

	local sampleCount = soundData:getSampleCount()
	local soundDataIndex = 0

	while soundDataIndex < sampleCount do
		bufferData[bufferIndex] = soundData:getSample(soundDataIndex)
		bufferIndex = (bufferIndex + 1) % bufferSize

		soundDataIndex = soundDataIndex + 1
	end

	self.index = bufferIndex
	self.currentSampleRate = soundData:getSampleRate()
end

function LipSync:_updateJob()
	self.outputChannel:push({
		input = love.data.newByteData(self.buffer),
		startIndex = self.index,
		outputSampleRate = self.currentSampleRate,
		targetSampleRate = self.config.sampleRate or LipSync.DEFAULT_CONFIG.sampleRate,
		melFilterBankChannels = self.config.melFilterBankChannels or LipSync.DEFAULT_CONFIG.melFilterBankChannels,
		mfccLength = self.config.mfccLength or LipSync.DEFAULT_CONFIG.mfccLength,
		phonemes = self.phonemes
	})
end

function LipSync:update(soundData)
	if soundData then
		self:_updateBuffer(soundData)
	end

	self:_updateJob()

	-- local event
	repeat
		event = self.inputChannel:pop()
	--	event = self.inputChannel:demand()
		if event then
			self:onResult(event)
		end
	until not event
end

function LipSync:release()
	self.job:push(false)
	self.job:wait()

	local e = self.job:getError()
	if e then
		Log.error("Error quitting lip sync thread: %s", e)
	end
end

return LipSync
