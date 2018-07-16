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
local GroundInventoryProvider = require "ItsyScape.Game.GroundInventoryProvider"
local TransferItemCommand = require "ItsyScape.Game.TransferItemCommand"
local LocalActor = require "ItsyScape.Game.LocalModel.Actor"
local LocalProp = require "ItsyScape.Game.LocalModel.Prop"
local Stage = require "ItsyScape.Game.Model.Stage"
local CompositeCommand = require "ItsyScape.Peep.CompositeCommand"
local InventoryBehavior = require "ItsyScape.Peep.Behaviors.InventoryBehavior"
local PositionBehavior = require "ItsyScape.Peep.Behaviors.PositionBehavior"
local Map = require "ItsyScape.World.Map"
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
	self.map = {}
	self.gravity = Vector(0, -9.8, 0)

	self:spawnGround()
end

function LocalStage:spawnGround()
	self.ground = self.game:getDirector():addPeep(require "Resources.Game.Peeps.Ground")
	local inventory = self.ground:getBehavior(InventoryBehavior).inventory
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
						t = record:get("Value")

						if not t or t == "" then
							Log.error("resource ID malformed for resource '%s'", value)
							return false, nil
						else
							Type = require(t)
							resource = r
						end
					else
						Log.error("no peep ID for resource '%s'", value)
						return false, nil
					end
				else
					Log.error("resource ('%s') '%s' not found.", resourceType, value)
					return false, nil
				end
			elseif protocol:lower() == "actor" then
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

function LocalStage:spawnActor(actorID)
	local Peep, resource, realID = self:lookupResource(actorID, "Peep")

	if Peep then
		local actor = LocalActor(self.game, Peep)
		actor:spawn(self.currentActorID, resource)

		self.onActorSpawned(self, realID, actor)

		self.currentActorID = self.currentActorID + 1
		self.actors[actor] = true

		local peep = actor:getPeep()
		self.peeps[actor] = peep
		self.peeps[peep] = actor

		return true, actor
	end

	return false, nil
end

function LocalStage:killActor(actor)
	if actor and self.actors[actor] then
		local a = self.actors[actor]

		self.onActorKilled(self, a)
		a:depart()

		local peep = self.peeps[actor]
		self.peeps[actor] = nil
		self.peeps[peep] = nil

		self.actors[actor] = nil
	end
end

function LocalStage:placeProp(propID)
	local Peep, resource, realID = self:lookupResource(propID, "Prop")

	if Peep then
		local prop = LocalProp(self.game, Peep)
		prop:place(self.currentPropID, resource)

		self.onPropPlaced(self, realID, prop)

		self.currentActorID = self.currentPropID + 1
		self.props[prop] = true

		local peep = prop:getPeep()
		self.peeps[prop] = peep
		self.peeps[peep] = prop

		return true, prop
	end

	return false, nil
end

function LocalStage:removeProp(prop)
	if prop and self.props[prop] then
		local p = self.props[prop]

		self.onPropRemoved(self, p)
		p:remove()

		local peep = self.peeps[prop]
		self.peeps[prop] = nil
		self.peeps[peep] = nil

		self.props[prop] = nil
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
		end

		self.onMapModified(self, self.map[layer], layer)
	end
end

function LocalStage:unloadMap(layer)
	if self.map[layer] then
		self.onUnloadMap(self, self.map[layer], layer)
		self.map[layer] = nil
		self.game:getDirector():setMap(layer, nil)
	end
end

function LocalStage:getMap(layer)
	return self.map[layer]
end

function LocalStage:getLayers()
	local layers = {}
	for index in pairs(self.map) do
		table.insert(layers, index)
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
	local inventory = self.ground:getBehavior(InventoryBehavior).inventory
	if not inventory then
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

function LocalStage:dropItem(item, count)
	local destination = self.ground:getBehavior(InventoryBehavior).inventory
	local broker = self.game:getDirector():getItemBroker()
	local transaction = broker:createTransaction()
	local provider = broker:getItemProvider(item)
	provider:getPeep():poke('dropItem', {
		item = item,
		count = count
	})

	transaction:addParty(provider)
	transaction:addParty(destination)
	transaction:transfer(destination, item, count, 'drop', false)
	transaction:commit()

end

function LocalStage:takeItem(i, j, layer, ref)
	local inventory = self.ground:getBehavior(InventoryBehavior).inventory
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

function LocalStage:decorate(group, decoration)
	self.onDecorate(self, group, decoration)
end

function LocalStage:iterateActors()
	return pairs(self.actors)
end

function LocalStage:iterateProps()
	return pairs(self.props)
end

return LocalStage
