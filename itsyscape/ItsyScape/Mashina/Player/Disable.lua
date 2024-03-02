--------------------------------------------------------------------------------
-- ItsyScape/Mashina/Player/Disable.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local B = require "B"
local Utility = require "ItsyScape.Game.Utility"
local DisabledBehavior = require "ItsyScape.Peep.Behaviors.DisabledBehavior"

local Disable = B.Node("Disable")
Disable.PLAYER = B.Reference()

function Disable:update(mashina, state, executor)
	local player = state[self.PLAYER]
	player:addBehavior(DisabledBehavior)

	return B.Status.Success
end

return Disable
