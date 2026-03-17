--------------------------------------------------------------------------------
-- ItsyScape/Game/Utility/Peep/Equipment.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local PlayerEquipmentStateProvider = require "ItsyScape.Game.PlayerEquipmentStateProvider"
local Utility = require "ItsyScape.Game.Utility"
local EquipmentBehavior = require "ItsyScape.Peep.Behaviors.EquipmentBehavior"

local Equipment = {}
function Equipment:reload(skipSerialize)
	local director = self:getDirector()
	local equipment = self:getBehavior(EquipmentBehavior)
	director:getItemBroker():removeProvider(equipment.equipment, skipSerialize)
	director:getItemBroker():addProvider(equipment.equipment)
end

function Equipment:onAssign(director)
	local equipment = self:getBehavior(EquipmentBehavior)
	director:getItemBroker():addProvider(equipment.equipment)

	self:getState():addProvider("Item", PlayerEquipmentStateProvider(self))
end

function Equipment:onReady(director)
	local broker = director:getItemBroker()
	local function equipItems(records)
		local equipment = self:getBehavior(EquipmentBehavior)
		if equipment and equipment.equipment then
			equipment = equipment.equipment
			for i = 1, #records do
				local record = records[i]
				local item = record:get("Item")
				local count = record:get("Count") or 1

				local transaction = broker:createTransaction()
				transaction:addParty(equipment)
				transaction:spawn(equipment, item.name, count, false)
				local s, r = transaction:commit()
				if not s then
					Log.error("Failed to equip item: %s", r)
				end
			end
		end
	end
	
	local gameDB = director:getGameDB()
	local resource = Utility.Peep.getResource(self)
	local mapObject = Utility.Peep.getMapObject(self)

	if resource then
		equipItems(gameDB:getRecords("PeepEquipmentItem", { Resource = resource }))
	end

	if mapObject then
		equipItems(gameDB:getRecords("PeepEquipmentItem", { Resource = mapObject }))
	end
end

return Equipment
