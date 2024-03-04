--------------------------------------------------------------------------------
-- ItsyScape/Mashina/Player/HasKeyItem.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local B = require "B"
local Utility = require "ItsyScape.Game.Utility"
local Peep = require "ItsyScape.Peep.Peep"
local InventoryBehavior = require "ItsyScape.Peep.Behaviors.InventoryBehavior"

local HasKeyItem = B.Node("HasKeyItem")
HasKeyItem.PLAYER = B.Reference()
HasKeyItem.KEY_ITEM = B.Reference()

function HasKeyItem:update(mashina, state, executor)
	local player = state[self.PLAYER]
	if not player then
		return B.Status.Failure
	end

	if player:getState():has("KeyItem", state[self.KEY_ITEM]) then
		return B.Status.Success
	end

	return B.Status.Failure
end

return HasKeyItem
