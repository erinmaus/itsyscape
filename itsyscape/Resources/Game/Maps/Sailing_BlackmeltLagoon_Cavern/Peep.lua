--------------------------------------------------------------------------------
-- Resources/Game/Maps/Sailing_BlackmeltLagoon_Cavern/Peep.lua
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
local Probe = require "ItsyScape.Peep.Probe"
local InventoryBehavior = require "ItsyScape.Peep.Behaviors.InventoryBehavior"

local BlackmeltLagoonCavern = Class(Map)

function BlackmeltLagoonCavern:new(resource, name, ...)
	Map.new(self, resource, name or 'Sailing_BlackmeltLagoon_Cavern', ...)
end

function BlackmeltLagoonCavern:spawnLoot(chestName, dropTableName, count)
	local director = self:getDirector()
	local itemBroker = director:getItemBroker()
	local gameDB = director:getGameDB()

	local chest = director:probe(self:getLayerName(), Probe.namedMapObject(chestName))[1]
	if chest then
		local chestInventory = chest:getBehavior(InventoryBehavior)
		local chestInventoryCount = itemBroker:count(chestInventory.inventory)

		if chestInventoryCount > 0 then
			Log.info("Chest '%s' already has reward.", chestName)
		else
			chest:poke('materialize', {
				count = count,
				dropTable = gameDB:getResource(dropTableName, "DropTable"),
				peep = Utility.Peep.getPlayer(self),
				chest = chest
			})

			Log.info("Materialized chest '%s' rewards.", chestName)
		end
	else
		Log.warn("No chest '%s' found in map.", chestName)
	end
end

function BlackmeltLagoonCavern:onLoad(filename, args, layer)
	Map.onLoad(self, filename, args, layer)

	local stage = self:getDirector():getGameInstance():getStage()
	stage:forecast(layer, 'Sailing_BlackmeltLagoon_Cavern_Ash', 'Fungal', {
		gravity = { 0, -0.5, 0 },
		wind = { -1, -1, 0 },
		colors = {
			{ 0.1, 0.1, 0.1, 1.0 },
			{ 1.0, 0.1, 0.1, 1.0 }
		},
		minHeight = 20,
		maxHeight = 25,
		heaviness = 0.25
	})

	self:spawnLoot("Chest_Legendary", "Sailing_BlackmeltLagoon_Cavern_Chest_Legendary", 1)
	self:spawnLoot("Chest_Gems", "Sailing_BlackmeltLagoon_Cavern_Chest_Gems", 10)
	self:spawnLoot("Chest_Gold", "Sailing_BlackmeltLagoon_Cavern_Chest_Gold", 20)
end

return BlackmeltLagoonCavern
