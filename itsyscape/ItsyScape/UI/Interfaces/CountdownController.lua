--------------------------------------------------------------------------------
-- ItsyScape/UI/Interfaces/CountdownController.lua
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

local CountdownController = Class(Controller)

function CountdownController:new(peep, director, time, finishCallback, message)
	Controller.new(self, peep, director)

	time = math.max(time or 3, 1)
	self.state = {
		totalTime = time,
		time = time,
		message = message
	}

	self.finishCallback = finishCallback or function() end
	self.finished = false
end

function CountdownController:poke(actionID, actionIndex, e)
	Controller.poke(self, actionID, actionIndex, e)
end

function CountdownController:pull()
	return self.state
end

function CountdownController:update(delta)
	local time = self.state.time - delta
	if time < 0 and not self.finished then
		self.finishCallback()
		self.finished = true
	end

	if time < -1 then
		self:getGame():getUI():closeInstance(self)
	end

	self.state.time = math.max(time, -1)
end

return CountdownController
