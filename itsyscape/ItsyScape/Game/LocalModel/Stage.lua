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
local Instance = require "ItsyScape.Game.LocalModel.Instance"
local LocalProp = require "ItsyScape.Game.LocalModel.Prop"
local Stage = require "ItsyScape.Game.Model.Stage"
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
local ExecutePathCommand = require "ItsyScape.World.ExecutePathCommand"

local LocalStage = Class(Stage)

function LocalStage:new(game)
	Stage.new(self)

	self.game = game

	self.actors = {}
	self.props = {}
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
end

function LocalStage:newLayer(instance)
	local layer = self.currentLayer
	self.currentLayer = self.currentLayer + 1

	self.instancesByLayer[layer] = instance

	return layer
end

function LocalStage:deleteLayer(layer)
	self.instancesByLayer[layer] = nil
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

	local instancesForFilename = self.instances[instance:getFilename()]
	if instancesForFilename then
		local instance = instancesForFilename.global
		instance:unload()

		instancesForFilename.global = nil

		Log.info("Unloaded global instance %s.", instance:getFilename())
		return
	end

	Log.error("Could not unload global instance %s; not found.", instance:getFilename())
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
	if not instances or not instances.global then
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
		return nil
	end

	local id, filename = self:splitLayerNameIntoInstanceIDAndFilename(peep:getLayerName())
	return self:getInstanceByFilenameAndID(filename, id)
end

function LocalStage:spawnGround(filename, layer)
	Log.engine(
		"Spawning ground on layer %d in instance layer name '%s'.",
		layer,
		filename)

	local ground = self.game:getDirector():addPeep(filename, require "Resources.Game.Peeps.Ground")
	self.grounds[layer] = ground

	local inventory = ground:getBehavior(InventoryBehavior).inventory
	inventory.onTakeItem:register(self.notifyTakeItem, self, layer)
	inventory.onDropItem:register(self.notifyDropItem, self, layer)
end 

function LocalStage:notifyTakeItem(layer, item, key)
	local ref = self.game:getDirector():getItemBroker():getItemRef(item)
	Log.engine(
		"Item '%s' (ref = %d, count = %d, noted = %s) taken from layer %d.",
		item:getID(), ref, item:getCount(), ((item:isNoted() and "yes") or "no"), layer)

	self.onTakeItem(
		self,
		ref,
		{ ref = ref, id = item:getID(), noted = item:isNoted(), count = item:getCount() },
		layer)
end

function LocalStage:notifyDropItem(layer, item, key, source)
	local ref = self.game:getDirector():getItemBroker():getItemRef(item)
	local position = source:getPeep():getBehavior(PositionBehavior)
	if position then
		local p = position.position
		position = Vector(p.x, p.y, p.z)
	else
		position = Vector(0)
	end

	Log.engine(
		"Item '%s' (ref = %d, count = %d, noted = %s) dropped at (%d, %d -> %f, %f, %f) on layer %d.",
		item:getID(), ref, item:getCount(), ((item:isNoted() and "yes") or "no"),
		key.i, key.j,
		position.x, position.y, position.z,
		layer)

	self.onDropItem(
		self,
		ref,
		{ ref = ref, id = item:getID(), noted = item:isNoted(), count = item:getCount() },
		{ i = key.i, j = key.j, layer = key.layer },
		position,
		layer)
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
	end
end

function LocalStage:instantiateMapObject(resource, layer, layerName, isLayer)
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
					end
				end
			end
		end
	end

	return actorInstance, propInstance
end

function LocalStage:loadMapFromFile(filename, layer, tileSetID, maskID)
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
		self.onLoadMap(self, map, layer, tileSetID, maskID)
		self.game:getDirector():setMap(layer, map)

		self:updateMap(layer, map)
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

function LocalStage:newMap(width, height, tileSetID, maskID, layer)
	local map = Map(width, height, Stage.CELL_SIZE)

	for i = 1, map:getWidth() do
		for j = 1, map:getHeight() do
			map:getTile(i, j).tileSetID = tileSetID
		end
	end

	self.onLoadMap(self, map, layer, tileSetID, maskID)
	self.game:getDirector():setMap(layer, map)

	self:updateMap(layer, map)

	return map
end

function LocalStage:updateMap(layer, map)
	map = map or self.game:getDirector():getMap(layer)

	if map then
		self.game:getDirector():setMap(layer, map)
		self.onMapModified(self, map, layer)
	end
end

function LocalStage:unloadMap(layer)
	local map = self.game:getDirector():getMap(layer)
	if map then
		self.onUnloadMap(self, map, layer)
		self.game:getDirector():setMap(layer, nil)
	end
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
			self:collectItems(instance)
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

function LocalStage:movePeep(peep, path, anchor)
	local filename, arguments, instance
	if type(path) == 'string' then
		filename = self:getFilenameFromPath(path)
		arguments = self:getArgumentsFromPath(path)

		Log.info("Moving peep '%s' to map '%s'.", peep:getName(), filename)

		if self:isPathLocal(path) then
			instance = self:newLocalInstance(filename, arguments)
			Log.info("Path is local; created new instance %s (%d).", instance:getFilename(), instance:getID())
		elseif self:isPathGlobal(path) then
			instance = self:getGlobalInstanceByFilename(filename) or self:newGlobalInstance(filename)
			Log.info("Path is global; getting global instance %s (%d).", instance:getFilename(), instance:getID())
		end
	elseif Class.isCompatibleType(path, Instance) then
		instance = path

		filename = instance:getFilename()

		local mapScript = instance:getMapScriptByLayer(instance:getBaseLayer())
		args = (mapScript and mapScript:getArguments()) or {}

		Log.info("Moving peep '%s' to existing instance %s (%d).", instance:getFilename(), instance:getID())
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
		local player = self.game:getPlayerByID(peep:getBehavior(PlayerBehavior).id)

		local previousInstance = self:getPeepInstance(peep)
		if previousInstance then
			previousInstance:removePlayer(player)
		end
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

			local x, y, z = mapObject:get("PositionX"), mapObject:get("PositionY"), mapObject:get("PositionZ")
			Utility.Peep.setPosition(peep, Vector(x, y, z))
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
		local player = self.game:getPlayerByID(peep:getBehavior(PlayerBehavior).id)
		if player then
			local id, filename = self:splitLayerNameIntoInstanceIDAndFilename(oldLayerName)

			local previousInstance = self:getInstanceByFilenameAndID(filename, id)
			if previousInstance then
				previousInstance:removePlayer(player)
			else
				Log.engine(
					"Player '%s' (player ID = %d, actor ID = %d) was not in instance.",
					player:getActor():getName(), player:getID(), player:getActor():getID())
			end

			instance:addPlayer(player, { isOrphan = oldLayerName == "::orphan" })
			player:setInstance(oldLayerName, newLayerName, instance)

			local hasInstance = previousInstance ~= nil
			local hasNoPlayers = hasInstance and not previousInstance:hasPlayers()
			local noRaid = hasInstance and not previousInstance:hasRaid()

			if hasInstance and hasNoPlayers and noRaid then
				Log.info(
					"Previous instance %s (%d) is empty; marking for removal.",
					previousInstance:getFilename(), previousInstance:getID())
				table.insert(self.instancesPendingUnload, previousInstance)
			end
		end
	end

	return instance
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

	local baseLayer
	for _, item in ipairs(love.filesystem.getDirectoryItems(directoryPath)) do
		local localLayer = item:match(".*(-?%d)%.lmap$")
		if localLayer then
			localLayer = tonumber(localLayer)

			local tileSetID
			if meta[localLayer] then
				tileSetID = meta[localLayer].tileSetID
			end

			local layerMeta = meta[localLayer] or {}

			local globalLayer = self:newLayer(instance)
			baseLayer = baseLayer or globalLayer
			instance:addLayer(globalLayer, args.isInstancedToPlayer and args.player)

			self:loadMapFromFile(directoryPath .. "/" .. item, globalLayer, layerMeta.tileSetID, layerMeta.maskID)
		end
	end

	if not baseLayer then
		baseLayer = self:newLayer(instance)
		instance:addLayer(baseLayer)
	end

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

	self:spawnGround(layerName, baseLayer)

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
		local group = item:match("(.*)%.ldeco$")
		if group then
			local key = directoryPath .. "/Decorations/" .. item
			local decoration = Decoration(directoryPath .. "/Decorations/" .. item)
			self:decorate(key, decoration, baseLayer)
		end
	end

	local mapScript

	local gameDB = self.game:getGameDB()
	local resource = gameDB:getResource(filename, "Map")
	if resource then
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

		local objects = gameDB:getRecords("MapObjectLocation", {
			Map = resource
		})

		for i = 1, #objects do
			self:instantiateMapObject(objects[i]:get("Resource"), baseLayer, layerName, args.isLayer)
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

function LocalStage:loadStage(instance, filename, args)

	-- TODO
	-- do
	-- 	local director = self.game:getDirector()
	-- 	director:movePeep(self.game:getPlayer():getActor():getPeep(), "::safe")
	-- end

	-- for i = 1, #self.music do
	-- 	self.music[i].stopping = true
	-- end

	self:loadMapResource(instance, filename, args)

	-- TODO
	-- local index = 1
	-- while index <= #self.music do
	-- 	local m = self.music[index]
	-- 	if m.stopping then
	-- 		self.onStopMusic(self.stageName, m.channel, m.song)
	-- 		table.remove(self.music, index)
	-- 	else
	-- 		index = index + 1
	-- 	end
	-- end

	-- TODO
	-- do
	-- 	local director = self.game:getDirector()
	-- 	local player = self.game:getPlayer():getActor():getPeep()
	-- 	director:movePeep(player, filename)

	-- 	local resource = director:getGameDB():getResource(filename, "Map")

	-- 	player:addBehavior(MapResourceReferenceBehavior)
	-- 	local m = player:getBehavior(MapResourceReferenceBehavior)
	-- 	m.map = resource or false

	-- 	player:poke('travel', {
	-- 		from = oldStageName,
	-- 		to = filename
	-- 	})
	-- end
end

function LocalStage:getMap(layer)
	return self.game:getDirector():getMap(layer)
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
	local layer = Utility.Peep.getLayer(provider:getPeep())
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
	if not self.grounds[layer] then
		return
	end

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

function LocalStage:collectAllItems()
	Log.engine("Collecting items across the multiverse...")

	for i = 1, #self.instances do
		self:collectItems(self.instances[i])
	end

	Log.engine("Collected items from %d instances.", #self.instances)
end

function LocalStage:collectItems(instance)
	Log.engine("Collecting items in instance %s (%d).", instance:getFilename(), instance:getID())

	local transactions = {}

	local broker = self.game:getDirector():getItemBroker()
	local manager = self.game:getDirector():getItemManager()
	local layer = instance:getBaseLayer()

	if not layer then
		Log.warn("No layer for instance %s (%d); cannot collect items.", instance:getFilename(), instance:getID())
		return
	end

	local ground = self.grounds[layer]
	if not ground then
		Log.warn("No ground for layer %d in instance %s (%d).", layer, instance:getFilename(), instance:getID())
		return
	end

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
						item:getID(), item:getCount(), owner:getName(), owner:getBehavior(PlayerBehavior).id)
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
		self.onDecorate(self, group, decoration, layer or 1)
	end
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
		instance:tick()

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

					offset = offset.offset
				else
					offset = Vector.ZERO
				end

				self.onMapMoved(self, layer, position + offset, rotation, scale, origin, mapScript:hasBehavior(DisabledBehavior))
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

				table.insert(self.instancesPendingUnload, instance)
			end
		end
	end

	Log.info("Unloaded all orphaned instances for party %d.", party:getID())
end

function LocalStage:unloadInstancesPendingRemoval()
	for i = 1, #self.instancesPendingUnload do
		local instance = self.instancesPendingUnload[i]
		if instance:getIsGlobal() then
			self:unloadGlobalInstance(instance)
		else
			self:unloadLocalInstance(instance)
		end
	end
	table.clear(self.instancesPendingUnload)
end

function LocalStage:tick()
	self:unloadInstancesPendingRemoval()
	self:updateMapPositions()
end

function LocalStage:update(delta)
	-- Nothing.
end

return LocalStage
