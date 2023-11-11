--------------------------------------------------------------------------------
-- ItsyScape/GameDB/Meta.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Action = require "ItsyScape.GameDB.Commands.Action"
local Pokeable = require "ItsyScape.GameDB.Commands.Pokeable"
local Resource = require "ItsyScape.GameDB.Commands.Resource"

local MetaInstance = Class(Pokeable)

function MetaInstance:new(meta, t)
	self.meta = meta
	self.definition = meta:getDefinition()
	self.instance = false
	self.values = {}

	local info = debug.getinfo(4, "Sl")
	self.debugInfo = info

	if t ~= nil then
		self:poke(t)
	end
end

function MetaInstance:instantiate(brochure)
	if not self.instance then
		self.instance = Mapp.Record(self.definition)
		for key, value in pairs(self.values) do
			local v
			if Class.isType(value, Action) then
				v = value:instantiate(brochure)
			elseif Class.isType(value, Resource) then
				v = value:instantiate(brochure)
			else
				v = value
			end

			self.instance:set(key, v)
		end

		local s, e = pcall(function() brochure:insert(self.definition, self.instance) end)
		if not s then
			local message = string.format("%s:%d: Could not insert Meta ('%s') from: %s", self.debugInfo.source, self.debugInfo.currentline, self.meta:getName(), Log.stringify(self.values))
			ItsyScape.Error(message)
		end
	end

	return self.instance
end

-- Assigns values from 't' to columns in the underlying record.
--
-- Only values with string keys from 't' are assigned.
function MetaInstance:poke(t)
	t = t or {}

	for key, value in pairs(t) do
		if type(key) == 'string' then
			self.values[key] = value
		end
	end
end

return MetaInstance
