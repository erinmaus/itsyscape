--------------------------------------------------------------------------------
-- ItsyScape/Peep/Behaviors/ShipStatsBehavior.lua
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
local ShipStatsBehavior = Behavior("ShipStatsBehavior")

-- These are required.
ShipStatsBehavior.BASE_STATS = {
	"Health",
	"Distance",
	"Defense",
	"Speed",
	"Storage",

	-- Degrees the ship will turn per second.
	"Turn"
}

ShipStatsBehavior.STAT_HEALTH   = "Health"
ShipStatsBehavior.STAT_DISTANCE = "Distance"
ShipStatsBehavior.STAT_DEFENSE  = "Defense"
ShipStatsBehavior.STAT_SPEED    = "Speed"
ShipStatsBehavior.STAT_STORAGE  = "Storage"
ShipStatsBehavior.STAT_TURN     = "Turn"

-- These are optional, for example merchant ships.
ShipStatsBehavior.EXTRA_STATS = {
	"OffenseRange",
	"OffenseMinDamage",
	"OffenseMaxDamage"
}

-- Constructs a ShipStatsBehavior.
--
-- 'bonuses' is a table of bonuses (see BASE_STATS and EXTRA_STATS).
-- All values default to zero.
function ShipStatsBehavior:new()
	Behavior.Type.new(self)

	self.bonuses = {}
	for i = 1, #ShipStatsBehavior.BASE_STATS do
		local stat = ShipStatsBehavior.BASE_STATS[i]
		self.bonuses[stat] = 0
	end
end

return ShipStatsBehavior
