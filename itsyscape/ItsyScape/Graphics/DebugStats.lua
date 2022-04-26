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

function DebugStats:new()
	self.debugStats = {}
end

function DebugStats:measure(node, ...)
	local nodeName = node:getDebugInfo().shortName
	local stat = self.debugStats[nodeName] or { min = math.huge, max = -math.huge, currentTotal = 0, samples = 0 }

	local duration
	do
		local before = love.timer.getTime()
		self:process(node, ...)
		local after = love.timer.getTime()
		duration = after - before
	end

	stat.min = math.min(stat.min, duration)
	stat.max = math.max(stat.max, duration)
	stat.currentTotal = stat.currentTotal + duration
	stat.samples = stat.samples + 1

	self.debugStats[nodeName] = stat
end

function DebugStats:process(node, ...)
	Class.ABSTRACT()
end

function DebugStats:dumpStatsToCSV(topic)
	local suffix = os.date("%Y-%m-%d %H%M%S")
	local filename = string.format("%s %s.csv", topic, suffix)

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
	for i = 1, #sortedDebugStats do
		local stats = sortedDebugStats[i].stats
		local nodeName = sortedDebugStats[i].nodeName
		local f = string.format(
			"%s, %f, %f, %f, %f, %f",
			nodeName, stats.min, stats.max, stats.currentTotal, stats.samples, stats.currentTotal / stats.samples)
		table.insert(stringifiedStats, f)
	end

	local result = table.concat(stringifiedStats, "\n")
	love.filesystem.write(filename, result)

	local url = string.format("%s/%s", love.filesystem.getSaveDirectory(), filename)
	local isWindows = love.system.getOS() == "Windows"
	if isWindows then
		url = url:gsub("/", "\\")
	end
	Log.info("Dumped stats for topic '%s' to \"%s\".", topic, url)
end

return DebugStats
