--------------------------------------------------------------------------------
-- ItsyScape/UI/Interfaces/PlayerConfigController.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Utility = require "ItsyScape.Game.Utility"
local Controller = require "ItsyScape.UI.Controller"

local PlayerConfigController = Class(Controller)

function PlayerConfigController:poke(actionID, actionIndex, e)
	if actionID == "quit" then
		self:quit(e)
	elseif actionID == "rate" then
		self:rate(e)
	else
		Controller.poke(self, actionID, actionIndex, e)
	end
end

function PlayerConfigController:quit(e)
	local playerModel = Utility.Peep.getPlayerModel(self:getPeep())

	playerModel:saveLocation()
	Utility.save(self:getPeep())
	playerModel:onLeave()
end

function PlayerConfigController:rate(e)
	if e.rating == true then
		Analytics:rateSession(self:getPeep(), "Thumbs Up")
	elseif e.rating == false then
		Analytics:rateSession(self:getPeep(), "Thumbs Down")
	else
		Analytics:rateSession(self:getPeep(), "Skip")
	end

	local playerStorage = Utility.Peep.getStorage(self:getPeep())
	local clockSection = playerStorage:getSection("clock")
	clockSection:set("survey", os.time())
end

function PlayerConfigController:pull()
	local playerStorage = Utility.Peep.getStorage(self:getPeep())
	local clockSection = playerStorage:getSection("clock")
	local lastSurveyTime = clockSection:get("survey") or (os.time() - Utility.Time.DAY)

	return {
		showSurvey = (os.time() - lastSurveyTime) >= Utility.Time.DAY
	}
end

return PlayerConfigController
