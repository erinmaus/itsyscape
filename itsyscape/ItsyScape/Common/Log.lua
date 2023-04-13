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

function Log.sendError(message, targetStack)
	if _DEBUG then
		return
	end

	if not targetStack then
		return
	end

	targetStack = targetStack + 1

	local MAX_LENGTH = 512

	if debug.getinfo(targetStack) and debug.getinfo(targetStack).func == error then
		targetStack = targetStack + 1
	end

	local variables = {}

	local localIndex = 1
	while debug.getlocal(targetStack, localIndex) do
		local localName, localValue = debug.getlocal(targetStack, localIndex)

		local r = {
			storage = "local",
			name = localName,
			value = Log.stringify(localValue),
			type = Log.type(localValue)
		}

		if #r.value > MAX_LENGTH then
			r.value = r.value:sub(1, MAX_LENGTH) .. "..."
		end

		if not r.name:match("^%(") then
			table.insert(variables, r)
		end

		localIndex = localIndex + 1
	end

	local upvalueIndex = 1
	local func = debug.getinfo(targetStack) and debug.getinfo(targetStack).func
	while func and debug.getupvalue(func, upvalueIndex) do
		local upvalueName, upvalueValue = debug.getupvalue(func, upvalueIndex)

		r = {
			storage = "upvalue",
			name = upvalueName,
			value = Log.stringify(upvalueValue),
			type = Log.type(upvalueValue)
		}

		if #r.value > MAX_LENGTH then
			r.value = r.value:sub(1, MAX_LENGTH) .. "..."
		end

		table.insert(variables, r)

		upvalueIndex = upvalueIndex + 1
	end

	local NSentry = require "nbunny.sentry"
	NSentry.error(debug.traceback(message, targetStack), variables)
end

function Log.type(value)
	local Class = require "ItsyScape.Common.Class"
	if Class.isClass(value) then
		return value:getDebugInfo().shortName
	else
		return type(value)
	end
end

function Log.boolean(value)
	return (value and "true") or "false"
end

function Log._stringifyClassSimple(value)
	local Class = require "ItsyScape.Common.Class"

	local r = {}

	for k, v in pairs(value) do
		if type(k) == 'string' then
			if Class.isClass(v) then
				table.insert(r, string.format("%s (%s) = { ... }", k, v:getDebugInfo().shortName))
			else
				table.insert(r, string.format("%s = %s", k, Log._stringifyFieldSimple(v)))
			end
		end
	end

	return string.format("{ %s }", table.concat(r, ", "))
end

function Log._stringifyFieldSimple(value)
	if type(value) == 'table' then
		return "{ ... }"
	elseif type(value) == 'string' then
		return string.format("%q", value)
	else
		return tostring(value)
	end
end

function Log.stringify(value)
	local Class = require "ItsyScape.Common.Class"

	if type(value) == 'table' then
		local r = {}

		local hasKeys = false
		for k, v in pairs(value) do
			if type(k) == 'string' then
				hasKeys = true

				if Class.isClass(v) then
					table.insert(r, string.format("%s (%s) = { %s }", k, v:getDebugInfo().shortName, Log._stringifyClassSimple(v)))
				else
					table.insert(r, string.format("%s = %s", k, Log._stringifyFieldSimple(v)))
				end
			end
		end

		if not hasKeys then
			for i = 1, #value do
				local v = value[i]

				if Class.isClass(v) then
					table.insert(r, Log._stringifyClassSimple(v))
				else
					table.insert(r, Log._stringifyFieldSimple(v))
				end
			end
		end
		
		return string.format("{ %s }", table.concat(r, ", "))
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
	if not writeOnly or (_CONF and _CONF.server) then
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
