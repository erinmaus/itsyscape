--------------------------------------------------------------------------------
-- Resources/Game/Maps/Ship_IsabelleIsland_PortmasterJenkins/Peep.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Utility = require "ItsyScape.Game.Utility"
local Map = require "Resources.Game.Peeps.Maps.ShipMapPeep"

local Ship = Class(Map)
Ship.STATE_SQUID   = 0
Ship.STATE_PIRATES = 1

function Ship:new(resource, name, ...)
	Map.new(self, resource, name or 'Ship_IsabelleIsland_PortmasterJenkins', ...)
end

function Ship:getMaxHealth()
	return 150
end

function Ship:onLoad(filename, arguments, layer)
	Map.onLoad(self, filename, arguments, layer)

	local state = tonumber(arguments['jenkins_state'] or Ship.STATE_SQUID)
	if state == Ship.STATE_SQUID then
		Utility.spawnMapObjectAtAnchor(
			self,
			"Jenkins_Squid",
			"Anchor_Jenkins_Squid_Spawn")
		Utility.spawnMapObjectAtAnchor(
			self,
			"Sailor1",
			"Anchor_Sailor1_Spawn")
		Utility.spawnMapObjectAtAnchor(
			self,
			"Sailor2",
			"Anchor_Sailor2_Spawn")
	else

	end
end

return Ship
