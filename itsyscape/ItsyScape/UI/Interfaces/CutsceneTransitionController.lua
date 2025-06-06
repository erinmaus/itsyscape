--------------------------------------------------------------------------------
-- ItsyScape/UI/Interfaces/CutsceneTransitionController.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Callback = require "ItsyScape.Common.Callback"
local Class = require "ItsyScape.Common.Class"
local Controller = require "ItsyScape.UI.Controller"

local CutsceneTransitionController = Class(Controller)

function CutsceneTransitionController:new(peep, director, minDuration, callback)
	Controller.new(self, peep, director)

	self.state = {
		minDuration = minDuration
	}

	self.isClosing = false

	self.onBeginClosing = Callback()
	self.onFinishClosing = Callback()

	self.onFinishClosing:register(callback)
end

function CutsceneTransitionController:getIsClosing()
	return self.isClosing
end

function CutsceneTransitionController:move()
	self:getDirector():getGameInstance():getUI():sendPoke(
		self,
		"onPlayerMove",
		nil,
		{})
end

function CutsceneTransitionController:poke(actionID, actionIndex, e)
	if actionID == "close" then
		if self.isClosing then
			self:onFinishClosing()

			self:getGame():getUI():closeInstance(self)
		else
			self:onBeginClosing()
			self.isClosing = true
		end
	else
		Controller.poke(self, actionID, actionIndex, e)
	end
end

function CutsceneTransitionController:pull()
	return self.state
end

return CutsceneTransitionController
