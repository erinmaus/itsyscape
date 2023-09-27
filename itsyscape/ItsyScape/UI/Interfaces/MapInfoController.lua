--------------------------------------------------------------------------------
-- ItsyScape/UI/Interfaces/MapInfoController.lua
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

local MapInfoController = Class(Controller)
MapInfoController.TIME = 5

function MapInfoController:new(peep, director, mapResource)
	Controller.new(self, peep, director)

	time = math.max(time or 3, 1)
	self.state = {
		time = MapInfoController.TIME,
		title = Utility.getName(mapResource, self:getDirector():getGameDB()),
		description = Utility.getDescription(mapResource, self:getDirector():getGameDB())
	}

	self.time = MapInfoController.TIME
end

function MapInfoController:poke(actionID, actionIndex, e)
	Controller.poke(self, actionID, actionIndex, e)
end

function MapInfoController:pull()
	return self.state
end

function MapInfoController:update(delta)
	local time = self.time - delta
	if time < -1 then
		self:getGame():getUI():closeInstance(self)
	end

	self.time = math.max(time, -1)
end

return MapInfoController
