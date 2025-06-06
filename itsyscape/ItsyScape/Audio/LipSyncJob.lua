--------------------------------------------------------------------------------
-- ItsyScape/Audio/LipSyncJob.lua
--
-- This file is a part of ItsyScape.
--
-- This file is a C#-to-Lua translation of https://github.com/hecomi/uLipSync;
-- it is licensed underr the MIT license.
--------------------------------------------------------------------------------
_LOG_SUFFIX = "LipSync"
require "bootstrap"

local ffi = require "ffi"
local Algorithm = require "ItsyScape.Audio.LipSyncAlgorithm"

local args = ...

local inputChannel, outputChannel = args.input, args.output
while true do
	local event = inputChannel:demand()

	if not event then
		break
	end

	local input = event.input
	local inputData = ffi.cast("float*", input:getFFIPointer())
	local inputLength = input:getSize() / ffi.sizeof("float")
	local startIndex = event.startIndex
	local outputSampleRate = event.outputSampleRate
	local targetSampleRate = event.targetSampleRate
	local melFilterBankChannels = event.melFilterBankChannels
	local mfccLength = event.mfccLength
	local phonemes = event.phonemes
	local cutoff = targetSampleRate / 2
	local range = 500

	local buffer = Algorithm.copyRingBuffer(inputData, inputLength, startIndex)
	local volume = Algorithm.getRMSVolume(buffer)
	Algorithm.lowPassFilter(buffer, outputSampleRate, cutoff, range)
	local data = Algorithm.downSample(buffer, outputSampleRate, targetSampleRate)
	Algorithm.preEmphasis(data, 0.97)
	Algorithm.hammingWindow(data)
	Algorithm.normalize(data)
	local spectrum = Algorithm.fft(data)
	local melSpectrum = Algorithm.melFilterBank(spectrum, targetSampleRate, melFilterBankChannels)
	Algorithm.powerToDB(melSpectrum)
	local melCepstrum = Algorithm.dct(melSpectrum)

	local mfcc = {}
	do
		local melCepstrumData = ffi.cast("float*", melCepstrum:getFFIPointer())

		local index = 1
		while index <= mfccLength do
			mfcc[index] = melCepstrumData[index]
			index = index + 1
		end
	end

	local scores = {}
	do
		local sum = 0

		for i = 1, #phonemes do
			local score = Algorithm.calculateScore(mfcc, phonemes[i])
			scores[i] = score
			sum = sum + score
		end

		for i = 1, #phonemes do
			if sum > 0 then
				scores[i] = scores[i] / sum
			else
				scores[i] = 0
			end
		end
	end

	local phonemeIndex
	do
		local maxScore = -math.huge

		for i = 1, #scores do
			local score = scores[i]
			if score > maxScore then
				phonemeIndex = i
				maxScore = score
			end
		end
	end

	outputChannel:push({
		mfcc = mfcc,
		scores = scores,
		phonemeIndex = phonemeIndex,
		volume = volume
	})
end
