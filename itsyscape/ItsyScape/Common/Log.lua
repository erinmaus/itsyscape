--------------------------------------------------------------------------------
-- ItsyScape/Common/Log.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

local debug = require "debug"
local Log = {}

function Log.boolean(value)
	return (value and "true") or "false"
end

function Log.stringify(value)
	if type(value) == 'table' then
		return require("ItsyScape.Common.StringBuilder").stringify(value, '%t')
	else
		return require("ItsyScape.Common.StringBuilder").stringify(value)
	end
end

function Log.profile(...)
	local DebugStats = require "ItsyScape.Graphics.DebugStats"
	DebugStats.GLOBAL:measure(...)
end

function Log.engine(format, ...)
	local s, r = pcall(string.format, format, ...)
	if s then
		Log.print("engine", r)
	else
		Log.error("Error printing `%s`: %s", format, r)
	end
end

function Log.debug(format, ...)
	local s, r = pcall(string.format, format, ...)
	if s then
		Log.print("debug", r)
	else
		Log.error("Error printing `%s`: %s", format, r)
	end
end

local ERRORS = {}
function Log.errorOnce(format, ...)
	local traceback = debug.traceback("...", 2)
	local s, r = pcall(string.format, format, ...)
	if s then
		local key = r .. traceback
		if not ERRORS[key] then
			Log.print("error", r)
			Log.print("traceback", traceback)
			ERRORS[key] = true
		end
	else
		-- At least print something
		Log.print("error", format)
		Log.print("traceback", traceback)
	end
end

function Log.error(format, ...)
	local s, r = pcall(string.format, format, ...)
	if s then
		Log.print("error", r)
	else
		-- At least print something
		Log.print("error", format)
	end

	local traceback = debug.traceback("...", 2)
	Log.print("traceback", traceback)
end

local WARNINGS = {}
function Log.warnOnce(format, ...)
	local s, r = pcall(string.format, format, ...)
	if s then
		if not WARNINGS[r] then
			WARNINGS[r] = true
			Log.print("warning", r)
		end
	else
		Log.error("Error printing `%s`: %s", format, r)
	end
end

function Log.warn(format, ...)
	local s, r = pcall(string.format, format, ...)
	if s then
		Log.print("warning", r)
	else
		Log.error("Error printing `%s`: %s", format, r)
	end
end

function Log.info(format, ...)
	local s, r = pcall(string.format, format, ...)
	if s then
		Log.print("info", r)
	else
		Log.error("Error printing `%s`: %s", format, r)
	end
end

local suffix = _LOG_SUFFIX
local date = os.date("%Y%m%d_%H%M%S")

function Log.setLogSuffix(value)
	suffix = value
end

function Log.getLogFilename()
	if suffix then
		return string.format("Logs/%s__%s.log", date, suffix)
	else
		return string.format("Logs/%s.log", date)
	end
end

function Log.print(scope, message)
	local s
	if scope and type(scope) == 'string' then
		s = string.format(" [%s]: ", string.lower(scope))
	else
		s = ": "
	end

	local formattedMessage = table.concat({ os.date(), s, message, "\n" }, "")
	Log.write(formattedMessage, scope == "debug" or scope == "engine")
end

function Log.write(message, writeOnly)
	if not writeOnly then
		io.stderr:write(message)
	end

	local logDirectoryInfo = love.filesystem.getInfo("Logs")
	if not logDirectoryInfo then
		love.filesystem.createDirectory("Logs")
	elseif logDirectoryInfo.type ~= "directory" then
		love.filesystem.remove("Logs")
		love.filesystem.createDirectory("Logs")
	end

	love.filesystem.append(Log.getLogFilename(), message)
end

function Log.quit()
	local url = string.format("%s/%s", love.filesystem.getSaveDirectory(), Log.getLogFilename())

	if suffix then
		Log.info("Saved '%s' log to '%s'.", suffix, url)
	else
		Log.info("Saved log to '%s'.", url)
	end
end

return Log
