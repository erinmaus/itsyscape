	--------------------------------------------------------------------------------
-- ItsyScape/Audio/LipSyncAlgorithm.lua
--
-- This file is a part of ItsyScape.
--
-- This file is a C#-to-Lua translation of https://github.com/hecomi/uLipSync;
-- it is licensed underr the MIT license.
--------------------------------------------------------------------------------
local ffi = require "ffi"
local NBunnyAudio = require "nbunny.audio"

local LipSyncAlgorithm = {}
LipSyncAlgorithm.EPSILON = 0

function LipSyncAlgorithm.new(size)
	return love.data.newByteData(size * ffi.sizeof("float"))
end

function LipSyncAlgorithm.copyRingBuffer(data, length, startIndex)
	local buffer = LipSyncAlgorithm.new(length)
	local pointer = ffi.cast("float*", buffer:getFFIPointer())

	local index = 0
	while index < length do
		pointer[index] = data[(index + startIndex) % length]
		index = index + 1
	end

	return buffer
end

LipSyncAlgorithm.getRMSVolume = NBunnyAudio.getRMSVolume
LipSyncAlgorithm.normalize = NBunnyAudio.normalize
LipSyncAlgorithm.lowPassFilter = NBunnyAudio.lowPassFilter
LipSyncAlgorithm.downSample = NBunnyAudio.downSample
LipSyncAlgorithm.preEmphasis = NBunnyAudio.preEmphasis
LipSyncAlgorithm.hammingWindow = NBunnyAudio.hammingWindow
LipSyncAlgorithm.fft = NBunnyAudio.fft
LipSyncAlgorithm.melFilterBank = NBunnyAudio.melFilterBank
LipSyncAlgorithm.powerToDB = NBunnyAudio.powerToDB
LipSyncAlgorithm.dct = NBunnyAudio.dct

function LipSyncAlgorithm.calculateScore(mfcc, phoneme)
	local n = #mfcc

	local mfccNorm = 0
	local phonemeNorm = 0

	local prod = 0
	for i = 1, n do
		local x = mfcc[i]
		local y = phoneme[i]
		mfccNorm = mfccNorm + x * x
		phonemeNorm = phonemeNorm + y * y
		prod = prod + x * y
	end

	mfccNorm = math.sqrt(mfccNorm)
	phonemeNorm = math.sqrt(phonemeNorm)

	local similarity = prod / (mfccNorm * phonemeNorm)
	similarity = math.max(similarity, 0)

	return similarity ^ 100.0
end

return LipSyncAlgorithm
