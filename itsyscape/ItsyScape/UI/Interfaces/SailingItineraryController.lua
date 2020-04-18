--------------------------------------------------------------------------------
-- ItsyScape/UI/SailingItineraryController.lua
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
local Controller = require "ItsyScape.UI.Controller"

local SailingItineraryController = Class(Controller)

function SailingItineraryController:new(peep, director)
	Controller.new(self, peep, director)

	self.itineraryStorage = Sailing.Itinerary.getStorage(peep)
end

function SailingItineraryController:poke(actionID, actionIndex, e)
	if actionID == "discard" then
		self:discard(e)
	elseif actionID == "sail" then
		self:sail(e)
	elseif actionID == "save" then
		self:save(e)
	else
		Controller.poke(self, actionID, actionIndex, e)
	end
end

function SailingItineraryController:discard()
	while self.itineraryStorage:length() > 1 do
		self.itineraryStorage:removeSection(self.itineraryStorage:length())
	end
end

function SailingItineraryController:save()
	local map = Utility.Peep.getMapScript(self:getPeep())
	map:poke('save')
end

function SailingItineraryController:sail()
	local map = Utility.Peep.getMapScript(self:getPeep())
	map:poke('sail')
end

function SailingItineraryController:pull()
	local state = {
		destinations = self.itineraryStorage:get(),
		canSail = Sailing.Itinerary.isReadyToSail(self:getPeep())
	}

	return state
end

return SailingItineraryController
