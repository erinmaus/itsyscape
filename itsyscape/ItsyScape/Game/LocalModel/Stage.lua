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
local LocalActor = require "ItsyScape.Game.LocalModel.Actor"
local Stage = require "ItsyScape.Game.Model.Stage"
local Map = require "ItsyScape.World.Map"

local LocalStage = Class(Stage)

function LocalStage:new(game)
	Stage.new(self)
	self.game = game
	self.actors = {}
	self.peeps = {}
	self.currentActorID = 1
	self.map = {}
	self.gravity = Vector(0, -9.8, 0)
end

function LocalStage:spawnActor(actorID)
	local Peep = require(actorID)
	if Peep then
		local actor = LocalActor(self.game, Peep)
		actor:spawn(self.currentActorID)

		self.onActorSpawned(self, actorID, actor)

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

function LocalStage:newMap(width, height, layer, tileSetID)
	self:unloadMap(layer)

	self.map[layer] = Map(width, height, Stage.CELL_SIZE)
	self.onLoadMap(self, self.map[layer], layer, tileSetID)

	self:updateMap(layer)
end

function LocalStage:updateMap(layer)
	if self.map[layer] then
		self.onMapModified(self, self.map[layer], layer)
	end
end

function LocalStage:unloadMap(layer)
	if self.map[layer] then
		self.onUnloadMap(self, self.map[layer], layer)
		self.map[layer] = nil
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

return LocalStage
