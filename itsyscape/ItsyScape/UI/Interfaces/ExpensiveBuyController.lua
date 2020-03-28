--------------------------------------------------------------------------------
-- ItsyScape/UI/ExpensiveBuyController.lua
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

local ExpensiveBuyController = Class(Controller)

function ExpensiveBuyController:new(peep, director, resource, action, seller)
	Controller.new(self, peep, director)

	local gameDB = self:getGame():getGameDB()
	local brochure = gameDB:getBrochure()

	self.resource = resource
	self.resourceType = brochure:getResourceTypeFromResource(self.resource)
	self.action = action
	self.state = Utility.getActionConstraints(director:getGameInstance(), action:getAction())
	self.storage = director:getPlayerStorage(peep):getRoot():getSection("Ship")
	self.seller = seller
end

function ExpensiveBuyController:poke(actionID, actionIndex, e)
	if actionID == "buy" then
		self:buy(e)
	elseif actionID == "nevermind" or actionID == "close" then
		self:getGame():getUI():closeInstance(self)
	else
		Controller.poke(self, actionID, actionIndex, e)
	end
end

function ExpensiveBuyController:buy(e)
	local hasResource = self:getPeep():getState():has(
		self.resourceType.name,
		self.resource.name)
	local success = hasResource or Utility.performAction(
		self:getGame(),
		self.resource,
		self.action:getAction().id.value,
		nil,
		self:getPeep():getState(), self:getPeep())

	if success then
		if self.seller then
			self.seller:poke('soldResource', self:getPeep(), self.resource, self.action)
		end

		self:getGame():getUI():closeInstance(self)
	end
end

function ExpensiveBuyController:pull()
	return self.state
end

return ExpensiveBuyController
