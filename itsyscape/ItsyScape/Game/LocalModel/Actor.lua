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
local Utility = require "ItsyScape.Game.Utility"
local ActorReferenceBehavior = require "ItsyScape.Peep.Behaviors.ActorReferenceBehavior"
local MovementBehavior = require "ItsyScape.Peep.Behaviors.MovementBehavior"
local PositionBehavior = require "ItsyScape.Peep.Behaviors.PositionBehavior"
local RotationBehavior = require "ItsyScape.Peep.Behaviors.RotationBehavior"
local CombatStatusBehavior = require "ItsyScape.Peep.Behaviors.CombatStatusBehavior"
local ScaleBehavior = require "ItsyScape.Peep.Behaviors.ScaleBehavior"
local SizeBehavior = require "ItsyScape.Peep.Behaviors.SizeBehavior"
local StatsBehavior = require "ItsyScape.Peep.Behaviors.StatsBehavior"
local PlayerBehavior = require "ItsyScape.Peep.Behaviors.PlayerBehavior"

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
	self.resource = false
end

function LocalActor:getPeep()
	return self.peep
end

function LocalActor:spawn(id, group, resource, ...)
	assert(self.id == Actor.NIL_ID, "Actor already spawned")

	self.peep = self.game:getDirector():addPeep(group, self.peepType, resource, ...)
	local _, actorReference = self.peep:addBehavior(ActorReferenceBehavior)
	actorReference.actor = self

	self.peep:listen("hit", function(_, p)
		self.onDamage(self, p:getDamageType(), p:getDamage())
	end)
	self.peep:listen("heal", function(_, p)
		self.onDamage(self, 'heal', p.hitPoints)
	end)

	self.id = id
	self.resource = resource or false
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
	local name = self.peep:getName()
	local isAttackable
	do
		local actions = self:getActions('world')
		for i = 1, #actions do
			if actions[i].type == 'Attack' then
				isAttackable = true
				break
			end
		end
	end

	if isAttackable or self.peep:hasBehavior(PlayerBehavior) then
		local combatLevel = Utility.Combat.getCombatLevel(self.peep)
		name = string.format("%s (Lvl %d)", name, combatLevel)
	end

	return name
end

function LocalActor:getDescription()
	return Utility.Peep.getDescription(self.peep)
end

function LocalActor:setName(value)
	self.peep:setName(value)
end

function LocalActor:setDirection(direction)
	if direction and self.peep then
		local movement = self.peep:getBehavior(MovementBehavior)

		if movement then
			if direction.x < 0 then
				movement.facing = MovementBehavior.FACING_LEFT
			elseif direction.y > 0 then
				movement.facing = MovementBehavior.FACING_RIGHT
			end

			local rotation = self.peep:getBehavior(RotationBehavior)
			if rotation then
				self.onDirectionChanged(self, direction, rotation.rotation)
			else
				self.onDirectionChanged(self, direction)
			end
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

function LocalActor:move(position, layer)
	if position and self.peep then
		local positionBehavior = self.peep:getBehavior(PositionBehavior)
		if positionBehavior then
			positionBehavior.position = position
			positionBehavior.layer = layer or positionBehavior.layer

			self.onMove(self, position, layer)
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

function LocalActor:getScale()
	if not self.peep then
		return Vector.ONE
	end

	local scale = self.peep:getBehavior(ScaleBehavior)
	if scale then
		return scale.scale
	else
		return Vector.ONE
	end
end

-- Gets the current hitpoints of the Actor.
function LocalActor:getCurrentHitpoints()
	if not self.peep then
		return 1
	end

	local combatStats = self.peep:getBehavior(CombatStatusBehavior)
	if combatStats then
		return combatStats.currentHitpoints
	else
		return 1
	end
end

-- Gets the maximum hitpoints of the Actor.
function LocalActor:getMaximumHitpoints()
	if not self.peep then
		return 1
	end

	local combatStats = self.peep:getBehavior(CombatStatusBehavior)
	if combatStats then
		return combatStats.maximumHitpoints
	else
		return 1
	end
end

function LocalActor:getTile()
	if not self.peep then
		return 0, 0, 0
	end

	local position = self.peep:getBehavior(PositionBehavior)
	if position then
		local map = self.game:getDirector():getMap(position.layer or 1)
		if not map then
			return 0, 0, 0
		end

		local i, j = map:getTileAt(position.position.x, position.position.z)

		return i, j, position.layer or 1
	else
		return 0, 0, 0
	end
end

function LocalActor:getCurrentHealth()
	if not self.peep then
		return 1
	end

	local status = self.peep:getBehavior(CombatStatusBehavior)
	if status then
		return status.currentHitpoints
	else
		return 1
	end
end

function LocalActor:getMaximumHealth()
	if not self.peep then
		return 1
	end

	local status = self.peep:getBehavior(CombatStatusBehavior)
	if status then
		return status.maxHitpoints
	else
		return 1
	end
end

function LocalActor:getBounds()
	if not self.peep then
		return Vector.ZERO, Vector.ZERO, 1, 0
	end

	local position = self:getPosition()

	local size = self.peep:getBehavior(SizeBehavior)
	if size then
		local xzSize = Vector(size.size.x / 2, 0, size.size.z / 2)
		local ySize = Vector(0, size.size.y, 0)
		local min = position - xzSize
		local max = position + xzSize + ySize

		return min + size.offset, max + size.offset, size.zoom, size.pan
	else
		return position, position, 1, 0
	end
end

function LocalActor:getResource()
	return self.resource or Utility.Peep.getResource(self.peep)
end

function LocalActor:getActions(scope)
	local status = self.peep:getBehavior(CombatStatusBehavior)
	if status and status.dead then
		return {}
	end

	if self:getResource() and self:getCurrentHealth() > 0 then
		local actions = Utility.getActions(self.game, self:getResource(), scope or 'world')
		if self.peep then
			local mapObject = Utility.Peep.getMapObject(self.peep)
			if mapObject then
				local proxyActions = Utility.getActions(self.game, mapObject, scope or 'world')

				for i = 1, #proxyActions do
					table.insert(actions, proxyActions[i])
				end
			end
		end

		return actions
	else
		return {}
	end
end

function LocalActor:poke(action, scope)
	if self:getResource() then
		local player = self.game:getPlayer():getActor():getPeep()
		local peep = self:getPeep()
		local s = Utility.performAction(
			self.game,
			self:getResource(),
			action,
			scope,
			player:getState(), player, peep)
		local m = Utility.Peep.getMapObject(peep)
		if not s and m then
			Utility.performAction(
				self.game,
				m,
				action,
				scope,
				player:getState(), player, peep)
		end
	end
end

function LocalActor:setBody(body)
	self.body = body or false
	self.onTransmogrified(self, body)
end

function LocalActor:playAnimation(slot, priority, animation, force)
	if not priority then
		self.animations[slot] = nil
		self.onAnimationPlayed(self, slot, priority, animation)

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

	if priority then
		if skin ~= nil then
			table.insert(s, { priority = priority, skin = skin })
			table.sort(s, function(a, b) return a.priority < b.priority end)
		end

		self.skin[slot] = s
	else
		for i = 1, #self.skin[slot] do
			if self.skin[slot][i].skin == skin then
				table.remove(self.skin[slot], i)
				break
			end
		end
	end

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
		table.insert(result, { skin = slot[i].skin, priority = slot[i].priority })
	end

	return unpack(result)
end

function LocalActor:flash(message, ...)
	self.onHUDMessage(self, message, ...)
end

return LocalActor
