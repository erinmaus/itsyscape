--------------------------------------------------------------------------------
-- Resources/Game/Peeps/Skelemental/Skelemental_IdleLogic.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Equipment = require "ItsyScape.Game.Equipment"
local EquipmentBehavior = require "ItsyScape.Peep.Behaviors.EquipmentBehavior"
local MappResourceBehavior = require "ItsyScape.Peep.Behaviors.MappResourceBehavior"
local Utility = require "ItsyScape.Game.Utility"

local Common = {}
function Common.probeForMetal(target)
	return function(peep)
		local gameDB = peep:getDirector():getGameDB()

		local equipment = peep:getBehavior(EquipmentBehavior)
		if equipment and equipment.equipment then
			equipment = equipment.equipment

			local broker = peep:getDirector():getItemBroker()
			for item in broker:iterateItems(equipment) do
				local resource = gameDB:getResource(item:getID(), "Item")
				local metal = gameDB:getRecord("ResourceCategory", { Key = "Metal", Resource = resource })
				if metal then
					metal = metal:get("Value")

					if metal and metal:lower() == target:lower() then
						return false
					end
				end
			end
		end

		local resource = peep:getBehavior(MappResourceBehavior)
		if resource and resource.resource then
			resource = resource.resource
			local tag = gameDB:getRecord("ResourceTag", { Value = "Undead", Resource = resource })
			if tag then
				return false
			end
		end

		return true
	end
end

return Common
