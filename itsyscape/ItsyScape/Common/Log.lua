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

function Log.profile(...)
	local DebugStats = require "ItsyScape.Graphics.DebugStats"
	DebugStats.GLOBAL:measure(...)
end

function Log.debug(format, ...)
	if not _DEBUG then
		return
	end

	local s, r = pcall(string.format, format, ...)
	if s then
		Log.print("debug", r)
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
	end
end

function Log.warn(format, ...)
	local s, r = pcall(string.format, format, ...)
	if s then
		Log.print("warning", r)
	end
end

function Log.info(format, ...)
	local s, r = pcall(string.format, format, ...)
	if s then
		Log.print("info", r)
	end
end

function Log.print(scope, message)
	local s
	if scope and type(scope) == 'string' then
		s = string.format(" [%s]: ", string.lower(scope))
	else
		s = ": "
	end

	io.stderr:write(os.date(), s, message, "\n")
end

return Log
