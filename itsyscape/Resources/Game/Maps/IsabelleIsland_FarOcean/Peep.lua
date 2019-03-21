--------------------------------------------------------------------------------
-- Resources/Game/Maps/IsabelleIsland_FarOcean/Peep.lua
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
local PositionBehavior = require "ItsyScape.Peep.Behaviors.PositionBehavior"

local FarOcean = Class(Map)

function FarOcean:new(resource, name, ...)
	Map.new(self, resource, name or 'IsabelleIsland_FarOcean', ...)
end

function FarOcean:onLoad(filename, args, layer)
	Map.onLoad(self, filename, args, layer)

	Utility.Map.spawnShip(
		self,
		"Ship_IsabelleIsland_Pirate",
		layer,
		16, 8,
		2.25)

	local stage = self:getDirector():getGameInstance():getStage()
	stage:forecast(layer, 'IsabelleIsland_FarOcean_HeavyRain', 'Rain', {
		wind = { -15, 0, 0 },
		heaviness = 0.25
	})
end

return FarOcean
