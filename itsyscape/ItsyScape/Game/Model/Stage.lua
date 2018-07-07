--------------------------------------------------------------------------------
-- ItsyScape/Game/Model/Stage.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
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
	self.onDropItem = Callback()
	self.onTakeItem = Callback()

	-- (group, value [nil/Decoration])
	self.onDecorate = Callback()
end

-- Spawns an Actor.
--
-- If the Actor was spawned, invokes onActorSpawned with the actorID and Actor.
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

-- Loads a map from the file pointed to by 'filename' into the layer using the
-- specified tile set ID.
--
-- If a map is loaded, first unloads the map.
--
-- Calls the onLoadMap callback with the map and layer. Also calls onMapModified.
--
-- Returns true if the map was loaded and the Map instance; otherwise,
-- returns false plus an error message.
function Stage:loadMapFromFile(filename, layer, tileSetID)
	return Class.ABSTRACT()
end

-- Creates a new Map with the provided dimensions into the layer using the
-- specified tile set ID.
--
-- If a map is loaded, first unloads the map.
--
-- Calls onLoadMap with the map. Calls onMapModified.
--
-- Returns true on success and the Map instance; otherwise, returns false plus
-- an error message.
function Stage:newMap(width, height, layer, tileSetID)
	return Class.ABSTRACT()
end

-- Notifies the Stage that the map at the specified layer has been updated.
--
-- Invokes the onMapModified callback with the Map instance and layer.
function Stage:updateMap(layer)
	Class.ABSTRACT()
end

-- Unloads the current map at the specified layer.
--
-- Does nothing if no map is loaded.
function Stage:unloadMap(layer)
	Class.ABSTRACT()
end

-- Returns current Map instance at the layer, if loaded; false otherwise.
function Stage:getMap(layer)
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

-- Gets the items at the tile.
--
-- Returns an array with tables in the form:
--   * ref (number): unique reference to the item on the tile
--   * id (string): ID of the item in small form (e.g., AmuletOfYendor)
--   * count (number): number of the items in the stack
--   * noted: whether or not the item is noted or not 
function Stage:getItemsAtTile(i, j, layer)
	return Class.ABSTRACT()
end

-- Takes the item with 'ref' at the provided tile.
--
-- Does nothing if the item doesn't exist.
function Stage:takeItem(i, j, layer, ref)
	Class.ABSTRACT()
end

-- Returns an iterator over the actors.
function Stage:iterateActors()
	return Class.ABSTRACT()
end

return Stage
