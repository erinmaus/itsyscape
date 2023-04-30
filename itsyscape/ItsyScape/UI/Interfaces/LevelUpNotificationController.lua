--------------------------------------------------------------------------------
-- ItsyScape/UI/LevelUpNotificationController.lua
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

local LevelUpNotificationController = Class(Controller)
LevelUpNotificationController.TIMEOUT = 5

function LevelUpNotificationController:new(peep, director, skill)
	Controller.new(self, peep, director)

	self.state = {
		skill = skill:getName(),
		level = skill:getBaseLevel()
	}

	self.time = LevelUpNotificationController.TIMEOUT
end

function LevelUpNotificationController:poke(actionID, actionIndex, e)
	if actionID == "open" then
		self:openSkillGuide()
	else
		Controller.poke(self, actionID, actionIndex, e)
	end
end

function LevelUpNotificationController:openSkillGuide()
	self:getGame():getUI():interrupt(self:getPeep())
	self:getGame():getUI():openBlockingInterface(
		self:getPeep(),
		"SkillGuide",
		self.state.skill)
end

function LevelUpNotificationController:pull()
	return self.state
end

function LevelUpNotificationController:update(delta)
	Controller.update(self, delta)

	self.time = self.time - delta
	if self.time <= 0 then
		self:getGame():getUI():closeInstance(self)
	end
end

return LevelUpNotificationController
