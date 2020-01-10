--------------------------------------------------------------------------------
-- ItsyScape/Game/Dialog/Message.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local StringBuilder = require "ItsyScape.Common.StringBuilder"
local Property = require "ItsyScape.UI.Property"

local Message = Class()
Message.COLORS = {
	location = { 0, 0.5, 1.0, 1 },
	item = { 0.5, 1, 0, 1 },
	person = { 1, 0.0, 0, 1 },
	hint = { 1, 1, 0, 1 },
	empty = { 0.3, 0.3, 0.3, 1 },
}
Message.DEFAULT_COLOR = { 1, 1, 1, 1 }
Message.ERROR_COLOR = { 0, 0, 0, 1 }

function Message:new(t, g)
	if type(t) == 'string' then
		t = { t }
	end

	self.message = {}
	for i = 1, #t do
		self.message[i] = t[i]
	end

	self.g = g or false
end

function Message:inflate(g)
	local inflated = {}
	for i = 1, #self.message do
		local m = self.message[i]
		local c = {}

		local current = 1
		repeat
			local colorStart, colorEnd, color, text = m:find("%%(%w+)(%b{})", current)
			if colorStart and colorEnd then
				if colorStart ~= current then
					table.insert(c, Message.DEFAULT_COLOR)
					table.insert(c, m:sub(current, colorStart - 1))
				end

				table.insert(c, Message.COLORS[color] or Message.ERROR_COLOR)
				table.insert(c, text:sub(2, -2))

				current = colorEnd + 1
			else
				table.insert(c, Message.DEFAULT_COLOR)
				table.insert(c, m:sub(current))
				current = #m + 1
			end
		until current > #m

		for j = 2, #c, 2 do
			c[j] = c[j]:gsub("%$(%b{})", function(ref)
				ref = ref:match("%{(.*)%}")
				local prop = Property(ref)
				return StringBuilder.stringify(prop:get(g or self.g or _G, {}, ref))
			end)
		end

		inflated[i] = c
	end

	return inflated
end

return Message
