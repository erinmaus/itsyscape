--------------------------------------------------------------------------------
-- ItsyScape/UI/GenericNotificationController.lua
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

local GenericNotificationController = Class(Controller)
GenericNotificationController.TIMEOUT = 5.0

function GenericNotificationController:new(peep, director, message)
	Controller.new(self, peep, director)

	self.state = {
		message = message or "Lorem ipsum..."
	}

	self.time = GenericNotificationController.TIMEOUT

	local player = Utility.Peep.getPlayerModel(peep)
	player:pushMessage(nil, self.state.message)
end

function GenericNotificationController:pull()
	return self.state
end

function GenericNotificationController:update(delta)
	Controller.update(self, delta)

	self.time = self.time - delta
	if self.time <= 0 then
		self:getGame():getUI():closeInstance(self)
	end
end

return GenericNotificationController
