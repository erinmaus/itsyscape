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
	self.state = { lines = lines, maxDuration = duration, time = love.timer.getTime() }
end

function DramaticTextController:poke(actionID, actionIndex, e)
	if actionID == "close" then
		self:getGame():getUI():closeInstance(self)
	else
		Controller.poke(self, actionID, actionIndex, e)
	end
end

function DramaticTextController:pull()
	return self.state
end

return DramaticTextController
