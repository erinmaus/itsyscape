--------------------------------------------------------------------------------
-- ItsyScape/UI/QuestCompleteNotificationController.lua
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

local QuestCompleteNotificationController = Class(Controller)
QuestCompleteNotificationController.TIMEOUT = 4.0

function QuestCompleteNotificationController:new(peep, director, quest)
	Controller.new(self, peep, director)

	self.state = {
		quest = Utility.getName(quest, peep:getDirector():getGameDB())
	}

	self.time = QuestCompleteNotificationController.TIMEOUT
end

function QuestCompleteNotificationController:pull()
	return self.state
end

function QuestCompleteNotificationController:update(delta)
	Controller.update(self, delta)

	self.time = self.time - delta
	if self.time <= 0 then
		self:getGame():getUI():closeInstance(self)
	end
end

return QuestCompleteNotificationController
