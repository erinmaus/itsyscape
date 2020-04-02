--------------------------------------------------------------------------------
-- Resources/Game/Peeps/Maps/BasicMapTable.lua
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

local MapTable = Class(Map)

function MapTable:new(resource, name, ...)
	Map.new(self, resource, name or 'BasicMapTable', ...)
end

function MapTable:onLoad(filename, arguments, layer)
	Map.onLoad(self, filename, arguments, layer)

	local gameDB = self:getDirector():getGameDB()
	local seaChart = gameDB:getRecord("MapSeaChart", {
		Map = Utility.Peep.getMapResource(self)
	})

	local playerAnchor = arguments.playerAnchor or "Port_Rumbridge"

	if seaChart then
		local map = Utility.Peep.getMap(self)

		local sailingMapLocations = gameDB:getRecords("SailingMapLocation", {
			SeaChart = seaChart:get("SeaChart")
		})

		local playerMapLocation = gameDB:getRecord("SailingMapLocation", {
			SeaChart = seaChart:get("SeaChart"),
			Resource = gameDB:getResource(playerAnchor, "SailingMapAnchor")
		})

		for i = 1, #sailingMapLocations do
			local sailingMapLocation = sailingMapLocations[i]

			local tileCenter = map:getTileCenter(
				sailingMapLocation:get("AnchorI"),
				sailingMapLocation:get("AnchorJ"))
			local prop = Utility.spawnPropAtPosition(
				self,
				"Sailing_MapAnchor_Default",
				tileCenter.x,
				tileCenter.y,
				tileCenter.z,
				0)
			if prop then
				prop:getPeep():listen('finalize', function(peep)
					peep:poke('assignMapLocation', sailingMapLocation, playerMapLocation)
				end)
			else
				Log.warn("Couldn't spawn map anchor prop for location '%s'.", sailingMapLocations[i]:get("Resource").name)
			end
		end
	end
end

return MapTable
