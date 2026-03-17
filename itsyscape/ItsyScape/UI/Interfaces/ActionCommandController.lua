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
local Utility = require "ItsyScape.Game.Utility"
local Controller = require "ItsyScape.UI.Controller"
local ActorReferenceBehavior = require "ItsyScape.Peep.Behaviors.ActorReferenceBehavior"
local PropReferenceBehavior = require "ItsyScape.Peep.Behaviors.PropReferenceBehavior"

local ActionCommandController = Class(Controller)

function ActionCommandController:new(peep, director, prop, action, t, attack)
	Controller.new(self, peep, director)

	local ActionCommandType = Utility.Skilling.getActionCommandType(prop, action)

	self.prop = prop
	self.attack = attack
	self.actionCommand = ActionCommandType and ActionCommandType(action, peep, prop, t)

	if self.actionCommand then
		self.actionCommand.onHit:register(self.hit, self)
		self.actionCommand.onParticles:register(self.particles, self)
	end

	self:update(0)
end

function ActionCommandController:close()
	if self.actionCommand then
		self.actionCommand:close()
	end
end

function ActionCommandController:hit(_, spread)
	if self.attack then
		local damage = self.attack(self:getPeep(), spread)
		self.actionCommand:onDamage(damage)
	end
end

function ActionCommandController:particles(_, particles, x, y, z)
	self:send("showParticles", particles, x, y, z)
end

function ActionCommandController:poke(actionID, actionIndex, e)
	if actionID == "axis" then
		self:axis(e)
	elseif actionID == "button" then
		self:button(e)
	elseif actionID == "key" then
		self:key(e)
	elseif actionID == "control" then
		self:control(e)
	elseif actionID == "close" then
		self:getPeep():getCommandQueue():clear()
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

function ActionCommandController:key(e)
	if e.type == "down" then
		self.actionCommand:onKeyDown(e.controller, e.value)
	elseif e.type == "up" then
		self.actionCommand:onKeyUp(e.controller, e.value)
	end
end

function ActionCommandController:control(e)
	if e.type == "down" then
		self.actionCommand:onControlDown(e.value)
	elseif e.type == "up" then
		self.actionCommand:onControlUp(e.value)
	end
end

function ActionCommandController:pull()
	local prop = self.prop:getBehavior(PropReferenceBehavior)
	prop = prop and prop.prop

	local actor = self.prop:getBehavior(ActorReferenceBehavior)
	actor = actor and actor.actor

	return {
		actorID = actor and actor:getID(),
		propID = prop and prop:getID(),
		current = self.currentInterface,
		previous = self.previousInterface,
		message = self.actionCommand and self.actionCommand:getMessage()
	}
end

function ActionCommandController:update(delta)
	Controller.update(self, delta)

	if not self.actionCommand then
		self:getGame():getUI():closeInstance(self)
		return
	end

	self.actionCommand:update(delta)

	self.previousInterface = self.currentInterface or self.actionCommand:serialize()
	self.currentInterface = self.actionCommand:serialize()
end

return ActionCommandController
