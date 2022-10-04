--------------------------------------------------------------------------------
-- ItsyScape/Peep/Cortexes/MovementCortex.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local bump = require "bump"
local Class = require "ItsyScape.Common.Class"
local Callback = require "ItsyScape.Common.Callback"
local Vector = require "ItsyScape.Common.Math.Vector"
local Utility = require "ItsyScape.Game.Utility"
local Cortex = require "ItsyScape.Peep.Cortex"
local MovementBehavior = require "ItsyScape.Peep.Behaviors.MovementBehavior"
local PositionBehavior = require "ItsyScape.Peep.Behaviors.PositionBehavior"
local TargetTileBehavior = require "ItsyScape.Peep.Behaviors.TargetTileBehavior"
local Tile = require "ItsyScape.World.Tile"

local MovementCortex = Class(Cortex)

-- The epsilon to determine whether an object is on the ground.
MovementCortex.GROUND_EPSILON = 0.1

-- If any of the components of the acceleration or velocity vectors fall within
-- +/- CLAMP_EPSILON, then the component is clamped to zero.
MovementCortex.CLAMP_EPSILON = 0.05

function MovementCortex:new()
	Cortex.new(self)

	self:require(MovementBehavior)
	self:require(PositionBehavior)
end

function MovementCortex:attach(director)
	Cortex.attach(self, director)

	self.ready = true
end

function MovementCortex:detach()
	local stage = self:getDirector():getGameInstance():getStage()
	stage.onLoadMap:unregister(self._onLoadMap)
	stage.onMapModified:unregister(self._onMapModified)
	stage.onUnloadMap:unregister(self._onUnloadMap)

	Cortex.detach(self)
end

function MovementCortex:listen()
	local stage = self:getDirector():getGameInstance():getStage()

	self.worlds = {}
	self.peepsByLayer = {}
	self._onLoadMap = function(_, map, layer)
		self:addWorld(layer, map)
	end
	stage.onLoadMap:register(self._onLoadMap)

	self._onMapModified = function(_, map, layer)
		self:updateWorld(layer, map)
	end
	stage.onMapModified:register(self._onMapModified)

	self._onUnloadMap = function(_, map, layer)
		self:unloadWorld(map, layer)
	end
	stage.onUnloadMap:register(self._onUnloadMap)

	self._filter = Callback.bind(self.filter, self)
end

function MovementCortex:addWorld(layer, map)
	local world = bump.newWorld(map:getCellSize())
	self.worlds[layer] = {
		world = world,
		tiles = {},
		peeps = {},
		layer = layer
	}
end

function MovementCortex:addPeepToWorld(layer, peep)
	self:removePeepFromWorld(peep)

	local w = self.worlds[layer]
	if w then
		w.peeps[peep] = true

		local position = Utility.Peep.getPosition(peep)
		local size = Utility.Peep.getSize(peep)
		w.world:add(peep, position.x - size.x / 2, position.z - size.z / 2, size.x, size.z)
	end
end

function MovementCortex:removePeepFromWorld(peep)
	local layer = self.peepsByLayer[peep]
	if not layer then
		return
	end

	local w = self.worlds[layer]
	if not w then
		return
	end

	w.peeps[peep] = nil
	if w.world:hasItem(peep) then
		w.world:remove(peep)
	end
end

function MovementCortex:updateWorld(layer, map)
	local w = self.worlds[layer]
	if not w then
		return
	end

	for i = 1, #w.tiles do
		w.world:remove(w.tiles[i])
	end
	table.clear(w.tiles)

	for i = 1, map:getWidth() do
		for j = 1, map:getHeight() do
			local tile = map:getTile(i, j)
			local tileCenter = map:getTileCenter(i, j)
			local min = tileCenter - Vector(map:getCellSize() / 2)

			if tile:hasFlag("wall-left") then
				w.world:add(tile, min.x, min.z, map:getCellSize() / 2, map:getCellSize())
			elseif tile:hasFlag("wall-right") then
				w.world:add(tile, min.x + map:getCellSize() / 2, min.z, map:getCellSize() / 2, map:getCellSize())
			elseif tile:hasFlag("wall-top") then
				w.world:add(tile, min.x, min.z, map:getCellSize(), map:getCellSize() / 2)
			elseif tile:hasFlag("wall-bottom") then
				w.world:add(tile, min.x, min.z + map:getCellSize() / 2, map:getCellSize(), map:getCellSize() / 2)
			else
				w.world:add(tile, min.x, min.z, map:getCellSize(), map:getCellSize())
			end

			table.insert(w.tiles, tile)
		end
	end
end

function MovementCortex:unloadWorld(layer)
	if self.worlds[layer] then
		self.worlds[layer] = nil
	end
end

function MovementCortex:filter(item, other)
	if Class.isCompatibleType(other, Tile) then
		-- local peepI, peepJ, layer = Utility.Peep.getTile(item)
		-- local map = self.worlds[layer] and self:getDirector():getMap(layer)
		-- local tileI, tileJ = other:getData("x-map-i"), other:getData("x-map-j")
		if (other:hasFlag("impassable") or other:hasFlag("door") or
		   other:hasFlag("wall-left") or other:hasFlag("wall-right") or
		   other:hasFlag("wall-top") or other:hasFlag("wall-bottom"))
	    then
			return "slide"
		-- elseif map and tileI and tileJ and not map:canMove(peepI, peepJ, tileI - peepI, tileJ - peepJ) then
		-- 	if (math.abs(tileI - peepI) == 1 or math.abs(tileJ - peepJ) == 1) and math.abs(tileI - peepI) + math.abs(tileJ - peepJ) == 1 then
		-- 		print("SLIDE!", tileI - peepI, tileJ - peepJ)
		-- 		return "slide"
		-- 	end
		end
	end

	return nil
end

-- Clamps vector following rules of MovementCortex.CLAMP_EPSILON.
local function clampVector(v)
	if math.abs(v.x) < MovementCortex.CLAMP_EPSILON then
		v.x = 0
	end

	if math.abs(v.y) < MovementCortex.CLAMP_EPSILON then
		v.y = 0
	end

	if math.abs(v.z) < MovementCortex.CLAMP_EPSILON then
		v.z = 0
	end
end

function MovementCortex.accumulateAcceleration(effect, acceleration)
	return effect:applyToAcceleration(acceleration)
end

function MovementCortex.accumulateVelocity(effect, velocity)
	return effect:applyToVelocity(velocity)
end

function MovementCortex.accumulatePosition(effect, position, elevation)
	return effect:applyToPosition(position, elevation)
end

function MovementCortex:accumulate(peep, func, value, ...)
	for effect in peep:getEffects(require "ItsyScape.Peep.Effects.MovementEffect") do
		value = func(effect, value, ...)
	end

	return value
end

function MovementCortex:update(delta)
	if self.ready then
		self:listen()
		self.ready = false
	end

	local game = self:getDirector():getGameInstance()
	local gravity = game:getStage():getGravity()
	local map = game:getStage():getMap()

	for peep in self:iterate() do
		local movement = peep:getBehavior(MovementBehavior)
		local position = peep:getBehavior(PositionBehavior)
		local size = Utility.Peep.getSize(peep)
		local halfSize = size / 2
		local layer = Utility.Peep.getLayer(peep)
		local map = self:getDirector():getMap(layer)
		local w = self.worlds[layer]
		if map and w then
			if not w.world:hasItem(peep) then
				self:addPeepToWorld(layer, peep)
			end

			movement:clampMovement()

			movement.acceleration = movement.acceleration + movement.acceleration * delta + gravity
			clampVector(movement.acceleration)

			local wasMoving
			do
				local xzVelocity = movement.velocity * Vector(1, 0, 1)
				if xzVelocity:getLengthSquared() > 0 then
					wasMoving = true
				end
			end


			local acceleration = movement.acceleration * delta * movement.accelerationMultiplier + movement.additionalAcceleration
			acceleration = self:accumulate(peep, self.accumulateAcceleration, acceleration)

			movement.velocity = movement.velocity + acceleration
			clampVector(movement.velocity)

			do
				local xzVelocity = movement.velocity * Vector(1, 0, 1)
				if xzVelocity:getLengthSquared() == 0 and movement.isOnGround then
					movement.isStopping = false
					if wasMoving and movement.targetFacing then
						movement.facing = movement.targetFacing
						movement.targetFacing = false
					end
				end
			end

			local oldPosition = position.position
			w.world:update(peep, oldPosition.x - halfSize.x, oldPosition.z - halfSize.x, size.x, size.z)

			local oldTile, oldI, oldJ = map:getTileAt(oldPosition.x, oldPosition.z)

			local velocity = (movement.velocity + movement.additionalVelocity) * delta * movement.velocityMultiplier
			velocity = self:accumulate(peep, self.accumulateVelocity, velocity)

			position.position = position.position + velocity

			local actualX, actualZ = w.world:move(
				peep,
				position.position.x - halfSize.x,
				position.position.z - halfSize.z,
				self._filter)
			actualX = actualX + halfSize.x
			actualZ = actualZ + halfSize.z

			local newTile, newI, newJ = map:getTileAt(actualX, actualZ)
			if newTile:hasFlag('impassable') or
			   newTile:hasFlag('door') or
			   not map:canMove(oldI, oldJ, newI - oldI, newJ - oldJ) or
			   map:isOutOfBounds(position.position.x, position.position.z)
			then
				-- Last fail safe.
				position.position = Vector(oldPosition:get())

				peep:poke('movedOutOfBounds')
			else
				position.position = Vector(actualX, position.position.y, actualZ)
			end

			local y = map:getInterpolatedHeight(
				position.position.x,
				position.position.z) + movement.float
			if position.position.y < y then
				if movement.bounce > 0 then
					movement.acceleration.y = -movement.acceleration.y * movement.bounce
					movement.velocity.y = -movement.velocity.y * movement.bounce
					position.position.y = y

					if movement.velocity.y < movement.bounceThreshold then
						movement.acceleration.y = 0
						movement.velocity.y = 0
						movement.isOnGround = true
					else
						movement.isOnGround = false
					end
				elseif not movement.isOnGround then
					movement.isOnGround = true
				end
			elseif position.position.y > y + MovementCortex.GROUND_EPSILON
			       and movement.isOnGround
			then
				movement.isOnGround = false
			end

			if movement.isOnGround then
				position.position.y = y
				movement.acceleration.y = 0
				movement.velocity.y = 0

				if movement.isStopping then
					movement.acceleration = movement.acceleration * movement.decay * delta
					movement.velocity = movement.velocity * movement.decay * delta
				end
			else
				position.position.y = math.max(position.position.y, y)
			end

			position.position = self:accumulate(peep, self.accumulatePosition, position.position, y)

			local stepY = position.position.y - oldPosition.y 
			if stepY > movement.maxStepHeight then
				position.position = oldPosition
			end

			if movement.velocity.x < -0.5 then
				movement.facing = MovementBehavior.FACING_LEFT
			elseif movement.velocity.x > 0.5 then
				movement.facing = MovementBehavior.FACING_RIGHT
			end
		end
	end
end

return MovementCortex
