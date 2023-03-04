--------------------------------------------------------------------------------
-- ItsyScape/Game/Skills/Antilogika/Cell.lua
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
local BuildingAnchor = require "ItsyScape.Game.Skills.Antilogika.BuildingAnchor"
local BuildingPlanner = require "ItsyScape.Game.Skills.Antilogika.BuildingPlanner"
local BuildingConfig = require "ItsyScape.Game.Skills.Antilogika.BuildingConfig"
local RoomConfig = require "ItsyScape.Game.Skills.Antilogika.RoomConfig"
local Map = require "ItsyScape.World.Map"
local MultiTileSet = require "ItsyScape.World.MultiTileSet"

local InstanceManager = Class()
InstanceManager.MAP_SIZE = 24

function InstanceManager:new(game, dimensionBuilder)
	self.game = game
	self.dimensionBuilder = dimensionBuilder

	self.instances = {}
end

function InstanceManager:getGame()
	return self.game
end

function InstanceManager:getStage()
	return self.game:getStage()
end

function InstanceManager:getDimensionBuilder()
	return self.dimensionBuilder
end

function InstanceManager:buildMap(i, j, layer)
	local cell = self:getDimensionBuilder():getCell(i, j)

	local stage = self:getStage()
	local map = Map(InstanceManager.MAP_SIZE, InstanceManager.MAP_SIZE, 2)
	local mutateMapResults = cell:mutateMap(map, self:getDimensionBuilder())

	stage:newMap(
		InstanceManager.MAP_SIZE,
		InstanceManager.MAP_SIZE,
		mutateMapResults:getTileSetIDs(),
		true,
		layer)
	stage:updateMap(layer, map)

	love.filesystem.write("1.lmap", map:toString())

	return layer, mutateMapResults
end

function InstanceManager:_instantiatePortal(targetI, targetJ, instance, position)
	local AntilogikaTravelAnchorBehavior = require "ItsyScape.Peep.Behaviors.AntilogikaTravelAnchorBehavior"
	local SizeBehavior = require "ItsyScape.Peep.Behaviors.SizeBehavior"

	local mapScript = instance:getMapScriptByMapFilename("Antilogika")
	local map = self:getStage():getMap(instance:getBaseLayer())

	local onPlayerEnter = function(_, player)
		local _, tileI, tileJ = map:getTileAt(position.x, position.z)
		local walk = Utility.Peep.getWalk(player:getActor():getPeep(), tileI, tileJ, instance:getBaseLayer(), math.huge, {
			asCloseAsPossible = true
		})
		local node = walk and walk:getPath() and walk:getPath():getNodeAtIndex(-1)
		local newPosition = (node and map:getTileCenter(node.i, node.j)) or position

		local portal = Utility.spawnPropAtPosition(
			mapScript,
			"InvisiblePortal_Antilogika",
			newPosition.x,
			newPosition.y,
			newPosition.z,
			0)
		local peep = portal:getPeep()

		local _, antilogikaTravelAnchor = peep:addBehavior(AntilogikaTravelAnchorBehavior)
		antilogikaTravelAnchor.targetCellI = targetI
		antilogikaTravelAnchor.targetCellJ = targetJ
		antilogikaTravelAnchor.targetPosition = Vector(map:getWidth() * map:getCellSize(), 0, map:getHeight() * map:getCellSize()) - position
		antilogikaTravelAnchor.targetPosition.y = -antilogikaTravelAnchor.targetPosition.y

		local _, size = peep:addBehavior(SizeBehavior)
		size.size = Vector(2.5, 2, 2.5)

		mapScript:silence('postPlayerEnter', onPlayerEnter)
	end

	mapScript:listen('postPlayerEnter', onPlayerEnter)
end

function InstanceManager:instantiateMapObjects(i, j, instance, mutateMapResults)
	local map = self:getStage():getMap(instance:getBaseLayer())
	local cell = self.dimensionBuilder:getCell(i, j)

	if i > 1 and cell:hasNeighbor(BuildingAnchor.LEFT) then
		local position = map:getTileCenter(1, InstanceManager.MAP_SIZE / 2)
		self:_instantiatePortal(i - 1, j, instance, position)
	end

	if i < self:getDimensionBuilder():getWidth() and cell:hasNeighbor(BuildingAnchor.RIGHT) then
		local position = map:getTileCenter(InstanceManager.MAP_SIZE, InstanceManager.MAP_SIZE / 2)
		self:_instantiatePortal(i + 1, j, instance, position)
	end

	if j > 1 and cell:hasNeighbor(BuildingAnchor.BACK) then
		local position = map:getTileCenter(InstanceManager.MAP_SIZE / 2, 1)
		self:_instantiatePortal(i, j - 1, instance, position)
	end

	if j < self:getDimensionBuilder():getHeight() and cell:hasNeighbor(BuildingAnchor.FRONT) then
		local position = map:getTileCenter(InstanceManager.MAP_SIZE / 2, InstanceManager.MAP_SIZE)
		self:_instantiatePortal(i, j + 1, instance, position)
	end

	local mapScript = instance:getMapScriptByMapFilename("Antilogika")
	mapScript:listen('postLoad', function()
		local cell = self:getDimensionBuilder():getCell(i, j)
		cell:populate(mutateMapResults, map, mapScript, self:getDimensionBuilder())
		self:getStage():updateMap(instance:getBaseLayer(), map)
	end)

	mapScript:listen('playerEnter', function(_, player)
		local position = Utility.Peep.getPosition(player:getActor():getPeep())
		local tile = map:getTileAt(position.x, position.z)
		if tile:hasFlag("impassable") then
			Utility.Peep.setPosition(player:getActor():getPeep(), map:getTileCenter(map:getWidth() / 2, map:getHeight() / 2))
		end
	end)
end

function InstanceManager:instantiate(i, j)
	local index = j * self:getDimensionBuilder():getWidth() + i
	if self.instances[index] then
		return self.instances[index]
	end

	local instance = self:getStage():newLocalInstance("Antilogika", {
		antilogikaInstanceManager = self,
		i = i,
		j = j
	})
	local _, mutateMapResults = self:buildMap(i, j, instance:getBaseLayer())

	instance.onUnload:register(self.onUnloadInstance, self, index)
	self.instances[index] = instance

	self:instantiateMapObjects(i, j, instance, mutateMapResults)

	return instance
end

function InstanceManager:onUnloadInstance(index)
	self.instances[index] = nil
end

return InstanceManager
