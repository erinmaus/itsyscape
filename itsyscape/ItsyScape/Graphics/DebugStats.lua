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

DebugStats.GlobalDebugStats = Class(DebugStats)

function DebugStats.GlobalDebugStats:process(node, func, ...)
	return func(...)
end

function DebugStats:new()
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

	local stat = self.debugStats[nodeName] or {
		minTime = math.huge,
		maxTime = -math.huge,
		minMemory = math.huge,
		maxMemory = -math.huge,
		currentTimeTotal = 0,
		currentMemoryTotal = 0,
		samples = 0 
	}

	local duration, memory, result
	do
		local beforeTime = love.timer.getTime()
		collectgarbage("stop")
		local beforeMemory = collectgarbage("count")
		result = self:process(node, ...)
		local afterTime = love.timer.getTime()
		local afterMemory = collectgarbage("count")
		collectgarbage("restart")
		duration = afterTime - beforeTime
		memory = afterMemory - beforeMemory
	end

	stat.minTime = math.min(stat.minTime, duration)
	stat.maxTime = math.max(stat.maxTime, duration)
	stat.minMemory = math.min(stat.minMemory, memory)
	stat.maxMemory = math.max(stat.maxMemory, memory)
	stat.currentTimeTotal = stat.currentTimeTotal + duration
	stat.currentMemoryTotal = stat.currentMemoryTotal + memory
	stat.samples = stat.samples + 1

	self.debugStats[nodeName] = stat

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
	table.insert(stringifiedStats, "Node, Min Time (ms), Max Time (ms), Min Memory (kbs), Max Memory (kbs), Total Time (secs), Total Memory (kbs), Samples, Avg Time (ms), Avg Mem (kb)")

	for i = 1, #sortedDebugStats do
		local stats = sortedDebugStats[i].stats
		local nodeName = sortedDebugStats[i].nodeName
		local f = string.format(
			"%s, %f, %f, %f, %f, %f, %f, %f, %f, %f",
			nodeName,
			stats.minTime * 1000,
			stats.maxTime * 1000,
			stats.minMemory,
			stats.maxMemory,
			stats.currentTimeTotal,
			stats.currentMemoryTotal,
			stats.samples,
			(stats.currentTimeTotal / stats.samples) * 1000,
			stats.currentMemoryTotal / stats.samples)
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
end

DebugStats.GLOBAL = DebugStats.GlobalDebugStats()

return DebugStats
