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
local Quaternion = require "ItsyScape.Common.Math.Quaternion"
local Utility = require "ItsyScape.Game.Utility"
local Probe = require "ItsyScape.Peep.Probe"
local Map = require "ItsyScape.Peep.Peeps.Map"
local RotationBehavior = require "ItsyScape.Peep.Behaviors.RotationBehavior"
local PositionBehavior = require "ItsyScape.Peep.Behaviors.PositionBehavior"

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

	local _, ship = Utility.Map.spawnMap(self, "Ship_IsabelleIsland_Pirate", Vector(12, 0, 48))
	local rotation = ship:getBehavior(RotationBehavior)
	rotation.rotation = Quaternion.Y_90
	local position = ship:getBehavior(PositionBehavior)
	position.offset = Vector(0, 2, 0)
end

return Mansion
