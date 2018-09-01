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
		local f = m:gsub("%$(%b{})", function(ref)
			ref = ref:match("%{(.*)%}")
			local prop = Property(ref)
			return StringBuilder.stringify(prop:get(g or self.g or _G, {}, ref))
		end)

		inflated[i] = f
	end

	return inflated
end

return Message
