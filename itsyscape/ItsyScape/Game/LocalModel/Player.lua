--------------------------------------------------------------------------------
-- ItsyScape/Game/LocalModel/Player.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Vector = require "ItsyScape.Common.Math.Vector"
local Ray = require "ItsyScape.Common.Math.Ray"
local Utility = require "ItsyScape.Game.Utility"
local Player = require "ItsyScape.Game.Model.Player"
local PlayerBehavior = require "ItsyScape.Peep.Behaviors.PlayerBehavior"
local ActorReferenceBehavior = require "ItsyScape.Peep.Behaviors.ActorReferenceBehavior"
local MovementBehavior = require "ItsyScape.Peep.Behaviors.MovementBehavior"
local PropReferenceBehavior = require "ItsyScape.Peep.Behaviors.PropReferenceBehavior"
local PositionBehavior = require "ItsyScape.Peep.Behaviors.PositionBehavior"
local SizeBehavior = require "ItsyScape.Peep.Behaviors.SizeBehavior"
local TargetTileBehavior = require "ItsyScape.Peep.Behaviors.TargetTileBehavior"
local CombatTargetBehavior = require "ItsyScape.Peep.Behaviors.CombatTargetBehavior"
local CombatCortex = require "ItsyScape.Peep.Cortexes.CombatCortex"
local MapPathFinder = require "ItsyScape.World.MapPathFinder"
local PathNode = require "ItsyScape.World.PathNode"
local ExecutePathCommand = require "ItsyScape.World.ExecutePathCommand"

local Player = Class()

-- Constructs a new player.
--
-- The Actor isn't created until Player.spawn is called.
function Player:new(game, stage)
	self.game = game
	self.stage = stage
	self.actor = false
	self.direction = Vector.UNIT_X
end

function Player:spawn()
	local success, actor = self.stage:spawnActor("Resources.Game.Peeps.Player.One")
	if success then
		self.actor = actor
		actor:getPeep():addBehavior(PlayerBehavior)

		local p = actor:getPeep():getBehavior(PlayerBehavior)
		p.id = 1

		actor:getPeep():listen('finalize', function()
			local storage = self.game:getDirector():getPlayerStorage(1):getRoot()
			if storage:hasSection("Location") then
				local location = storage:getSection("Location")
				if location:get("name") then
					self.stage:movePeep(
						actor:getPeep(),
						location:get("name"),
						Vector(
							location:get("x"),
							location:get("y"),
							location:get("z")),
						true)
					return
				end
			end
		end)
	else
		self.actor = false
	end
end

function Player:poof()
	if self.actor then
		self.stage:killActor(self.actor)
	end

	self.actor = false
end

-- Gets the Actor this Player is represented by.
function Player:getActor()
	return self.actor
end

function Player:flee()
	local peep = self.actor:getPeep()
	peep:removeBehavior(CombatTargetBehavior)
	peep:getCommandQueue(CombatCortex.QUEUE):clear()
end

function Player:getIsEngaged()
	local peep = self.actor:getPeep()
	return peep:hasBehavior(CombatTargetBehavior)
end

function Player:findPath(i, j, k)
	local peep = self.actor:getPeep()
	local position = peep:getBehavior(PositionBehavior).position
	local map = self.game:getDirector():getMap(k)
	local _, playerI, playerJ = map:getTileAt(position.x, position.z)
	local pathFinder = MapPathFinder(map)
	return pathFinder:find(
		{ i = playerI, j = playerJ },
		{ i = i, j = j },
		0)
end

function Player:move(x, z)
	if not self.actor then
		return
	end

	local direction = Vector(x, 0, z):getNormal()
	local length = direction:getLength()
	local peep = self.actor:getPeep()
	local movement = peep:getBehavior(MovementBehavior)
	if length == 0 then
		local currentAccceleration = movement.acceleration:getLength()
		if currentAccceleration < 1 then
			movement.acceleration = Vector.ZERO
			movement.velocity = Vector.ZERO
			movement.isStopping = true
		end
	else
		if peep:getCommandQueue():clear() then
			movement.acceleration = movement.maxAcceleration * direction
			movement.isStopping = false

			local i, j, k = Utility.Peep.getTile(peep)

			self.direction = direction
			peep:poke('walk', { i = i, j = j, k = k })
		end
	end
end

function Player:poke()
	if not self.actor then
		return
	end

	local playerPeep = self.actor:getPeep()
	local director = playerPeep:getDirector()
	local direction = self.direction

	local ray = Ray(
		Utility.Peep.getAbsolutePosition(playerPeep) + Vector.UNIT_Y,
		direction)
	local RANGE = 2.5

	local hits = director:probe(playerPeep:getLayerName(), function(peep)
		if peep == playerPeep then
			return false
		end

		local position = Utility.Peep.getAbsolutePosition(peep)
		local size = peep:getBehavior(SizeBehavior)
		if not size then
			return false
		else
			size = size.size
		end
	
		local min = position - Vector(size.x / 2, 0, size.z / 2)
		local max = position + Vector(size.x / 2, size.y, size.z / 2)


		local s, p = ray:hitBounds(min, max)
		return s and (p - ray.origin):getLength() <= RANGE
	end)

	local closest, closestDistance = nil, math.huge
	for i = 1, #hits do
		local position = Utility.Peep.getAbsolutePosition(hits[i])
		local distance = (ray.origin - position):getLength()
		if distance <= closestDistance then
			closest = hits[i]
			closestDistance = distance
		end
	end

	if closest then
		local actor = closest:getBehavior(ActorReferenceBehavior)
		if actor and actor.actor then
			local action = actor.actor:getActions('world')[1]
			actor.actor:poke(action.id, 'world')
		else
			local prop = closest:getBehavior(PropReferenceBehavior)
			if prop and prop.prop then
				local action = action or prop.prop:getActions('world')[1]
				prop.prop:poke(action.id, 'world')
			end
		end
	end
end

-- Moves the player to the specified position on the map via walking.
function Player:walk(i, j, k)
	local peep = self.actor:getPeep()
	return Utility.Peep.walk(peep, i, j, k, math.huge, { asCloseAsPossible = true })
end

return Player
