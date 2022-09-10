--------------------------------------------------------------------------------
-- ItsyScape/Peep/Behaviors/InstancedInventoryBehavior.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

local Vector = require "ItsyScape.Common.Math.Vector"
local Behavior = require "ItsyScape.Peep.Behavior"

-- Specifies the position of a Peep.
local InstancedInventoryBehavior = Behavior("InstancedInventory")

-- Constructs a InstancedInventoryBehavior.
--
-- 'inventory' should be a map of playerID -> inventory.
function InstancedInventoryBehavior:new()
	Behavior.Type.new(self)

	self.inventory = {}
end

function InstancedInventoryBehavior:unload(peep)
	local broker = peep:getDirector():getItemBroker()

	for _, inventory in pairs(self.inventory) do
		if inventory then
			broker:removeProvider(inventory)
		end
	end
end

return InstancedInventoryBehavior
