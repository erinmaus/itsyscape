--------------------------------------------------------------------------------
-- ItsyScape/Mashina/Player/IsInterfaceOpen.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local B = require "B"
local Utility = require "ItsyScape.Game.Utility"

local IsInterfaceOpen = B.Node("IsInterfaceOpen")
IsInterfaceOpen.INTERFACE = B.Reference()
IsInterfaceOpen.INDEX = B.Reference()
IsInterfaceOpen.PLAYER = B.Reference()

function IsInterfaceOpen:update(mashina, state, executor)
	local player = state[self.PLAYER]
	if not player then
		return B.Status.Failure
	end

	if Utility.UI.isOpen(player, state[self.INTERFACE], state[self.INDEX]) then
		return B.Status.Success
	end

	return B.Status.Failure
end

return IsInterfaceOpen
