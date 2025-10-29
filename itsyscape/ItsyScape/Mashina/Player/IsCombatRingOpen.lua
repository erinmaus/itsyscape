--------------------------------------------------------------------------------
-- ItsyScape/Mashina/Player/IsCombatRingOpen.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local B = require "B"
local Utility = require "ItsyScape.Game.Utility"

local IsCombatRingOpen = B.Node("IsCombatRingOpen")
IsCombatRingOpen.PLAYER = B.Reference()

function IsCombatRingOpen:update(mashina, state, executor)
	local player = state[self.PLAYER]
	if not player then
		return B.Status.Failure
	end

	local ring = Utility.UI.getOpenInterface(player, "GamepadCombatHUD")
	if not (ring and ring:getIsOpen()) then
		return B.Status.Failure
	end

	return B.Status.Success
end

return IsCombatRingOpen
