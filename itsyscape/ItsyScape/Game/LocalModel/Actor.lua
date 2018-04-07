--------------------------------------------------------------------------------
-- ItsyScape/Game/LocalModel/Actor.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Vector = require "ItsyScape.Common.Math.Vector"
local Actor = require "ItsyScape.Game.Model.Actor"
local ActorReferenceBehavior = require "ItsyScape.Peep.Behaviors.ActorReferenceBehavior"
local MovementBehavior = require "ItsyScape.Peep.Behaviors.MovementBehavior"
local PositionBehavior = require "ItsyScape.Peep.Behaviors.PositionBehavior"

-- Represents an Actor that is simulated locally.
local LocalActor = Class(Actor)

function LocalActor:new(game, peepType)
	Actor.new(self)

	self.game = game
	self.id = Actor.NIL_ID
	self.peepType = peepType

	self.skin = {}
end

function LocalActor:spawn(id)
	assert(self.id == Actor.NIL_ID, "Actor already spawned")

	self.peep = self.game:getDirector():addPeep(self.peepType)
	local _, actorReference = self.peep:addBehavior(ActorReferenceBehavior)
	actorReference.actor = self

	self.id = id
end

function LocalActor:depart()
	assert(self.id ~= Actor.NIL_ID, "Actor not spawned")

	self.game:getDirector():removePeep(self.peep)
	self.peep = nil

	self.id = Actor.NIL_ID
end

function LocalActor:getID()
	return self.id
end

function LocalActor:getName()
	return self.peep:getName()
end

function LocalActor:setName(value)
	self.peep:setName(value)
end

function LocalActor:getDirection()
	if not self.peep then
		return Vector.ZERO
	end

	local movement = self.peep:getBehavior(MovementBehavior)
	if movement then
		return Vector(movement.facing, 0, 0)
	else
		return Vector(MovementBehavior.FACING_RIGHT)
	end
end

function LocalActor:getPosition()
	if not self.peep then
		return Vector.ZERO
	end

	local position = self.peep:getBehavior(PositionBehavior)
	if position then
		return position.position
	else
		return Vector.ZERO
	end
end

function LocalActor:getCurrentHealth()
	return 1
end

function LocalActor:getMaximumHealth()
	return 1
end

function LocalActor:setSkin(slot, priority, skin)
	local slot = self.skin[slot] or {}

	-- Remove existing slot if necessary.
	for i = 1, #slot do
		if slot[i].priority == priority then
			table.remove(slot, i)
			break
		end
	end

	if skin ~= nil then
		table.insert(slot, { priority = priority, skin = skin })
		table.sort(slot, function(a, b) return a.priority < b.priority end)
	end

	self.onSkinChanged(self, slot, priority, skin)
end

function LocalActor:getSkin(index)
	local slot = self.skin[index] or {}
	local result = {}

	for i = 1, #slot do
		table.insert(result, slot[i].skin)
		table.insert(result, slot[i].priority)
	end

	return unpack(result)
end

return LocalActor
