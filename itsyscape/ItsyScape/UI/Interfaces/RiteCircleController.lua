--------------------------------------------------------------------------------
-- ItsyScape/UI/Interfaces/RiteCircleController.lua
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

local RiteCircleController = Class(Controller)

function RiteCircleController:new(peep, director, power)
	Controller.new(self, peep, director)

	self.state = {
		resource = power:getResource().name,
		name = Utility.getName(power:getResource(), self:getDirector():getGameDB()),
		description = Utility.getDescription(power:getResource(), self:getDirector():getGameDB())
	}
end

function RiteCircleController:updateTime()
	local playerStorage = self:getDirector():getPlayerStorage(self:getPeep())
	local rootStorage = playerStorage:getRoot()

	self.state.time = Utility.Time.getAndUpdateTime(rootStorage)
end

function RiteCircleController:poke(actionID, actionIndex, e)
	if actionID == "close" then
		self:getGame():getUI():closeInstance(self)
	else
		Controller.poke(self, actionID, actionIndex, e)
	end
end

function RiteCircleController:pull()
	self:updateTime()

	return {
		resource = self.state.resource,
		name = self.state.name,
		description = self.state.description,
		time = self.state.time
	}
end

return RiteCircleController
