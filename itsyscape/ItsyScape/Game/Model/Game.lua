--------------------------------------------------------------------------------
-- ItsyScape/Game/Model/Game.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Callback = require "ItsyScape.Common.Callback"

-- Represents a high-level view of the Game.
--
-- The operations must be implemented for the various cases. For example:
--  * LocalGame: Runs completely on the client. No networking. Simulates
--    the game.
--  * ClientGame: Receives data from a server. Does not simulate the game.
--  * ServerGame: Sends data to a client. Simulates the game.
local Game = Class()

function Game:new()
	self.onQuit = Callback()
	self.onLeave = Callback()
	self.onPlayerSpawned = Callback()
	self.onPlayerPoofed = Callback()
	self.onReady = Callback()
end

-- Gets the GameDB.
function Game:getGameDB()
	return Class.ABSTRACT()
end

-- Returns the player.
--
-- The player is an implementation of ItsyScape.Game.Model.Player. This value
-- should be created by the Game object.
function Game:getPlayer()
	return Class.ABSTRACT()
end

-- Returns the stage.
--
-- The stage is an implementation ot ItsyScape.Game.Model.Stage. This value
-- should be created by the Game object.
function Game:getStage()
	return Class.ABSTRACT()
end

-- Returns the UI.
--
-- The ui is an implementation ot ItsyScape.Game.Model.UI. This value
-- should be created by the Game object.
function Game:getUI()
	return Class.ABSTRACT()
end

-- Gets the tick rate of the world, in ticks-per-second.
--
-- For example, at a tick rate of 10 per second, this method returns 10. For
-- the value of ticks in seconds, see Game.getDelta.
function Game:getTicks()
	return Class.ABSTRACT()
end

-- Gets the delta. This is the time between a tick.
--
-- This value is the same as 1.0 / self:getTicks().
function Game:getDelta()
	local ticks = self:getTicks()
	if ticks then
		return 1.0 / ticks
	else
		return nil
	end
end

-- Gets the current tick since the beginning of the game instance.
--
-- This value should never go down. For every update or tick call, this value
-- should increase by one.
function Game:getCurrentTick()
	return Class.ABSTRACT()
end

return Game
