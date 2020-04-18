--------------------------------------------------------------------------------
-- Resources/Game/Actions/Sail.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Utility = require "ItsyScape.Game.Utility"
local Sailing = require "ItsyScape.Game.Skills.Sailing"
local Action = require "ItsyScape.Peep.Action"
local BasicMapAnchor = require "Resources.Game.Peeps.Props.BasicSailingMapAnchor"

local Sail = Class(Action)
Sail.SCOPES = { ['world'] = true, ['world-pvm'] = true, ['world-pvp'] = true }

function Sail:perform(state, peep, prop)
	local isMapAnchor = prop:isCompatibleType(BasicMapAnchor)
	if not isMapAnchor then
		return false
	end

	if not self:canPerform(state, peep) then
		return false
	end

	local game = peep:getDirector():getGameInstance()
	local gameDB = peep:getDirector():getGameDB()

	if Sailing.Itinerary.isReadyToSail(peep) then
		local message = gameDB:getResource("Message_Sailing_IsDone", "KeyItem")
		local requirements = { Utility.getActionConstraintResource(game, message) }

		Utility.UI.openInterface(peep, "Notification", false, { requirements = requirements })
		return true
	end

	local _, currentLocation = Sailing.Itinerary.getLastDestination(peep)
	local targetLocation = prop:getMapLocation()

	local currentResource = currentLocation:get("Resource")
	local targetResource = targetLocation:get("Resource")
	if currentResource.id.value == targetResource.id.value then
		local message = gameDB:getResource("Message_Sailing_SameDestination", "KeyItem")
		local requirements = { Utility.getActionConstraintResource(game, message) }

		Utility.UI.openInterface(peep, "Notification", false, { requirements = requirements })
		return true
	end

	local distance = Sailing.getDistanceBetweenLocations(currentLocation, targetLocation)
	local shipStats = Sailing.Ship.getStats(peep)
	if distance > shipStats["Distance"] then
		local message = gameDB:getResource("Message_Sailing_DistanceTooFar", "KeyItem")
		local requirements = { Utility.getActionConstraintResource(game, message) }

		Utility.UI.openInterface(peep, "Notification", false, { requirements = requirements })
		return true
	end

	Sailing.Itinerary.addDestination(peep, targetLocation)
	return true
end

return Sail
