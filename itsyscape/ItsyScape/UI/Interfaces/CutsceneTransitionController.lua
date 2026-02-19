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
local Utility = require "ItsyScape.Game.Utility"
local Controller = require "ItsyScape.UI.Controller"

local CutsceneTransitionController = Class(Controller)

function CutsceneTransitionController:new(peep, director, minDuration, callback)
	Controller.new(self, peep, director)

	self.state = {
		minDuration = minDuration
	}

	self.isClosing = false
	self.isReady = false

	self.onBeginClosing = Callback()
	self.onFinishClosing = Callback()

	self.onFinishClosing:register(callback)

	self._travel = Callback(self.move, self)
	assert(peep:listen("moveInstance", self._travel))
end

function CutsceneTransitionController:close()
	Controller.close(self)
	self:getPeep():silence("move", self._travel)
end

function CutsceneTransitionController:getIsClosing()
	return self.isClosing
end

function CutsceneTransitionController:move()
	self:send("onPlayerMove")
	self:getPeep():silence("move", self._travel)
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
	return {
		minDuration = self.state.minDuration,
		isReady = self.isReady
	}
end

function CutsceneTransitionController:update(delta)
	Controller.update(self, delta)

	if not self.isReady then
		local instance = Utility.Peep.getInstance(self:getPeep())
		local baseMapScript = instance and instance:getBaseMapScript()

		if not baseMapScript or baseMapScript:getDirector() then
			self.isReady = true
		end
	end
end

return CutsceneTransitionController
