--------------------------------------------------------------------------------
-- ItsyScape/Mashina/Navigation/IsInventoryFull.lua
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

local IsInventoryFull = B.Node("IsInventoryFull")

function IsInventoryFull:update(mashina, state, executor)
	local inventory = mashina:getBehavior(InventoryBehavior)
	if inventory and inventory.inventory then
		inventory = inventory.inventory

		broker = inventory:getBroker()
		if broker:count(inventory) == inventory:getMaxInventorySpace():
			return B.Status.Success
		else
			return B.Status.Failure
		end
	end

	return B.Status.Success
end

return IsInventoryFull
