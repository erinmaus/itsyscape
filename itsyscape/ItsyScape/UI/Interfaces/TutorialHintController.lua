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

	self.inputs = {
		message = message,
		id = id,
		style = e.style,
		position = e.position
	}

	self.openCallback = openCallback or function() return true end
	self.nextCallback = nextCallback

	self:updateState()
end

function TutorialHintController:poke(actionID, actionIndex, e)
	Controller.poke(self, actionID, actionIndex, e)
end

function TutorialHintController.get(f)
	return Class.isCallable(f) and f() or f
end

function TutorialHintController:build()
	return {
		id = TutorialHintController.get(self.inputs.id),
		message = TutorialHintController.get(self.inputs.message),
		style = TutorialHintController.get(self.inputs.style),
		position = TutorialHintController.get(self.inputs.position)
	}
end

function TutorialHintController:updateState()
	local state = self:build()

	if type(state.message) ~= "table" and state.message then
		state.message = {
			gamepad = {
				button = "mouse",
				controller = "KeyboardMouse",
				label = state.message
			},
			standard = {
				button = "mouse",
				controller = "KeyboardMouse",
				label = state.message
			},
			mobile = {
				button = "tap",
				controller = "Touch",
				label = state.message
			}
		}
	end

	if type(state.id) ~= "table" then
		state.id = {
			gamepad = state.id,
			standard = state.id,
			mobile = state.id
		}
	end

	if type(state.position) ~= "table" then
		local position = TutorialHintController.POSITION[state.position or "up"] or "up"

		state.position = {
			gamepad = position,
			standard = position,
			mobile = position
		}
	end

	if type(state.style) ~= "table" then
		local style = TutorialHintController.STYLE[state.style or "rectangle"] or "rectangle"

		state.style = {
			standard = style,
			gamepad = style,
			mobile = style
		}
	end

	state.didPerformAction = self.openCallback(
		self:getPeep(),
		self:getDirector(),
		self:getGame():getUI(),
		self.inputState)

	self.state = state
end

function TutorialHintController:pull()
	return self.state
end

function TutorialHintController:update(delta)
	self:updateState()

	if self.state.didPerformAction then
		if self.nextCallback then
			self.nextCallback()
		end

		self:getGame():getUI():closeInstance(self)
	end
end

return TutorialHintController
