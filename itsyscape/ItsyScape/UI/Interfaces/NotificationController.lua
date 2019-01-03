--------------------------------------------------------------------------------
-- ItsyScape/UI/NotificationController.lua
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

local NotificationController = Class(Controller)
NotificationController.TIMEOUT = 1.0
NotificationController.STEP = 0.5

function NotificationController:new(peep, director, constraints)
	Controller.new(self, peep, director)

	self.constraints = constraints or {}
	self.constraints.inputs = self.constraints.inputs or {}
	self.constraints.requirements = self.constraints.requirements or {}

	local count = #self.constraints.inputs + #self.constraints.requirements
	if count == 0 then
		self:getGame():getUI():closeInstance(self)
	end

	self.time = NotificationController.TIMEOUT + count * NotificationController.STEP
end

function NotificationController:pull()
	return self.constraints
end

function NotificationController:update(delta)
	Controller.update(self, delta)

	self.time = self.time - delta
	if self.time <= 0 then
		self:getGame():getUI():closeInstance(self)
	end
end

return NotificationController
