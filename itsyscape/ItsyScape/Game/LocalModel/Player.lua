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
local Utility = require "ItsyScape.Game.Utility"
local Player = require "ItsyScape.Game.Model.Player"
local PlayerBehavior = require "ItsyScape.Peep.Behaviors.PlayerBehavior"
local PositionBehavior = require "ItsyScape.Peep.Behaviors.PositionBehavior"
local CombatTargetBehavior = require "ItsyScape.Peep.Behaviors.CombatTargetBehavior"
local CombatCortex = require "ItsyScape.Peep.Cortexes.CombatCortex"
local MapPathFinder = require "ItsyScape.World.MapPathFinder"
local ExecutePathCommand = require "ItsyScape.World.ExecutePathCommand"

local Player = Class()

-- Constructs a new player.
--
-- The Actor isn't created until Player.spawn is called.
function Player:new(game, stage)
	self.game = game
	self.stage = stage
	self.actor = false
end

function Player:spawn()
	local success, actor = self.stage:spawnActor("Resources.Game.Peeps.Player.One")
	if success then
		self.actor = actor
		actor:getPeep():addBehavior(PlayerBehavior)

		local p = actor:getPeep():getBehavior(PlayerBehavior)
		p.id = 1

		actor:getPeep():listen('finalize', function()
			local storage = self.game:getDirector():getPlayerStorage(game):getRoot()
			if storage:hasSection("Location") then
				local location = storage:getSection("Location")
				if location:get("name") then
					self.stage:movePeep(
						actor:getPeep(),
						location:get("name"),
						Vector(
							location:get("x"),
							location:get("y"),
							location:get("z")))
				else
					self.stage:movePeep(
						actor:getPeep(),
						"IsabelleIsland_Tower",
						"Anchor_StartGame")
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
	return peep:getCommandQueue(CombatCortex.QUEUE):getIsPending() or peep:hasBehavior(CombatTargetBehavior)
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

-- Moves the player to the specified position on the map via walking.
function Player:walk(i, j, k)
	local peep = self.actor:getPeep()
	return Utility.Peep.walk(peep, i, j, k, math.huge, { asCloseAsPossible = true })
end

return Player
