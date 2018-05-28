--------------------------------------------------------------------------------
-- ItsyScape/GameDB/Commands/Resource.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Pokeable = require "ItsyScape.GameDB.Commands.Pokeable"

-- Maps to a Mapp.Resource.
local Resource = Class(Pokeable)

-- Constructs a new Resource with the given type and name.
function Resource:new(type, name)
	Pokeable.new(self)

	self.actions = {}
	self.type = type
	self.name = name
	self.isSingleton = false
	self.instance = false
end

-- Defines a resource.
--
-- 't' can the following fields:
--   - isSingle (truthy): marks the Resource as a singleton or not.
--
-- 't' can also have an array of Actions. These Actions are then connected to
-- the Resource when instantiated.
function Resource:poke(t)
	t = t or {}

	if t.isSingleton ~= nil then
		self.isSingleton = t.isSingleton or false
	end

	for i = 1, #t do
		table.insert(self.actions, t[i])
	end
end

function Resource:instantiate(brochure)
	if not self.instance then
		self.instance = brochure:createResource(
			self.type:instantiate(brochure),
			self.name,
			self.isSingleton)

		for i = 1, #self.actions do
			local actionInstance = self.actions[i]:instantiate(brochure)
			brochure:connect(actionInstance, self.instance)
		end
	end

	return self.instance
end

return Resource
