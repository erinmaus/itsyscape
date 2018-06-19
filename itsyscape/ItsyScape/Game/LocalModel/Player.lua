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
local Player = require "ItsyScape.Game.Model.Player"
local PositionBehavior = require "ItsyScape.Peep.Behaviors.PositionBehavior"
local CombatTargetBehavior = require "ItsyScape.Peep.Behaviors.CombatTargetBehavior"
local MapPathFinder = require "ItsyScape.World.MapPathFinder"
local ExecutePathCommand = require "ItsyScape.World.ExecutePathCommand"

local Player = Class()

-- Constructs a new player.
--
-- The Actor isn't created until Player.spawn is called.
function Player:new(game)
	self.game = game
	self.actor = false
end

function Player:spawn()
	local stage = self.game:getStage()
	local success, actor = stage:spawnActor("Resources.Game.Peeps.Player.One")
	if success then
		self.actor = actor
	else
		self.actor = false
	end
end

-- Gets the Actor this Player is represented by.
function Player:getActor()
	return self.actor
end

function Player:findPath(i, j, k)
	local peep = self.actor:getPeep()
	local position = peep:getBehavior(PositionBehavior).position
	local map = self.game:getStage():getMap(k)
	local _, playerI, playerJ = map:getTileAt(position.x, position.z)
	local pathFinder = MapPathFinder(map)
	return pathFinder:find(
		{ i = playerI, j = playerJ },
		{ i = i, j = j },
		true)
end

-- Moves the player to the specified position on the map via walking.
function Player:walk(i, j, k)
	local peep = self.actor:getPeep()
	local path = self:findPath(i, j, k)
	if path then
		local queue = self.actor:getPeep():getCommandQueue()
		if queue:interrupt(ExecutePathCommand(path)) then
			-- TODO: move this somewhere else; some univer sal "interrupt player"
			--       function...
			peep:removeBehavior(CombatTargetBehavior)

			return true
		else
			return false
		end
	else
		return false
	end
end

return Player
