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

	self.maps = {}

	self._onLoadMap = function(_, map, layer, tileSetID)
		if self:hasLayer(layer) then
			self.maps[layer] = Instance.Map(layer, map, tileSetID)
		end
	end
	stage.onLoadMap:register(self._onLoadMap)

	self._onUnloadMap = function(_, map, layer)
		if self:hasLayer(layer) then
			self.maps[layer] = map
		end
	end
	stage.onUnloadMap:register(self._onUnloadMap)

	self._onMapModified = function(_, map, layer)
		if self:hasLayer(layer) then
			local previousMap = self.maps[layer]
			if previousMap then
				self.maps[layer] = Instance.Map(layer, map, previousMap:getTileSetID())
			end
		end
	end
	stage.onMapModified:register(self._onMapModified)

	self.actors = {}
	self.actorsByID = {}

	self._onActorSpawned = function(_, actorID, actor)
		local instance = stage:getPeepInstance(actor:getPeep())
		if instance == self then
			table.insert(self.actors, actor)
			self.actorsByID[actor:getID()] = actor
		end
	end
	stage.onActorSpawned:register(self._onActorSpawned)

	self._onActorKilled = function(_, actor)
		local instance = stage:getPeepInstance(actor:getPeep())
		if instance == self then
			for i = 1, #self.actors do
				if self.actors[i] == actor then
					table.remove(self.actors, i)
					self.actorsByID[actor:getID()] = nil
					break
				end
			end
		end
	end
	stage.onActorKilled:register(self._onActorKilled)

	self.props = {}
	self.propsByID = {}

	self._onPropPlaced = function(_, propID, prop)
		local instance = stage:getPeepInstance(prop:getPeep())
		if instance == self then
			table.insert(self.props, prop)
			self.propsByID[prop:getID()] = prop
		end
	end
	stage.onPropPlaced:register(self._onPropPlaced)

	self._onPropRemoved = function(_, prop)
		local instance = stage:getPeepInstance(prop:getPeep())
		if instance == self then
			for i = 1, #self.props do
				if self.props[i] == prop then
					table.remove(self.props, i)
					self.propsByID[prop:getID()] = nil
					break
				end
			end
		end
	end
	stage.onPropRemoved:register(self._onPropRemoved)

	self.water = {}

	self._onWaterFlood = function(_, key, water, layer)
		if self:hasLayer(layer) then
			for i = 1, #self.water do
				if self.water[i]:getKey() == key then
					self.water[i] = Instance.Water(layer, key, water)
					self:onWaterFlood(key, water, layer)
					return
				end
			end

			table.insert(self.water, Instance.Water(layer, key, water))
			self:onWaterFlood(key, water, layer)
		end
	end
	stage.onWaterFlood:register(self._onWaterFlood)

	self._onWaterDrain = function(_, key, layer)
		if self:hasLayer(layer) then
			for i = 1, #self.water do
				if self.water[i]:getKey() == key then
					table.remove(self.water, i)
					self:onWaterDrain(key, layer)
					break
				end
			end
		end
	end
	stage.onWaterDrain:register(self._onWaterDrain)

	self.weather = {}

	self._onForecast = function(_, layer, key, id, props)
		if self:hasLayer(layer) then
			for i = 1, #self.weather do
				if self.weather[i]:getKey() == key then
					self.weather[i] = Instance.Weather(layer, key, id, props)
					self:onForecast(layer, key, id, props)
					return
				end
			end

			table.insert(self.weather, Instance.Weather(layer, key, id, props))
			self:onForecast(layer, key, id, props)
		end
	end
	stage.onForecast:register(self._onForecast)

	self._onStopForecast = function(_, layer, key)
		if self:hasLayer(layer) then
			for i = 1, #self.weather do
				if self.weather[i]:getKey() == key then
					table.remove(self.weather, i)
					self:onStopForecast(layer, key)
					break
				end
			end
		end
	end
	stage.onStopForecast:register(self._onStopForecast)

	self.decorations = {}

	self._onDecorate = function(_, group, decoration, layer)
		if self:hasLayer(layer) then
			for i = 1, #self.decorations do
				if self.decorations[i]:getGroup() == group then
					self.decorations[i] = Instance.Decoration(layer, group, decoration)
					self:onDecorate(group, decoration, layer)
					return
				end
			end

			table.insert(self.decorations, Instance.Decoration(layer, group, decoration))
			self:onDecorate(group, decoration, layer)
		end
	end
	stage.onDecorate:register(self._onDecorate)

	self._onUndecorate = function(_, group, layer)
		if self:hasLayer(layer) then
			for i = 1, #self.decorations do
				if self.decorations[i]:getGroup() == group then
					table.remove(self.decorations, i)
					self:onUndecorate(group, layer)
					break
				end
			end
		end
	end
	stage.onUndecorate:register(self._onUndecorate)

	self.pendingProjectiles = {}

	self._onProjectile = function(_, projectileID, source, destination, time)
		local sourceLayer = source and not Class.isType(source, Vector) and Utility.Peep.getLayer(source:getPeep())
		local destinationLayer = destination and not Class.isType(destination, Vector) and Utility.Peep.getLayer(destination:getPeep())

		if (self:hasLayer(sourceLayer) or source == nil) and
		   (self:hasLayer(destinationLayer) or destination == nil) then
			self:onProjectile(projectileID, source, destination, time)
		end
	end
	stage.onProjectile:register(self._onProjectile)
end

function Instance:unload()
	self.stage.onWaterFlood:unregister(self._onWaterFlood)
	self.stage.onWaterDrain:unregister(self._onWaterDrain)
	self.stage.onForecast:unregister(self._onForecast)
	self.stage.onStopForecast:unregister(self._onStopForecast)
	self.stage.onDecorate:unregister(self._onDecorate)
	self.stage.onUndecorate:unregister(self._onUndecorate)
	self.stage.onProjectile:unregister(self._onProjectile)
end

function Instance:getID()
	return self.id
end

function Instance:getFilename()
	return self.filename
end

function Instance:hasLayer(layer)
	return self.layersByID[layer] == true
end

function Instance:addLayer(layer)
	if not self:hasLayer(layer) then
		self.layersByID[layer] = true
		table.insert(self.layers, layer)
	end
end

function Instance:removeLayer(layer)
	self.layersByID[layer] = nil
	for i = 1, #self.layers do
		if self.layers[i] == layer then
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
		self.baseLayer = layer
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
		self.mapScripts[layer] = Instance.MapScript(layer, peep, filename)
	end
end

function Instance:removeMapScript(layer)
	self.mapScripts[layer] = nil
end

function Instance:getMapScriptByLayer(layer)
	local mapScript = self.mapScripts[layer]
	if mapScript then
		return mapScript:getPeep()
	end

	return nil
end

function Instance:hasPlayer(player)
	return self.playersByID[player:getID()] == true
end

function Instance:addPlayer(player)
	if not self:hasPlayer(player) then
		table.insert(self.players, player)

		self:_addPlayerToInstance(player)
	end
end

function Instance:removePlayer(player)
	self.playersByID[player:getID()] = nil
	for i = 1, #self.players do
		if self.players[i]:getID() == player:getID() then
			table.remove(self.players, i)

			if self.partyLeader and self.partyLeader:getID() == player:getID() then
				self.partyLeader = nil
			end

			self:_removePlayerFromInstance(player)

			break
		end
	end
end

function Instance:setPartyLeader(player)
	if self:hasPlayer(player) then
		self.partyLeader = player
	end
end

function Instance:hasActor(actor)
	return self.actorsByID[actor:getID()] ~= nil
end

function Instance:hasProp(prop)
	return self.propsByID[prop:getID()] ~= nil
end

function Instance:playMusic(track, song)
	self.music[track] = Instance.Music(track, song)
end

function Instance:stopMusic(track, song)
	self.music[track] = nil
end

function Instance:_addPlayerToInstance(player)
	local actor = player:getActor()
	table.insert(self.actors, actor)
	self.actorsByID[actor:getID()] = actor
end

function Instance:_removePlayerFromInstance(player)
	local actor = player:getActor()
	for i = 1, #self.actors do
		if self.actors[i] == actor then
			table.remove(self.actors, i)
			self.actorsByID[actor:getID()] = actor
			break
		end
	end
end

function Instance:unloadPlayer(localGameManager, player)
	for _, layer in self:iterateLayers() do
		local map = self.stage:getMap(layer)

		localGameManager:pushCallback(
			"ItsyScape.Game.Model.Stage",
			0,
			"onUnloadMap",
			localGameManager:getArgs(map, layer))
		localGameManager:assignTargetToLastPush(player)
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
	end

	for _, water in ipairs(self.water) do
		localGameManager:pushCallback(
			"ItsyScape.Game.Model.Stage",
			0,
			"onWaterDrain",
			localGameManager:getArgs(water:getKey(), water:getLayer()))
		localGameManager:assignTargetToLastPush(player)
	end

	for _, weather in ipairs(self.weather) do
		localGameManager:pushCallback(
			"ItsyScape.Game.Model.Stage",
			0,
			"onStopForecast",
			localGameManager:getArgs(weather:getLayer(), weather:getKey()))
		localGameManager:assignTargetToLastPush(player)
	end

	for _, decoration in ipairs(self.decorations) do
		localGameManager:pushCallback(
			"ItsyScape.Game.Model.Stage",
			0,
			"onUndecorate",
			localGameManager:getArgs(decoration:getGroup(), decoration:getLayer()))
		localGameManager:assignTargetToLastPush(player)
	end
end

function Instance:loadPlayer(localGameManager, player)
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
	end

	for i = 1, #self.actors do
		local actor = self.actors[i]

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
	end

	for _, water in ipairs(self.water) do
		localGameManager:pushCallback(
			"ItsyScape.Game.Model.Stage",
			0,
			"onWaterFlood",
			localGameManager:getArgs(water:getKey(), water:getWaterDefinition(), water:getLayer()))
		localGameManager:assignTargetToLastPush(player)
	end

	for _, weather in ipairs(self.weather) do
		localGameManager:pushCallback(
			"ItsyScape.Game.Model.Stage",
			0,
			"onForecast",
			localGameManager:getArgs(weather:getLayer(), weather:getKey(), weather:getWeatherID(), weather:getProps()))
		localGameManager:assignTargetToLastPush(player)
	end

	for _, decoration in ipairs(self.decorations) do
		localGameManager:pushCallback(
			"ItsyScape.Game.Model.Stage",
			0,
			"onDecorate",
			localGameManager:getArgs(decoration:getGroup(), decoration:getDecoration(), decoration:getLayer()))
		localGameManager:assignTargetToLastPush(player)
	end
end

function Instance:loadActor(localGameManager, player, actor)
	local actorInstance = localGameManager:getInstance(
		"ItsyScape.Game.Model.Actor",
		actor:getID())

	if not actorInstance then
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
			end
		end
	end
end

return Instance
