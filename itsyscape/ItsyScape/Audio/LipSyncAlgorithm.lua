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
	return ffi.new("float[?]", size)
end

function LipSyncAlgorithm.free(buffer)
	-- Nothing.
end

function LipSyncAlgorithm.copy(data, length)
	local temp = LipSyncAlgorithm.new(length)

	local index = 0
	while index < length do
		temp[index] = data[index]
		index = index + 1
	end

	return temp, length
end

function LipSyncAlgorithm.copyRingBuffer(data, length, startIndex)
	local buffer = LipSyncAlgorithm.new(length)

	local index = 0
	while index < length do
		buffer[index] = data[(index + startIndex) % length]
		index = index + 1
	end

	return buffer, length
end

function LipSyncAlgorithm.getMaxValue(data, length)
	local max = 0
	local index = 0
	while index < length do
		max = math.max(max, math.abs(data[index]))

		index = index + 1
	end

	return max
end

function LipSyncAlgorithm.getRMSVolume(array, length)
	local average = 0

	local index = 0
	while index < length do
		average = average + array[index] * array[index]
		index = index + 1
	end

	return math.sqrt(average / length)
end

function LipSyncAlgorithm.normalize(array, length, value)
	value = value or 1

	local max = LipSyncAlgorithm.getMaxValue(array, length)

	if max < LipSyncAlgorithm.EPSILON then
		return
	end

	local r = value / max
	local index = 0
	while index < length do
		array[index] = array[index] * r
		index = index + 1
	end
end

function LipSyncAlgorithm.lowPassFilter(data, length, sampleRate, cutoff, range)
	cutoff = (cutoff - range) / sampleRate
	range = range / sampleRate

	local temp = LipSyncAlgorithm.copy(data, length)

	local n = math.floor(3.1 / range + 0.5)
	if (n + 1) % 2 == 0 then
		n = n + 1
	end

	local b = LipSyncAlgorithm.new(n)

	do
		local index = 0
		while index < n do
			local x = index - (n - 1) / 2.0
			local ang = 2.0 * math.pi * cutoff * x

			b[index] = 2.0 * cutoff * math.sin(ang) / ang

			index = index + 1
		end
	end

	local i = 0
	while i < length do
		local j = 0
		while j < n do
			if i - j >= 0 then
				data[i] = data[i] + b[j] * temp[i - j]
			end

			j = j + 1
		end

		i = i + 1
	end

	LipSyncAlgorithm.free(temp)
	LipSyncAlgorithm.free(b)
end

function LipSyncAlgorithm.downSample(input, length, sampleRate, targetSampleRate)
	local output, n
	if sampleRate <= targetSampleRate then
		output = LipSyncAlgorithm.copy(input, length)
		n = length
	elseif sampleRate % targetSampleRate == 0 then
		local skip = sampleRate / targetSampleRate

		n = length / skip
		output = LipSyncAlgorithm.new(n)

		local index = 0
		while index < n do
			output[index] = input[index * skip]
			index = index + 1
		end
	else
		local df = sampleRate / targetSampleRate

		n = math.floor(length / df + 0.5)
		output = LipSyncAlgorithm.new(n)

		local index = 0
		while index < n do
			local fIndex = df * index
			local i0 = math.floor(fIndex)
			local i1 = math.min(i0, length - 1)
			local t = fIndex - i0
			local x0 = input[i0]
			local x1 = input[i1]

			output[index] = x1 * t + x0 * (1.0 - t)

			index = index + 1
		end
	end

	return output, n
end

function LipSyncAlgorithm.preEmphasis(data, length, p)
	local temp = LipSyncAlgorithm.copy(data, length)

	local index = 1
	while index < length do
		data[index] = temp[index] - p * temp[index - 1]
		index = index + 1
	end

	LipSyncAlgorithm.free(temp)
end

function LipSyncAlgorithm.hammingWindow(data, length)
	local index = 0
	while index < length do
		local x = index / (length - 1)
		data[index] = data[index] * 0.54 - 0.46 * math.cos(2 * math.pi * x)

		index = index + 1
	end
end

function LipSyncAlgorithm.fft(data, length)
	local N = length
	local spectrum = LipSyncAlgorithm.new(N)

	local spectrumRe = LipSyncAlgorithm.new(N)
	local spectrumIm = LipSyncAlgorithm.new(N)

	do
		local index = 0
		while index < N do
			spectrumRe[index] = data[index]
			index = index + 1
		end
	end

	LipSyncAlgorithm._fft(spectrumRe, spectrumIm, N)

	do
		local index = 0
		while index < N do
			local re = spectrumRe[index]
			local im = spectrumIm[index]

			spectrum[index] = math.sqrt(re * re + im * im)

			index = index + 1
		end
	end

	LipSyncAlgorithm.free(spectrumRe)
	LipSyncAlgorithm.free(spectrumIm)

	return spectrum, N
end

function LipSyncAlgorithm._fft(spectrumRe, spectrumIm, N)
	if N < 2 then
		return
	end

	local halfN = N / 2
	local evenRe = LipSyncAlgorithm.new(halfN)
	local evenIm = LipSyncAlgorithm.new(halfN)
	local oddRe = LipSyncAlgorithm.new(halfN)
	local oddIm = LipSyncAlgorithm.new(halfN)

	do
		local index = 0
		while index < halfN do
			evenRe[index] = spectrumRe[index * 2]
			evenIm[index] = spectrumIm[index * 2]

			oddRe[index] = spectrumRe[index * 2 + 1]
			oddIm[index] = spectrumIm[index * 2 + 1]

			index = index + 1
		end
	end

	LipSyncAlgorithm._fft(evenRe, evenIm, halfN)
	LipSyncAlgorithm._fft(oddRe, oddIm, halfN)

	do
		local index = 0
		while index < halfN do
			local _er = evenRe[index]
			local _ei = evenIm[index]
			local _or = oddRe[index]
			local _oi = oddIm[index]
			local theta = -2.0 * math.pi * index / N

			local cx0 = math.cos(theta)
			local cy0 = math.sin(theta)
			local cx1 = cx0 * _or - cy0 * _oi
			local cy1 = cx0 * _oi + cy0 * _or

			spectrumRe[index] = _er + cx1
			spectrumIm[index] = _ei + cy1
			spectrumRe[halfN + index] = _er - cx1
			spectrumIm[halfN + index] = _ei - cy1

			index = index + 1
		end
	end

	LipSyncAlgorithm.free(evenRe)
	LipSyncAlgorithm.free(evenIm)
	LipSyncAlgorithm.free(oddRe)
	LipSyncAlgorithm.free(oddIm)
end

function LipSyncAlgorithm.melFilterBank(spectrum, length, sampleRate, melDiv)
	local melSpectrum = LipSyncAlgorithm.new(melDiv)

	local fMax = sampleRate / 2
	local melMax = LipSyncAlgorithm.toMel(fMax)
	local nMax = length / 2
	local df = fMax / nMax
	local dMel = melMax / (melDiv + 1)

	local n = 0
	while n < melDiv do
		local melBegin = dMel * n
		local melCenter = dMel * (n + 1)
		local melEnd = dMel * (n + 2)

		local fBegin = LipSyncAlgorithm.toHz(melBegin)
		local fCenter = LipSyncAlgorithm.toHz(melCenter)
		local fEnd = LipSyncAlgorithm.toHz(melEnd)

		local iBegin = math.ceil(fBegin / df)
		local iCenter = math.floor(fCenter / df + 0.5)
		local iEnd = math.floor(fEnd / df)

		local sum = 0
		local index = iBegin + 1
		while index <= iEnd do
			local f = df * index

			local a
			if index < iCenter then
				a = (f - fBegin) / (fCenter - fBegin)
			else
				a = (fEnd - f) / (fEnd - fCenter)
			end

			a = a / (fEnd - fBegin) * 0.5
			sum = sum + a * spectrum[index]

			index = index + 1
		end
		melSpectrum[n] = sum

		n = n + 1
	end

	return melSpectrum, melDiv
end

function LipSyncAlgorithm.powerToDB(data, length)
	local index = 0
	while index < length do
		data[index] = 10.0 * math.log10(data[index])

		index = index + 1
	end
end

function LipSyncAlgorithm.toMel(hz)
	local a = 1127.0
	return a * math.log(hz / 700.0 + 1.0)
end

function LipSyncAlgorithm.toHz(mel)
	local a = 1127.0
	return 700.0 * (math.exp(mel / a) - 1.0)
end

function LipSyncAlgorithm.dct(spectrum, length)
	local cepstrum = LipSyncAlgorithm.new(length)

	local a = math.pi / length

	local i = 0
	while i < length do
		local sum = 0

		local j = 0
		while j < length do
			local ang = (j + 0.5) * i * a
			sum = sum + spectrum[j] * math.cos(ang)

			j = j + 1
		end

		cepstrum[i] = sum

		i = i + 1
	end

	return cepstrum, length
end

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
