--------------------------------------------------------------------------------
-- Resources/Game/Maps/Rumbridge_LeafyLake_Cavern/Peep.lua
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

local Cavern = Class(Map)

function Cavern:new(resource, name, ...)
	Map.new(self, resource, name or 'Rumbridge_LeafyLake_Cavern', ...)
end

function Cavern:onLoad(filename, args, layer)
	Map.onLoad(self, filename, args, layer)

	local stage = self:getDirector():getGameInstance():getStage()
	stage:forecast(layer, 'Rumbridge_LeafyLake_Cavern_Drips', 'Rain', {
		wind = { 0, 0, 0 },
		heaviness = 1 / 32
	})
end

return Cavern
