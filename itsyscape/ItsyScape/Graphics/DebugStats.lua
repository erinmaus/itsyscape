--------------------------------------------------------------------------------
-- ItsyScape/Graphics/DebugStats.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"

local DebugStats = Class()
DebugStats._STACK = {}

DebugStats.GlobalDebugStats = Class(DebugStats)

function DebugStats.GlobalDebugStats:process(node, func, ...)
	return func(...)
end

function DebugStats:new()
	self.previousDebug = false
	self.debugStats = {}
end

function DebugStats:measure(node, ...)
	if not _DEBUG then
		return self:process(node, ...)
	end

	local nodeName
	if type(node) == "string" then
		nodeName = node
	else
		nodeName = node:getDebugInfo().shortName
	end

	if self.previousDebug ~= _DEBUG then
		self.debugStats[nodeName] = nil
		self.previousDebug = _DEBUG
	end

	local beforeStat = collectgarbage("count")
	local stat = self.debugStats[nodeName] or {
		minTime = math.huge,
		maxTime = -math.huge,
		minMemory = math.huge,
		maxMemory = -math.huge,
		currentTimeTotal = 0,
		currentMemoryTotal = 0,
		currentMemoryTime = 0,
		sampleCount = 0,
		samples = {}
	}
	local afterStat = collectgarbage("count")

	local duration, memory, result
	do
		local beforeMemory, afterMemory
		local beforeTime = love.timer.getTime()

		if _DEBUG == "plus" then
			collectgarbage("stop")
			beforeMemory = collectgarbage("count")
		end

		table.insert(DebugStats._STACK, stat)
		result = self:process(node, ...)
		table.remove(DebugStats._STACK)

		local afterTime = love.timer.getTime()

		if _DEBUG == "plus" then
			afterMemory = collectgarbage("count")
			collectgarbage("restart")
		end

		duration = afterTime - beforeTime
		memory = (afterMemory or 0) - (beforeMemory or 0)
	end

	stat.minTime = math.min(stat.minTime, duration)
	stat.maxTime = math.max(stat.maxTime, duration)
	stat.minMemory = math.min(stat.minMemory, memory)
	stat.maxMemory = math.max(stat.maxMemory, memory)
	stat.currentTimeTotal = stat.currentTimeTotal + duration
	stat.currentMemoryTotal = stat.currentMemoryTotal + memory
	stat.sampleCount = stat.sampleCount + 1

	local beforeSample = collectgarbage("count")
	if _DEBUG == "plus" then
		local currentSampleTime = love.timer.getTime() - Log.START
		local firstSampleTime = stat.samples[1] and stat.samples[1].time or 0

		stat.currentMemoryTime = currentSampleTime - firstSampleTime

		table.insert(stat.samples, { time = currentSampleTime, duration = duration, memory = memory })
	end
	local afterSample = collectgarbage("count")

	self.debugStats[nodeName] = stat

	if _DEBUG == "plus" then
		for _, parent in ipairs(DebugStats._STACK) do
			local a = afterStat - beforeStat
			local b = beforeSample - afterSample
			parent.currentMemoryTotal = parent.currentMemoryTotal - (a + b)
		end
	end

	return result
end

function DebugStats:process(node, ...)
	Class.ABSTRACT()
end

function DebugStats:dumpStatsToCSV(topic)
	local suffix = os.date("%Y-%m-%d %H%M%S")
	local filename = string.format("Performance/%s %s.csv", topic, suffix)

	local sortedDebugStats = {}
	do
		local unsortedDebugStats = self.debugStats
		for nodeName, stats in pairs(unsortedDebugStats) do
			table.insert(sortedDebugStats, {
				nodeName = nodeName,
				stats = stats
			})
		end

		table.sort(sortedDebugStats, function(a, b)
			return a.nodeName < b.nodeName
		end)
	end

	local stringifiedStats = {}
	table.insert(stringifiedStats, "Node, Min Time (ms), Max Time (ms), Min Memory (kbs), Max Memory (kbs), Total Time (secs), Total Memory (kbs), Total Samples, Total Memory Samples, Avg Time (ms), Avg Mem (kb), Avg Mem (kb/s)")

	for i = 1, #sortedDebugStats do
		local stats = sortedDebugStats[i].stats
		local nodeName = sortedDebugStats[i].nodeName
		local f = string.format(
			"%s, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f",
			nodeName,
			stats.minTime * 1000,
			stats.maxTime * 1000,
			stats.minMemory,
			stats.maxMemory,
			stats.currentTimeTotal,
			stats.currentMemoryTotal,
			stats.sampleCount,
			#stats.samples,
			(stats.currentTimeTotal / stats.sampleCount) * 1000,
			stats.currentMemoryTotal / math.max(#stats.samples, 1),
			stats.currentMemoryTime > 0 and (stats.currentMemoryTotal / stats.currentMemoryTime) or 0)
		table.insert(stringifiedStats, f)
	end

	local result = table.concat(stringifiedStats, "\n")
	love.filesystem.createDirectory("Performance")
	love.filesystem.write(filename, result)

	local url = string.format("%s/%s", love.filesystem.getSaveDirectory(), filename)
	local isWindows = love.system.getOS() == "Windows"
	if isWindows then
		url = url:gsub("/", "\\")
	end
	Log.info("Dumped stats for topic '%s' to \"%s\".", topic, url)

	for i = 1, #sortedDebugStats do
		local stats = sortedDebugStats[i].stats
		local nodeName = sortedDebugStats[i].nodeName

		if #stats.samples > 0 then
			local samplesFilename = string.format("Performance/%s %s Samples %d.csv", topic, suffix, i)
			local stringifiedSamples = {}
			table.insert(stringifiedSamples, "Timestamp, Node, Time (ms), Memory (kbs)")
			for _, sample in ipairs(stats.samples) do
				local f = string.format(
					"%0.7f, %s, %f, %f",
					sample.time,
					nodeName,
					sample.duration * 1000,
					sample.memory)
				table.insert(stringifiedSamples, f)
			end

			local samplesResult = table.concat(stringifiedSamples, "\n")
			love.filesystem.write(samplesFilename, samplesResult)
		end
	end
end

DebugStats.GLOBAL = DebugStats.GlobalDebugStats()

return DebugStats
