--------------------------------------------------------------------------------
-- ItsyScape/UI/Interfaces/DramaticTextController.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Controller = require "ItsyScape.UI.Controller"

local DramaticTextController = Class(Controller)
DramaticTextController.CANVAS_WIDTH = 1920
DramaticTextController.CANVAS_HEIGHT = 1080

function DramaticTextController:new(peep, director, lines, duration)
	Controller.new(self, peep, director)

	duration = duration or math.huge
	self.state = { lines = lines, maxDuration = duration, currentDuration = duration }
end

function DramaticTextController:poke(actionID, actionIndex, e)
	Controller.poke(self, actionID, actionIndex, e)
end

function DramaticTextController:pull()
	return self.state
end

function DramaticTextController:update(delta)
	if self.state.maxDuration ~= math.huge then
		self.state.currentDuration = self.state.currentDuration - delta

		if self.state.currentDuration < 0 then
			self:getGame():getUI():closeInstance(self)
		end
	end
end

return DramaticTextController
