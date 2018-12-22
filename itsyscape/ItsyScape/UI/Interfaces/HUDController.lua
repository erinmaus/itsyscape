--------------------------------------------------------------------------------
-- ItsyScape/UI/Interfaces/HUDController.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Controller = require "ItsyScape.UI.Controller"

local HUDController = Class(Controller)
HUDController.OPEN_TIME = 0.5
HUDController.CLOSE_TIME = 0.5

function HUDController:new(peep, director)
	Controller.new(self, peep, director)

	self.isOpening = true
	self.isClosing = false
	self.time = 0
end

function HUDController:poke(actionID, actionIndex, e)
	if actionID == "close" then
		self.isOpening = false
		self.isClosing = true
	else
		Controller.poke(self, actionID, actionIndex, e)
	end
end

function HUDController:update(delta)
	if self.isOpening or self.isClosing then
		self.time = self.time + delta

		if self.isOpening and self.time >= self.OPEN_TIME then
			self.isOpening = false
			self.time = self.OPEN_TIME
		elseif self.isClosing and self.time >= self.CLOSE_TIME then
			self.isClosing = false
			self.time = self.CLOSE_TIME
			self:getGame():getUI():closeInstance(self)
		end
	end
end

function HUDController:pull()
	local delta
	if self.isOpening then
		delta = self.time / self.OPEN_TIME
	elseif self.isClosing then
		delta = 1 - self.time / self.CLOSE_TIME
	else
		delta = 1
	end

	return {
		state = {
			delta = delta,
			isOpening = self.isOpening,
			isClosing = self.isClosing
		}
	}
end

return HUDController
