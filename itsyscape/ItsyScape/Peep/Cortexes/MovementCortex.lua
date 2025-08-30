--------------------------------------------------------------------------------
-- ItsyScape/Peep/Cortexes/MovementCortex.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local slick = require "slick"
local Class = require "ItsyScape.Common.Class"
local Callback = require "ItsyScape.Common.Callback"
local Vector = require "ItsyScape.Common.Math.Vector"
local Utility = require "ItsyScape.Game.Utility"
local Cortex = require "ItsyScape.Peep.Cortex"
local Peep = require "ItsyScape.Peep.Peep"
local MovementBehavior = require "ItsyScape.Peep.Behaviors.MovementBehavior"
local PositionBehavior = require "ItsyScape.Peep.Behaviors.PositionBehavior"
local PropReferenceBehavior = require "ItsyScape.Peep.Behaviors.PropReferenceBehavior"
local StaticBehavior = require "ItsyScape.Peep.Behaviors.StaticBehavior"
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

-- Until we have pathfinding that takes into account a peep's size,
-- we need to clamp them to roughly a tile (with some wiggle room to make imperfect movement easier)
MovementCortex.PEEP_RADIUS = 0.5

local function _isPassable(map, i, j, s, t)
	return not map:getTile(s, t):hasStaticFlag("impassable")
end

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

function MovementCortex:previewPeep(peep)
	Cortex.previewPeep(self, peep)

	if peep:hasBehavior(StaticBehavior) and peep:hasBehavior(PropReferenceBehavior) then
		self:addPropToWorld(Utility.Peep.getLayer(peep), peep)
	elseif self.props[peep] then
		self:removePropFromWorld(self.peepsByLayer[peep], peep)
	end
end

function MovementCortex:listen()
	local stage = self:getDirector():getGameInstance():getStage()

	self.worlds = {}
	self.peepsByLayer = {}
	self.props = {}
	self._onLoadMap = function(_, _, layer)
		self:addWorld(layer)
	end
	stage.onLoadMap:register(self._onLoadMap)

	self._onMapModified = function(_, _, layer)
		self:updateWorld(layer)
	end
	stage.onMapModified:register(self._onMapModified)

	self._onUnloadMap = function(_, layer)
		self:unloadWorld(layer)
	end
	stage.onUnloadMap:register(self._onUnloadMap)

	self._filter = Callback.bind(self.filter, self)
end

function MovementCortex:addWorld(layer)
	local map = self:getDirector():getMap(layer)
	local world = slick.newWorld(
		map:getWidth() * map:getCellSize(),
		map:getHeight() * map:getCellSize(), {
			quadTreeX = 0,
			quadTreeY = 0,
			quadTreeMaxLevels = 4,
			quadTreeMaxData = 16
		})

	self.worlds[layer] = {
		world = world,
		tiles = {},
		peeps = {},
		props = {},
		layer = layer
	}
end

function MovementCortex:addPeepToWorld(layer, peep)
	self:removePeepFromWorld(self.peepsByLayer[peep], peep)

	local w = self.worlds[layer]
	if w then
		w.peeps[peep] = true
		self.peepsByLayer[peep] = Utility.Peep.getLayer(peep)

		local position = Utility.Peep.getPosition(peep)
		w.world:add(peep, position.x, position.z, slick.newCircleShape(0, 0, MovementCortex.PEEP_RADIUS))
	end
end

function MovementCortex:addPropToWorld(layer, prop)
	self:removePropFromWorld(self.peepsByLayer[prop], prop)

	local w = self.worlds[layer]
	if w then
		w.props[prop] = true
		self.peepsByLayer[prop] = Utility.Peep.getLayer(prop)
		self.props[prop] = true

		local position = Utility.Peep.getPosition(prop)
		local _, rotation, _ = Utility.Peep.getRotation(prop):getEulerXYZ()
		local scale = Utility.Peep.getScale(prop)
		local size = Utility.Peep.getSize(prop)
		local offset = -size / 2
		w.world:add(
			prop,
			slick.newTransform(position.x, position.z, rotation, scale.x, scale.z),
			slick.newRectangleShape(offset.x, offset.z, size.x, size.z))
	end
end

function MovementCortex:updateProp(prop)
	local layer = Utility.Peep.getLayer(prop)
	if layer ~= self.peepsByLayer[prop] then
		self:removePropFromWorld(self.peepsByLayer[prop], prop)
		self:addPropToWorld(layer, prop)
	end

	local w = self.worlds[layer]
	if w then
		local position = Utility.Peep.getPosition(prop)
		local _, rotation, _ = Utility.Peep.getRotation(prop):getEulerXYZ()
		local scale = Utility.Peep.getScale(prop)
		local size = Utility.Peep.getSize(prop)
		local offset = -size / 2
		w.world:update(
			prop,
			slick.newTransform(position.x, position.z, rotation, scale.x, scale.z),
			slick.newRectangleShape(offset.x, offset.z, size.x, size.z))
	end
end

function MovementCortex:removePeepFromWorld(layer, peep)
	if not layer then
		return
	end

	local w = self.worlds[layer]
	if not w then
		return
	end

	w.peeps[peep] = nil
	if w.world:has(peep) then
		w.world:remove(peep)
	end
end

function MovementCortex:removePropFromWorld(layer, prop)
	if not layer then
		return
	end

	local w = self.worlds[layer]
	if not w then
		return
	end

	w.props[prop] = nil
	self.props[prop] = true

	if w.world:has(prop) then
		w.world:remove(prop)
	end
end

function MovementCortex:updateWorld(layer)
	local map = self:getDirector():getMap(layer)

	local w = self.worlds[layer]
	if not w then
		return
	end

	local add = w.world.add
	local totalTime = 0 
	w.world.add = function(...)
		local b = love.timer.getTime()
		local r = add(...)
		local a = love.timer.getTime()
		totalTime = totalTime + (a - b) * 1000
		return r
	end

	local b = love.timer.getTime()
	for i = 1, #w.tiles do
		w.world:remove(w.tiles[i])
	end
	table.clear(w.tiles)
	local a = love.timer.getTime()

	local b = love.timer.getTime()

	for i = 1, map:getWidth() do
		for j = 1, map:getHeight() do
			local tile = map:getTile(i, j)
			local tileCenter = map:getTileCenter(i, j)
			local min = tileCenter - Vector(map:getCellSize() / 2)

			w.world:add(tile, min.x, min.z, slick.newRectangleShape(0, 0, map:getCellSize(), map:getCellSize()))
			if tile:getIsPassable() then
				for k = 1, #MovementCortex.OFFSETS do
					local offsetI, offsetJ = unpack(MovementCortex.OFFSETS[k])

					if not map:canMove(i, j, offsetI, offsetJ, false, _isPassable) and map:getTile(i + offsetI, j + offsetJ):getIsPassable() then
						local t = Tile()
						t:setFlag("impassable")

						if offsetI < 0 then
							w.world:add(t, min.x, min.z, slick.newLineSegmentShape(0, 0, 0, map:getCellSize()))
						elseif offsetI > 0 then
							w.world:add(t, min.x, min.z, slick.newLineSegmentShape(map:getCellSize(), 0, map:getCellSize(), map:getCellSize()))
						end

						if offsetJ < 0 then
							w.world:add(t, min.x, min.z, slick.newLineSegmentShape(0, 0, map:getCellSize(), 0))
						elseif offsetJ > 0 then
							w.world:add(t, min.x, min.z, slick.newLineSegmentShape(0, map:getCellSize(), map:getCellSize(), map:getCellSize()))
						end

						table.insert(w.tiles, t)
					end
				end
			end

			table.insert(w.tiles, tile)
		end
	end

	print(">>> totalTime", totalTime)
end

function MovementCortex:unloadWorld(layer)
	if self.worlds[layer] then
		self.worlds[layer] = nil
	end
end

function MovementCortex:filter(item, other)
	if Class.isCompatibleType(other, Tile) then
		if other:hasStaticFlag("impassable") then
			return "slide"
		end
	elseif Class.isCompatibleType(other, Peep) then
		local static = other:getBehavior(StaticBehavior)
		if static and static.type == StaticBehavior.IMPASSABLE then
			return "slide"
		end
	end

	return false
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

	for prop in pairs(self.props) do
		self:updateProp(prop)
	end

	for peep in self:iterate() do
		local movement = peep:getBehavior(MovementBehavior)
		local position = peep:getBehavior(PositionBehavior)
		local layer = Utility.Peep.getLayer(peep)

		if layer ~= self.peepsByLayer[peep] then
			self:removePeepFromWorld(self.peepsByLayer[layer], peep)
			self:addPeepToWorld(layer, peep)
		end

		local map = self:getDirector():getMap(layer)
		local w = self.worlds[layer]
		if map and w then
			if not w.world:has(peep) then
				self:addPeepToWorld(layer, peep)
			end

			movement:clampMovement()

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
					if not wasMoving and movement.targetFacing then
						movement.facing = movement.targetFacing
						movement.targetFacing = false
					end
				end
			end

			local oldPosition = position.position
			w.world:update(peep, oldPosition.x, oldPosition.z)

			local velocity = (movement.velocity + movement.additionalVelocity) * delta * movement.velocityMultiplier
			velocity = velocity + movement.push * delta
			velocity = self:accumulate(peep, self.accumulateVelocity, velocity)

			local newPosition = position.position + velocity
			if not movement.noClip then
				newPosition = newPosition + gravity * delta
			end

			if not movement.noClip and velocity:getLength() > 0 then
				local actualX, actualZ, collisions = w.world:move(
					peep,
					newPosition.x,
					newPosition.z,
					self._filter)

				position.position = Vector(actualX, newPosition.y, actualZ)
			else
				position.position = newPosition
			end

			local isOnGround = movement.isOnGround
			local y = map:getInterpolatedHeight(
				position.position.x,
				position.position.z) + movement.float
			if not movement.noClip then
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
			else
				movement.isOnGround = false
			end

			if not isOnGround and movement.isOnGround then
				peep:poke("fall")
			end

			if movement.isOnGround then
				position.position.y = y
				movement.acceleration.y = 0
				movement.velocity.y = 0
			else
				if not movement.noClip then
					position.position.y = math.max(position.position.y, y)
				end
			end

			if movement.isStopping then
				movement.velocity = movement.velocity * (movement.velocityDecay ^ delta)
			end
			movement.acceleration = movement.acceleration * (movement.accelerationDecay ^ delta)

			movement.push = movement.push * (movement.pushDecay ^ delta)
			clampVector(movement.push)

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
