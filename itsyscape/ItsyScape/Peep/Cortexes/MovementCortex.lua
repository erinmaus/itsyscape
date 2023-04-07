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

MovementCortex.OFFSETS = {
	{ -1,  0 },
	{  1,  0 },
	{  0, -1 },
	{  0,  1 }
}

MovementCortex.BUFFER = 0.01

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

	world:addResponse("slide-left", MovementCortex.slide(-1, 0))
	world:addResponse("slide-right", MovementCortex.slide(1, 0))
	world:addResponse("slide-up", MovementCortex.slide(0, -1))
	world:addResponse("slide-down", MovementCortex.slide(0, 1))
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

function MovementCortex:_addProxyTileToWorld(world, flags, x, y, w, h)
	local tile = Tile()
	for i = 1, #flags do
		tile:setFlag(flags[i])
	end

	world.world:add(tile, x, y, w, h)

	table.insert(world.tiles, tile)
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

	local buffer = map:getCellSize() * MovementCortex.BUFFER
	for i = 1, map:getWidth() do
		for j = 1, map:getHeight() do
			local tile = map:getTile(i, j)
			local tileCenter = map:getTileCenter(i, j)
			local min = tileCenter - Vector(map:getCellSize() / 2)
			local isWall = tile:hasFlag("wall-left") or tile:hasFlag("wall-right") or tile:hasFlag("wall-top") or tile:hasFlag("wall-bottom")

			if tile:hasFlag("wall-left") then
				self:_addProxyTileToWorld(w, { "wall-left" }, min.x, min.z, map:getCellSize() / 2, map:getCellSize())
			end

			if tile:hasFlag("wall-right") then
				self:_addProxyTileToWorld(w, { "wall-right" }, min.x + map:getCellSize() / 2, min.z, map:getCellSize() / 2, map:getCellSize())
			end

			if tile:hasFlag("wall-top") then
				self:_addProxyTileToWorld(w, { "wall-top" }, min.x, min.z, map:getCellSize(), map:getCellSize() / 2)
			end

			if tile:hasFlag("wall-bottom") then
				self:_addProxyTileToWorld(w, { "wall-bottom" }, min.x, min.z + map:getCellSize() / 2, map:getCellSize(), map:getCellSize() / 2)
			end

			if not isWall then
				w.world:add(tile, min.x, min.z, map:getCellSize(), map:getCellSize())
			end

			if not isWall and tile:getIsPassable() then
				for k = 1, #MovementCortex.OFFSETS do
					local offsetI, offsetJ = unpack(MovementCortex.OFFSETS[k])

					if not map:canMove(i, j, offsetI, offsetJ) and map:getTile(i + offsetI, j + offsetJ):getIsPassable() then
						local t = Tile()

						if offsetI < 0 then
							t:setFlag("x-movement-slide-right")
							w.world:add(t, min.x, min.z, buffer, map:getCellSize())
						elseif offsetI > 0 then
							t:setFlag("x-movement-slide-left")
							w.world:add(t, min.x + map:getCellSize() - buffer, min.z, buffer, map:getCellSize())
						end

						if offsetJ < 0 then
							t:setFlag("x-movement-slide-up")
							w.world:add(t, min.x, min.z, map:getCellSize(), buffer)
						elseif offsetJ > 0 then
							t:setFlag("x-movement-slide-down")
							w.world:add(t, min.x, min.z + map:getCellSize() - buffer, map:getCellSize(), buffer)
						end

						table.insert(w.tiles, t)
					end
				end
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

function MovementCortex.slide(normalX, normalY)
	return function(world, col, x, y, w, h, goalX, goalY, filter)
		goalX = goalX or x
		goalY = goalY or y

		local tch, move  = col.touch, col.move
		if move.x ~= 0 or move.y ~= 0 then
			if col.normal.x == normalX and normalX ~= 0 then
				goalX = tch.x
			elseif col.normal.y == -normalY and normalY ~= 0 then
				goalY = tch.y
			end
		end

		col.slide = { x = goalX, y = goalY }

		x,y = tch.x, tch.y
		local cols, len  = world:project(col.item, x, y, w, h, goalX, goalY, filter)
		return goalX, goalY, cols, len
	end
end

function MovementCortex:filter(item, other)
	if Class.isCompatibleType(other, Tile) then
		if (other:hasFlag("impassable") or other:hasFlag("door") or
		   other:hasFlag("wall-left") or other:hasFlag("wall-right") or
		   other:hasFlag("wall-top") or other:hasFlag("wall-bottom"))
	    then
			return "slide"
		elseif other:hasFlag("x-movement-slide-left") then
			return "slide-left"
		elseif other:hasFlag("x-movement-slide-right") then
			return "slide-right"
		elseif other:hasFlag("x-movement-slide-up") then
			return "slide-up"
		elseif other:hasFlag("x-movement-slide-down") then
			return "slide-down"
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

			movement.acceleration = movement.acceleration + movement.acceleration * delta
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

			local newPosition = position.position + velocity + gravity * delta

			if not movement.noClip then
				local actualX, actualZ, collisions = w.world:move(
					peep,
					newPosition.x - halfSize.x,
					newPosition.z - halfSize.z,
					self._filter)
				actualX = actualX + halfSize.x
				actualZ = actualZ + halfSize.z

				local newTile, newI, newJ = map:getTileAt(actualX, actualZ)
				if not map:canMove(oldI, oldJ, newI - oldI, newJ - oldJ) or map:isOutOfBounds(actualX, actualZ) then
					-- Last fail safe.
					position.position = Vector(oldPosition:get())
				else
					position.position = Vector(actualX, newPosition.y, actualZ)

					if #collisions > 0 then
						peep:poke('movedOutOfBounds')
					end
				end
			else
				position.position = newPosition
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

			if movement.velocity.x < -0.5 then
				movement.facing = MovementBehavior.FACING_LEFT
			elseif movement.velocity.x > 0.5 then
				movement.facing = MovementBehavior.FACING_RIGHT
			end
		end
	end
end

return MovementCortex
