--------------------------------------------------------------------------------
-- ItsyScape/Mashina/Player/IsDisabled.lua
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

local IsDisabled = B.Node("IsDisabled")
IsDisabled.PLAYER = B.Reference()

function IsDisabled:update(mashina, state, executor)
	local player = state[self.PLAYER]

	if Utility.Peep.isDisabled(player) then
		return B.Status.Success
	end

	return B.Status.Failure
end

return IsDisabled
