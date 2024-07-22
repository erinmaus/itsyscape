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

require "bootstrap"
require "love.timer"

local input = love.thread.getChannel('ItsyScape.Resource.File::input')
local output = love.thread.getChannel('ItsyScape.Resource.File::output')
while true do
	local request
	repeat
		local request = input:pop()
		if request then
			if request.filename then
				local oldFilename
				local newFilename = request.filename

				repeat
					oldFilename = newFilename
					newFilename = oldFilename:gsub("(.+)/.+/%.%./", "%1/")
				until oldFilename == newFilename

				request.filename = newFilename
			end

			if request.type == 'file' then
				if not love.filesystem.getInfo(request.filename) then
					Log.warn("Filename '%s' not found!", request.filename)
				end

				local s = love.filesystem.read(request.filename)
				output:push({ id = request.id, value = s or "" })
			elseif request.type == 'lua' then
				if not love.filesystem.getInfo(request.filename) then
					Log.warn("Filename '%s' not found!", request.filename)
				end

				local l
				do
					local cacheFilename = request.filename .. ".cache"
					local hasCache = love.filesystem.getInfo(cacheFilename)
					if hasCache then
						l = { id = request.id, table = love.filesystem.read(cacheFilename) }
					else
						local file = love.filesystem.read(request.filename)
						s, e = loadstring("return " .. (file or "nil"))
						l = { id = request.id, table = buffer.encode(assert(setfenv(s, {}))() or {}) }
					end
				end

				output:push(l or {})
			elseif request.type == 'quit' then
				return
			end
		end
	until not request

	love.timer.sleep(0.001)
end
