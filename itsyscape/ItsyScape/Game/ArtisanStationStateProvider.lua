--------------------------------------------------------------------------------
-- ItsyScape/Game/ArtisanStationStateProvider.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local State = require "ItsyScape.Game.State"
local StateProvider = require "ItsyScape.Game.StateProvider"
local ActiveArtisanStationBehavior = require "ItsyScape.Peep.Behaviors.ActiveArtisanStationBehavior"

local ArtisanStationStateProvider = Class(StateProvider)

function ArtisanStationStateProvider:new(peep)
	self.peep = peep
end

function ArtisanStationStateProvider:getActiveArtisanStation()
	local activeArtisanStation = self.peep:getBehavior(ActiveArtisanStationBehavior)
	return activeArtisanStation and activeArtisanStation.target
end

function ArtisanStationStateProvider:getPriority()
	return State.PRIORITY_IMMEDIATE
end

function ArtisanStationStateProvider:has(name, count, flags)
	return count <= self:count(name, flags)
end

function ArtisanStationStateProvider:take(name, count, flags)
	return false
end

function ArtisanStationStateProvider:give(name, count, flags)
	return false
end

function ArtisanStationStateProvider:count(name, flags)
	local selfCount = Utility.Artisan.countProperty(self, name)
	local stationCount = Utility.Artisan.countProperty(self:getActiveArtisanStation(), name)

	return (selfCount == math.huge or stationCount == math.huge) and math.huge or (selfCount + stationCount)
end

return ArtisanStationStateProvider
