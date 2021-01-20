--------------------------------------------------------------------------------
-- ItsyScape/Game/Model/Player.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Callback = require "ItsyScape.Common.Callback"

local Player = Class()

-- Constructs a new player.
function Player:new()
	self.onChangeCamera = Callback()
end

-- Gets the Actor this Player is represented by.
function Player:getActor()
	return Class.ABSTRACT()
end

-- Disengages from combat.
function Player:flee()
	return Class.ABSTRACT()
end

-- Returns true if the player is in combat, false otherwise.
function Player:getIsEngaged()
	return Class.ABSTRACT()
end

-- Returns the Actor that is the combat target of the player, false otherwise.
function Player:getTarget()
	return Class.ABSTRACT()
end

-- Moves the player to the specified position on the map via walking.
function Player:walk(i, j, k)
	return Class.ABSTRACT()
end

return Player
