--------------------------------------------------------------------------------
-- ItsyScape/Game/LocalModel/Instance.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Vector = require "ItsyScape.Common.Math.Vector"
local Utility = require "ItsyScape.Game.Utility"
local Stage = require "ItsyScape.Game.Model.Stage"
local ActorProxy = require "ItsyScape.Game.Model.ActorProxy"
local Event = require "ItsyScape.Game.RPC.Event"
local PlayerBehavior = require "ItsyScape.Peep.Behaviors.PlayerBehavior"

local Instance = Class(Stage)

Instance.GLOBAL_ID      = 0
Instance.LOCAL_ID_START = 1

Instance.Map = Class()

function Instance.Map:new(layer, map, tileSetID)
	self.layer = layer
	self.map = map
	self.tileSetID = tileSetID
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

Instance.Music = Class()

function Instance.Music:new(track, song)
	self.track = track
end

function Instance.Music:getTrack()
	return self.track
end

function Instance.Music:getSong()
	return self.song
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

function Instance.Music:new(layer, track, song)
	self.layer = layer
	self.track = track
	self.song = song
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

function Instance:new(id, filename, stage)
	Stage.new(self)

	self.id = id
	self.filename = filename
	self.stage = stage

	self.layers = {}
	self.layersByID = {}
	self.mapScripts = {}

	self.players = {}
	self.playersByID = {}
	self.orphans = {}

	self.maps = {}

	self._onLoadMap = function(_, map, layer, tileSetID)
		if self:hasLayer(layer) then
			Log.engine(
				"Adding map to instance %s (%d) on layer %d.",
				self:getFilename(),
				self:getID(),
				layer)
			self.maps[layer] = Instance.Map(layer, map, tileSetID)
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
		if self:hasLayer(layer) then
			Log.engine(
				"Unloaded map from instance %s (%d) on layer %d.",
				self:getFilename(),
				self:getID(),
				layer)
			self.maps[layer] = nil
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
		if self:hasLayer(layer) then
			Log.engine(
				"Modified map in instance %s (%d) on layer %d.",
				self:getFilename(),
				self:getID(),
				layer)

			local previousMap = self.maps[layer]
			if previousMap then
				self.maps[layer] = Instance.Map(layer, map, previousMap:getTileSetID())
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
			table.insert(self.actorsPendingRemoval, actor)
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
			table.insert(self.propsPendingRemoval, prop)
		else
			Log.engine(
				"Did not try to remove prop '%s' (resource/peep ID = %s, ID = %d) from instance %s (%d); prop not in instance.",
				prop:getName(), prop:getPeepID(), prop:getID(), self:getFilename(), self:getID())
		end
	end
	stage.onPropRemoved:register(self._onPropRemoved)

	self.water = {}

	self._onWaterFlood = function(_, key, water, layer)
		if self:hasLayer(layer) then
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
		if self:hasLayer(layer) then
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
		if self:hasLayer(layer) then
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
		if self:hasLayer(layer) then
			Log.engine(
				"Trying to stop music on track '%s' (layer = %d) from instance %s (%d).",
				track, layer, self:getFilename(), self:getID())

			for i = 1, #self.music do
				if self.music[i]:getTrack() == track then
					Log.engine("Music removed from index %d.", i)
					table.remove(self.music, i)
					self:onStopMusic(track, song, layer)
					return
				end
			end

			Log.engine("Warning; music not found.")
		else
			Log.engine(
				"Did not stop music on track '%s' (layer = %d) from instance %s (%d); layer not in instance.",
				track, layer, self:getFilename(), self:getID())
		end
	end
	stage.onStopMusic:register(self._onStopMusic)

	self.weather = {}

	self._onForecast = function(_, layer, key, id, props)
		if self:hasLayer(layer) then
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
		if self:hasLayer(layer) then
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
		if self:hasLayer(layer) then
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
		if self:hasLayer(layer) then
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

			Log.engine("Warning; deocration not found.")
		else
			Log.engine(
				"Did not remove decoration '%s' (layer = %d) to instance %s (%d); layer not instance",
				group, layer, self:getFilename(), self:getID())
		end
	end
	stage.onUndecorate:register(self._onUndecorate)

	self.items = {}

	self._onDropItem = function(_, ref, item, tile, position, layer)
		if self:hasLayer(layer) then
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
		if self:hasLayer(layer) then
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

		if (self:hasLayer(sourceLayer) or source == nil) and
		   (self:hasLayer(destinationLayer) or destination == nil) then

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

function Instance:hasLayer(layer)
	return self.layersByID[layer] == true
end

function Instance:addLayer(layer)
	if not self:hasLayer(layer) then
		Log.engine("Adding layer %d to instance %s (%d).", layer, self:getFilename(), self:getID())
		self.layersByID[layer] = true
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
	if self:hasLayer(layer) then
		Log.engine("Base layer set to %d in instance %s (%d).", layer, self:getFilename(), self:getID())
		self.baseLayer = layer
	else
		Log.engine("Could not set base layer to %d in instance %s (%d); layer not in instance.", layer, self:getFilename(), self:getID())
	end
end

function Instance:getBaseLayer()
	return self.baseLayer
end

function Instance:iterateLayers()
	return ipairs(self.layers)
end

function Instance:addMapScript(layer, peep, filename)
	if self:hasLayer(layer) then
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

	Log.warn("No map script for layer %d in instance %s (%d).", layer, self:getFilename(), self:getInstance())
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
		Log.info("Adding player '%s' (%d) to instance %s (%d).", player:getActor():getName(), player:getID(), self:getFilename(), self:getID())

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
			Log.info("Removing player '%s' (%d) from instance %s (%d).", player:getActor():getName(), player:getID(), self:getFilename(), self:getID())

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
		player:getActor():getName(), player:getID(), self:getFilename(), self:getID())
end

function Instance:getPartyLeader()
	return self.partyLeader
end

function Instance:setPartyLeader(player)
	if self:hasPlayer(player) then
		Log.info("Set party leader to player '%s' (%d) to instance %s (%d).", player:getActor():getName(), player:getID(), self:getFilename(), self:getID())
		self.partyLeader = player
	else
		Log.info("Could not set party leader to player '%s' (%d) to instance %s (%d); player not in instance.", player:getActor():getName(), player:getID(), self:getFilename(), self:getID())
	end
end

function Instance:hasActor(actor)
	return self.actorsByID[actor:getID()] ~= nil
end

function Instance:hasProp(prop)
	return self.propsByID[prop:getID()] ~= nil
end

function Instance:_addPlayerToInstance(player, e)
	if e and e.isOrphan then
		self.orphans[player:getActor():getID()] = true
	end

	for i = 1, #self.layers do
		local mapScript = self:getMapScriptByLayer(self.layers[i])
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

function Instance:_removePlayerFromInstance(player)
	self.orphans[player] = nil

	for i = 1, #self.layers do
		local mapScript = self:getMapScriptByLayer(self.layers[i])
		if mapScript then
			local function onPlayerLeave()
				mapScript:pushPoke('playerLeave', player)
				mapScript:silence('finalize', onPlayerEnter)
			end

			if mapScript:getDirector() then
				onPlayerLeave()
			else
				mapScript:listen('finalize', onPlayerEnter)
			end
		end
	end
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
			actor:getID())
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
			prop:getID())
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

	for _, music in ipairs(self.music) do
		localGameManager:pushCallback(
			"ItsyScape.Game.Model.Stage",
			0,
			"onStopMusic",
			localGameManager:getArgs(music:getTrack(), music:getSong(), music:getLayer()))
		localGameManager:assignTargetToLastPush(player)

		Log.engine("Unloaded song '%s' on track '%s' for layer %d.", music:getSong(), music:getTrack(), music:getLayer())
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
				localGameManager:getArgs(player:getActor()))
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
	Log.engine("Restoring instance for player '%s'...", (player:getActor() and player:getActor():getName()) or tostring(player:getID()))

	for _, layer in self:iterateLayers() do
		local map = self.stage:getMap(layer)

		localGameManager:pushCallback(
			"ItsyScape.Game.Model.Stage",
			0,
			"onLoadMap",
			localGameManager:getArgs(map, layer, self.maps[layer]:getTileSetID()))
		localGameManager:assignTargetToLastPush(player)
		localGameManager:pushCallback(
			"ItsyScape.Game.Model.Stage",
			0,
			"onMapModified",
			localGameManager:getArgs(map, layer))
		localGameManager:assignTargetToLastPush(player)
		localGameManager:pushCallback(
			"ItsyScape.Game.Model.Stage",
			0,
			"onMapModified",
			localGameManager:getArgs(map, layer))

		Log.engine("Loaded layer %d.", layer)
	end

	for i = 1, #self.actors do
		local actor = self.actors[i]
		if self.orphans[actor:getID()] then
			Log.engine(
				"Actor '%s' (%d) was orphan, no need to re-create.",
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

		Log.engine("Restored prop '%s' (%s).", prop:getName(), prop:getPeepID())
	end

	for _, water in ipairs(self.water) do
		localGameManager:pushCallback(
			"ItsyScape.Game.Model.Stage",
			0,
			"onWaterFlood",
			localGameManager:getArgs(water:getKey(), water:getWaterDefinition(), water:getLayer()))
		localGameManager:assignTargetToLastPush(player)

		Log.engine("Restored water '%s' for layer %d.", water:getKey(), water:getLayer())
	end

	for _, weather in ipairs(self.weather) do
		localGameManager:pushCallback(
			"ItsyScape.Game.Model.Stage",
			0,
			"onForecast",
			localGameManager:getArgs(weather:getLayer(), weather:getKey(), weather:getWeatherID(), weather:getProps()))
		localGameManager:assignTargetToLastPush(player)

		Log.engine("Restored weather '%s' for layer %d.", weather:getKey(), weather:getLayer())
	end

	for _, decoration in ipairs(self.decorations) do
		localGameManager:pushCallback(
			"ItsyScape.Game.Model.Stage",
			0,
			"onDecorate",
			localGameManager:getArgs(decoration:getGroup(), decoration:getDecoration(), decoration:getLayer()))
		localGameManager:assignTargetToLastPush(player)

		Log.engine("Restored decoration '%s' for layer %d.", decoration:getGroup(), decoration:getLayer())
	end

	for _, music in ipairs(self.music) do
		localGameManager:pushCallback(
			"ItsyScape.Game.Model.Stage",
			0,
			"onPlayMusic",
			localGameManager:getArgs(music:getTrack(), music:getSong(), music:getLayer()))
		localGameManager:assignTargetToLastPush(player)

		Log.engine("Restored song '%s' on track '%s' for layer %d.", music:getSong(), music:getTrack(), music:getLayer())
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

	Log.engine("Restored actor '%s' (%d).", actor:getName(), actor:getID())
end

function Instance:tick()
	for i = 1, #self.actorsPendingRemoval do
		local actor = self.actorsPendingRemoval[i]

		for i = 1, #self.actors do
			if self.actors[i] == actor then
				Log.engine("Finally removed actor %d from instance %s (%d).", actor:getID(), self:getFilename(), self:getID())
				table.remove(self.actors, i)
				self.actorsByID[actor:getID()] = nil
				break
			end
		end
	end
	table.clear(self.actorsPendingRemoval)

	for i = 1, #self.propsPendingRemoval do
		local prop = self.propsPendingRemoval[i]
		for i = 1, #self.props do
			if self.props[i] == prop then
				Log.engine("Finally removed prop %d from instance %s (%d).", prop:getID(), self:getFilename(), self:getID())
				table.remove(self.props, i)
				self.propsByID[prop:getID()] = nil
				break
			end
		end
	end
	table.clear(self.propsPendingRemoval)

	table.clear(self.orphans)
end

return Instance
