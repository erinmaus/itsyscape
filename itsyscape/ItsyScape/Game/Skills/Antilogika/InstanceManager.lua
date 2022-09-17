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
local Utility = require "ItsyScape.Game.Utility"
local Map = require "ItsyScape.World.Map"

local InstanceManager = Class()
InstanceManager.MAP_SIZE = 16

function InstanceManager:new(game, dimensionBuilder)
	self.game = game
	self.dimensionBuilder = dimensionBuilder

	self.instances = {}
	self.tileSets = {}
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

	local tileSets = {
		"EmptyRuins",
		"RumbridgeMainland",
		"YendorianRuins",
		"GrassyPlain",
	}

	local index = j * self:getDimensionBuilder():getWidth() + i
	self.tileSets[index] = self.tileSets[index] or tileSets[cell.rng:random(1, #tileSets)]

	local stage = self:getStage()
	local map = stage:newMap(
		InstanceManager.MAP_SIZE,
		InstanceManager.MAP_SIZE,
		self.tileSets[index],
		layer)
	cell:mutateMap(map, self:getDimensionBuilder())
	stage:updateMap(layer, map)

	return layer
end

function InstanceManager:_instantiatePortal(targetI, targetJ, instance, position)
	local AntilogikaTravelAnchorBehavior = require "ItsyScape.Peep.Behaviors.AntilogikaTravelAnchorBehavior"
	local SizeBehavior = require "ItsyScape.Peep.Behaviors.SizeBehavior"

	local mapScript = instance:getMapScriptByMapFilename("Antilogika")
	local map = self:getStage():getMap(instance:getBaseLayer())

	mapScript:listen('postLoad', function()
		local portal = Utility.spawnPropAtPosition(
			mapScript,
			"InvisiblePortal_Antilogika",
			position.x,
			position.y,
			position.z,
			0)
		local peep = portal:getPeep()

		local _, antilogikaTravelAnchor = peep:addBehavior(AntilogikaTravelAnchorBehavior)
		antilogikaTravelAnchor.targetCellI = targetI
		antilogikaTravelAnchor.targetCellJ = targetJ
		antilogikaTravelAnchor.targetPosition = Vector(map:getWidth() * map:getCellSize(), 0, map:getHeight() * map:getCellSize()) - position
		antilogikaTravelAnchor.targetPosition.y = -antilogikaTravelAnchor.targetPosition.y

		local _, size = peep:addBehavior(SizeBehavior)
		size.size = Vector(2.5, 2, 2.5)

		print('mapScript.getLayer', mapScript:getLayer(), mapScript.layer)
		print('instancce.getBaseLayer', instance:getBaseLayer())
	end)
end

function InstanceManager:instantiateMapObjects(i, j, instance)
	local map = self:getStage():getMap(instance:getBaseLayer())

	if i > 1 then
		local position = map:getTileCenter(1, InstanceManager.MAP_SIZE / 2)
		self:_instantiatePortal(i - 1, j, instance, position)
	end

	if i < InstanceManager.MAP_SIZE then
		local position = map:getTileCenter(InstanceManager.MAP_SIZE, InstanceManager.MAP_SIZE / 2)
		self:_instantiatePortal(i + 1, j, instance, position)
	end

	if j > 1 then
		local position = map:getTileCenter(InstanceManager.MAP_SIZE / 2, j)
		self:_instantiatePortal(i, j - 1, instance, position)
	end

	if j < InstanceManager.MAP_SIZE then
		local position = map:getTileCenter(InstanceManager.MAP_SIZE / 2, InstanceManager.MAP_SIZE)
		self:_instantiatePortal(i, j + 1, instance, position)
	end
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
	self:buildMap(i, j, instance:getBaseLayer())

	instance.onUnload:register(self.onUnloadInstance, self, index)
	self.instances[index] = instance

	self:instantiateMapObjects(i, j, instance)

	return instance
end

function InstanceManager:onUnloadInstance(index)
	self.instances[index] = nil
end

return InstanceManager
