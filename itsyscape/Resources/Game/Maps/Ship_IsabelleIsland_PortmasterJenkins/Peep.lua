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

function Ship:new(resource, name, ...)
	Map.new(self, resource, name or 'Ship_IsabelleIsland_PortmasterJenkins', ...)
end

function Ship:getMaxHealth()
	return 150
end

return Ship
