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
	self.currentActorID = 1
	self.gravity = Vector(0, -9.8, 0) * 8
end

function LocalStage:spawnActor(actorID)
	local Peep = require(actorID)
	if Peep then
		local actor = LocalActor(self.game, Peep)
		actor:spawn(self.currentActorID)

		self.onActorSpawned(self, actor)

		self.currentActorID = self.currentActorID + 1
		self.actors[actor] = true

		return true, actor
	end

	return false, nil
end

function LocalStage:killActor(actor)
	if actor and self.actors[actor] then
		local a = self.actors[actor]

		self.onActorKilled(self, a)
		a:depart()

		self.actors[actor] = nil
	end
end

function LocalStage:newMap(width, height)
	self:unloadMap()

	self.map = Map(width, height, Stage.CELL_SIZE)
	self.onLoadMap(self, self.map)

	self:updateMap()
end

function LocalStage:updateMap()
	self.onMapModified(self, self.map)
end

function LocalStage:unloadMap()
	self.onUnloadMap(self, self.map)
	self.map = falsee
end

function LocalStage:getMap()
	return self.map
end

function LocalStage:getGravity()
	return self.gravity
end

function LocalStage:setGravity(value)
	self.gravity = value or self.gravity
end

return LocalStage
