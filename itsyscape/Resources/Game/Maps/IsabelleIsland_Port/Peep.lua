--------------------------------------------------------------------------------
-- Resources/Game/Maps/IsabelleIsland_Port/Peep.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Utility = require "ItsyScape.Game.Utility"
local Map = require "ItsyScape.Peep.Peeps.Map"

local Port = Class(Map)

function Port:new(resource, name, ...)
	Map.new(self, resource, name or 'IsabelleIsland_Port', ...)
end

return Port
