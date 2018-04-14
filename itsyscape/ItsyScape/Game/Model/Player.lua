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

local Player = Class()

-- Constructs a new player.
function Player:new()
	-- Nothing.
end

-- Gets the Actor this Player is represented by.
function Player:getActor()
	return Class.ABSTRACT()
end

-- Moves the player to the specified position on the map.
function Player:moveTo(i, j)
	return Class.ABSTRACT()
end

return Player
