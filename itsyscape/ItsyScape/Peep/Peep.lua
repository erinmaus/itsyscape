--------------------------------------------------------------------------------
-- Razmatazz/Peep/Peep.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
-------------------------------------------------------------------------------

local Callback = require "ItsyScape.Common.Callback"
local Class = require "ItsyScape.Common.Class"
local Behavior = require "ItsyScape.Peep.Behavior"

-- Peep type. All objects (static or otherwise) are instances of this type.
--
-- A peep is the equivalent of an entity in an entity-component-system (ECS). In
-- simple terms, it's a collection of components (Behaviors in this case). Peeps
-- with certain combinations of Behaviors are then updated accordingly by
-- matching systems (Cortexes in this case).
local Peep = Class()

function Peep:new()
	self.behaviors = {}
	self.onBehaviorAdded = Callback()
	self.onBehaviorRemoved = Callback()
end

-- Gets the Behavior represented by the value, b.
--
-- If b is a number, then it is considered a Behavior ID. Otherwise, if it's
-- a string, it's considered a name of a Behavior. Lastly, if it's a table, then
-- it's considered a Behavior type.
--
-- Returns nil if no Behavior was found; returns the Behavior instance
-- otherwise.
function Peep:getBehavior(b)
	if type(b) == 'number' then
		return self.behaviors[b]
	elseif type(b) == 'type' then
		return self.behaviors[b.ID]
	elseif type(b) == 'string' then
		return self.behaviors[Behavior.getIDByName(b)]
	else
		return nil
	end
end

-- Returns true if the Peep has the Behavior, false otherwise.
--
-- See Peep.getBehavior for semantics of the b parameter.
function Peep:hasBehavior(b)
	return self:getBehavior(b) ~= nil
end

-- Adds a Behavior.
--
-- Does nothing if the Behavior already exists.
--
-- Any extra arguments are passed to the Behavior constructor, if applicable.
-- If the Behavior already exists, then nothing happens...
--
-- The BehaviorAdded is invoked if the Behavior is added.
--
-- See Peep.getBehavior for semantics of the b parameter.
--
-- Returns true if the Behavior was added (or was already added) and the
-- Behavior instance. Otherwise, returns false.
function Peep:addBehavior(b, ...)
	local behaviorType
	if type(b) == 'number' then
		behaviorType = behaviors.getTypeByID(b)
	elseif type(b) == 'string' then
		behaviorType = behaviors.getTypeByName(b)
	elseif type(b) == 'table' then
		behaviorType = b
	end

	if behaviorType then
		local behavior = self:getBehavior(behaviorType.ID)
		if behavior == nil then
			behavior = behaviorType(...)
			self.behaviors[behaviorType.ID] = behavior

			self.onBehaviorAdded(self, behavior)
		end

		return true, behavior
	else
		return false, nil
	end
end

-- Removes a Behavior.
--
-- Does nothing if the behavior doesn't exist.
--
-- The BehaviorAdded is invoked if the Behavior is removed.
--
-- See Peep.getBehavior for semantics of the b parameter.
--
-- Returns true and the behavior if the behavior was removed, false otherwise.
function Peep:removeBehavior(b)
	local behavior = self:getBehavior(b)
	if behavior ~= nil then
		self.behaviors[behavior.id] = nil
		self.onBehaviorRemoved(self, behavior)

		return true, behavior
	else
		return false
	end
end

-- Returns true if the Peep has all the Behaviors, false otherwise.
--
-- Each argument is treated like the b parameter to Peep.getBehavior.
function Peep:match(...)
	local args = { n = select('#', ...), ... }
	for i = 1, args.n do
		if not self:hasBehavior(args[i]) then
			return false
		end
	end

	return true
end

return Peep
