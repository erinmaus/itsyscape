--------------------------------------------------------------------------------
-- ItsyScape/Game/State.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"

local State = Class()

function State:new()
	self.providers = {}
end

function State:addProvider(resource, provider)
	local p = self.providers[resource]
	if not p then
		p = {}
		self.providers[resource] = p
	end

	table.insert(p, provider)
end

function State:has(resource, name, count, flags)
	local p = self.providers[resource]
	if not p then
		return false
	end

	for i = 1, #p do
		if p:has(name, count, flags) then
			return true
		end
	end
end

return State
