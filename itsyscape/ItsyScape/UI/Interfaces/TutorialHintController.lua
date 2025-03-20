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
	none = "none",
	circle = "circle",
	rectangle = "rectangle"
}

TutorialHintController.POSITION = {
	up = "up",
	down = "down",
	left = "left",
	right = "right",
	center = "center"
}

function TutorialHintController:new(peep, director, id, message, openCallback, e, nextCallback)
	e = e or {}

	Controller.new(self, peep, director)

	if type(message) ~= "table" then
		message = {
			standard = {
				button = "mouse",
				controller = "KeyboardMouse",
				label = message
			}
		}
	end

	if type(id) ~= "table" then
		id = {
			standard = id
		}
	end

	local position = e.position
	if type(position) ~= "table" then
		position = {
			standard = TutorialHintController.POSITION[position or "up"] or "up"
		}
	end

	local style = e.style
	if type(style) ~= "table" then
		local s = TutorialHintController.STYLE[style or "rectangle"] or "rectangle"

		style = {
			standard = s,
			gamepad = s,
			mobile = s
		}
	end

	self.inputs = {
		message = message,
		id = id,
		style = style,
		position = position
	}

	self.openCallback = openCallback or function() return true end
	self.nextCallback = nextCallback
end

function TutorialHintController:poke(actionID, actionIndex, e)
	Controller.poke(self, actionID, actionIndex, e)
end

function TutorialHintController.get(f)
	return Class.isCallable(f) and f() or f
end

function TutorialHintController:pull()
	return {
		message = TutorialHintController.get(self.inputs.message),
		id = TutorialHintController.get(self.inputs.id),
		style = TutorialHintController.get(self.inputs.style),
		position = TutorialHintController.get(self.inputs.position)
	}
end

function TutorialHintController:update(delta)
	local result = self.openCallback(
		self:getPeep(),
		self:getDirector(),
		self:getGame():getUI(),
		self.state)

	if result then
		if self.nextCallback then
			self.nextCallback()
		end

		self:getGame():getUI():closeInstance(self)
	end
end

return TutorialHintController
