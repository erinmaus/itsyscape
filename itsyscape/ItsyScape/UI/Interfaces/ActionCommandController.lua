--------------------------------------------------------------------------------
-- ItsyScape/UI/ActionCommandController.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Controller = require "ItsyScape.UI.Controller"
local PropReferenceBehavior = require "ItsyScape.Peep.Behaviors.PropReferenceBehavior"

local ActionCommandController = Class(Controller)

function ActionCommandController:new(peep, director, prop, action, attack)
	Controller.new(self, peep, director)

	local Fish1 = require "Resources.Game.ActionCommands.Fish1"
	self.prop = prop
	self.attack = attack
	self.actionCommand = Fish1(action)
	self.actionCommand.onHit:register(self.hit, self)

	self:update(0)
end

function ActionCommandController:hit(_, spread)
	if self.attack then
		self.attack(self:getPeep(), spread)
	end
end

function ActionCommandController:poke(actionID, actionIndex, e)
	if actionID == "axis" then
		self:axis(e)
	elseif actionID == "button" then
		self:button(e)
	elseif actionID == "close" then
		self:getGame():getUI():closeInstance(self)
	else
		Controller.poke(self, actionID, actionIndex, e)
	end
end

function ActionCommandController:axis(e)
	if e.axis == "x" then
		self.actionCommand:onXAxis(e.controller, e.value)
	elseif e.axis == "y" then
		self.actionCommand:onYAxis(e.controller, e.value)
	end
end

function ActionCommandController:button(e)
	if e.type == "down" then
		self.actionCommand:onButtonDown(e.controller, e.value)
	elseif e.type == "up" then
		self.actionCommand:onButtonUp(e.controller, e.value)
	end
end

function ActionCommandController:pull()
	local prop = self.prop:getBehavior(PropReferenceBehavior)
	prop = prop and prop.prop

	return {
		propID = prop and prop:getID(),
		current = self.currentInterface,
		previous = self.previousInterface
	}
end

function ActionCommandController:update(delta)
	self.actionCommand:update(delta)

	self.previousInterface = self.currentInterface or self.actionCommand:serialize()
	self.currentInterface = self.actionCommand:serialize()
end

return ActionCommandController
