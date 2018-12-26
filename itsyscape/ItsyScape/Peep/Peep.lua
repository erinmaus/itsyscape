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
local State = require "ItsyScape.Game.State"
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
	self.index = Peep.PEEPS_TALLY

	Peep.PEEPS_TALLY = Peep.PEEPS_TALLY + 1

	self.isReady = false

	self.commandQueues = {
		[Peep.DEFAULT_CHANNEL] = CommandQueue(self)
	}

	self.director = false
	self.layerName = "::orphan"

	self.pokes = {}

	self.resources = {}

	self.effects = {}

	self.state = State()

	self:addPoke('ready')
	self:addPoke('assign')
	self:addPoke('move')
	self:addPoke('finalize')
	self:addPoke('reaper')
	self:addPoke('poof')
	self:addPoke('effectAdded')
	self:addPoke('effectRemoved')
	self:addPoke('command')
end

-- Adds a poke 'name'.
--
-- A poke is a synonym for an event.
--
-- If 'name' exists, nothing happens.
--
-- Returns the poke.
function Peep:addPoke(name)
	if self.pokes[name] == nil then
		self.pokes[name] = Callback()
	end

	return self.pokes[name]
end

-- Returns true if the poke 'name' exists, false otherwise.
function Peep:hasPoke(name)
	return self.pokes[name] ~= nil
end

-- Registers the callback 'c' with the poke 'name'. Any extra arguments are
-- associated with the registration.
--
-- This is synonymous with Callback.register.
--
-- Returns true on success, false otherwise. Failure occurs if there is no poke
-- 'name'.
function Peep:listen(name, c, ...)
	if self.pokes[name] then
		self.pokes[name]:register(c, ...)

		return true
	end

	return false
end

-- Unregisters the callback 'c' with the poke 'name'.
--
-- This is synonymous with Callback.unregister.
--
-- Does nothing if 'poke' does not exist or 'c' was not registered.
function Peep:silence(name, c)
	if self.pokes[name] then
		self.pokes[name]:unregister(c)
	end
end

-- Pokes the peep.
--
-- 'name' is expected to be camel case (e.g., fooBar). It is transformed into the
-- form "onFooBar". If a method on the Peep exists with the name, then it is
-- invoked.
--
-- If a poke with the name 'event' exists, it is also invoked.
--
-- Any extra arguments ('...') are passed on to the method and/or pokes.
function Peep:poke(name, ...)
	local callback = "on" .. name:sub(1, 1):upper() .. name:sub(2)

	if self[callback] then
		self[callback](self, ...)
	end

	if self.pokes[name] then
		self.pokes[name](self, ...)
	end
end

-- Adds or replaces the CacheRef 'ref' to the resource 'name'.
--
-- 'index' defaults to 1. If 'index' is not a number, it also defaults to 1.
--
-- 'name' is unique per the type of CacheRef; for example, there can be an
-- "attack" resource for both a ItsyScape.Game.Skin.ModelSkin and
-- ItsyScape.Graphics.AnimationResource.
function Peep:addResource(name, ref, index)
	local r = self.resources[ref:getResourceTypeID()]
	if not r then
		r = {}
		self.resources[ref:getResourceTypeID()] = r
	end

	index = index or 1
	if type(index) ~= 'number' then
		index = 1
	end

	local subR = r[name]
	if not subR then
		subR = {}
		r[name] = subR
	end

	subR[index] = ref
end

-- Gets a resource 'name' belonging to the category 'resourceTypeID'.
--
-- 'index' defaults to 1.
--
-- See Peep.addResource.
function Peep:getResource(name, resourceTypeID, index)
	local r = self.resources[resourceTypeID]
	if r then
		index = index or 1
		local subR = r[name]
		if subR then
			return subR[index]
		end
	end

	return nil
end

-- Gets all resources associated with 'name' belonging to the category
-- 'resourceTypeID'.
--
-- The return value is an iterator. The iterator returns (index, resource).
-- There is no logic to the order the resources are returned in, since the
-- collection can be sparse. (Implementation detail: it's just pairs, not
-- ipairs).
function Peep:getResources(name, resourceTypeID)
	local r = self.resources[resourceTypeID]
	if r then
		return pairs(r)
	else
		return function() return nil end
	end
end

-- Gets the game state of the Peep.
function Peep:getState()
	return self.state
end

-- Returns the layer name.
function Peep:getLayerName()
	return self.layerName
end

-- Assigns a director to this peep.
--
-- This is immediately called after the constructor by Good(tm) directors.
function Peep:assign(director, key)
	self.director = director
	self.layerName = key or self.layerName
	
	if key == nil or type(key) ~= 'string' then
		Log.error("Bad key for peep: %s", tostring(key))
	end

	self:poke('assign', director, key)
end

function Peep:move(director, key)
	self.layerName = key or self.layerName

	self:poke('move', key)
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
-- finished by the time the Peep updates, the queue is discarded.
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

function Peep:getTally()
	return self.index
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
		return self.behaviors[Behavior.getIDFromName(b)]
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
		Log.error("invalid type '%s' for behavior", type(b))
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

-- Adds an Effect to the Peep.
function Peep:addEffect(effect)
	if not self.effects[effect] and not effect:isApplied() then
		self.effects[effect] = true
		effect:enchant(self)

		self:poke('effectAdded', effect)
	end
end

-- Removes an Effect from the peep.
function Peep:removeEffect(effect)
	if self.effects[effect] then
		self.effects[effect] = nil
		effect:sizzle()

		self:poke('effectRemoved', effect)
	end
end

-- Iterates over effects applied to the peep, optionally of type 'EffectType'.
function Peep:getEffects(EffectType)
	local effect
	return function()
		effect = next(self.effects, effect)
		while effect ~= nil
		      and EffectType ~= nil and
		      not Class.isCompatibleType(effect, EffectType)
		do
			effect = next(self.effects, effect)
		end

		return effect
	end
end

-- Returns the first effect of 'EffectType'.
function Peep:getEffect(EffectType)
	return self:getEffects(EffectType)()
end

-- Called when the Peep is ready.
--
-- This should never be called externally.
function Peep:ready(director, game)
	self:poke('ready', director, game)
	self:poke('finalize', director, game)
	self.finalized = true
end

-- Returns true if the Peep was poofed, false otherwise.
function Peep:wasPoofed()
	return self.poofed == true
end

-- Called when the Peep is removed.
function Peep:poof()
	for _, behavior in pairs(self.behaviors) do
		behavior:unload(self)
	end

	self:poke('poof')

	self.poofed = true
end

-- Called before cortexes are updated.
function Peep:preUpdate(director, game)
	if not self.isReady then
		self:ready(director, game)
		self.isReady = true
	end
end

-- Updates the Peep.
--
-- There is no guarantee to the order Peeps are updated.
function Peep:update(director, game)
	for _, queue in pairs(self.commandQueues) do
		queue:update(game:getDelta())
	end

	do
		-- If an Effect sizzles while updating, bad things happen since you
		-- can't modify a table you're iterating.
		--
		-- So create a lazy clone of the effects table. Aside: might be performance
		-- bottleneck if there's a lot of effects on a lot of Peeps.

		local effects = self.effects
		self.effects = {}

		for effect in pairs(effects) do
			self.effects[effect] = true

			effect:update(game:getDelta())
		end
	end
end

return Peep
