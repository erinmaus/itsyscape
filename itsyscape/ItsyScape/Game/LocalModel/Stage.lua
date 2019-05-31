--------------------------------------------------------------------------------
-- ItsyScape/Game/LocalModel/Stage.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Vector = require "ItsyScape.Common.Math.Vector"
local Quaternion = require "ItsyScape.Common.Math.Quaternion"
local Utility = require "ItsyScape.Game.Utility"
local GroundInventoryProvider = require "ItsyScape.Game.GroundInventoryProvider"
local TransferItemCommand = require "ItsyScape.Game.TransferItemCommand"
local LocalActor = require "ItsyScape.Game.LocalModel.Actor"
local LocalProp = require "ItsyScape.Game.LocalModel.Prop"
local Stage = require "ItsyScape.Game.Model.Stage"
local CompositeCommand = require "ItsyScape.Peep.CompositeCommand"
local Peep = require "ItsyScape.Peep.Peep"
local ActorReferenceBehavior = require "ItsyScape.Peep.Behaviors.ActorReferenceBehavior"
local InventoryBehavior = require "ItsyScape.Peep.Behaviors.InventoryBehavior"
local MapResourceReferenceBehavior = require "ItsyScape.Peep.Behaviors.MapResourceReferenceBehavior"
local PlayerBehavior = require "ItsyScape.Peep.Behaviors.PlayerBehavior"
local PositionBehavior = require "ItsyScape.Peep.Behaviors.PositionBehavior"
local PropReferenceBehavior = require "ItsyScape.Peep.Behaviors.PropReferenceBehavior"
local RotationBehavior = require "ItsyScape.Peep.Behaviors.RotationBehavior"
local ScaleBehavior = require "ItsyScape.Peep.Behaviors.ScaleBehavior"
local Map = require "ItsyScape.World.Map"
local Decoration = require "ItsyScape.Graphics.Decoration"
local ExecutePathCommand = require "ItsyScape.World.ExecutePathCommand"

local LocalStage = Class(Stage)

function LocalStage:new(game)
	Stage.new(self)
	self.game = game
	self.actors = {}
	self.props = {}
	self.peeps = {}
	self.decorations = {}
	self.currentActorID = 1
	self.currentPropID = 1
	self.map = {}
	self.numMaps = 0
	self.mapScripts = {}
	self.water = {}
	self.gravity = Vector(0, -9.8, 0)
	self.stageName = "::orphan"
	self.tests = { id = 1 }
	self.weathers = {}
	self.music = {}

	self.grounds = {}
	self:spawnGround(self.stageName, 1)

	self.mapThread = love.thread.newThread("ItsyScape/Game/LocalModel/Threads/Map.lua")
	self.mapThread:start()
end

function LocalStage:spawnGround(filename, layer)
	local ground = self.game:getDirector():addPeep(filename, require "Resources.Game.Peeps.Ground")
	self.grounds[filename] = ground
	self.grounds[layer] = ground

	local inventory = ground:getBehavior(InventoryBehavior).inventory
	inventory.onTakeItem:register(self.notifyTakeItem, self)
	inventory.onDropItem:register(self.notifyDropItem, self)
end 

function LocalStage:notifyTakeItem(item, key)
	local ref = self.game:getDirector():getItemBroker():getItemRef(item)
	self.onTakeItem(self, { ref = ref, id = item:getID(), noted = item:isNoted() })
end

function LocalStage:notifyDropItem(item, key, source)
	local ref = self.game:getDirector():getItemBroker():getItemRef(item)
	local position = source:getPeep():getBehavior(PositionBehavior)
	if position then
		local p = position.position
		position = Vector(p.x, p.y, p.z)
	else
		position = Vector(0)
	end

	self.onDropItem(
		self,
		{ ref = ref, id = item:getID(), noted = item:isNoted() },
		{ i = key.i, j = key.j, layer = key.layer },
		position)
end

function LocalStage:getMapScript(key)
	local map = self.mapScripts[key]
	if map then
		return map.peep, map.layer
	else
		return nil
	end
end

function LocalStage:lookupResource(resourceID, resourceType)
	local Type
	local realResourceID, resource
	do
		local protocol, value = resourceID:match("(.*)%:%/*(.*)")
		if protocol and value then
			realResourceID = value

			if protocol:lower() == "resource" then
				local gameDB = self.game:getGameDB()
				local r = gameDB:getResource(value, resourceType)

				if r then
					local record = gameDB:getRecords("PeepID", { Resource = r }, 1)[1]
					if record then
						local t = record:get("Value")

						if not t or t == "" then
							Log.error("resource ID malformed for resource '%s'", value)
							return false, nil
						else
							Type = require(t)
							resource = r
						end
					else
						Log.warn("no peep ID for resource '%s'", value)
						return false, nil
					end
				else
					Log.error("resource ('%s') '%s' not found.", resourceType, value)
					return false, nil
				end
			elseif protocol:lower() == "peep" then
				Type = require(value)
			else
				Log.error("bad protocol: '%s'", protocol:lower())
				return false, nil
			end
		else
			Type = require(resourceID)
			realResourceID = resourceID
		end
	end

	return Type, resource, realResourceID
end

function LocalStage:spawnActor(actorID, layer)
	layer = layer or 1

	local Peep, resource, realID = self:lookupResource(actorID, "Peep")

	if Peep then
		local actor = LocalActor(self.game, Peep)
		actor:spawn(self.currentActorID, self.stageName, resource)

		self.onActorSpawned(self, realID, actor)

		self.currentActorID = self.currentActorID + 1
		self.actors[actor] = true

		local peep = actor:getPeep()
		self.peeps[actor] = peep
		self.peeps[peep] = actor

		peep:listen('ready', function()
			local p = peep:getBehavior(PositionBehavior)
			if p then
				p.layer = layer
			end
		end)

		return true, actor
	end

	return false, nil
end

function LocalStage:killActor(actor)
	if actor and self.actors[actor] or self.peeps[actor] then
		if actor:isCompatibleType(Peep) then
			actor = self.peeps[actor]
		end

		self.onActorKilled(self, actor)
		actor:depart()

		local peep = self.peeps[actor]
		self.peeps[actor] = nil
		self.peeps[peep] = nil

		self.actors[actor] = nil
	end
end

function LocalStage:placeProp(propID, layer)
	layer = layer or 1

	local Peep, resource, realID = self:lookupResource(propID, "Prop")

	if Peep then
		local prop = LocalProp(self.game, Peep)
		prop:place(self.currentPropID, self.stageName, resource)

		self.onPropPlaced(self, realID, prop)

		self.currentPropID = self.currentPropID + 1
		self.props[prop] = true

		local peep = prop:getPeep()
		self.peeps[prop] = peep
		self.peeps[peep] = prop

		peep:listen('ready', function()
			local p = peep:getBehavior(PositionBehavior)
			if p then
				p.layer = layer
			end
		end)

		return true, prop
	end

	return false, nil
end

function LocalStage:removeProp(prop)
	if prop and self.props[prop] or self.peeps[prop] then
		if prop:isCompatibleType(Peep) then
			prop = self.peeps[prop]
		end

		self.onPropRemoved(self, prop)
		prop:remove()

		local peep = self.peeps[prop]
		self.peeps[prop] = nil
		self.peeps[peep] = nil

		self.props[prop] = nil
	end
end

function LocalStage:instantiateMapObject(resource, layer)
	layer = layer or 1

	local gameDB = self.game:getGameDB()

	local object = gameDB:getRecord("MapObjectLocation", {
		Resource = resource
	}) or gameDB:getRecord("MapObjectReference", {
		Resource = resource
	})

	local actorInstance, propInstance

	if object then
		local x = object:get("PositionX") or 0
		local y = object:get("PositionY") or 0
		local z = object:get("PositionZ") or 0

		do
			local prop = gameDB:getRecord("PropMapObject", {
				MapObject = object:get("Resource")
			})

			if prop then
				prop = prop:get("Prop")
				if prop then
					local s, p = self:placeProp("resource://" .. prop.name, layer)

					if s then
						local peep = p:getPeep()
						local position = peep:getBehavior(PositionBehavior)
						if position then
							position.position = Vector(x, y, z)
						end

						local scale = peep:getBehavior(ScaleBehavior)
						if scale then
							local sx = math.max(object:get("ScaleX") or 0, 1)
							local sy = math.max(object:get("ScaleY") or 0, 1)
							local sz = math.max(object:get("ScaleZ") or 0, 1)

							scale.scale = Vector(sx, sy, sz)
						end

						local rotation = peep:getBehavior(RotationBehavior)
						if rotation then
							local rx = object:get("RotationX") or 0
							local ry = object:get("RotationY") or 0
							local rz = object:get("RotationZ") or 0
							local rw = object:get("RotationW") or 1

							if rw ~= 0 then
								rotation.rotation = Quaternion(rx, ry, rz, rw)
							end
						end

						propInstance = p

						Utility.Peep.setMapObject(peep, resource)

						local s, b = peep:addBehavior(MapResourceReferenceBehavior)
						if s then
							b.map = object:get("Map")
						end
					end
				end
			end
		end

		do
			local actor = gameDB:getRecord("PeepMapObject", {
				MapObject = object:get("Resource")
			})

			if actor then
				actor = actor:get("Peep")
				if actor then
					local s, a = self:spawnActor("resource://" .. actor.name, layer)

					if s then
						local peep = a:getPeep()
						local position = peep:getBehavior(PositionBehavior)
						if position then
							position.position = Vector(x, y, z)
						end

						local direction = object:get("Direction")
						if direction then
							if direction < 0 then
								a:setDirection(Vector(-1, 0, 0))
							elseif direction > 0 then
								a:setDirection(Vector(1, 0, 0))
							end
						end

						actorInstance = a

						Utility.Peep.setMapObject(peep, resource)

						local s, b = peep:addBehavior(MapResourceReferenceBehavior)
						if s then
							b.map = object:get("Map")
						end
					end
				end
			end
		end
	end

	return actorInstance, propInstance
end

function LocalStage:loadMapFromFile(filename, layer, tileSetID)
	self:unloadMap(layer)

	local map = Map.loadFromFile(filename)
	if map then
		self.map[layer] = map
		self.onLoadMap(self, self.map[layer], layer, tileSetID)
		self.game:getDirector():setMap(layer, map)

		self:updateMap(layer)
	end
end

function LocalStage:newMap(width, height, layer, tileSetID)
	self:unloadMap(layer)

	local map = Map(width, height, Stage.CELL_SIZE)
	self.map[layer] = map
	self.onLoadMap(self, self.map[layer], layer, tileSetID)
	self.game:getDirector():setMap(layer, map)

	self:updateMap(layer)
end

function LocalStage:updateMap(layer, map)
	if self.map[layer] then
		if map then
			self.map[layer] = map
			self.game:getDirector():setMap(layer, map)
		end

		love.thread.getChannel('ItsyScape.Map::input'):push({
			type = 'load',
			key = layer,
			data = self.map[layer]:toString()
		})

		self.onMapModified(self, self.map[layer], layer)
	end
end

function LocalStage:unloadMap(layer)
	if self.map[layer] then
		self.onUnloadMap(self, self.map[layer], layer)
		self.map[layer] = nil
		self.game:getDirector():setMap(layer, nil)

		love.thread.getChannel('ItsyScape.Map::input'):push({
			type = 'unload',
			key = layer
		})
	end
end

function LocalStage:flood(key, water, layer)
	self.onWaterFlood(self, key, water, layer)
end

function LocalStage:drain(key, layer)
	self.onWaterDrain(self, key)
end

function LocalStage:unloadAll()
	do
		self.game:getDirector():getItemBroker():toStorage()
	end

	local layers = self:getLayers()
	for i = 1, #layers do
		self:unloadMap(layers[i])
	end

	self.numMaps = 0

	for key in pairs(self.water) do
		self.onWaterDrain(self, key)
	end

	for group, decoration in pairs(self.decorations) do
		self:decorate(group, nil)
	end

	for weather in pairs(self.weathers) do
		self:forecast(nil, weather, nil)
	end

	do
		local p = {}

		for prop in self:iterateProps() do
			table.insert(p, prop)
		end

		for _, prop in ipairs(p) do
			self:removeProp(prop)
		end
	end

	do
		local p = {}

		for actor in self:iterateActors() do
			if actor ~= self.game:getPlayer():getActor() then
				table.insert(p, actor)
			end
		end

		do
			self:collectItems()

			self.grounds = {}
		end

		for _, actor in ipairs(p) do
			self:killActor(actor)
		end
	end

	self.game:getDirector():removeLayer(self.stageName)
	self.mapScripts = {}
end

function LocalStage:movePeep(peep, path, anchor, force)
	local filename
	do
		local s, e = path:find("%?")
		s = s or 1
		e = e or #path + 1
		
		filename = path:sub(1, e - 1)
	end

	local playerPeep = self.game:getPlayer():getActor():getPeep()
	if playerPeep == peep then
		-- We want to reload if this is a new stage, if it's forced, or if it's
		-- an instance (has a ?).
		if filename ~= self.stageName or force or filename ~= path then
			self:loadStage(path)
		end

		playerPeep = self.game:getPlayer():getActor():getPeep()
		local position = playerPeep:getBehavior(PositionBehavior)

		if Class.isType(anchor, Vector) then
			position.position = Vector(anchor.x, anchor.y, anchor.z)
		else
			local gameDB = self.game:getGameDB()
			local map = gameDB:getResource(filename, "Map")
			if map then
				local mapObject = gameDB:getRecord("MapObjectLocation", {
					Name = anchor,
					Map = map
				})

				local x, y, z = mapObject:get("PositionX"), mapObject:get("PositionY"), mapObject:get("PositionZ")
				position.position = Vector(x, y, z)
			end
		end
	else
		local actor = peep:getBehavior(ActorReferenceBehavior)
		local prop = peep:getBehavior(PropReferenceBehavior)
		if actor and actor.actor then
			self:killActor(actor.actor)
		elseif prop and prop.prop then
			self:removeProp(prop.prop)
		else
			Log.error("Cannot move peep '%s'; not player, actor, or prop.", peep:getName())
			Log.warn("Removing peep '%s' anyway; may cause bad references.", peep:getName())
			self.game:getDirector():removePeep(peep)
		end
	end
end

function LocalStage:loadMapResource(filename, args)
	local directoryPath = "Resources/Game/Maps/" .. filename

	local baseLayer = self.numMaps or 0

	local meta
	do
		local metaFilename = directoryPath .. "/meta"
		local data = "return " .. (love.filesystem.read(metaFilename) or "")
		local chunk = assert(loadstring(data))
		meta = setfenv(chunk, {})() or {}
	end

	local musicMeta
	do
		local metaFilename = directoryPath .. "/meta.music"
		local data = "return " .. (love.filesystem.read(metaFilename) or "")
		local chunk = assert(loadstring(data))
		musicMeta = setfenv(chunk, {})() or {}
	end

	for key, song in pairs(musicMeta) do
		self:playMusic(self.stageName, key, song)
	end

	local maxLayer = baseLayer
	for _, item in ipairs(love.filesystem.getDirectoryItems(directoryPath)) do
		local layer = item:match(".*(-?%d)%.lmap$")
		if layer then
			layer = tonumber(layer)

			local tileSetID
			if meta[layer] then
				tileSetID = meta[layer].tileSetID
			end

			local layerMeta = meta[layer] or {}

			self:loadMapFromFile(directoryPath .. "/" .. item, layer + baseLayer, layerMeta.tileSetID)
			maxLayer = math.max(layer + baseLayer, maxLayer)
		end
	end

	self.numMaps = maxLayer

	local layer = baseLayer + 1

	do
		local waterDirectoryPath = directoryPath .. "/Water"
		for _, item in ipairs(love.filesystem.getDirectoryItems(waterDirectoryPath)) do
			local data = "return " .. (love.filesystem.read(waterDirectoryPath .. "/" .. item) or "")
			local chunk = assert(loadstring(data))
			water = setfenv(chunk, {})() or {}

			self.onWaterFlood(self, item, water, layer)
			self.water[item] = water
		end
	end

	for _, item in ipairs(love.filesystem.getDirectoryItems(directoryPath .. "/Decorations")) do
		local group = item:match("(.*)%.ldeco$")
		if group then
			local key = directoryPath .. "/Decorations/" .. item
			local decoration = Decoration(directoryPath .. "/Decorations/" .. item)
			self:decorate(key, decoration, layer)
		end
	end

	self:spawnGround(filename, layer)

	local mapScript

	local gameDB = self.game:getGameDB()
	local resource = gameDB:getResource(filename, "Map")
	if resource then
		do
			local Peep = self:lookupResource("resource://" .. resource.name, "Map")
			if not Peep then
				Peep = require "ItsyScape.Peep.Peeps.Map"
			end

			self.mapScripts[filename] = {
				peep = self.game:getDirector():addPeep(self.stageName, Peep, resource),
				layer = layer
			}

			self.mapScripts[filename].peep:listen('ready',
				function(self)
					self:poke('load', filename, args or {}, layer)
				end
			)

			do
				local _, m = self.mapScripts[filename].peep:addBehavior(MapResourceReferenceBehavior)
				m.map = resource
			end 

			mapScript = self.mapScripts[filename].peep
		end

		local objects = gameDB:getRecords("MapObjectLocation", {
			Map = resource
		})

		for i = 1, #objects do
			self:instantiateMapObject(objects[i]:get("Resource"), baseLayer + 1)
		end
	end

	return baseLayer + 1, mapScript
end

function LocalStage:playMusic(layerName, channel, song)
	self.onPlayMusic(self, channel, song)
	table.insert(self.music, {
		channel = channel,
		song = song
	})
end

function LocalStage:stopMusic(layerName, channel, song)
	self.onStopMusic(self, channel, song)

	local index = 1
	while index <= #self.music do
		local m = self.music[index]
		if m.channel == channel and m.song == song then
			table.remove(self.music, index)
		else
			index = index + 1
		end
	end
end

function LocalStage:loadStage(path)
	local filename
	local args = {}
	do
		local s, e = path:find("%?")
		s = s or 1
		e = e or #path + 1
		
		filename = path:sub(1, e - 1)

		Log.info("Loading map %s.", filename)

		local pathArguments = path:sub(e, -1)
		for key, value in pathArguments:gmatch("([%w_]+)=([%w_]+)") do
			Log.info("Map argument '%s' -> '%s'.", key, value)
			args[key] = value
		end
	end

	do
		local director = self.game:getDirector()
		director:movePeep(self.game:getPlayer():getActor():getPeep(), "::safe")
	end

	local oldMusic = self.music
	self.music = {}

	self:unloadAll()
	self.oldStageName = self.stageName
	self.stageName = filename

	do
		for i = 1, #oldMusic do
			local m = oldMusic[i]
			local hasSong = false
			for j = 1, #self.music do
				if self.music[j].channel == m.channel then
					hasSong = true
					break
				end
			end

			if not hasSong then
				self:stopMusic(self.stageName, m.channel, m.song)
			end
		end
	end

	self:loadMapResource(filename, args)

	do
		local director = self.game:getDirector()
		local player = self.game:getPlayer():getActor():getPeep()
		director:movePeep(player, filename)

		local resource = director:getGameDB():getResource(filename, "Map")

		player:addBehavior(MapResourceReferenceBehavior)
		local m = player:getBehavior(MapResourceReferenceBehavior)
		m.map = resource or false

		player:poke('travel', {
			from = oldStageName,
			to = filename
		})
	end
end

function LocalStage:getMap(layer)
	return self.map[layer]
end

function LocalStage:testMap(layer, ray, callback)
	local id = self.tests.id
	self.tests.id = id + 1

	self.tests[id] = {
		layer = layer,
		callback = callback
	}

	love.thread.getChannel('ItsyScape.Map::input'):push({
		type = 'probe',
		id = id,
		key = layer,
		origin = { ray.origin.x, ray.origin.y, ray.origin.z },
		direction = { ray.direction.x, ray.direction.y, ray.direction.z }
	})
end

function LocalStage:getLayers()
	local layers = {}
	for index in pairs(self.map) do
		if type(index) == 'number' then
			table.insert(layers, index)
		end
	end

	table.sort(layers)
	return layers
end

function LocalStage:getGravity()
	return self.gravity
end

function LocalStage:setGravity(value)
	self.gravity = value or self.gravity
end

function LocalStage:getItemsAtTile(i, j, layer)
	local ground = self.grounds[layer]
	if not ground then
		return {}
	end

	local inventory = ground:getBehavior(InventoryBehavior).inventory

	if not inventory or not inventory:getBroker() then
		return {}
	else
		local key = GroundInventoryProvider.Key(i, j, layer)
		local broker = self.game:getDirector():getItemBroker()
		local result = {}
		for item in broker:iterateItemsByKey(inventory, key) do
			table.insert(result, {
				ref = broker:getItemRef(item),
				id = item:getID(),
				count = item:getCount(),
				noted = item:isNoted()
			})
		end

		return result
	end
end

function LocalStage:dropItem(item, count, owner)
	local broker = self.game:getDirector():getItemBroker()
	local provider = broker:getItemProvider(item)
	local map = provider:getPeep():getLayerName()
	local destination = self.grounds[map]:getBehavior(InventoryBehavior).inventory
	local transaction = broker:createTransaction()
	provider:getPeep():poke('dropItem', {
		item = item,
		count = count
	})

	transaction:addParty(provider)
	transaction:addParty(destination)
	transaction:transfer(destination, item, count, owner or 'drop', false)
	transaction:commit()
end

function LocalStage:takeItem(i, j, layer, ref)
	local inventory = self.grounds[layer]:getBehavior(InventoryBehavior).inventory
	if inventory then
		local key = GroundInventoryProvider.Key(i, j, layer)
		local broker = self.game:getDirector():getItemBroker()

		local targetItem
		for item in broker:iterateItemsByKey(inventory, key) do
			if broker:getItemRef(item) == ref then
				targetItem = item
				break
			end
		end

		if targetItem then
			local player = self.game:getPlayer()
			local path = player:findPath(i, j, layer)
			if path then
				local queue = player:getActor():getPeep():getCommandQueue()
				local function condition()
					if not broker:hasItem(targetItem) then
						return false
					end

					if broker:getItemProvider(targetItem) ~= inventory then
						return false
					end

					return true
				end

				local playerInventory = player:getActor():getPeep():getBehavior(
					InventoryBehavior).inventory
				if playerInventory then
					local walkStep = ExecutePathCommand(path)
					local takeStep = TransferItemCommand(
						broker,
						targetItem,
						playerInventory,
						targetItem:getCount(),
						'take',
						true)

					queue:interrupt(CompositeCommand(condition, walkStep, takeStep))
				end
			end
		end
	end
end

function LocalStage:collectItems()
	local transactions = {}

	local broker = self.game:getDirector():getItemBroker()
	local manager = self.game:getDirector():getItemManager()

	for key, ground in pairs(self.grounds) do
		inventory = ground:getBehavior(InventoryBehavior).inventory
		if broker:hasProvider(inventory) then
			for item in broker:iterateItems(inventory) do
				-- In the ground table, grounds are stored by layer (number) and layer (string).
				if type(key) == 'string' then
					local owner = broker:getItemTag(item, "owner")
					if owner and owner:hasBehavior(PlayerBehavior) then
						local bank = owner:getBehavior(InventoryBehavior).bank

						if bank then
							local transaction = transactions[owner]
							if not transaction then
								transaction = broker:createTransaction()
								transaction:addParty(bank)

								transactions[owner] = transaction
							end

							transaction:addParty(inventory)
							transaction:transfer(bank, item, item:getCount(), 'take')

							if not item:isNoted() and manager:isNoteable(item:getID()) then
								transaction:note(bank, item:getID(), item:getCount())
							end
						end
					end


					local ref = broker:getItemRef(item)
					self.onTakeItem(self, { ref = ref, id = item:getID(), noted = item:isNoted() })
				end
			end
		end
	end

	for _, transaction in pairs(transactions) do
		local s, r = transaction:commit()
		if not s then
			Log.warn("Couldn't commit pickicide: %s", r)
		end
	end
end

function LocalStage:fireProjectile(projectileID, source, destination)
	function peepToModel(peep)
		if peep:isCompatibleType(require "ItsyScape.Peep.Peep") then
			local prop = peep:getBehavior(PropReferenceBehavior)
			if prop and prop.prop then
				return prop.prop
			end

			local actor = peep:getBehavior(ActorReferenceBehavior)
			if actor and actor.actor then
				return actor.actor
			end

			return Utility.Peep.getAbsolutePosition(peep)
		end

		return peep
	end

	self.onProjectile(self, projectileID, peepToModel(source), peepToModel(destination), 0)
end

function LocalStage:forecast(layer, name, id, props)
	self.onForecast(self, name, id, props)
	self.weathers[name] = true
end

function LocalStage:decorate(group, decoration, layer)
	self.onDecorate(self, group, decoration, layer or 1)
	self.decorations[group] = decoration
end

function LocalStage:iterateActors()
	return pairs(self.actors)
end

function LocalStage:iterateProps()
	return pairs(self.props)
end

function LocalStage:tick()
	for _, map in pairs(self.mapScripts) do
		local peep = map.peep

		local position = peep:getBehavior(PositionBehavior)
		if position then
			position = position.position
		else
			position = Vector.ZERO
		end

		local rotation = peep:getBehavior(RotationBehavior)
		if rotation then
			rotation = rotation.rotation
		else
			rotation = Quaternion.IDENTITY
		end

		local scale = peep:getBehavior(ScaleBehavior)
		if scale then
			scale = scale.scale
		else
			scale = Vector.ONE
		end

		self.onMapMoved(self, map.layer, position, rotation, scale)
	end
end

function LocalStage:update(delta)
	local m = love.thread.getChannel('ItsyScape.Map::output'):pop()
	while m do
		if m.type == 'probe' then
			local test = self.tests[m.id]
			if test then
				local map = self:getMap(test.layer)
				if map then
					self.tests[m.id] = nil
					local results = {}

					for i = 1, #m.tiles do
						local tile = m.tiles[i]
						local result = {
							[Map.RAY_TEST_RESULT_TILE] = map:getTile(tile.i, tile.j),
							[Map.RAY_TEST_RESULT_I] = tile.i,
							[Map.RAY_TEST_RESULT_J] = tile.j,
							[Map.RAY_TEST_RESULT_POSITION] = Vector(unpack(tile.position))
						}

						table.insert(results, result)
					end

					test.callback(results)
				end
			end
		end
		m = love.thread.getChannel('ItsyScape.Map::output'):pop()
	end
end

return LocalStage
