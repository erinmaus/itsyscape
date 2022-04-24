--------------------------------------------------------------------------------
-- ItsyScape/Graphics/Threads/Resource.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
require "love.timer"

local input = love.thread.getChannel('ItsyScape.Resource.File::input')
local output = love.thread.getChannel('ItsyScape.Resource.File::output')
while true do
	local request
	repeat
		local request = input:pop()
		if request then
			if request.type == 'file' then
				local s = love.filesystem.read(request.filename)
				output:push(s)
			elseif request.type == 'lua' then
				local s = "return " .. love.filesystem.read(request.filename)
				local l = assert(setfenv(loadstring(s), {}))()
				output:push(l)
			elseif request.type == 'quit' then
				return
			end
		end
	until not request

	love.timer.sleep(0)
end
