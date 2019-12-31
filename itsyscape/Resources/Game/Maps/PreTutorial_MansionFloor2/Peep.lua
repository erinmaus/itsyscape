--------------------------------------------------------------------------------
-- Resources/Game/Maps/PreTutorial_MansionFloor1/Peep.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Vector = require "ItsyScape.Common.Math.Vector"
local Utility = require "ItsyScape.Game.Utility"
local Map = require "ItsyScape.Peep.Peeps.Map"

local Mansion = Class(Map)
Mansion.MIN_LIGHTNING_PERIOD = 3
Mansion.MAX_LIGHTNING_PERIOD = 6
Mansion.LIGHTNING_TIME = 0.5
Mansion.MAX_AMBIENCE = 2

function Mansion:new(resource, name, ...)
	Map.new(self, resource, name or 'PreTutorial_MansionFloor1', ...)
end

function Mansion:onLoad(filename, args, layer)
	Map.onLoad(self, filename, args, layer)

	Utility.Map.spawnMap(self, "PreTutorial_MansionFloor1", Vector(0, -6.1, 0), { isLayer = true })
end

return Mansion
