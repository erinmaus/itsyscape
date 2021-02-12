--------------------------------------------------------------------------------
-- ItsyScape/Mashina/Peep/GetPlayer.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local B = require "B"
local Utility = require "ItsyScape.Game.Utility"

local GetPlayer = B.Node("GetPlayer")
GetPlayer.PLAYER = B.Reference()

function GetPlayer:update(mashina, state, executor)
	state[self.PLAYER] = Utility.Peep.getPlayer(mashina)
	return B.Status.Success
end

return GetPlayer
