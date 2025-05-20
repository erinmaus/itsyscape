--------------------------------------------------------------------------------
-- ItsyScape/Graphics/Threads/Resource.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local buffer = require "string.buffer"

_INDEX = ...
_LOG_SUFFIX = _INDEX and string.format("Resource-%d", _INDEX) or "Resource"

require "bootstrap"
require "love.timer"

local input = love.thread.getChannel("ItsyScape.Resource.File::input")
local output = love.thread.getChannel("ItsyScape.Resource.File::output")
while true do
	local request = input:demand()
	if not request then
		break
	end

	Log.engine("Resource thread %d received a request %d for file '%s'.", _INDEX or 0, request.id or -1, request.filename or "n/a")

	local before = love.timer.getTime()
	if request.type == "file" then
		if not love.filesystem.getInfo(request.filename) then
			Log.warn("Filename '%s' not found!", request.filename)
		end

		local s = love.filesystem.read(request.filename)
		output:push({ type = request.type, id = request.id, value = s or "" })
	elseif request.type == "image" then
		if not love.filesystem.getInfo(request.filename) then
			Log.warn("Image '%s' not found!", request.filename)
		end

		local s = love.image.newImageData(request.filename)
		output:push({ type = request.type, id = request.id, value = s })
	elseif request.type == "lua" then
		if not love.filesystem.getInfo(request.filename) then
			Log.warn("Filename '%s' not found!", request.filename)
		end

		local l
		do
			local cacheFilename = request.filename .. ".cache"
			local hasCache = love.filesystem.getInfo(cacheFilename)
			if hasCache then
				local b = love.timer.getTime()
				l = { type = request.type, id = request.id, table = love.filesystem.read(cacheFilename) }
				local a = love.timer.getTime()
				Log.engine("Loaded cache file '%s' in %.2f ms.", cacheFilename, (a - b) * 1000)
			else
				local b = love.timer.getTime()
				local file = love.filesystem.read(request.filename)
				s, e = loadstring("return " .. (file or "nil"))
				l = { type = request.type, id = request.id, table = buffer.encode(assert(setfenv(s, {}))() or {}) }
				local a = love.timer.getTime()
				Log.engine("Loaded Lua file '%s' in %.2f ms.", cacheFilename, (a - b) * 1000)
			end
		end

		output:push(l or {})
	elseif request.type == "quit" then
		return
	end

	local after = love.timer.getTime()
	Log.engine("Resource thread %d request %d took %.2f ms.", _INDEX or 0, request.id or -1, (after - before) * 1000)
end
