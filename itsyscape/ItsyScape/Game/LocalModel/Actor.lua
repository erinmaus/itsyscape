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
	self.animations = {}
	self.body = false
end

function LocalActor:getPeep()
	return self.peep
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

function LocalActor:setDirection(direction)
	if direction and self.peep then
		local directionBehavior = self.peep:getBehavior(MovementBehavior)

		if directionBehavior then
			directionBehavior.direction = direction
			self.onDirectionChanged(self, direction)
		end
	end
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

function LocalActor:teleport(position)
	if position and self.peep then
		local positionBehavior = self.peep:getBehavior(PositionBehavior)
		if positionBehavior then
			positionBehavior.position = position

			self.onTeleport(self, position)
		end
	end
end

function LocalActor:move(position)
	if position and self.peep then
		local positionBehavior = self.peep:getBehavior(PositionBehavior)
		if positionBehavior then
			positionBehavior.position = position

			self.onMove(self, position)
		end
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

function LocalActor:getTile()
	if not self.peep then
		return 0, 0, 0
	end

	local position = self.peep:getBehavior(PositionBehavior)
	if position then
		local map = self.game:getStage():getMap(position.layer or 1)
		local i, j = map:getTileAt(position.position.x, position.position.z)

		return i, j, position.layer or 1
	else
		return 0, 0, 0
	end
end

function LocalActor:getCurrentHealth()
	return 1
end

function LocalActor:getMaximumHealth()
	return 1
end

function LocalActor:setBody(body)
	self.body = body or false
	self.onTransmogrified(self, body)
end

function LocalActor:playAnimation(slot, priority, animation, force)
	if not priority then
		self.animations[slot] = nil

		return true
	else
		local s = self.animations[slot] or { priority = -math.huge, animation = false }
		if s.priority <= priority or force then
			s.priority = priority
			s.animation = animation

			self.onAnimationPlayed(self, slot, priority, animation)
			self.animations[slot] = s

			return true
		end
	end

	return false
end

function LocalActor:setSkin(slot, priority, skin)
	local s = self.skin[slot] or {}

	-- Remove existing slot if necessary.
	for i = 1, #s do
		if s[i].priority == priority then
			table.remove(s, i)
			break
		end
	end

	if skin ~= nil then
		table.insert(s, { priority = priority, skin = skin })
		table.sort(s, function(a, b) return a.priority < b.priority end)
	end

	self.skin[slot] = s

	self.onSkinChanged(self, slot, priority, skin)
end

function LocalActor:unsetSkin(slot, skin)
	local s = self.skin[slot]
	if s then
		for i = 1, #s do
			if s[i].skin == skin then
				table.remove(s, i)
				self.onSkinChanged(self, slot, false, skin)
				break
			end
		end
	end
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
