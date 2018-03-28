--------------------------------------------------------------------------------
-- ItsyScape/Game/Model/Stage.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
-------------------------------------------------------------------------------

local Class = require "ItsyScape.Common.Class"
local Callback = require "ItsyScape.Common.Callback"

-- Represents a high-level view of the world.
--
-- The world includes by things like collision, physics, and map data.
local Stage = Class()

-- The constant representing the cell size of a Map.
Stage.CELL_SIZE = 2

function Stage:new()
	self.onLoadMap = Callback()
	self.onUnloadMap = Callback()
	self.onMapModified = Callback()
	self.onActorSpawned = Callback()
	self.onActorKilled = Callback()
end

-- Spawns an Actor.
--
-- If the Actor was spawned, invokes onActorSpawned with the Actor.
--
-- Returns true if the Actor was spawned, plus the Actor. Returns false if the
-- actor could not be spawned.
function Stage:spawnActor(actorID)
	return Class.ABSTRACT()
end

-- Kills the actor.
--
-- Kill, in this case, means removed from the game; i.e., the opposite of spawn.
--
-- If the Actor was killed, invokes onActorKilled with the Actor.
function Stage:killActor(actor)
	Class.ABSTRACT()
end

-- Loads a map from the file pointed to by 'filename'.
--
-- If a map is loaded, first unloads the map.
--
-- Calls the onLoadMap callback with the map. Also calls onMapModified.
--
-- Returns true if the map was loaded and the Map instance; otherwise,
-- returns false plus an error message.
function Stage:loadMapFromFile(filename)
	return Class.ABSTRACT()
end

-- Creates a new Map with the provided dimensions.
--
-- If a map is loaded, first unloads the map.
--
-- Calls onLoadMap with the map. Calls onMapModified.
--
-- Returns true on success and the Map instance; otherwise, returns false plus
-- an error message.
function Stage:newMap(width, height)
	return Class.ABSTRACT()
end

-- Notifies the Stage that the map has been updated.
--
-- Invokes the onMapModified callback with the Map instance.
function Stage:updateMap()
	Class.ABSTRACT()
end

-- Unloads the current map.
--
-- Does nothing if no map is loaded.
function Stage:unloadMap()
	Class.ABSTRACT()
end

-- Returns current Map instance, if loaded; false otherwise.
function Stage:getMap()
	return Class.ABSTRACT()
end

-- Returns a Vector with the gravitational force of the world.
function Stage:getGravity()
	return Class.ABSTRACT()
end

-- Sets the gravitational force to the provided value.
function Stage:setGravity(value)
	Class.ABSTRACT()
end

return Stage
