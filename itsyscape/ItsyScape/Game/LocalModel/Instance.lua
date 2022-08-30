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
local Stage = require "ItsyScape.Game.Model.Stage"

local Instance = Class(Stage)

Instance.GLOBAL_ID      = 0
Instance.LOCAL_ID_START = 1

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
					self.weather[i] = Instance.Water(layer, key, id, props)
					self:onForecast(layer, key, id, props)
					return
				end
			end

			table.insert(self.weather, Instance.Water(layer, key, id, props))
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
		local sourceLayer = Utility.Peep.getLayer(source)
		local destinationLayer = Utility.Peep.getLayer(destination)

		if self:hasLayer(sourceLayer) and self:hasLayer(destinationLayer) then
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

function Instance:playMusic(track, song)
	self.music[track] = Instance.Music(track, song)
end

function Instance:stopMusic(track, song)
	self.music[track] = nil
end

function Instance:_addPlayerToInstance(player)
	-- Nothing.
end

function Instance:_removePlayerFromInstance(player)
	-- Nothing.
end

return Instance
