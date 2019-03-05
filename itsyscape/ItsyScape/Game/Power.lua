--------------------------------------------------------------------------------
-- ItsyScape/Game/Power.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Utility = require "ItsyScape.Game.Utility"

local Power = Class()

function Power:new(game, resource, ...)
	self.game = game
	self.resource = resource

	local gameDB = game:getGameDB()
	self.name = Utility.getName(resource, gameDB)
	self.description = Utility.getDescription(resource, gameDB)

	local actions = Utility.getActions(game, resource, 'self')
	for i = 1, #actions do
		if actions[i].instance:is("Activate") then
			self.action = actions[i].instance
		end
	end
end

function Power:getGame()
	return self.game
end

function Power:getResource()
	return self.resource
end

function Power:getName()
	return self.name
end

function Power:getDescription()
	return self.description
end

function Power:getAction()
	return self.action or false
end

function Power:perform(activator, target)
	return self:getAction():perform(activator:getState(), activator, target)
end

function Power:activate(activator, target)
	activator:poke('powerActivated', {
		power = self,
		target = target,
		action = self:getAction()
	})

	target:poke('powerApplied', {
		power = self,
		activator = activator,
		action = self:getAction()
	})
end

function Power:getCoolDown(peep)
	return math.huge
end

return Power
