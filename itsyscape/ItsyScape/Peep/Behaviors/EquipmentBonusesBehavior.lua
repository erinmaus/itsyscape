--------------------------------------------------------------------------------
-- ItsyScape/Peep/Behaviors/EquipmentBonusesBehavior.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

local Vector = require "ItsyScape.Common.Math.Vector"
local Behavior = require "ItsyScape.Peep.Behavior"
local EquipmentInventoryProvider = require "ItsyScape.Game.EquipmentInventoryProvider"

-- Specifies equipment bonuses directly.
local EquipmentBonusesBehavior = Behavior("EquipmentBonusesBehavior")

-- Constructs a EquipmentBonusesBehavior.
--
-- 'bonuses' is a table of bonuses (see Equipment meta or EquipmentInventoryProvider.STATS).
-- All values default to zero.
function EquipmentBonusesBehavior:new()
	Behavior.Type.new(self)

	self.bonuses = {}
	for i = 1, #EquipmentInventoryProvider.STATS do
		local stat = EquipmentInventoryProvider.STATS[i]
		self.bonuses[stat] = 0
	end
end

return EquipmentBonusesBehavior
