--------------------------------------------------------------------------------
-- Resources/Game/Maps/Ship_IsabelleIsland_Pirate/Peep.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Utility = require "ItsyScape.Game.Utility"
local Sailing = require "ItsyScape.Game.Skills.Sailing"
local ShipMapPeep = require "Resources.Game.Peeps.Maps.ShipMapPeep"
local ShipStatsBehavior = require "ItsyScape.Peep.Behaviors.ShipStatsBehavior"

local Ship = Class(ShipMapPeep)
Ship.MAX_PIRATES = 4

function Ship:new(resource, name, ...)
	ShipMapPeep.new(self, resource, name or 'Ship_IsabelleIsland_Pirate', ...)
end

function Ship:onLoad(...)
	ShipMapPeep.onLoad(self, ...)

	local behavior = self:getBehavior(ShipStatsBehavior)
	behavior.bonuses[ShipStatsBehavior.STAT_SPEED] = 500
	behavior.bonuses[ShipStatsBehavior.STAT_TURN]  = 90

	if self:getArguments().spawnRaven then
		local raven = Utility.spawnMapObjectAtAnchor(self, "CapnRaven", "Anchor_CapnRaven_Spawn")
		Sailing.setCaptain(self, raven:getPeep())

		for i = 1, self.MAX_PIRATES do
			local anchor = string.format("Anchor_Pirate%d", i)
			local pirate = Utility.spawnMapObjectAtAnchor(self, "Pirate", anchor)
			Sailing.setCrewMember(self, pirate:getPeep())
		end
	end
end

function Ship:getMaxHealth()
	return 200
end

return Ship
