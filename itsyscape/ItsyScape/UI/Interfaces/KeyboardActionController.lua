--------------------------------------------------------------------------------
-- ItsyScape/UI/Interfaces/KeyboardActionController.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Controller = require "ItsyScape.UI.Controller"

local KeyboardActionController = Class(Controller)

function KeyboardActionController:new(peep, director, keybind, callback, isOpen)
	Controller.new(self, peep, director)

	self.state = { keybind = keybind }

	self.actionCallback = callback or function(a)
		Log.warn("Keybind %s not given callback (action '%s' invoked by player).", keybind, a)
	end

	self.openCallback = isOpen or function() return true end
end

function KeyboardActionController:poke(actionID, actionIndex, e)
	if actionID == "pressed" then
		self.actionCallback("pressed")
	elseif actionID == "released" then
		self.actionCallback("released")
	else
		Controller.poke(self, actionID, actionIndex, e)
	end
end

function KeyboardActionController:pull()
	return self.state
end

function KeyboardActionController:update(delta)
	local result = self.openCallback(
		self:getPeep(),
		self:getDirector(),
		self:getGame():getUI())

	if not result then
		self:getGame():getUI():closeInstance(self)
	end
end

return KeyboardActionController
