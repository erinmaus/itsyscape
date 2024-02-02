--------------------------------------------------------------------------------
-- ItsyScape/GameDB/Commands/MetaCategory.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local MetaInstance = require "ItsyScape.GameDB.Commands.MetaInstance"

-- Category for Meta records.
--
-- Like ResourceCategory, new fields are created when a new Meta record is
-- defined. After being defined, a record can be created by calling the
-- corresponding field.
--
-- For example, Meta "Foo" { ... } will created a field "Foo". Then, to
-- construct a Foo instance, simply call Game.Meta.Foo { ... }.
local MetaCategory = Class()

function MetaCategory:new(game)
	self._game = game
	self._metaLookup = {}
	self._metas = {}
end

-- Internal method. Adds a new Meta record definition, 'meta'.
--
-- It is an error to create multiple Meta records with the same name.
function MetaCategory:add(meta)
	local name = meta:getName()
	local records = { definition = meta }

	assert(self[name] == nil, string.format("'%s' already exists", name))

	self[name] = function(t)
		local instance = MetaInstance(meta)
		table.insert(records, instance)

		return instance(t)
	end

	self._metaLookup[name] = records
	self._metaLookup[#self._metas + 1] = name

	table.insert(self._metas, records)
end

function MetaCategory:getNameByIndex(index)
	return self._metaLookup[index]
end

-- Iterates over the fields, return (index, metaInstances).
--
-- 'metaInstances' is an array of MetaInstance.
function MetaCategory:iterate()
	return ipairs(self._metas)
end

return MetaCategory
