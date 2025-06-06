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
local Equipment = require "ItsyScape.Game.Equipment"
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

function LocalActor:new(game, peepType, peepID)
	Actor.new(self)

	self.game = game
	self.id = Actor.NIL_ID
	self.peepType = peepType
	self.peepID = peepID

	self.skin = {}
	self.animations = {}
	self.body = false
	self.resource = false
end

function LocalActor:getPeep()
	return self.peep
end

function LocalActor:getPeepID()
	return self.peepID
end

function LocalActor:spawn(id, group, resource, ...)
	assert(self.id == Actor.NIL_ID, "Actor already spawned")

	self.peep = self.game:getDirector():addPeep(group, self.peepType, resource, ...)
	local _, actorReference = self.peep:addBehavior(ActorReferenceBehavior)
	actorReference.actor = self

	self.peep:listen("hit", function(_, p)
		self.onDamage(self, p:getDamageType(), p:getDamage())
	end)
	self.peep:listen("miss", function(_, p)
		self.onDamage(self, 'block', 0)
	end)
	self.peep:listen("heal", function(_, p)
		self.onDamage(self, 'heal', p.hitPoints or p.hitpoints or 0)
	end)
	self.peep:listen("travel", function()
		for animationSlot, animation in self:iterateAnimationSlots() do
			if animationSlot ~= "main" then
				Log.info(
					"Stopping animation '%s' on slot '%s' for actor '%s' due to travel.",
					animation:getFilename(), animationSlot, self.peep:getName())

				self:stopAnimation(animationSlot)
			end
		end
	end)

	self.id = id
	self.oldID = nil
	self.resource = resource or false
end

function LocalActor:depart()
	assert(self.id ~= Actor.NIL_ID, "Actor not spawned")

	self.game:getDirector():removePeep(self.peep)

	self.oldID = self.id
	self.id = Actor.NIL_ID
end

function LocalActor:getID()
	return self.oldID or self.id
end

function LocalActor:getIsPoofed()
	return self.oldID ~= nil
end

function LocalActor:getName()
	if not self.peep then
		return "<poofed>"
	end

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
		name = string.format("%s (Lvl %s)", name, Utility.Text.prettyNumber(combatLevel))
	end

	return name
end

function LocalActor:getDescription()
	local resource = Utility.Peep.getResource(self.peep)
	if not self.descriptionResource or resource.id.value ~= self.descriptionResource.id.value then
		self.description = Utility.Peep.getDescription(self.peep)
		self.descriptionResource = resource
	end

	return self.description
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

	local rotation = self.peep:getBehavior(RotationBehavior)
	rotation = rotation and rotation.rotation

	local movement = self.peep:getBehavior(MovementBehavior)
	if movement then
		return Vector(movement.facing, 0, 0), rotation or nil
	else
		return Vector(MovementBehavior.FACING_RIGHT), rotation or nil
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

		local _, i, j = map:getTileAt(position.position.x, position.position.z)

		return i, j, position.layer or 1
	else
		return 0, 0, 0
	end
end

function LocalActor:getBounds()
	if not self.peep then
		return Vector.ZERO, Vector.ZERO, 1, 0
	end

	local position = self:getPosition()
	local scale = self:getScale()

	local size = self.peep:getBehavior(SizeBehavior)
	if size then
		local xzSize = Vector(size.size.x / 2, 0, size.size.z / 2) * scale 
		local ySize = Vector(0, size.size.y, 0) * scale
		local min = position - xzSize
		local max = position + xzSize + ySize

		return min + size.offset, max + size.offset, size.zoom, size.pan
	else
		return position, position, 1, 0
	end
end

function LocalActor:getResource()
	return Utility.Peep.getResource(self.peep)
end

function LocalActor:getActions(scope)
	local status = self.peep:getBehavior(CombatStatusBehavior)
	if status and status.dead then
		return {}
	end

	local result = {}
	if self:getResource() then
		local actions = Utility.getActions(self.game, self:getResource(), scope or 'world')
		for i = 1, #actions do
			result[i] = actions[i]
		end

		if self.peep then
			local mapObject = Utility.Peep.getMapObject(self.peep)
			if mapObject then
				local proxyActions = Utility.getActions(self.game, mapObject, scope or 'world')

				for i = 1, #proxyActions do
					table.insert(result, proxyActions[i])
				end
			end
		end
	end

	return result
end

function LocalActor:poke(action, scope, player)
	if self:getResource() then
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

function LocalActor:getBody()
	return self.body
end

function LocalActor:setBody(body)
	self.body = body or false
	self.onTransmogrified(self, body)
end

function LocalActor:playAnimation(slot, priority, animation, force, time)
	self.animations[slot] = animation
	self.onAnimationPlayed(self, slot, priority, animation, force, time)
end

function LocalActor:stopAnimation(slot)
	self.animations[slot] = nil
	self.onAnimationStopped(self, slot, math.huge, true)
end

function LocalActor:iterateAnimationSlots()
	return pairs(self.animations)
end

function LocalActor:setSkin(slot, priority, skin, config)
	local s = self.skin[slot] or {}

	if priority then
		if skin ~= nil then
			table.insert(s, { priority = priority, skin = skin, config = config })
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

	Log.engine(
		"Setting skin for skin for '%s' (%d) @ slot '%s' (%s, priority = %d): '%s'.",
		(self.peep and self:getName()) or "<poofed>", self:getID(),
		Equipment.PLAYER_SLOT_NAMES[slot] or tostring(slot), tostring(slot), priority,
		skin:getFilename())

	self.onSkinChanged(self, slot, priority, skin, config)
end

function LocalActor:unsetSkin(slot, priority, skin)
	local s = self.skin[slot]
	if s then
		for i = 1, #s do
			if s[i].skin == skin and s[i].priority == priority then
				local priority = s[i].priority

				table.remove(s, i)
				break
			end
		end
	end

	Log.engine(
		"Unsetting skin for '%s' (%d) @ slot '%s' (%s, priority = %d): '%s'.",
		(self.peep and self:getName()) or "<poofed>", self:getID(),
		Equipment.PLAYER_SLOT_NAMES[slot] or tostring(slot), tostring(slot), priority,
		skin:getFilename())

	self.onSkinRemoved(self, slot, priority, skin)
end

function LocalActor:getSkin(index)
	local slot = self.skin[index] or {}
	local result = {}

	for i = 1, #slot do
		table.insert(result, { skin = slot[i].skin, priority = slot[i].priority, config = slot[i].config })
	end

	return unpack(result)
end

function LocalActor:flash(message, ...)
	self.onHUDMessage(self, message, ...)
end

return LocalActor
