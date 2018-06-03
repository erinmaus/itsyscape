--------------------------------------------------------------------------------
-- ItsyScape/Peep/Peep.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Callback = require "ItsyScape.Common.Callback"
local Class = require "ItsyScape.Common.Class"
local Behavior = require "ItsyScape.Peep.Behavior"
local CommandQueue = require "ItsyScape.Peep.CommandQueue"

-- Peep type. All objects (static or otherwise) are instances of this type.
--
-- A peep is the equivalent of an entity in an entity-component-system (ECS). In
-- simple terms, it's a collection of components (Behaviors in this case). Peeps
-- with certain combinations of Behaviors are then updated accordingly by
-- matching systems (Cortexes in this case).
local Peep = Class()

-- Total number of Peeps created.
Peep.PEEPS_TALLY = 1

-- Default channel.
Peep.DEFAULT_CHANNEL = 1

function Peep:new(name)
	self.behaviors = {}
	self.onBehaviorAdded = Callback()
	self.onBehaviorRemoved = Callback()

	-- It's a RollerCoaster Tycoon reference.
	self.name = name or string.format("Guest %d", Peep.PEEPS_TALLY)

	Peep.PEEPS_TALLY = Peep.PEEPS_TALLY + 1

	self.isReady = false

	self.commandQueues = {
		[Peep.DEFAULT_CHANNEL] = CommandQueue(self)
	}

	self.director = false
end

-- Assigns a director to this peep.
--
-- This is immediately called after the constructor by Good(tm) directors.
function Peep:assign(director)
	self.director = director
end

-- Gets the director this Peep was assigned to.
function Peep:getDirector()
	return self.director
end

-- Returns the command queue on the provided channel.
--
-- Ideally 'channel' should be an integer though it doesn't matter.
--
-- Don't keep the reference around longer than necessary--if a channel is
-- finished by the time the Peep updates, the queue is discardded.
--
-- 'DEFAULT_CHANNEL' is a reserved value. It follows slightly different
-- semantics than any other channel: references to it are always valid.
function Peep:getCommandQueue(channel)
	channel = channel or Peep.DEFAULT_CHANNEL

	local queue = self.commandQueues[channel]
	if not queue then
		queue = CommandQueue(self)
		self.commandQueues[channel] = queue
	end

	return queue
end

-- Returns the name of the Peep.
--
-- Defaults to "Guest #", where '#' is an incrementing counter.
function Peep:getName()
	return self.name
end

-- Sets the name of peep.
--
-- If value is falsey, this does nothing.
function Peep:setName(value)
	self.name = value or self.name
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
	elseif type(b) == 'table' then
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

-- Called when the Peep is ready.
--
-- This should never be called externally.
function Peep:ready(director, game)
	-- Nothing.
end

-- Updates the Peep.
--
-- There is no guarantee to the order Peeps are updated.
function Peep:update(director, game)
	if not self.isReady then
		self:ready(director, game)
		self.isReady = true
	end

	for _, queue in pairs(self.commandQueues) do
		queue:update(game:getDelta())
	end
end

return Peep
