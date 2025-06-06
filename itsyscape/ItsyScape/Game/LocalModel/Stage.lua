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
local InventoryProvider = require "ItsyScape.Game.InventoryProvider"
local TransferItemCommand = require "ItsyScape.Game.TransferItemCommand"
local LocalActor = require "ItsyScape.Game.LocalModel.Actor"
local Instance = require "ItsyScape.Game.LocalModel.Instance"
local LocalProp = require "ItsyScape.Game.LocalModel.Prop"
local Stage = require "ItsyScape.Game.Model.Stage"
local CallbackCommand = require "ItsyScape.Peep.CallbackCommand"
local CompositeCommand = require "ItsyScape.Peep.CompositeCommand"
local Peep = require "ItsyScape.Peep.Peep"
local ActorReferenceBehavior = require "ItsyScape.Peep.Behaviors.ActorReferenceBehavior"
local DisabledBehavior = require "ItsyScape.Peep.Behaviors.DisabledBehavior"
local InventoryBehavior = require "ItsyScape.Peep.Behaviors.InventoryBehavior"
local InstancedBehavior = require "ItsyScape.Peep.Behaviors.InstancedBehavior"
local MapResourceReferenceBehavior = require "ItsyScape.Peep.Behaviors.MapResourceReferenceBehavior"
local MapOffsetBehavior = require "ItsyScape.Peep.Behaviors.MapOffsetBehavior"
local OriginBehavior = require "ItsyScape.Peep.Behaviors.OriginBehavior"
local PlayerBehavior = require "ItsyScape.Peep.Behaviors.PlayerBehavior"
local PositionBehavior = require "ItsyScape.Peep.Behaviors.PositionBehavior"
local PropReferenceBehavior = require "ItsyScape.Peep.Behaviors.PropReferenceBehavior"
local RotationBehavior = require "ItsyScape.Peep.Behaviors.RotationBehavior"
local ScaleBehavior = require "ItsyScape.Peep.Behaviors.ScaleBehavior"
local Map = require "ItsyScape.World.Map"
local TileSet = require "ItsyScape.World.TileSet"
local Decoration = require "ItsyScape.Graphics.Decoration"
local Spline = require "ItsyScape.Graphics.Spline"
local ExecutePathCommand = require "ItsyScape.World.ExecutePathCommand"

local LocalStage = Class(Stage)

LocalStage.UNLOAD_TICK_DELAY = 2
LocalStage.PRELOAD_DURATION_MS = 100

function LocalStage:new(game)
	Stage.new(self)

	self.game = game

	self.actors = {}
	self.actorsByID = {}
	self.props = {}
	self.propsByID = {}
	self.peeps = {}

	self.currentActorID = 1
	self.currentPropID = 1
	self.currentLayer = 1

	self.grounds = {}

	self.gravity = Vector(0, -18, 0)

	self.tests = { id = 1 }

	self.instances = {}
	self.instancesByLayer = {}
	self.instancesPendingUnload = {}
	self.mapTransformsByLayer = {}

	self.dummyInstance = Instance(0, "<dummy>", self)
	self.dummyInstance:addLayer(1)
	table.insert(self.instances, self.dummyInstance)
	self.instancesByLayer[1] = self.dummyInstance

	self._preloadMapObjects = coroutine.wrap(self.preloadMapObjects)
	if self:_preloadMapObjects() then
		self._preloadMapObjects = nil
	end
end

function LocalStage:preloadMapObjects()
	local gameDB = self.game:getGameDB()
	local startTime = love.timer.getTime()

	local beforeTime = startTime
	local function _tryYield()
		local currentTime = love.timer.getTime()
		if (currentTime - beforeTime) * 1000 > LocalStage.PRELOAD_DURATION_MS then
			Log.engine("Yielding map object preload (%.2f ms passed).", (currentTime - beforeTime) * 1000)

			coroutine.yield()
			beforeTime = love.timer.getTime()
		end
	end

	Log.info("Preloading map objects...")
	for resource in gameDB:getResources("MapObject") do
		gameDB:getRecord("MapObjectLocation", {
			Resource = resource
		})

		_tryYield()

		gameDB:getRecord("PropMapObject", {
			MapObject = resource
		})

		_tryYield()

		gameDB:getRecord("PeepMapObject", {
			MapObject = resource
		})

		_tryYield()
	end

	for resource in gameDB:getResources("Map") do
		gameDB:getRecords("MapObjectLocation", {
			Map = resource
		})

		_tryYield()
	end

	Log.info("Done preloading map objects in %.2f ms!", (love.timer.getTime() - startTime) * 1000)
	return true
end

function LocalStage:newLayer(instance)
	local layer = self.currentLayer
	self.currentLayer = self.currentLayer + 1

	self.instancesByLayer[layer] = instance

	return layer
end

function LocalStage:deleteLayer(layer)
	Log.engine("Deleting layer %d.", layer)
	self.instancesByLayer[layer] = nil
	self.mapTransformsByLayer[layer] = nil
end

function LocalStage:newGlobalInstance(filename)
	do
		local existingGlobalInstance = self.instances[filename]
		existingGlobalInstance = existingGlobalInstance and existingGlobalInstance.global

		if existingGlobalInstance then
			Log.error("Global instance for '%s' already exists.", filename)
			return existingGlobalInstance
		end
	end

	Log.info("Global instance for '%s' does not exist; creating.", filename)

	local instance = Instance(Instance.GLOBAL_ID, filename, self)

	local instancesForFilename = self.instances[filename]
	if not instancesForFilename then
		instancesForFilename = {
			index = Instance.LOCAL_ID_START,
			instances = {}
		}

		self.instances[filename] = instancesForFilename
	end
	instancesForFilename.global = instance

	table.insert(self.instances, instance)
	self:loadStage(instance, filename, {})

	return instance
end

function LocalStage:newLocalInstance(filename, args)
	local instancesForFilename = self.instances[filename]
	if not instancesForFilename then
		instancesForFilename = {
			index = Instance.LOCAL_ID_START,
			instances = {}
		}

		self.instances[filename] = instancesForFilename
	end

	local index = instancesForFilename.index
	instancesForFilename.index = instancesForFilename.index + 1

	local instance = Instance(index, filename, self)
	table.insert(instancesForFilename.instances, instance)
	table.insert(self.instances, instance)

	self:loadStage(instance, filename, args)

	return instance
end

function LocalStage:unloadGlobalInstance(instance)
	if instance:hasPlayers() then
		Log.error("Cannot unload instance %s (%d); has players.", instance:getFilename(), instance:getID())
		return
	end

	instance:unload()
	Log.info("Unloaded global instance %s.", instance:getFilename())
end

function LocalStage:unloadLocalInstance(instance)
	if instance:hasPlayers() then
		Log.error("Cannot unload instance %s (%d); has players.", instance:getFilename(), instance:getID())
		return
	end

	local instancesForFilename = self.instances[instance:getFilename()]
	if instancesForFilename then
		for i = 1, #instancesForFilename.instances do
			if instancesForFilename.instances[i]:getID() == instance:getID() then
				Log.info("Unloading instance %s (%d).", instance:getFilename(), instance:getID())

				instance:unload()
				table.remove(instancesForFilename.instances, i)

				return
			end
		end
	end

	Log.error("Could not unload instance %s (%d); not found.", instance:getFilename(), instance:getID())
end

function LocalStage:getGlobalInstanceByFilename(filename)
	local instances = self.instances[filename]
	if not instances then
		return nil
	end

	if not instances.global then
		return nil
	end

	return instances.global
end

function LocalStage:getLocalInstanceByFilenameAndID(filename, id)
	local instances = self.instances[filename]
	if not instances then
		return nil
	end

	instances = instances.instances
	for i = 1, #instances do
		if instances[i]:getID() == id then
			return instances[i]
		end
	end

	return nil
end

function LocalStage:getInstanceByFilenameAndID(filename, id)
	if id == Instance.GLOBAL_ID then
		return self:getGlobalInstanceByFilename(filename)
	else
		return self:getLocalInstanceByFilenameAndID(filename, id)
	end
end

function LocalStage:getInstanceByLayer(layer)
	return self.instancesByLayer[layer]
end

function LocalStage:getPeepInstance(peep)
	if not peep then
		return self.dummyInstance
	end

	local id, filename = self:splitLayerNameIntoInstanceIDAndFilename(peep:getLayerName())
	return self:getInstanceByFilenameAndID(filename, id) or self.dummyInstance
end

function LocalStage:iterateItems()
	return pairs({})
end

function LocalStage:spawnGround(filename, layer)
	Log.engine(
		"Spawning ground on layer %d in instance layer name '%s'.",
		layer,
		filename)

	local ground = self.game:getDirector():addPeep(filename, require "Resources.Game.Peeps.Ground")
	Utility.Peep.setLayer(ground, layer)

	self.grounds[layer] = ground

	local inventory = ground:getBehavior(InventoryBehavior).inventory
	inventory.onTakeItem:register(self.notifyTakeItem, self, layer)
	inventory.onDropItem:register(self.notifyDropItem, self, layer)
end 

function LocalStage:notifyTakeItem(layer, item, key, _, peep)
	local ref = self.game:getDirector():getItemBroker():getItemRef(item)
	Log.info(
		"Item '%s' (ref = %d, count = %d, noted = %s) taken from layer %d by peep '%s'.",
		item:getID(), ref, item:getCount(), ((item:isNoted() and "yes") or "no"), layer, peep and peep:getName() or "???")

	self.onTakeItem(
		self,
		ref,
		Utility.Item.pull(peep, item, "world"),
		layer)
end

function LocalStage:notifyDropItem(layer, item, key, _, _, peep)
	local ref = self.game:getDirector():getItemBroker():getItemRef(item)

	local position
	if Class.isCompatibleType(source, Vector) then
		position = source
	else
		local map = self:getMap(layer)
		local tileCenter = map:getTileCenter(key.i, key.j)
		local x = (love.math.random() * 2) - 1
		local z = (love.math.random() * 2) - 1
		position = tileCenter + Vector(x, 0, z)
	end

	local actorOrProp
	if peep then
		local actor = peep:getBehavior(ActorReferenceBehavior)
		local prop = peep:getBehavior(PropReferenceBehavior)
		actorOrProp = (actor and actor.actor) or (prop and prop.prop)
	end

	Log.info(
		"Item '%s' (ref = %d, count = %d, noted = %s) dropped at (%d, %d -> %f, %f, %f) on layer %d by peep '%s'.",
		item:getID(), ref, item:getCount(), ((item:isNoted() and "yes") or "no"),
		key.i, key.j,
		position.x, position.y, position.z,
		layer,
		peep and peep:getName() or "???")

	self.onDropItem(
		self,
		ref,
		Utility.Item.pull(peep, item, "world"),
		{ i = key.i, j = key.j, layer = key.layer },
		position,
		layer,
		actorOrProp)
end

function LocalStage:lookupPropAlias(resourceID)
	local gameDB = self.game:getGameDB()
	local resource = gameDB:getResource(resourceID, "Prop")
	if not resource then
		return resourceID
	end

	local alias = gameDB:getRecord("PropAlias", {
		Resource = resource
	})

	return (alias and alias:get("Alias").name) or resourceID
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

function LocalStage:spawnActor(actorID, layer, layerName)
	layer = layer or 1

	local Peep, resource, realID = self:lookupResource(actorID, "Peep")

	if Peep then
		local actor = LocalActor(self.game, Peep, realID)
		actor:spawn(self.currentActorID, layerName, resource)

		self.currentActorID = self.currentActorID + 1
		self.actors[actor] = true

		local peep = actor:getPeep()
		self.peeps[actor] = peep
		self.peeps[peep] = actor
		self.actorsByID[actor:getID()] = actor

		local function _onAssign()
			local p = peep:getBehavior(PositionBehavior)
			if p then
				p.layer = layer
			end

			self.onActorSpawned(self, realID, actor)

			peep:silence('assign', _onAssign)
		end
		peep:listen('assign', _onAssign)

		return true, actor
	end

	return false, nil
end

function LocalStage:killActor(actor)
	if actor and (self.actors[actor] or self.peeps[actor]) then
		if actor:isCompatibleType(Peep) then
			actor = self.peeps[actor]
		end

		self.onActorKilled(self, actor, false, Utility.Peep.getLayer(actor:getPeep()))
		actor:depart()

		local peep = self.peeps[actor]
		self.peeps[actor] = nil
		self.peeps[peep] = nil
		self.actorsByID[actor:getID()] = nil

		self.actors[actor] = nil
	end
end

function LocalStage:placeProp(propID, layer, layerName)
	layer = layer or 1

	local Peep, resource, realID = self:lookupResource(propID, "Prop")

	if Peep then
		local prop = LocalProp(self.game, Peep, realID)
		prop:place(self.currentPropID, layerName, resource)

		self.currentPropID = self.currentPropID + 1
		self.props[prop] = true

		local peep = prop:getPeep()
		self.peeps[prop] = peep
		self.peeps[peep] = prop
		self.propsByID[prop:getID()] = prop

		peep:listen('ready', function()
			local p = peep:getBehavior(PositionBehavior)
			if p then
				p.layer = layer
			end

			self.onPropPlaced(self, self:lookupPropAlias(realID), prop)
		end)

		return true, prop
	end

	return false, nil
end

function LocalStage:removeProp(prop)
	if prop and (self.props[prop] or self.peeps[prop]) then
		if prop:isCompatibleType(Peep) then
			prop = self.peeps[prop]
		end

		self.onPropRemoved(self, prop, false, Utility.Peep.getLayer(prop:getPeep()))
		prop:remove()

		local peep = self.peeps[prop]
		self.peeps[prop] = nil
		self.peeps[peep] = nil

		self.props[prop] = nil
		self.propsByID[prop:getID()] = nil
	end
end

function LocalStage:instantiateMapObject(resource, layer, layerName, isLayer, playerPeep)
	layer = layer or 1

	local gameDB = self.game:getGameDB()

	local object = gameDB:getRecord("MapObjectLocation", {
		Resource = resource
	}) or gameDB:getRecord("MapObjectReference", {
		Resource = resource
	})

	local isInstanced = object and gameDB:getRecord("MapObjectGroup", {
		IsInstanced = 1,
		MapObject = resource
	})

	local actorInstance, propInstance

	if object and (not isInstanced or playerPeep) then
		local x = object:get("PositionX") or 0
		local y = object:get("PositionY") or 0
		local z = object:get("PositionZ") or 0

		do
			local prop = gameDB:getRecord("PropMapObject", {
				MapObject = object:get("Resource")
			})

			local spawnProp
			do
				local map = self:getMap(layer)
				spawnProp = not isLayer or (prop and prop:get("IsMultiLayer") ~= 0) or not map:getTileAt(x, z):hasFlag('building')
			end

			if prop and spawnProp then
				prop = prop:get("Prop")
				if prop then
					local s, p = self:placeProp("resource://" .. prop.name, layer, layerName)

					if s then
						local peep = p:getPeep()
						local position = peep:getBehavior(PositionBehavior)
						if position then
							position.position = Vector(x, y, z)
							position.layer = layer
						end

						local scale = peep:getBehavior(ScaleBehavior)
						if scale then
							local sx = object:get("ScaleX")
							local sy = object:get("ScaleY")
							local sz = object:get("ScaleZ")

							scale.scale = Vector(
								(sx ~= 0 and sx) or 1,
								(sy ~= 0 and sy) or 1,
								(sz ~= 0 and sz) or 1)
						end

						local rotation = peep:getBehavior(RotationBehavior)
						if rotation then
							local rx = object:get("RotationX") or 0
							local ry = object:get("RotationY") or 0
							local rz = object:get("RotationZ") or 0
							local rw = object:get("RotationW") or 1

							if rw ~= 0 or rx ~= 0 or ry ~= 0 or rz ~= 0 then
								rotation.rotation = Quaternion(rx, ry, rz, rw)
							end
						end

						propInstance = p

						Utility.Peep.setMapObject(peep, resource)

						local s, b = peep:addBehavior(MapResourceReferenceBehavior)
						if s then
							b.map = object:get("Map")
						end

						if isInstanced and playerPeep then
							local playerID = playerPeep:hasBehavior(PlayerBehavior) and playerPeep:getBehavior(PlayerBehavior).playerID
							if playerID then
								local _, instancedBehavior = peep:addBehavior(InstancedBehavior)
								instancedBehavior.playerID = playerID
							end
						end
					end
				end
			end
		end

		do
			local actor = gameDB:getRecord("PeepMapObject", {
				MapObject = object:get("Resource")
			})

			local spawnActor = not isLayer

			if actor and spawnActor then
				actor = actor:get("Peep")
				if actor then
					local s, a = self:spawnActor("resource://" .. actor.name, layer, layerName)

					if s then
						local peep = a:getPeep()
						local position = peep:getBehavior(PositionBehavior)
						if position then
							position.position = Vector(x, y, z)
							position.layer = layer
						end

						local scale = peep:getBehavior(ScaleBehavior)
						if scale then
							local sx = object:get("ScaleX")
							local sy = object:get("ScaleY")
							local sz = object:get("ScaleZ")

							scale.scale = Vector(
								(sx ~= 0 and sx) or 1,
								(sy ~= 0 and sy) or 1,
								(sz ~= 0 and sz) or 1)
						end

						local rotation = peep:getBehavior(RotationBehavior)
						if rotation then
							local rx = object:get("RotationX") or 0
							local ry = object:get("RotationY") or 0
							local rz = object:get("RotationZ") or 0
							local rw = object:get("RotationW") or 1

							if rw ~= 0 or rx ~= 0 or ry ~= 0 or rz ~= 0 then
								rotation.rotation = Quaternion(rx, ry, rz, rw)
							end
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

						if isInstanced and playerPeep then
							local playerID = playerPeep:hasBehavior(PlayerBehavior) and playerPeep:getBehavior(PlayerBehavior).playerID
							if playerID then
								local _, instancedBehavior = peep:addBehavior(InstancedBehavior)
								instancedBehavior.playerID = playerID
							end
						end
					end
				end
			end
		end
	end

	return actorInstance, propInstance
end

function LocalStage:loadMapFromFile(filename, layer, tileSetID, maskID, meta)
	self:unloadMap(layer)

	local map = Map.loadFromFile(filename)
	if type(tileSetID) == 'string' then
		for i = 1, map:getWidth() do
			for j = 1, map:getHeight() do
				map:getTile(i, j).tileSetID = tileSetID
			end
		end
	end

	if map then
		self.game:getDirector():setMap(layer, map)
		self.onLoadMap(self, filename, layer, tileSetID, maskID, meta)

		self:updateMap(layer, filename)
	end

	if tileSetID and type(tileSetID) == 'string' then
		local tileSetFilename = string.format(
			"Resources/Game/TileSets/%s/Layout.lua",
			tileSetID)
		local tileSet = TileSet.loadFromFile(tileSetFilename, false)

		local w, h = map:getWidth(), map:getHeight()
		for j = 1, h do
			for i = 1, w do
				local tile = map:getTile(i, j)

				for key, value in tileSet:getTileProperties(tile.flat) do
					tile:setData("x-tileset-" .. key, value)
				end
			end
		end
	end
end

function LocalStage:newMap(width, height, tileSetID, maskID, layer, meta)
	local map = Map(width, height, Stage.CELL_SIZE)

	for i = 1, map:getWidth() do
		for j = 1, map:getHeight() do
			map:getTile(i, j).tileSetID = tileSetID
		end
	end

	self.game:getDirector():setMap(layer, map)
	self.onLoadMap(self, map, layer, tileSetID, maskID, meta)

	self:updateMap(layer, map)

	return map
end

function LocalStage:updateMap(layer, map)
	map = map or self.game:getDirector():getMap(layer)

	if map then
		if type(map) ~= "string" then
			self.game:getDirector():setMap(layer, map)
		end

		self.onMapModified(self, map, layer)
	end
end

function LocalStage:unloadMap(layer)
	local map = self.game:getDirector():getMap(layer)
	if map then
		self.onUnloadMap(self, layer)
		self.game:getDirector():setMap(layer, nil)
	end
end

function LocalStage:unloadLayer(layer)
	do
		local p = {}

		for prop in self:iterateProps() do
			local propLayer = Utility.Peep.getLayer(prop:getPeep())
			if propLayer == layer then
				table.insert(p, prop)
			end
		end

		for _, prop in ipairs(p) do
			self:removeProp(prop)
		end
	end

	do
		local p = {}

		for actor in self:iterateActors() do
			local actorLayer = Utility.Peep.getLayer(actor:getPeep())
			if actorLayer == layer and not actor:getPeep():getBehavior(PlayerBehavior) then
				table.insert(p, actor)
			end
		end

		do
			self:collectLayerItems(layer)
			self.grounds = {}
		end

		for _, actor in ipairs(p) do
			self:killActor(actor)
		end
	end

	self:unloadMap(layer)
	self:deleteLayer(layer)
end

function LocalStage:flood(key, water, layer)
	self.onWaterFlood(self, key, water, layer)
end

function LocalStage:drain(key, layer)
	self.onWaterDrain(self, key, layer)
end

function LocalStage:unloadAll(instance)
	for _, layer in instance:iterateLayers() do
		self:unloadMap(layer)
		self:deleteLayer(layer)
	end

	do
		local p = {}

		for prop in self:iterateProps() do
			local layer = Utility.Peep.getLayer(prop:getPeep())
			if instance:hasLayer(layer, true) then
				table.insert(p, prop)
			end
		end

		for _, prop in ipairs(p) do
			self:removeProp(prop)
		end
	end

	do
		local p = {}

		for actor in self:iterateActors() do
			local layer = Utility.Peep.getLayer(actor:getPeep())
			if instance:hasLayer(layer, true) and not actor:getPeep():getBehavior(PlayerBehavior) then
				table.insert(p, actor)
			end
		end

		do
			self:collectInstanceItems(instance)
			self.grounds = {}
		end

		for _, actor in ipairs(p) do
			self:killActor(actor)
		end
	end

	local layerName = self:buildLayerNameFromInstanceIDAndFilename(instance:getID(), instance:getFilename())
	self.game:getDirector():removeLayer(layerName)
end

function LocalStage:getFilenameFromPath(path)
	local filename
	do
		local s, e = path:find("%?")
		s = s or 1
		e = e or #path + 1
		
		filename = path:sub(1, e - 1)
	end

	return filename:match("^@?([%w_]*)")
end

function LocalStage:getArgumentsFromPath(path)
	local filename
	local args = {}
	do
		local s, e = path:find("%?")
		s = s or 1
		e = e or #path + 1
		
		filename = path:sub(1, e - 1)

		local pathArguments = path:sub(e, -1)
		for key, value in pathArguments:gmatch("([%w_@]+)=([%w_@]+)") do
			Log.info("Map argument '%s' -> '%s'.", key, value)
			args[key] = value
		end
	end

	return args
end

function LocalStage:isPathLocal(path)
	return path:match("^@") ~= nil or next(self:getArgumentsFromPath(path), nil) ~= nil
end

function LocalStage:isPathGlobal(path)
	return path:match("^@") == nil and next(self:getArgumentsFromPath(path), nil) == nil
end

function LocalStage:splitLayerNameIntoInstanceIDAndFilename(layerName)
	local id, filename = layerName:match("(%d*)@([%w_]*)")
	if id and filename then
		return tonumber(id), filename
	end

	return Instance.GLOBAL_ID, layerName
end

function LocalStage:buildLayerNameFromInstanceIDAndFilename(id, filename)
	return string.format("%d@%s", id, filename)
end

function LocalStage:removePlayer(player)
	if not player:getActor() then
		Log.info("Player (%d) does not have an actor; cannot remove.", player:getID())
		return false
	end

	local peep = player:getActor():getPeep()
	local instance = self:getPeepInstance(peep)
	if instance:hasPlayer(player) then
		Log.info(
			"Player '%s' (%d) in instance '%s' (%d); removing...",
			player:getActor():getName(), player:getID(),
			instance:getFilename(), instance:getID())

		instance:removePlayer(player)

		local hasNoPlayers = not instance:hasPlayers()
		local noRaid = not instance:hasRaid()

		if hasNoPlayers and noRaid then
			Log.info("Instance is empty; unloading...")
			self:unloadInstance(instance)
		end

		Log.info("Player successfully removed from instance.")
		return true
	end

	Log.info(
		"Player '%s' (%d) not in instance %s (%d); no need to remove.",
		player:getActor():getName(), player:getID(),
		instance:getFilename(), instance:getID())
	return false
end

function LocalStage:movePeep(peep, path, anchor, e)
	local filename, arguments, instance
	if type(path) == 'string' then
		filename = self:getFilenameFromPath(path)
		arguments = self:getArgumentsFromPath(path)

		if e and e.path then
			for k, v in pairs(e.path) do
				arguments[k] = v
			end
		end

		Log.info("Moving peep '%s' to map '%s'.", peep:getName(), filename)

		if self:isPathLocal(path) and next(arguments) == nil then
			instance = self:newLocalInstance(filename, arguments)
			Log.info("Path is local; created new instance %s (%d).", instance:getFilename(), instance:getID())
		elseif self:isPathGlobal(path) or next(arguments) ~= nil then
			instance = self:getGlobalInstanceByFilename(filename)
			if not instance then
				instance = self:newGlobalInstance(filename)
			end

			Log.info("Got or created global instance %s (%d).", instance:getFilename(), instance:getID())
		end
	elseif Class.isCompatibleType(path, Instance) then
		instance = path

		filename = instance:getFilename()

		local mapScript = instance:getMapScriptByLayer(instance:getBaseLayer())
		args = (mapScript and mapScript:getArguments()) or {}

		Log.info("Moving peep '%s' to existing instance %s (%d).", peep:getName(), instance:getFilename(), instance:getID())
	end

	if not instance then
		if type(path) == 'string' then
			Log.error("Path '%s' is malformed; not global (no prefix and no arguments) or local (prefixed with '@' or has arguments after '?').", path)
		elseif Class.isClass(path) then
			Log.error("Path is unexpected type '%s'.", instance:getDebugInfo().shortName)
		else
			Log.error("Expected string or instance, got '%s'.", type(path))
		end

		return nil
	end

	if peep:hasBehavior(PlayerBehavior) then
		local player = self.game:getPlayerByID(peep:getBehavior(PlayerBehavior).playerID)
		player:saveLocation()
	end

	do
		local actor = peep:getBehavior(ActorReferenceBehavior)
		actor = actor and actor.actor

		local prop = peep:getBehavior(PropReferenceBehavior)
		prop = prop and prop.prop


		if actor then
			self:onActorKilled(actor, true)
		end

		if prop then
			self:onPropRemoved(prop, true)
		end
	end

	local previousLayer, newLayer
	do
		previousLayer = Utility.Peep.getLayer(peep)

		local layer = instance:getBaseLayer()
		if not layer then
			Log.engine("No base layer in instance %s (%d); finding lowest layer.", instance:getFilename(), instance:getID())

			for _, l in instance:iterateLayers() do
				layer = math.min(layer or math.huge, l)
			end
		end

		if not layer then
			Log.error("No layer in instance '%s' (ID = %d).", instance:getFilename(), instance:getID())
			return nil
		else
			Log.engine("Set peep '%s' layer to %d.", peep:getName(), layer)
			Utility.Peep.setLayer(peep, layer)
		end

		if previousLayer ~= layer then
			Log.engine("Layer different; firing travel event.")
			peep:poke('travel', {
				from = filename,
				to = filename
			})
		end

		newLayer = layer
	end

	if Class.isType(anchor, Vector) then
		Utility.Peep.setPosition(peep, anchor)
	else
		local gameDB = self.game:getGameDB()
		local map = gameDB:getResource(filename, "Map")
		if map then
			local mapObject = gameDB:getRecord("MapObjectLocation", {
				Name = anchor,
				Map = map
			})

			if mapObject then
				local x, y, z = mapObject:get("PositionX"), mapObject:get("PositionY"), mapObject:get("PositionZ")
				Utility.Peep.setPosition(peep, Vector(x, y, z))

				local direction = mapObject:get("Direction")
				Utility.Peep.setFacing(peep, direction)
				
				local localLayer = math.max(mapObject:get("Layer"), 1)
				local mapGroup = instance:getMapGroup(instance:getBaseLayer())
				local globalLayer = instance:getGlobalLayerFromLocalLayer(localLayer)

				Utility.Peep.setLayer(peep, globalLayer)
			end
		end
	end

	local newLayerName = self:buildLayerNameFromInstanceIDAndFilename(instance:getID(), instance:getFilename())
	local oldLayerName

	if peep:getBehavior(PlayerBehavior) then
		oldLayerName = peep:getLayerName()
	end

	self.game:getDirector():movePeep(peep, newLayerName)

	do
		local gameDB = self.game:getGameDB()
		local map = gameDB:getResource(filename, "Map")

		local _, m = peep:addBehavior(MapResourceReferenceBehavior)
		m.map = map
	end

	do
		local actor = peep:getBehavior(ActorReferenceBehavior)
		actor = actor and actor.actor

		local prop = peep:getBehavior(PropReferenceBehavior)
		prop = prop and prop.prop

		if actor then
			self:onActorSpawned(actor:getPeepID(), actor, true)
		end

		if prop then
			self:onPropPlaced(prop:getPeepID(), prop, true)
		end
	end

	if peep:getBehavior(PlayerBehavior) then
		local player = self.game:getPlayerByID(peep:getBehavior(PlayerBehavior).playerID)
		if player then
			local id, filename = self:splitLayerNameIntoInstanceIDAndFilename(oldLayerName)

			local previousInstance = self:getInstanceByFilenameAndID(filename, id)
			if previousInstance then
				previousInstance:removePlayer(player, { arguments = e and e.previousInstancePlayerArguments })
			else
				Log.engine(
					"Player '%s' (player ID = %d, actor ID = %d) was not in instance.",
					(player:getActor() and player:getActor():getName()) or "<poofed player>", player:getID(), (player:getActor() and player:getActor():getID()) or -1)
			end

			instance:addPlayer(player, { isOrphan = oldLayerName == "::orphan", arguments = e and e.instancePlayerArguments })
			player:setInstance(oldLayerName, newLayerName, instance)
			peep:poke('moveInstance', previousInstance, instance)

			local hasInstance = previousInstance ~= nil
			local hasNoPlayers = hasInstance and not previousInstance:hasPlayers()
			local noRaid = hasInstance and not previousInstance:hasRaid()

			if hasInstance and hasNoPlayers and noRaid then
				Log.info(
					"Previous instance %s (%d) is empty; marking for removal.",
					previousInstance:getFilename(), previousInstance:getID())

				self:unloadInstance(previousInstance)
			end
		end
	else
		local actor = peep:getBehavior(ActorReferenceBehavior)
		actor = actor and actor.actor

		local prop = peep:getBehavior(PropReferenceBehavior)
		prop = prop and prop.prop

		if actor then
			self:onActorMoved(actor, previousLayerName, newLayerName)
		end

		if prop then
			self:onPropMoved(prop, previousLayerName, newLayerName)
		end
	end

	return instance
end

local function _sortLayers(a, b)
	return a.localLayer < b.localLayer
end

function LocalStage:loadMapResource(instance, filename, args)
	args = args or {}
	local layerName = self:buildLayerNameFromInstanceIDAndFilename(instance:getID(), instance:getFilename())
	local directoryPath = "Resources/Game/Maps/" .. filename

	local meta
	do
		local metaFilename = directoryPath .. "/meta"
		local data = "return " .. (love.filesystem.read(metaFilename) or "")
		local chunk = assert(loadstring(data))
		meta = setfenv(chunk, {})() or {}
	end

	local layers = {}
	for _, item in ipairs(love.filesystem.getDirectoryItems(directoryPath)) do
		local localLayer = item:match(".*(-?%d)%.lmap$")
		if localLayer then
			localLayer = tonumber(localLayer)

			table.insert(layers, { localLayer = localLayer, filename = item })
		end
	end
	table.sort(layers, _sortLayers)

	local group = instance:newMapGroup()
	local baseLayer

	for i, l in ipairs(layers) do
		local localLayer = l.localLayer
		local filename = l.filename

		if localLayer ~= i then
			error(string.format("incorrectly ordered map (expected %d): '%s/%s'", i, directoryPath, filename))
		end

		local tileSetID
		if meta[localLayer] then
			tileSetID = meta[localLayer].tileSetID
		end

		local layerMeta = meta[localLayer] or {}

		local globalLayer = self:newLayer(instance)
		baseLayer = baseLayer or globalLayer
		instance:addLayer(globalLayer, group, args.isInstancedToPlayer and args.player)

		self:loadMapFromFile(directoryPath .. "/" .. filename, globalLayer, layerMeta.tileSetID, layerMeta.maskID, layerMeta)
		self:spawnGround(layerName, globalLayer)
	end

	if not baseLayer then
		baseLayer = self:newLayer(instance)
		instance:addLayer(baseLayer)
	end

	if not instance:getBaseLayer() then
		instance:setBaseLayer(baseLayer)
	end

	do
		local waterDirectoryPath = directoryPath .. "/Water"
		for _, item in ipairs(love.filesystem.getDirectoryItems(waterDirectoryPath)) do
			local data = "return " .. (love.filesystem.read(waterDirectoryPath .. "/" .. item) or "")
			local chunk = assert(loadstring(data))
			water = setfenv(chunk, {})() or {}

			self.onWaterFlood(self, item, water, baseLayer)
		end
	end

	for _, item in ipairs(love.filesystem.getDirectoryItems(directoryPath .. "/Decorations")) do
		local decorationName = item:match("(.*)%.ldeco$")
		local splineName = item:match("(.*)%.lspline$")
		local filename = directoryPath .. "/Decorations/" .. item
		local key = filename

		local decoration
		if decorationName then
			decoration = Decoration(filename)
		elseif splineName then
			decoration = Spline(filename)
		end

		if decoration then
			self:decorate(key, decoration, baseLayer)
		end
	end

	local mapScript

	local gameDB = self.game:getGameDB()
	local resource = gameDB:getResource(filename, "Map")
	if resource then
		local objects = gameDB:getRecords("MapObjectLocation", {
			Map = resource
		})

		for i = 1, #objects do
			local localLayer = math.max(objects[i]:get("Layer"), 1)
			local globalLayer = instance:getGlobalLayerFromLocalLayer(group, localLayer) or baseLayer
			self:instantiateMapObject(objects[i]:get("Resource"), globalLayer, layerName, args.isLayer)
		end

		do
			local Peep = self:lookupResource("resource://" .. resource.name, "Map")
			if not Peep then
				Peep = require "ItsyScape.Peep.Peeps.Map"
			end

			local peep = self.game:getDirector():addPeep(layerName, Peep, resource)
			instance:addMapScript(baseLayer, peep, filename)

			peep:listen('ready', function(self)
				self:poke('load', filename, args or {}, baseLayer)
			end)

			do
				local _, m = peep:addBehavior(MapResourceReferenceBehavior)
				m.map = resource
			end

			if args.isInstancedToPlayer and args.player then
				local _, instancedBehavior = peep:addBehavior(InstancedBehavior)
				instancedBehavior.playerID = args.player:getID()
			end

			mapScript = peep
		end

		for _, l in ipairs(layers) do
			local localLayer = l.localLayer
			local globalLayer = instance:getGlobalLayerFromLocalLayer(group, localLayer)

			local layerMeta = meta[localLayer]
			local currentMapScript = instance:getMapScriptByLayer(globalLayer)

			if not currentMapScript then
				local peep = self.game:getDirector():addPeep(
					layerName,
					require "ItsyScape.Peep.Peeps.Map")

				peep:listen('ready', function(self)
					self:poke('load', filename, args or {}, globalLayer)
				end)

				instance:addMapScript(globalLayer, peep, nil)

				local _, m = peep:addBehavior(MapResourceReferenceBehavior)
				m.map = resource

				if args.isInstancedToPlayer and args.player then
					local _, instancedBehavior = peep:addBehavior(InstancedBehavior)
					instancedBehavior.playerID = args.player:getID()
				end

				currentMapScript = peep
			end

			local _, offset = currentMapScript:addBehavior(MapOffsetBehavior)
			if localLayer > 1 then
				offset.parentLayer = baseLayer
			end

			if layerMeta.transform then
				offset.origin = Vector(unpack(layerMeta.transform.origin or {}))
				offset.offset = Vector(unpack(layerMeta.transform.translation or {}))
				offset.rotation = Quaternion(unpack(layerMeta.transform.rotation or {}))
				offset.scale = Vector(unpack(layerMeta.transform.scale or {}))
			end
		end
	end

	for layer, layerMeta in ipairs(meta) do
		if layerMeta.links then
			for _, otherLayer in ipairs(layerMeta.links) do
				self:onMapLinked(instance:getGlobalLayerFromLocalLayer(group, layer, otherLayer))
				self:onMapLinked(instance:getGlobalLayerFromLocalLayer(group, otherLayer, layer))
			end
		end
	end

	return baseLayer, mapScript
end

function LocalStage:playMusic(layer, channel, song)
	self.onPlayMusic(self, channel, song, layer)
end

function LocalStage:stopMusic(layer, channel, song)
	self.onStopMusic(self, channel, song, layer)
end

function LocalStage:loadMusic(baseLayer, filename)
	local directoryPath = "Resources/Game/Maps/" .. filename

	local musicMeta
	do
		local metaFilename = directoryPath .. "/meta.music"
		local data = "return " .. (love.filesystem.read(metaFilename) or "")
		local chunk = assert(loadstring(data))
		musicMeta = setfenv(chunk, {})() or {}
	end

	for key, song in pairs(musicMeta) do
		self:playMusic(baseLayer, key, song)
	end

	if not musicMeta["ambience"] then
		self:stopMusic(baseLayer, "ambience", false)
	end

	if not musicMeta["main"] then
		self:stopMusic(baseLayer, "main", false)
	end
end

function LocalStage:loadStage(instance, filename, args)
	local baseLayer = self:loadMapResource(instance, filename, args)

	if args and not args.mute then
		self:loadMusic(baseLayer, filename)
	end
end

function LocalStage:getMap(layer)
	return self.game:getDirector():getMap(layer)
end

function LocalStage:getGround(layer)
	return self.grounds[layer]
end

function LocalStage:getLayers()
	local layers = {}
	for index in pairs(self.instancesByLayer) do
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
				item = {
					ref = broker:getItemRef(item),
					id = item:getID(),
					count = item:getCount(),
					noted = item:isNoted()
				},
				tile = { i = i, j = j, layer = layer },
				position = { 0, 0, 0 }
			})
		end

		return result
	end
end

function LocalStage:dropItem(item, count, owner)
	local broker = self.game:getDirector():getItemBroker()
	local provider = broker:getItemProvider(item)

	local layer
	if Class.isCompatibleType(owner, GroundInventoryProvider.Key) then
		layer = owner.layer
	else
		layer = Utility.Peep.getLayer(provider:getPeep())
	end

	local ground = self.grounds[layer]
	if not ground then
		Log.warn(
			"Cannot drop item '%s' (ref = %d) on layer '%d'; layer not found.",
			item:getID(), broker:getItemRef(item), layer)
		return
	end

	local destination = self.grounds[layer]:getBehavior(InventoryBehavior).inventory
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

function LocalStage:takeItem(i, j, layer, ref, player)
	Log.info("Player '%s' is trying to take an item...", player:getActor():getName())

	if not self.grounds[layer] then
		Log.info("No ground for layer '%d'; player '%s' cannot take item.", layer, player:getActor():getName())
		return
	end

	if Utility.Peep.isDisabled(player:getActor():getPeep()) then
		Log.info("Player '%s' is disabled; cannot take item.", player:getActor():getName())
	end

	local groundInventory = self.grounds[layer]:getBehavior(InventoryBehavior)
	groundInventory = groundInventory and groundInventory.inventory

	if groundInventory then
		local key = GroundInventoryProvider.Key(i, j, layer)
		local broker = self.game:getDirector():getItemBroker()

		local targetItem
		for item in broker:iterateItemsByKey(groundInventory, key) do
			if broker:getItemRef(item) == ref then
				targetItem = item
				break
			else
				Log.info(
					"Item '%s' (ref = %d) not a match for target ref %d.",
					item:getID(), broker:getItemRef(item), ref)
			end
		end

		if targetItem then
			local path = player:findPath(i, j, layer)
			if path then
				local queue = player:getActor():getPeep():getCommandQueue()
				local function condition()
					if not broker:hasItem(targetItem) then
						return false
					end

					if broker:getItemProvider(targetItem) ~= groundInventory then
						return false
					end

					return true
				end

				local peep = player:getActor():getPeep()
				local playerInventory = peep:getBehavior(InventoryBehavior)
				playerInventory = playerInventory and playerInventory.inventory
				if playerInventory then
					Log.info(
						"Player '%s' taking item '%s' (%d) at (%d, %d; %d)",
						player:getActor():getName(),
						targetItem:getID(), ref,
						i, j, layer)

					local walkStep = ExecutePathCommand(path)
					local takeStep = TransferItemCommand(
						broker,
						targetItem,
						playerInventory,
						targetItem:getCount(),
						'take',
						true)

					if peep:hasBehavior(PlayerBehavior) then
						local playerModel = Utility.Peep.getPlayerModel(peep)
						queue:interrupt(CompositeCommand(condition, walkStep, takeStep, notifyStep))
					else
						queue:interrupt(CompositeCommand(condition, walkStep, takeStep))
					end

				else
					Log.info("Player '%s' does not have inventory.", player:getActor():getName())
				end
			else
				Log.info(
					"Player '%s' cannot reach (%d, %d; %d).", 
					player:getActor():getName(),
					i, j, layer)
			end
		else
			Log.info(
				"No item at (%d, %d; %d); player '%s' cannot take item.",
				i, j, layer,
				player:getActor():getName())
		end
	end
end

function LocalStage:collectAllItems()
	Log.engine("Collecting items across the multiverse...")

	for i = 1, #self.instances do
		self:collectInstanceItems(self.instances[i])
	end

	Log.engine("Collected items from %d instances.", #self.instances)
end

function LocalStage:collectLayerItems(layer)
	local ground = self.grounds[layer]
	if not ground then
		Log.warn("No ground for layer %d.", layer)
		return
	end

	local transactions = {}

	local broker = self.game:getDirector():getItemBroker()
	local manager = self.game:getDirector():getItemManager()

	inventory = ground:getBehavior(InventoryBehavior).inventory
	if broker:hasProvider(inventory) then
		for item in broker:iterateItems(inventory) do
			local owner = broker:getItemTag(item, "owner")
			if owner and owner:hasBehavior(PlayerBehavior) then
				local bank = owner:getBehavior(InventoryBehavior).bank

				if bank and broker:hasProvider(bank) then
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

					Log.engine(
						"Transferring item '%s' (count = %d) to bank of player '%s' (%d).",
						item:getID(), item:getCount(), owner:getName(), owner:getBehavior(PlayerBehavior).playerID)
				end
			end

			local ref = broker:getItemRef(item)
			self.onTakeItem(self, ref, { ref = ref, id = item:getID(), noted = item:isNoted(), count = item:getCount() }, layer)
		end
	end

	for _, transaction in pairs(transactions) do
		local s, r = transaction:commit()
		if not s then
			Log.warn(
				"Couldn't commit pickicide on layer %d in instance %s (%d): %s",
				layer, instance:getFilename(), instance:getID(), r)
		end
	end
end

function LocalStage:collectInstanceItems(instance)
	Log.engine("Collecting items in instance %s (%d).", instance:getFilename(), instance:getID())

	for layer in instance:iterateLayers() do
		self:collectLayerItems(layer)
	end
end

function LocalStage:fireProjectile(projectileID, source, destination, layer)
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

	self.onProjectile(self, projectileID, peepToModel(source), peepToModel(destination), layer)
end

function LocalStage:forecast(layer, name, id, props)
	if not props then
		self.onStopForecast(self, layer, name)
	else
		self.onForecast(self, layer, name, id, props)
	end
end

function LocalStage:decorate(group, decoration, layer)
	if not decoration then
		self.onUndecorate(self, group, layer or 1)
	else
		if Class.isCompatibleType(decoration, Spline) then
			self.onDecorate(self, group, { type = "ItsyScape.Graphics.Spline", value = decoration:serialize() }, layer or 1)
		elseif Class.isCompatibleType(decoration, Decoration) then
			self.onDecorate(self, group, { type = "ItsyScape.Graphics.Decoration", value = decoration:serialize() }, layer or 1)
		end
	end
end

function LocalStage:getActorByID(actorID)
	return self.actorsByID[actorID]
end

function LocalStage:getPropByID(propID)
	return self.propsByID[propID]
end

function LocalStage:iterateActors()
	return pairs(self.actors)
end

function LocalStage:iterateProps()
	return pairs(self.props)
end

function LocalStage:quit()
	for i = 1, #self.instances do
		self:unloadAll(self.instances[i])
	end
end

function LocalStage:updateMapPositions()
	for i = 1, #self.instances do
		local instance = self.instances[i]

		for _, layer in instance:iterateLayers() do
			local mapScript = instance:getMapScriptByLayer(layer)
			if mapScript then
				local position = mapScript:getBehavior(PositionBehavior)
				if position then
					position = position.position
				else
					position = Vector.ZERO
				end

				local rotation = mapScript:getBehavior(RotationBehavior)
				if rotation then
					rotation = rotation.rotation
				else
					rotation = Quaternion.IDENTITY
				end

				local scale = mapScript:getBehavior(ScaleBehavior)
				if scale then
					scale = scale.scale
				else
					scale = Vector.ONE
				end

				local origin = mapScript:getBehavior(OriginBehavior)
				if origin then
					origin = origin.origin
				else
					origin = Vector.ZERO
				end

				local offset = mapScript:getBehavior(MapOffsetBehavior)
				if offset then
					rotation = rotation * offset.rotation
					scale = scale * offset.scale
					origin = origin + offset.origin
					position = position + offset.offset
				end

				local parentLayer = false
				if offset then
					parentLayer = offset.parentLayer
				end

				local disabled = mapScript:hasBehavior(DisabledBehavior)

				local didMove = false
				local currentTransform = self.mapTransformsByLayer[layer]
				if currentTransform then
					didMove = currentTransform.position ~= position or
					          currentTransform.rotation ~= rotation or
					          currentTransform.scale ~= scale or
					          currentTransform.origin ~= origin or
					          currentTransform.disabled ~= disabled or
					          currentTransform.parentLayer ~= parentLayer
				else
					didMove = true
				end

				self.mapTransformsByLayer[layer] = {
					position = position,
					rotation = rotation,
					scale = scale,
					origin = origin,
					disabled = disabled,
					parentLayer = parentLayer
				}

				if didMove then
					self.onMapMoved(self, layer, position, rotation, scale, origin, disabled, parentLayer)
				end
			end
		end
	end
end

function LocalStage:disbandParty(party)
	Log.info("Unloading all orphaned instances for party %d...", party:getID())

	if party:isInRaid() then
		for _, instance in party:getRaid():iterateInstances() do
			if instance:hasPlayers() then
				Log.engine(
					"Instance %s (%d) was a party of party %d (raid '%s'), but party has disbanded; however, player(s) in instance, so not marking for removal.",
					instance:getFilename(), instance:getID(), party:getID(), party:getRaid():getResource().name)
			else
				Log.engine(
					"Instance %s (%d) was a party of party %d (raid '%s'), but party has disbanded; marking for removal.",
					instance:getFilename(), instance:getID(), party:getID(), party:getRaid():getResource().name)

				self:unloadInstance(instance)
			end
		end
	end

	Log.info("Unloaded all orphaned instances for party %d.", party:getID())
end

function LocalStage:unloadInstance(instance)
	Log.info("Marking instance '%s' (%d) as pending unload.", instance:getFilename(), instance:getID())

	if instance:getIsGlobal() then
		Log.info("Instance is global; pre-emptively removing global reference.")

		local existingGlobalInstance = self.instances[instance:getFilename()]
		if existingGlobalInstance and existingGlobalInstance.global == instance then
			Log.info("Successfully removed global reference.")
			existingGlobalInstance.global = nil
		else
			Log.warn("Global instance not found.")
		end
	else
		Log.info("Instance is not global; nothing else to do!")
	end

	table.insert(self.instancesPendingUnload, {
		instance = instance,
		ticks = LocalStage.UNLOAD_TICK_DELAY
	})
end

function LocalStage:unloadInstancesPendingRemoval()
	local index = 1
	while index <= #self.instancesPendingUnload do
		local pending = self.instancesPendingUnload[index]
		local instance = pending.instance

		pending.ticks = pending.ticks - 1

		if pending.ticks <= 0 then
			if instance:getIsGlobal() then
				self:unloadGlobalInstance(instance)
			else
				self:unloadLocalInstance(instance)
			end

			table.remove(self.instancesPendingUnload, index)
		else
			index = index + 1
		end
	end
end

function LocalStage:tick()
	self:updateMapPositions()

	if self._preloadMapObjects and self:_preloadMapObjects() then
		self._preloadMapObjects = nil
	end
end

function LocalStage:cleanup()
	for i = 1, #self.instances do
		local instance = self.instances[i]
		instance:cleanup()
	end

	self:unloadInstancesPendingRemoval()
end

function LocalStage:update(delta)
	-- Nothing.
end

return LocalStage
