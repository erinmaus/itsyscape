--------------------------------------------------------------------------------
-- ItsyScape/Mashina/Player/IsEnabled.lua
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

local IsEnabled = B.Node("IsEnabled")
IsEnabled.PLAYER = B.Reference()

function IsEnabled:update(mashina, state, executor)
	local player = state[self.PLAYER]

	if Utility.Peep.isEnabled(player) then
		return B.Status.Success
	end

	return B.Status.Failure
end

return IsEnabled
