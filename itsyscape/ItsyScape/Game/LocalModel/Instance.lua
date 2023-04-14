
--------------------------------------------------------------------------------
-- ItsyScape/Game/LocalModel/Instance.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local buffer = require "string.buffer"
local Class = require "ItsyScape.Common.Class"
local Callback = require "ItsyScape.Common.Callback"
local Vector = require "ItsyScape.Common.Math.Vector"
local PlayerStorage = require "ItsyScape.Game.PlayerStorage"
local Utility = require "ItsyScape.Game.Utility"
local Stage = require "ItsyScape.Game.Model.Stage"
local ActorProxy = require "ItsyScape.Game.Model.ActorProxy"
local Event = require "ItsyScape.Game.RPC.Event"
local PlayerBehavior = require "ItsyScape.Peep.Behaviors.PlayerBehavior"
local InstancedBehavior = require "ItsyScape.Peep.Behaviors.InstancedBehavior"

local Instance = Class(Stage)

Instance.GLOBAL_ID      = 0
Instance.LOCAL_ID_START = 1

Instance.UNLOAD_TICK_DELAY = 2

Instance.Map = Class()

function Instance.Map:new(layer, map, tileSetID, maskID)
	self.layer = layer
	self.map = map
	self.tileSetID = tileSetID
	self.maskID = maskID
end

function Instance.Map:getLayer()
	return self.layer
end

function Instance.Map:getMap()
	return self.map
end

function Instance.Map:getTileSetID()
	return self.tileSetID
end

function Instance.Map:getMaskID()
	return self.maskID
end

Instance.MapScript = Class()

function Instance.MapScript:new(layer, peep, filename)
	self.layer = layer
	self.peep = peep
	self.filename = filename
end

function Instance.MapScript:getLayer()
	return self.layer
end

function Instance.MapScript:getPeep()
	return self.peep
end

function Instance.MapScript:getFilename()
	return self.filename
end

Instance.Water = Class()

function Instance.Water:new(layer, key, water)
	self.layer = layer
	self.key = key
	self.water = water
end

function Instance.Water:getLayer()
	return self.layer
end

function Instance.Water:getKey()
	return self.key
end

function Instance.Water:getWaterDefinition()
	return self.water
end

Instance.Weather = Class()

function Instance.Weather:new(layer, key, weatherID, props)
	self.layer = layer
	self.key = key
	self.weatherID = weatherID
	self.props = props
end

function Instance.Weather:getLayer()
	return self.layer
end

function Instance.Weather:getKey()
	return self.key
end

function Instance.Weather:getWeatherID()
	return self.weatherID
end

function Instance.Weather:getProps()
	return self.props
end

Instance.Decoration = Class()

function Instance.Decoration:new(layer, group, decoration)
	self.layer = layer
	self.group = group
	self.decoration = decoration
end

function Instance.Decoration:getLayer()
	return self.layer
end

function Instance.Decoration:getGroup()
	return self.group
end

function Instance.Decoration:getDecoration()
	return self.decoration
end

Instance.Item = Class()

function Instance.Item:new(layer, ref, item, tile, position)
	self.layer = layer
	self.ref = ref
	self.item = item
	self.tile = tile
	self.position = position
end

function Instance.Item:getLayer()
	return self.layer
end

function Instance.Item:getRef()
	return self.ref
end

function Instance.Item:getItem()
	return self.item
end

function Instance.Item:getTile()
	return self.tile
end

function Instance.Item:getPosition()
	return self.position
end

Instance.Music = Class()

function Instance.Music:new(layer, track, song, stopped)
	self.layer = layer
	self.track = track
	self.song = song
	self.stopped = stopped or false
end

function Instance.Music:getLayer()
	return self.layer
end

function Instance.Music:getTrack()
	return self.track
end

function Instance.Music:getSong()
	return self.song
end

function Instance.Music:stop()
	self.stopped = true
end

function Instance.Music:getIsStopped()
	return self.stopped
end

function Instance:new(id, filename, stage)
	Stage.new(self)

	self.id = id
	self.filename = filename
	self.stage = stage

	self.storage = PlayerStorage()

	self.layers = {}
	self.layersByID = {}
	self.layersPendingRemovalByID = {}
	self.mapScripts = {}

	self.players = {}
	self.playersByID = {}
	self.orphans = {}

	self.maps = {}

	self.onPlayerEnter = Callback()
	self.onPlayerLeave = Callback()
	self.onUnload = Callback()

	self._onLoadMap = function(_, map, layer, tileSetID, maskID)
		if self:hasLayer(layer, true) then
			Log.engine(
				"Adding map to instance %s (%d) on layer %d.",
				self:getFilename(),
				self:getID(),
				layer)
			self.maps[layer] = Instance.Map(layer, map, tileSetID, maskID)
		else
			Log.engine(
				"Did not add map to instance %s (%d) on layer %d; layer is not in instance.",
				self:getFilename(),
				self:getID(),
				layer)
		end
	end
	stage.onLoadMap:register(self._onLoadMap)

	self._onUnloadMap = function(_, map, layer)
		if self:hasLayer(layer, true) then
			Log.engine(
				"Unloaded map from instance %s (%d) on layer %d.",
				self:getFilename(),
				self:getID(),
				layer)

			self.layersPendingRemovalByID[layer] = {
				playerID = self.layersByID[layer],
				ticks = Instance.UNLOAD_TICK_DELAY
			}

			self.maps[layer] = nil
			for i = 1, #self.layers do
				if self.layers[i] == layer then
					table.remove(self.layers, i)
					break
				end
			end
			self.layersByID[layer] = nil

			local mapScript = self.mapScripts[layer]
			if mapScript then
				Utility.Peep.poof(mapScript:getPeep())
			end
		else
			Log.engine(
				"Did not unload map to instance %s (%d) on layer %d; layer is not in instance.",
				self:getFilename(),
				self:getID(),
				layer)
		end
	end
	stage.onUnloadMap:register(self._onUnloadMap)

	self._onMapModified = function(_, map, layer)
		if self:hasLayer(layer, true) then
			Log.engine(
				"Modified map in instance %s (%d) on layer %d.",
				self:getFilename(),
				self:getID(),
				layer)

			local previousMap = self.maps[layer]
			if previousMap then
				self.maps[layer] = Instance.Map(layer, map, previousMap:getTileSetID(), previousMap:getMaskID())
			end
		else
			Log.engine(
				"Did not modify map in instance %s (%d) on layer %d; layer is not in instance.",
				self:getFilename(),
				self:getID(),
				layer)
		end
	end
	stage.onMapModified:register(self._onMapModified)

	self.actors = {}
	self.actorsByID = {}
	self.actorsPendingRemoval = {}

	self._onActorSpawned = function(_, actorID, actor)
		if self:hasActor(actor) then
			Log.engine(
				"Did not add actor '%s' (resource/peep ID = %s, ID = %d) to instance %s (%d); actor already in instance.",
				actor:getName(), actor:getPeepID(), actor:getID(), self:getFilename(), self:getID())
			return
		end

		local instance = stage:getPeepInstance(actor:getPeep())
		if instance == self then
			Log.engine(
				"Added actor '%s' (resource/peep ID = %s, ID = %d) to instance %s (%d).",
				actor:getName(), actor:getPeepID(), actor:getID(), self:getFilename(), self:getID())
			table.insert(self.actors, actor)
			self.actorsByID[actor:getID()] = actor
		else
			Log.engine(
				"Did not add actor '%s' (resource/peep ID = %s, ID = %d) to instance %s (%d); actor not in instance.",
				actor:getName(), actor:getPeepID(), actor:getID(), self:getFilename(), self:getID())
		end
	end
	stage.onActorSpawned:register(self._onActorSpawned)

	self._onActorKilled = function(_, actor)
		if self:hasActor(actor) then
			Log.engine(
				"Pending removal of actor '%s' (resource/peep ID = %s, ID = %d) in instance %s (%d).",
				actor:getName(), actor:getPeepID(), actor:getID(), self:getFilename(), self:getID())
			table.insert(self.actorsPendingRemoval, { actor = actor, ticks = Instance.UNLOAD_TICK_DELAY })
		else
			Log.engine(
				"Did not try to remove actor '%s' (resource/peep ID = %s, ID = %d) from instance %s (%d); actor not in instance.",
				actor:getName(), actor:getPeepID(), actor:getID(), self:getFilename(), self:getID())
		end
	end
	stage.onActorKilled:register(self._onActorKilled)

	self.props = {}
	self.propsByID = {}
	self.propsPendingRemoval = {}

	self._onPropPlaced = function(_, propID, prop)
		if self:hasProp(prop) then
			Log.engine(
				"Did not add prop '%s' (resource/peep ID = %s, ID = %d) to instance %s (%d); prop already in instance.",
				prop:getName(), prop:getPeepID(), prop:getID(), self:getFilename(), self:getID())
			return
		end

		local instance = stage:getPeepInstance(prop:getPeep())
		if instance == self then
			Log.engine(
				"Added prop '%s' (resource/peep ID = %s, ID = %d) to instance %s (%d).",
				prop:getName(), prop:getPeepID(), prop:getID(), self:getFilename(), self:getID())
			table.insert(self.props, prop)
			self.propsByID[prop:getID()] = prop
		else
			Log.engine(
				"Did not add prop '%s' (resource/peep ID = %s, ID = %d) to instance %s (%d); prop not in instance.",
				prop:getName(), prop:getPeepID(), prop:getID(), self:getFilename(), self:getID())
		end
	end
	stage.onPropPlaced:register(self._onPropPlaced)

	self._onPropRemoved = function(_, prop)
		if self:hasProp(prop) then
			Log.engine(
				"Pending removal of prop '%s' (resource/peep ID = %s, ID = %d) in instance %s (%d).",
				prop:getName(), prop:getPeepID(), prop:getID(), self:getFilename(), self:getID())
			table.insert(self.propsPendingRemoval, { prop = prop, ticks = Instance.UNLOAD_TICK_DELAY })
		else
			Log.engine(
				"Did not try to remove prop '%s' (resource/peep ID = %s, ID = %d) from instance %s (%d); prop not in instance.",
				prop:getName(), prop:getPeepID(), prop:getID(), self:getFilename(), self:getID())
		end
	end
	stage.onPropRemoved:register(self._onPropRemoved)

	self.water = {}

	self._onWaterFlood = function(_, key, water, layer)
		if self:hasLayer(layer, true) then
			Log.engine(
				"Trying to add water '%s' (layer = %d) to instance %s (%d).",
				key, layer, self:getFilename(), self:getID())

			for i = 1, #self.water do
				if self.water[i]:getKey() == key then
					Log.engine("Water exists at index %d; replacing.", i)
					self.water[i] = Instance.Water(layer, key, water)
					self:onWaterFlood(key, water, layer)
					return
				end
			end

			Log.engine("Water does not exist; adding.")
			table.insert(self.water, Instance.Water(layer, key, water))
			self:onWaterFlood(key, water, layer)
		else
			Log.engine(
				"Did not add water '%s' (layer = %d) to instance %s (%d); layer not in instance.",
				key, layer, self:getFilename(), self:getID())
		end
	end
	stage.onWaterFlood:register(self._onWaterFlood)

	self._onWaterDrain = function(_, key, layer)
		if self:hasLayer(layer, true) then
			Log.engine(
				"Trying to remove water '%s' (layer = %d) from instance %s (%d).",
				key, layer, self:getFilename(), self:getID())

			for i = 1, #self.water do
				if self.water[i]:getKey() == key then
					Log.engine("Water removed from index %d.", i)
					table.remove(self.water, i)
					self:onWaterDrain(key, layer)
					return
				end
			end

			Log.engine("Warning; water not found.")
		else
			Log.engine(
				"Did not remove water '%s' (layer = %d) from instance %s (%d); layer not in instance.",
				key, layer, self:getFilename(), self:getID())
		end
	end
	stage.onWaterDrain:register(self._onWaterDrain)

	self.music = {}

	self._onPlayMusic = function(_, track, song, layer)
		if self:hasLayer(layer, true) then
			Log.engine(
				"Trying to play music '%s' on track '%s' (layer = %d) to instance %s (%d).",
				song, track, layer, self:getFilename(), self:getID())

			for i = 1, #self.music do
				if self.music[i]:getTrack() == track then
					Log.engine("Music playing at index %d; replacing.", i)
					self.music[i] = Instance.Music(layer, track, song)
					self:onPlayMusic(track, song, layer)
					return
				end
			end

			Log.engine("Music is not playing; playing.")
			table.insert(self.music, Instance.Music(layer, track, song))
			self:onPlayMusic(track, song, layer)
		else
			Log.engine(
				"Did not play music '%s' on track '%s' (layer = %d) to instance %s (%d); layer not in instance.",
				song, track, layer, self:getFilename(), self:getID())
		end
	end
	stage.onPlayMusic:register(self._onPlayMusic)

	self._onStopMusic = function(_, track, song, layer)
		if self:hasLayer(layer, true) then
			Log.engine(
				"Trying to stop music on track '%s' (layer = %d) from instance %s (%d).",
				track, layer, self:getFilename(), self:getID())

			for i = 1, #self.music do
				if self.music[i]:getTrack() == track then
					Log.engine("Music stopped at index %d.", i)
					self.music[i]:stop()
					self:onStopMusic(track, song, layer)
					return
				end
			end

			Log.engine("Music not found. Stopping anyway.")
			table.insert(self.music, Instance.Music(layer, track, song, true))
			self:onStopMusic(track, song, layer)
		else
			Log.engine(
				"Did not stop music on track '%s' (layer = %d) from instance %s (%d); layer not in instance.",
				track, layer, self:getFilename(), self:getID())
		end
	end
	stage.onStopMusic:register(self._onStopMusic)

	self.weather = {}

	self._onForecast = function(_, layer, key, id, props)
		if self:hasLayer(layer, true) then
			Log.engine(
				"Trying to add weather '%s' of type %s (layer = %d) to instance %s (%d).",
				key, id, layer, self:getFilename(), self:getID())
			for i = 1, #self.weather do
				if self.weather[i]:getKey() == key then
					Log.engine("Weather exists at index %d; replacing.", i)
					self.weather[i] = Instance.Weather(layer, key, id, props)
					self:onForecast(layer, key, id, props)
					return
				end
			end

			Log.engine("Weather does not exist; adding.")
			table.insert(self.weather, Instance.Weather(layer, key, id, props))
			self:onForecast(layer, key, id, props)
		else
			Log.engine(
				"Could not add weather '%s' of type %s (layer = %d) to instance %s (%d); layer not in instance.",
				key, id, layer, self:getFilename(), self:getID())
		end
	end
	stage.onForecast:register(self._onForecast)

	self._onStopForecast = function(_, layer, key)
		if self:hasLayer(layer, true) then
			Log.engine(
				"Trying to remove weather '%s' (layer = %d) from instance %s (%d).",
				key, layer, self:getFilename(), self:getID())

			for i = 1, #self.weather do
				if self.weather[i]:getKey() == key then
					Log.engine("Weather removed from index %d.", i)
					table.remove(self.weather, i)
					self:onStopForecast(layer, key)
					return
				end
			end

			Log.engine("Warning; weather not found.")
		else
			Log.engine(
				"Did not remove weather '%s' (layer = %d) from instance %s (%d); layer not in instance.",
				key, layer, self:getFilename(), self:getID())
		end
	end
	stage.onStopForecast:register(self._onStopForecast)

	self.decorations = {}

	self._onDecorate = function(_, group, decoration, layer)
		if self:hasLayer(layer, true) then
			Log.engine(
				"Trying to add decoration '%s' (layer = %d) to instance %s (%d).",
				group, layer, self:getFilename(), self:getID())
			for i = 1, #self.decorations do
				if self.decorations[i]:getGroup() == group then
					Log.engine("Decoration exists at index %d; replacing.", i)
					self.decorations[i] = Instance.Decoration(layer, group, decoration)
					self:onDecorate(group, decoration, layer)
					return
				end
			end

			Log.engine("Decoration does not exist; adding.")
			table.insert(self.decorations, Instance.Decoration(layer, group, decoration))
			self:onDecorate(group, decoration, layer)
		else
			Log.engine(
				"Could not add decoration '%s' (layer = %d) to instance %s (%d); layer not in instance.",
				group, layer, self:getFilename(), self:getID())
		end
	end
	stage.onDecorate:register(self._onDecorate)

	self._onUndecorate = function(_, group, layer)
		if self:hasLayer(layer, true) then
			Log.engine(
				"Trying to remove decoration '%s' (layer = %d) from instance %s (%d).",
				group, layer, self:getFilename(), self:getID())

			for i = 1, #self.decorations do
				if self.decorations[i]:getGroup() == group then
					Log.engine("Decoration removed from index %d.", i)
					table.remove(self.decorations, i)
					self:onUndecorate(group, layer)
					break
				end
			end

			Log.engine("Warning; decoration not found.")
		else
			Log.engine(
				"Did not remove decoration '%s' (layer = %d) to instance %s (%d); layer not instance",
				group, layer, self:getFilename(), self:getID())
		end
	end
	stage.onUndecorate:register(self._onUndecorate)

	self.items = {}

	self._onDropItem = function(_, ref, item, tile, position, layer)
		if self:hasLayer(layer, true) then
			Log.engine(
				"Trying to drop item '%s' (ref = %d, count = %d) at (%d, %d) (layer = %d) in instance %s (%d).",
				item.id, ref, item.count, tile.i, tile.j, layer, self:getFilename(), self:getID())

			for i = 1, #self.items do
				if self.items[i]:getRef() == ref then
					Log.engine("Item found at index %d; replacing.", i)
					self.items[i] = Instance.Item(layer, ref, item, tile, position)
					self:onDropItem(ref, item, tile, position, layer)
					return
				end
			end

			Log.engine("Item not found; dropping.")
			table.insert(self.items, Instance.Item(layer, ref, item, tile, position))
			self:onDropItem(ref, item, tile, position, layer)
		else
			Log.engine(
				"Did not drop item '%s' (ref = %d, count = %d) at (%d, %d) (layer = %d) in instance %s (%d); layer not in instance.",
				item.id, ref, item.count, tile.i, tile.j, layer, self:getFilename(), self:getID())
		end
	end
	stage.onDropItem:register(self._onDropItem)

	self._onTakeItem = function(_, ref, item, layer)
		if self:hasLayer(layer, true) then
			Log.engine(
				"Trying to take item '%s' (count = %d) on layer = %d in instance %s (%d).",
				item.id, item.count, layer, self:getFilename(), self:getID())

			for i = 1, #self.items do
				if self.items[i]:getRef() == ref then
					Log.engine("Item removed from index %d.", i)
					table.remove(self.items, i)
					self:onTakeItem(ref, item, layer)
					return
				end
			end

			Log.engine("Warning; item not found.")
		else
			Log.engine(
				"Did not take item '%s' (ref = %d, count = %d) on layer %d in instance %s (%d); layer not in instance.",
				item.id, ref, item.count, layer, self:getFilename(), self:getID())
		end
	end
	stage.onTakeItem:register(self._onTakeItem)

	self._onProjectile = function(_, projectileID, source, destination, time)
		local sourceLayer = source and not Class.isType(source, Vector) and source:getPeep() and Utility.Peep.getLayer(source:getPeep())
		local destinationLayer = destination and not Class.isType(destination, Vector) and destination:getPeep() and Utility.Peep.getLayer(destination:getPeep())

		if (self:hasLayer(sourceLayer, true) or source == nil) and
		   (self:hasLayer(destinationLayer, true) or destination == nil) then

			Log.engine(
				"Firing projectile '%s' in instance %s (%d).",
				projectileID, self:getFilename(), self:getID())

			self:onProjectile(projectileID, source, destination, time)
		end
	end
	stage.onProjectile:register(self._onProjectile)

	Log.engine("Added instance %s (%d).", self:getFilename(), self:getID())
end

function Instance:unload()
	Log.engine("Unloaded instance %s (%d).", self:getFilename(), self:getID())

	self:onUnload()

	self.stage.onLoadMap:unregister(self._onLoadMap)
	self.stage.onUnloadMap:unregister(self._onUnloadMap)
	self.stage.onMapModified:unregister(self._onMapModified)
	self.stage.onActorSpawned:unregister(self._onActorSpawned)
	self.stage.onActorKilled:unregister(self._onActorKilled)
	self.stage.onPropPlaced:unregister(self._onPropPlaced)
	self.stage.onPropRemoved:unregister(self._onPropRemoved)
	self.stage.onWaterFlood:unregister(self._onWaterFlood)
	self.stage.onWaterDrain:unregister(self._onWaterDrain)
	self.stage.onForecast:unregister(self._onForecast)
	self.stage.onStopForecast:unregister(self._onStopForecast)
	self.stage.onDecorate:unregister(self._onDecorate)
	self.stage.onUndecorate:unregister(self._onUndecorate)
	self.stage.onProjectile:unregister(self._onProjectile)
	self.stage.onPlayMusic:unregister(self._onPlayMusic)
	self.stage.onStopMusic:unregister(self._onStopMusic)
	self.stage.onDropItem:unregister(self._onDropItem)
	self.stage.onTakeItem:unregister(self._onTakeItem)

	for i = 1, #self.actors do
		local actor = self.actors[i]

		if actor:getPeep():hasBehavior(PlayerBehavior) then
			Log.engine("Actor '%s' (%d) is player; not removing.", actor:getName(), actor:getID())
		else
			self.stage:killActor(actor)
		end
	end

	for i = 1, #self.props do
		self.stage:removeProp(self.props[i])
	end

	for layer, map in pairs(self.maps) do
		self.stage:unloadMap(layer)
	end

	for _, mapScript in pairs(self.mapScripts) do
		Utility.Peep.poof(mapScript:getPeep())
	end
end

function Instance:getID()
	return self.id
end

function Instance:getFilename()
	return self.filename
end

function Instance:getIsGlobal()
	return self.id == Instance.GLOBAL_ID
end

function Instance:getIsLocal()
	return not self:getIsGlobal()
end

function Instance:getPlayerStorage()
	return self.storage
end

function Instance:setRaid(raid)
	self.raid = raid or nil
end

function Instance:hasRaid()
	return self.raid ~= nil
end

function Instance:getRaid()
	return self.raid
end

function Instance:hasLayer(layer, player)
	if player and player ~= true and not self:hasPlayer(player) then
		return self.layersPendingRemovalByID[layer] and self.layersPendingRemovalByID[layer].playerID == player:getID()
	end

	if player and player ~= true then
		return self.layersByID[layer] == true or self.layersByID[layer] == player:getID()
	else
		return self.layersByID[layer] == true or (self.layersByID[layer] ~= nil and player)
	end
end

function Instance:addLayer(layer, player)
	if not self:hasLayer(layer, true) then
		Log.engine("Adding layer %d to instance %s (%d).", layer, self:getFilename(), self:getID())
		self.layersByID[layer] = (player and player:getID()) or true
		table.insert(self.layers, layer)
	end
end

function Instance:removeLayer(layer)
	self.layersByID[layer] = nil
	for i = 1, #self.layers do
		if self.layers[i] == layer then
			Log.engine("Removed layer %d from instance %s (%d).", layer, self:getFilename(), self:getID())

			table.remove(self.layers, i)

			if self.baseLayer == layer then
				self.baseLayer = nil
			end

			self:removeMapScript(layer)

			break
		end
	end
end

function Instance:setBaseLayer(layer)
	if self:hasLayer(layer, true) then
		Log.engine("Base layer set to %d in instance %s (%d).", layer, self:getFilename(), self:getID())
		self.baseLayer = layer
	else
		Log.engine(
			"Could not set base layer to %d in instance %s (%d); layer not in instance.",
			layer, self:getFilename(), self:getID())
	end
end

function Instance:getBaseLayer()
	return self.baseLayer
end

function Instance:getBaseMapScript()
	return self:getMapScriptByLayer(self:getBaseLayer())
end

function Instance:iterateLayers()
	return ipairs(self.layers)
end

function Instance:addMapScript(layer, peep, filename)
	if self:hasLayer(layer, true) then
		Log.engine("Added map script '%s' to layer %d in instance %s (%d).", peep:getName(), layer, self:getFilename(), self:getID())
		self.mapScripts[layer] = Instance.MapScript(layer, peep, filename)
	else
		Log.engine("Could not add map script '%s' to layer %d in instance %s (%d); layer not in instance.", peep:getName(), layer, self:getFilename(), self:getID())
	end
end

function Instance:removeMapScript(layer)
	if self.mapScripts[layer] then
		Log.engine("Removed map script '%s' at layer %d from instance %s (%d).", self.mapScripts[layer]:getName(), layer, self:getFilename(), self:getID())
		self.mapScripts[layer] = nil
	end
end

function Instance:getMapScriptByLayer(layer)
	local mapScript = self.mapScripts[layer]
	if mapScript then
		return mapScript:getPeep()
	end

	Log.warn("No map script for layer %d in instance %s (%d).", layer, self:getFilename(), self:getID())
	return nil
end

function Instance:getMapScriptByMapFilename(filename)
	for _, mapScript in pairs(self.mapScripts) do
		if mapScript:getFilename() == filename then
			return mapScript:getPeep()
		end
	end

	Log.warn("No map script with the filename '%s' in instance %s (%d).", filename, self:getFilename(), self:getID())
	return nil
end

function Instance:iteratePlayers()
	return ipairs(self.players)
end

function Instance:hasPlayers()
	return #self.players > 0
end

function Instance:hasPlayer(player)
	return self.playersByID[player:getID()] ~= nil
end

function Instance:addPlayer(player, e)
	if not self:hasPlayer(player) then
		Log.info("Adding player '%s' (%d) to instance %s (%d).", (player:getActor() and player:getActor():getName()) or "<pending>", player:getID(), self:getFilename(), self:getID())

		table.insert(self.players, player)
		self.playersByID[player:getID()] = player
		self:_addPlayerToInstance(player, e)

		if not self.partyLeader then
			Log.info("No party leader; setting player to party instance.")
			self:setPartyLeader(player)
		end
	end
end

function Instance:removePlayer(player)
	self.playersByID[player:getID()] = nil
	for i = 1, #self.players do
		if self.players[i]:getID() == player:getID() then
			Log.info("Removing player '%s' (%d) from instance %s (%d).", (player:getActor() and player:getActor():getName()) or "<pending>", player:getID(), self:getFilename(), self:getID())

			table.remove(self.players, i)

			if self.partyLeader and self.partyLeader:getID() == player:getID() then
				self.partyLeader = nil
			end

			self:_removePlayerFromInstance(player)

			return
		end
	end

	Log.warn(
		"Could not remove player '%s' (%d) from instance %s (%d); not in instance.",
		(player:getActor() and player:getActor():getName()) or "<poofed player>", player:getID(), self:getFilename(), self:getID())
end

function Instance:getPartyLeader()
	return self.partyLeader
end

function Instance:setPartyLeader(player)
	if self:hasPlayer(player) then
		Log.info("Set party leader to player '%s' (%d) to instance %s (%d).", (player:getActor() and player:getActor():getName()) or "<pending>", player:getID(), self:getFilename(), self:getID())
		self.partyLeader = player
	else
		Log.info("Could not set party leader to player '%s' (%d) to instance %s (%d); player not in instance.", (player:getActor() and player:getActor():getName()) or "<pending>", player:getID(), self:getFilename(), self:getID())
	end
end

function Instance:hasActor(actor, player)
	local hasActor = self.actorsByID[actor:getID()] ~= nil
	if hasActor and player and actor:getPeep() then
		local instanceBehavior = actor:getPeep():getBehavior(InstancedBehavior)
		local isVisible = not instanceBehavior or instanceBehavior.playerID == player:getID()

		return isVisible
	end

	return hasActor
end

function Instance:hasProp(prop, player)
	local hasProp = self.propsByID[prop:getID()] ~= nil
	if hasProp and player and prop:getPeep() then
		local instanceBehavior = prop:getPeep():getBehavior(InstancedBehavior)
		local isVisible = not instanceBehavior or instanceBehavior.playerID == player:getID()

		return isVisible
	end

	return hasProp
end

function Instance:_addPlayerToInstance(player, e)
	if not player:getActor() then
		return
	end

	if e and e.isOrphan then
		self.orphans[player:getActor():getID()] = true
	end

	for i = 1, #self.layers do
		local layer = self.layers[i]
		if self.layersByID[layer] == true or self.layersByID[layer] == player:getID() then
			local mapScript = self:getMapScriptByLayer(layer)
			if mapScript then
				local function onPlayerEnter()
					mapScript:pushPoke('playerEnter', player)
					mapScript:silence('finalize', onPlayerEnter)
				end

				if mapScript:getDirector() then
					onPlayerEnter()
				else
					mapScript:listen('finalize', onPlayerEnter)
				end
			end
		end
	end

	self:onPlayerEnter(player)
end

function Instance:_clearInstancedActors(player)
	for i = 1, #self.actors do
		local actor = self.actors[i]

		if actor:getPeep() then
			if Utility.Peep.isInstancedToPlayer(actor:getPeep(), player) then
				Log.engine(
					"Clearing instanced actor '%s' (%d) for player %s (%d).",
					actor:getName(), actor:getID(),
					(player:getActor() and player:getActor():getName()) or "<poofed player>", player:getID())
				Utility.Peep.poof(actor:getPeep())
			end
		end
	end
end

function Instance:_clearInstancedProps(player)
	for i = 1, #self.props do
		local prop = self.props[i]

		if prop:getPeep() then
			if Utility.Peep.isInstancedToPlayer(prop:getPeep(), player) then
				Log.engine(
					"Clearing instanced prop '%s' (%d) for player %s (%d).",
					prop:getName(), prop:getID(),
					(player:getActor() and player:getActor():getName()) or "<poofed player>", player:getID())
				Utility.Peep.poof(prop:getPeep())
			end
		end
	end
end

function Instance:_clearInstancedMap(layer)
	local water = {}
	for i = 1, #self.water do
		local w = self.water[i]
		if w:getLayer() == layer then
			table.insert(water, w)
		end
	end

	for i = 1, #water do
		self.stage:onWaterDrain(water:getKey(), water:getLayer())
	end

	local decorations = {}
	for i = 1, #self.decorations do
		local d = self.decorations[i]
		if d:getLayer() == layer then
			table.insert(decorations, d)
		end
	end

	for i = 1, #decorations do
		self.stage:onUndecorate(decorations[i]:getGroup(), decorations[i]:getLayer())
	end

	local music = {}
	for i = 1, #self.music do
		local m = self.music[i]
		if m:getLayer() == layer then
			table.insert(music, m)
		end
	end

	for i = 1, #music do
		self.stage:onStopMusic(music[i]:getTrack(), music[i]:getSong(), music[i]:getLayer())
	end

	local forecast = {}
	for i = 1, #self.weather do
		local f = self.weather[i]
		if f:getLayer() == layer then
			table.insert(forecast, f)
		end
	end

	for i = 1, #forecast do
		self.stage:onStopForecast(forecast[i]:getLayer(), forecast[i]:getKey())
	end
end

function Instance:_clearInstancedMaps(player)
	for layer, playerID in pairs(self.layersByID) do
		if playerID == player:getID() then
			Log.info(
				"Clearing instanced layer %d for player '%s' (%d).",
				layer, (player:getActor() and player:getActor():getName()) or "<poofed player>", player:getID())

			self:_clearInstancedMap(layer)
			self.stage:unloadMap(layer)
		end
	end
end

function Instance:_removePlayerFromInstance(player)
	self.orphans[player] = nil

	for i = 1, #self.layers do
		local layer = self.layers[i]
		if self.layersByID[layer] == true or self.layersByID[layer] == player:getID() then
			local mapScript = self:getMapScriptByLayer(layer)
			if mapScript then
				local function onPlayerLeave()
					mapScript:pushPoke('playerLeave', player)
					mapScript:silence('finalize', onPlayerLeave)
				end

				if mapScript:getDirector() then
					onPlayerLeave()
				else
					mapScript:listen('finalize', onPlayerLeave)
				end
			end
		end
	end

	self:_clearInstancedActors(player)
	self:_clearInstancedProps(player)
	self:_clearInstancedMaps(player)

	self:onPlayerLeave(player)
end

function Instance:unloadPlayer(localGameManager, player)
	Log.engine(
		"Unloading instance %s (%d) for player '%s'...",
		self:getFilename(),
		self:getID(),
		(player:getActor() and player:getActor():getName()) or tostring(player:getID()))

	for _, layer in self:iterateLayers() do
		local map = self.stage:getMap(layer)

		localGameManager:pushCallback(
			"ItsyScape.Game.Model.Stage",
			0,
			"onUnloadMap",
			localGameManager:getArgs(map, layer))
		localGameManager:assignTargetToLastPush(player)

		Log.engine("Unloaded layer %d.", layer)
	end

	for i = 1, #self.actors do
		local actor = self.actors[i]

		localGameManager:pushCallback(
			"ItsyScape.Game.Model.Stage",
			0,
			"onActorKilled",
			localGameManager:getArgs(actor))
		localGameManager:assignTargetToLastPush(player)

		localGameManager:pushDestroy(
			"ItsyScape.Game.Model.Actor",
			actor:getID(), Utility.Peep.getLayer(actor:getPeep()))
		localGameManager:assignTargetToLastPush(player)

		Log.engine("Unloaded actor '%s' (%s).", actor:getName(), actor:getID())
	end

	for i = 1, #self.props do
		local prop = self.props[i]

		localGameManager:pushCallback(
			"ItsyScape.Game.Model.Stage",
			0,
			"onPropRemoved",
			localGameManager:getArgs(prop))
		localGameManager:assignTargetToLastPush(player)

		localGameManager:pushDestroy(
			"ItsyScape.Game.Model.Prop",
			prop:getID(), Utility.Peep.getLayer(prop:getPeep()))
		localGameManager:assignTargetToLastPush(player)

		Log.engine("Unloaded prop '%s' (%s).", prop:getName(), prop:getPeepID())
	end

	for _, water in ipairs(self.water) do
		localGameManager:pushCallback(
			"ItsyScape.Game.Model.Stage",
			0,
			"onWaterDrain",
			localGameManager:getArgs(water:getKey(), water:getLayer()))
		localGameManager:assignTargetToLastPush(player)

		Log.engine("Unloaded water '%s' for layer %d.", water:getKey(), water:getLayer())
	end

	for _, weather in ipairs(self.weather) do
		localGameManager:pushCallback(
			"ItsyScape.Game.Model.Stage",
			0,
			"onStopForecast",
			localGameManager:getArgs(weather:getLayer(), weather:getKey()))
		localGameManager:assignTargetToLastPush(player)

		Log.engine("Unloaded weather '%s' for layer %d.", weather:getKey(), weather:getLayer())
	end

	for _, decoration in ipairs(self.decorations) do
		localGameManager:pushCallback(
			"ItsyScape.Game.Model.Stage",
			0,
			"onUndecorate",
			localGameManager:getArgs(decoration:getGroup(), decoration:getLayer()))
		localGameManager:assignTargetToLastPush(player)

		Log.engine("Unloaded decoration '%s' for layer %d.", decoration:getGroup(), decoration:getLayer())
	end

	for _, item in ipairs(self.items) do
		localGameManager:pushCallback(
			"ItsyScape.Game.Model.Stage",
			0,
			"onTakeItem",
			localGameManager:getArgs(item:getRef(), item:getItem()))
		localGameManager:assignTargetToLastPush(player)

		Log.engine(
			"Unloaded item '%s' (ref = %d, count = %d) at (%d, %d) for layer %d.",
			item:getItem().id, item:getRef(), item:getItem().count, item:getTile().i, item:getTile().j, item:getLayer())
	end

	for i = 1, #self.players do
		local otherPlayer = self.players[i]

		if otherPlayer:getID() ~= player:getID() then
			Log.engine(
				"Hiding self from other player '%s' (%d).",
				(otherPlayer:getActor() and otherPlayer:getActor():getName()) or "Player", otherPlayer:getID())

			localGameManager:pushCallback(
				"ItsyScape.Game.Model.Stage",
				0,
				"onActorKilled",
				localGameManager:getArgs(player:getActor()), Utility.Peep.getLayer(player:getActor():getPeep()))
			localGameManager:assignTargetToLastPush(otherPlayer)

			localGameManager:pushDestroy(
				"ItsyScape.Game.Model.Actor",
				player:getActor():getID())
			localGameManager:assignTargetToLastPush(otherPlayer)
		end
	end

	Log.engine(
		"Successfully unloaded instance %s (%d) for player '%s'.",
		self:getFilename(),
		self:getID(),
		(player:getActor() and player:getActor():getName()) or tostring(player:getID()))
end

function Instance:loadPlayer(localGameManager, player)
	Log.info("Restoring instance for player '%s'...", (player:getActor() and player:getActor():getName()) or tostring(player:getID()))

	for _, layer in self:iterateLayers() do
		if not self:hasLayer(layer, player) then
			Log.engine(
				"Layer %d is not visible to player, no need to update map.",
				layer)
		else
			local map = self.stage:getMap(layer)

			localGameManager:pushCallback(
				"ItsyScape.Game.Model.Stage",
				0,
				"onLoadMap",
				localGameManager:getArgs(map, layer, self.maps[layer]:getTileSetID(), self.maps[layer]:getMaskID()))
			localGameManager:assignTargetToLastPush(player)
			localGameManager:pushCallback(
				"ItsyScape.Game.Model.Stage",
				0,
				"onMapModified",
				localGameManager:getArgs(map, layer))
			localGameManager:assignTargetToLastPush(player)

			Log.engine("Loaded layer %d.", layer)
		end
	end

	for i = 1, #self.actors do
		local actor = self.actors[i]
		if self.orphans[actor:getID()] then
			Log.engine(
				"Actor '%s' (%d) was orphan, no need to re-create.",
				actor:getName(), actor:getID())
		elseif not self:hasActor(actor, player) then
			Log.engine(
				"Actor '%s' (%d) is not visible to player, no need to re-create.",
				actor:getName(), actor:getID())
		else
			localGameManager:pushCreate(
				"ItsyScape.Game.Model.Actor",
				actor:getID())
			localGameManager:assignTargetToLastPush(player)

			localGameManager:pushCallback(
				"ItsyScape.Game.Model.Stage",
				0,
				"onActorSpawned",
				localGameManager:getArgs(actor:getPeepID(), actor))
			localGameManager:assignTargetToLastPush(player)

			self:loadActor(localGameManager, player, actor)
		end
	end

	for i = 1, #self.props do
		local prop = self.props[i]

		if not self:hasProp(prop, player) then
			Log.engine(
				"Prop '%s' (%d) is not visible to player, no need to re-create.",
				prop:getName(), prop:getID())
		else

			localGameManager:pushCreate(
				"ItsyScape.Game.Model.Prop",
				prop:getID())
			localGameManager:assignTargetToLastPush(player)

			localGameManager:pushCallback(
				"ItsyScape.Game.Model.Stage",
				0,
				"onPropPlaced",
				localGameManager:getArgs(prop:getPeepID(), prop))
			localGameManager:assignTargetToLastPush(player)

			self:loadProp(localGameManager, player, prop)
		end

		Log.engine("Restored prop '%s' (%s).", prop:getName(), prop:getPeepID())
	end

	for _, water in ipairs(self.water) do
		if not self:hasLayer(water:getLayer(), player) then
			Log.engine(
				"Layer %d is not visible to player, no need to update water '%s'.",
				water:getLayer(), water:getKey())
		else
			localGameManager:pushCallback(
				"ItsyScape.Game.Model.Stage",
				0,
				"onWaterFlood",
				localGameManager:getArgs(water:getKey(), water:getWaterDefinition(), water:getLayer()))
			localGameManager:assignTargetToLastPush(player)

			Log.engine("Restored water '%s' for layer %d.", water:getKey(), water:getLayer())
		end
	end

	for _, weather in ipairs(self.weather) do
		if not self:hasLayer(weather:getLayer(), player) then
			Log.engine(
				"Layer %d is not visible to player, no need to update weather '%s'.",
				weather:getLayer(), weather:getKey())
		else
			localGameManager:pushCallback(
				"ItsyScape.Game.Model.Stage",
				0,
				"onForecast",
				localGameManager:getArgs(weather:getLayer(), weather:getKey(), weather:getWeatherID(), weather:getProps()))
			localGameManager:assignTargetToLastPush(player)

			Log.engine("Restored weather '%s' for layer %d.", weather:getKey(), weather:getLayer())
		end
	end

	for _, decoration in ipairs(self.decorations) do
		if not self:hasLayer(decoration:getLayer(), player) then
			Log.engine(
				"Layer %d is not visible to player, no need to update decoration '%s'.",
				decoration:getLayer(), decoration:getGroup())
		else
			localGameManager:pushCallback(
				"ItsyScape.Game.Model.Stage",
				0,
				"onDecorate",
				localGameManager:getArgs(decoration:getGroup(), decoration:getDecoration(), decoration:getLayer()))
			localGameManager:assignTargetToLastPush(player)

			Log.engine("Restored decoration '%s' for layer %d.", decoration:getGroup(), decoration:getLayer())
		end
	end

	for _, music in ipairs(self.music) do
		if not self:hasLayer(music:getLayer(), player) then
			Log.engine(
				"Layer %d is not visible to player, no need to update music track '%s'.",
				music:getLayer(), music:getTrack())
		else
			localGameManager:pushCallback(
				"ItsyScape.Game.Model.Stage",
				0,
				(music:getIsStopped() and "onStopMusic") or "onPlayMusic",
				localGameManager:getArgs(music:getTrack(), music:getSong(), music:getLayer()))
			localGameManager:assignTargetToLastPush(player)

			Log.engine("Restored song '%s' on track '%s' for layer %d.", Log.stringify(music:getSong()), music:getTrack(), music:getLayer())
		end
	end

	for _, item in ipairs(self.items) do
		localGameManager:pushCallback(
			"ItsyScape.Game.Model.Stage",
			0,
			"onDropItem",
			localGameManager:getArgs(item:getRef(), item:getItem(), item:getTile(), item:getPosition(), item:getLayer()))
		localGameManager:assignTargetToLastPush(player)

		Log.engine(
			"Restored item '%s' (ref = %d, count = %d) at (%d, %d) for layer %d.",
			item:getItem().id, item:getRef(), item:getItem().count, item:getTile().i, item:getTile().j, item:getLayer())
	end

	for i = 1, #self.players do
		local otherPlayer = self.players[i]

		if otherPlayer:getID() ~= player:getID() then
			Log.engine(
				"Presenting self to other player '%s' (%d).",
				(otherPlayer:getActor() and otherPlayer:getActor():getName()), otherPlayer:getID())

			localGameManager:pushCreate(
				"ItsyScape.Game.Model.Actor",
				player:getActor():getID())
			localGameManager:assignTargetToLastPush(otherPlayer)

			localGameManager:pushCallback(
				"ItsyScape.Game.Model.Stage",
				0,
				"onActorSpawned",
				localGameManager:getArgs(player:getActor():getPeepID(), player:getActor()))
			localGameManager:assignTargetToLastPush(otherPlayer)

			self:loadActor(localGameManager, otherPlayer, player:getActor())
		end
	end

	Log.engine(
		"Successfully unloaded instance %s (%d) for player '%s'.",
		self:getFilename(),
		self:getID(),
		(player:getActor() and player:getActor():getName()) or tostring(player:getID()))
end

function Instance:loadActor(localGameManager, player, actor)
	local actorInstance = localGameManager:getInstance(
		"ItsyScape.Game.Model.Actor",
		actor:getID())

	Log.engine("Restoring actor '%s' (%d)...", actor:getName(), actor:getID())

	if not actorInstance then
		Log.engine("Could not restore actor; instance not in local game manager.")
		return
	end

	for _, field in ActorProxy:iterateEvents() do
		local event = field:getValue()
		if Class.isCompatibleType(event, Event.Set) then
			local propertyGroup = actorInstance:getPropertyGroup(event:getGroup())
			for _, v in propertyGroup:iterate() do
				localGameManager:pushCallback(
					"ItsyScape.Game.Model.Actor",
					actor:getID(),
					event:getCallbackName(),
					v.value)
				localGameManager:assignTargetToLastPush(player)

				Log.engine("Restoring property %s via callback %s.", field:getKey(), event:getCallbackName())
			end
		end
	end

	for _, property in actorInstance:iterateProperties() do
		localGameManager:pushProperty(
			actorInstance:getInterface(),
			actorInstance:getID(),
			property:getField(),
			buffer.encode(property:getValue()),
			true)
		localGameManager:assignTargetToLastPush(player)
	end

	Log.engine("Restored actor '%s' (%d).", actor:getName(), actor:getID())
end

function Instance:loadProp(localGameManager, player, prop)
	local propInstance = localGameManager:getInstance(
		"ItsyScape.Game.Model.Prop",
		prop:getID())

	Log.engine("Restoring prop '%s' (%d)...", prop:getName(), prop:getID())

	if not propInstance then
		Log.engine("Could not restore prop; instance not in local game manager.")
		return
	end

	for _, property in propInstance:iterateProperties() do
		localGameManager:pushProperty(
			propInstance:getInterface(),
			propInstance:getID(),
			property:getField(),
			buffer.encode(property:getValue()),
			true)
		localGameManager:assignTargetToLastPush(player)

		Log.engine("Restored property '%s'.", property:getField())
	end

	Log.engine("Restored prop '%s' (%d).", prop:getName(), prop:getID())
end

function Instance:cleanup()
	for i = #self.actorsPendingRemoval, 1, -1 do
		local pending = self.actorsPendingRemoval[i]
		pending.ticks = pending.ticks - 1

		if pending.ticks <= 0 then
			local actor = pending.actor

			for i = 1, #self.actors do
				if self.actors[i] == actor then
					Log.engine("Finally removed actor %d from instance %s (%d).", actor:getID(), self:getFilename(), self:getID())
					table.remove(self.actors, i)
					self.actorsByID[actor:getID()] = nil
					break
				end
			end

			table.remove(self.actorsPendingRemoval, i)
		end
	end

	for i = #self.propsPendingRemoval, 1, -1 do
		local pending = self.propsPendingRemoval[i]
		pending.ticks = pending.ticks - 1

		if pending.ticks <= 0 then
			local prop = pending.prop

			for i = 1, #self.props do
				if self.props[i] == prop then
					Log.engine("Finally removed prop %d from instance %s (%d).", prop:getID(), self:getFilename(), self:getID())
					table.remove(self.props, i)
					self.propsByID[prop:getID()] = nil
					break
				end
			end

			table.remove(self.propsPendingRemoval, i)
		end
	end

	for layer, info in pairs(self.layersPendingRemovalByID) do
		info.ticks = info.ticks - 1
		if info.ticks <= 0 then
			self.stage:deleteLayer(layer)
			self.layersPendingRemovalByID[layer] = nil
		end
	end

	table.clear(self.orphans)
end

return Instance
