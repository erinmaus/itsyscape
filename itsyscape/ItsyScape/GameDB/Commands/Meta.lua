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
local Game = require "ItsyScape.GameDB.Commands.Game"
local Pokeable = require "ItsyScape.GameDB.Commands.Pokeable"

-- This maps to Mapp.RecordDefinition.
local Meta = Class(Pokeable)
Meta.TYPE_INTEGER = 0
Meta.TYPE_TEXT = 1
Meta.TYPE_REAL = 2
Meta.TYPE_BLOB = 3
Meta.TYPE_ACTION = 4
Meta.TYPE_RESOURCE = 5

-- Constructs a new Meta with the specified name.
--
-- The expected syntax is as follows:
--
-- Meta "ResourceTag" {
--   Value = Meta.TYPE_TEXT,
--   Resource = Meta.TYPE_RESOURCE
-- }
--
-- This would create a Meta called "ResourceTag" with two columns,
-- Value (a string) and Resource (the Resource it belongs to).
function Meta:new(name)
	self.definition = Mapp.RecordDefinition(name)

	local game = Game.getGame()
	game:addMeta(self)
end

-- Gets the name of the Meta.
function Meta:getName()
	return self.definition.name
end

-- Iterates over the columns in the Meta.
--
-- The order of the columns is unspecified and should not be relied upon.
function Meta:iterate()
	local index = 0

	return function()
		if index < self.definition:count() then
			local columnName = self.definition:getName(index)
			local columnType = self.definition:getType(index)
			index = index + 1

			return columnName, columnType
		end
	end
end

-- Gets the index for the specified column.
function Meta:getIndex(columnName)
	return self.definition:getIndex(columnName)
end

-- Gets the underlying Mapp.RecordDefinition.
function Meta:getDefinition()
	return self.definition
end

-- Creates the RecordDefinition in the Brochure.
function Meta:instantiate(brochure)
	brochure:createRecord(self.definition)

	return true
end

-- Maps columns (keys in 't') to types (values in 't').
--
-- For example, { Resource = Meta.TYPE_RESOURCE } would create a
-- single column, "Resource", which points to a Mapp.Resource.
function Meta:poke(t)
	t = t or {}

	-- XXX: The order the columns are defined in should not matter, since
	-- columns are retrieved by name from the GameDB (see
	-- twoflower/brochure.cpp and twoflower::Brochure::statement_to_record).
	--
	-- However, that's an implementation detail... So this could break.
	--
	-- Thus, also add: TODO HACK
	for column, columnType in pairs(t) do
		self.definition:define(column, columnType)
	end
end

return Meta
