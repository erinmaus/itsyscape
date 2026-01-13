--------------------------------------------------------------------------------
-- ItsyScape/mem.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local json = require "json"
local NLuaRuntime = require "nbunny.luaruntime"

local mem = {}

function mem:start()
	mem.info = nil
	NLuaRuntime.startProfile()
end

function mem:stop()
	mem.info = NLuaRuntime.stopProfile()
end

local function _sort(a, b)
	if a.memory == b.memory then
		if a.time == b.time then
			return a.id < b.id
		end

		return a.time > b.time
	end

	return a.memory > b.memory
end

function mem:dump(filename)
	if not mem.info then
		return
	end

	filename = filename or string.format("memory-%s.json", os.date("%Y%m%d_%H%M%S"))

	table.sort(mem.info, _sort)
	for _, info in ipairs(mem.info) do
		table.sort(info.calls, _sort)

		for _, call in ipairs(info.calls) do
			table.sort(call.unique, _sort)
		end
	end

	love.filesystem.write(filename, json.encode(mem.info))
	Log.info("Dumped memory profiling info to '%s/%s'.", love.filesystem.getSaveDirectory(), filename)
end

return mem

