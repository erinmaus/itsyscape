--------------------------------------------------------------------------------
-- ItsyScape/UI/BuyBoatController.lua
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

local BuyBoatController = Class(Controller)

function BuyBoatController:new(peep, director, guildMaster)
	Controller.new(self, peep, director)

	local gameDB = director:getGameDB()
	local resource = gameDB:getResource("Ship", "SailingItem")

	local action
	do
		local actions = Utility.getActions(director:getGameInstance(), resource, 'sailing')
		for k = 1, #actions do
			if actions[k].instance:is('SailingBuy') then
				action = actions[k].instance
				break
			end
		end
	end

	self.resource = resource
	self.action = action
	self.state = Utility.getActionConstraints(director:getGameInstance(), action:getAction())
	self.storage = director:getPlayerStorage(peep):getRoot():getSection("Ship")
	self.guildMaster = guildMaster
end

function BuyBoatController:poke(actionID, actionIndex, e)
	if actionID == "buy" then
		self:buy(e)
	elseif actionID == "nevermind" or actionID == "close" then
		self:getGame():getUI():closeInstance(self)
	else
		Controller.poke(self, actionID, actionIndex, e)
	end
end

function BuyBoatController:buy(e)
	local hasShip = self:getPeep():getState():has("SailingItem", "Ship")
	local success = hasShip or Utility.performAction(
		self:getGame(),
		self.resource,
		self.action:getAction().id.value,
		'sailing',
		self:getPeep():getState(), self:getPeep())

	if success then
		if self.guildMaster then
			self.guildMaster:poke('soldShip')
		end

		self:getGame():getUI():closeInstance(self)
	end
end

function BuyBoatController:pull()
	return self.state
end

return BuyBoatController
