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

-- To change priority within a category, subtract to increase, add to decrease.
--
-- For example, if you want to be slightly less accessible than LOCAL priority,
-- add 1. To be slightly more accessible, subtract 1.
--
-- Each category has a width of 100.
--
-- Priority is cached. It should constant per type, not per instance.
State.PRIORITY_COSMIC    = 300 -- For things really far away. (???)
State.PRIORITY_DISTANT   = 200 -- For things pretty far away, like banks.
State.PRIORITY_LOCAL     = 100 -- For things nearby, like inventory.
State.PRIORITY_IMMEDIATE =   0 -- For things *really* nearby, like equipment.

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
	table.sort(p, function(a, b) return a:getPriority() < b:getPriority() end)
end

function State:removeProvider(resource, provider)
	local p = self.providers[resource]
	if p then
		for i = 1, #p do
			if p[i] == provider then
				table.remove(p, i)
				return true
			end
		end
	end

	return false
end

function State:has(resource, name, count, flags)
	flags = flags or {}

	local p = self.providers[resource]
	if not p then
		return false
	end

	for i = 1, #p do
		if p[i]:has(name, count, flags) then
			return true, p[i]
		end
	end

	return false, nil
end

function State:take(resource, name, count, flags)
	flags = flags or {}

	local p = self.providers[resource]
	if not p then
		return false
	end

	for i = 1, #p do
		if p[i]:take(name, count, flags) then
			return true, p[i]
		end
	end

	return false
end

function State:count(resource, name, flags)
	flags = flags or {}

	local p = self.providers[resource]
	if not p then
		return false
	end

	local count = 0
	for i = 1, #p do
		count = count + p[i]:count(name, flags)
	end

	return count
end

function State:give(resource, name, count, flags)
	flags = flags or {}

	local p = self.providers[resource]
	if not p then
		return false
	end

	for i = 1, #p do
		if p[i]:give(name, count, flags) then
			return true, p[i]
		end
	end

	return false
end

return State
