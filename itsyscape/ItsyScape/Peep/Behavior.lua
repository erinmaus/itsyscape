--------------------------------------------------------------------------------
-- ItsyScape/Peep/Behavior.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
-------------------------------------------------------------------------------

local Class = require "ItsyScape.Common.Class"

-- Behavior database.
--
-- A behavior is equivalent to a component in an entity-componet-system (ECS);
-- in simple terms, it's a logicless collection of values that represent some
-- concept. For example, a HealthBehavior could have a few values:
-- currentHealth, maxhealth, etc.
local Behaviors = {
	byName = {},
	byID = {},
	byType = {},
	currentID = 1
}

-- Behavior module.
local Behavior = {}

-- Invalid ID constant.
--
-- No valid Behavior will ever have this ID.
Behavior.INVALID_ID = 0

-- Behavior type. All Behaviors inherit from this type.
--
-- It doesn't do much outside of expose utility methods for cortexes (systems in
-- an ECS).
Behavior.Type = Class()
function Behavior.Type:new()
	self.id = Behaviors.byType[self:getType()]
end

-- Constructs a new Behavior type.
--
-- The behavior is given the name 'name' and registered in the database.
-- If a behavior with the given name exists, it is returned.
local function __call(self, name)
	local Type = Behaviors.byName[name]
	if Type then
		return Type
	else
		Type = Class(Behavior.Type)
	end

	local id = Behaviors.currentID
	Behaviors.currentID = Behaviors.currentID + 1

	Behaviors.byName[name] = Type
	Behaviors.byID[id] = Type
	Behaviors.byType[Type] = id

	Type.NAME = name
	Type.ID = id

	return Type
end

-- Gets a Behavior type by name. If no behavior is found with the provided name,
-- returns nil.
function Behavior.getTypeByName(name)
	return Behaviors.byName[name]
end

-- Gets a Behavior type by ID. If no behavior is found with the provided ID,
-- returns nil.
function Behavior.getTypeByID(id)
	return Behaviors.byID[id]
end

-- Gets a Behavior ID from a name. If no Behavior with the given name exists,
-- returns 0.
function Behavior.getIDFromName(name)
	local t = Behaviors.byName[name]
	if t then
		return Behaviors.byType[t]
	else
		return 0
	end
end

return setmetatable(Behavior, { __call = __call })
