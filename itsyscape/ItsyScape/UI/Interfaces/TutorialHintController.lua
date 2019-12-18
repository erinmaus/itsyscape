--------------------------------------------------------------------------------
-- ItsyScape/UI/Interfaces/TutorialHintController.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Mapp = require "ItsyScape.GameDB.Mapp"
local Utility = require "ItsyScape.Game.Utility"
local Controller = require "ItsyScape.UI.Controller"
local InventoryBehavior = require "ItsyScape.Peep.Behaviors.InventoryBehavior"

local TutorialHintController = Class(Controller)
TutorialHintController.STYLE = {
	['none'] = 'none',
	['circle'] = 'circle',
	['rectangle'] = 'rectangle'
}
TutorialHintController.POSITION = {
	['up'] = 'up',
	['down'] = 'down',
	['left'] = 'left',
	['right'] = 'right',
	['center'] = 'center'
}

function TutorialHintController:new(peep, director, id, message, openCallback, e, nextCallback)
	Controller.new(self, peep, director)

	e = e or {}
	self.state = {
		message = message,
		id = id,
		style = TutorialHintController.STYLE[e.style or 'rectangle'] or 'rectangle',
		position = TutorialHintController.POSITION[e.position or 'up'] or 'up'
	}

	self.openCallback = openCallback or function() return true end
	self.nextCallback = nextCallback
end

function TutorialHintController:poke(actionID, actionIndex, e)
	Controller.poke(self, actionID, actionIndex, e)
end

function TutorialHintController:pull()
	return self.state
end

function TutorialHintController:update(delta)
	local result = self.openCallback(
		self:getPeep(),
		self:getDirector(),
		self:getGame():getUI())

	if result then
		if self.nextCallback then
			print('next')
			self.nextCallback()
		end

		self:getGame():getUI():closeInstance(self)
	end
end

return TutorialHintController
