--------------------------------------------------------------------------------
-- ItsyScape/UI/Interfaces/ConfigWindowController.lua
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

local ConfigWindowController = Class(Controller)

function ConfigWindowController:poke(actionID, actionIndex, e)
	if actionID == "quit" then
		self:quit(e)
	elseif actionID == "cancel" then
		self:cancel(e)
	else
		Controller.poke(self, actionID, actionIndex, e)
	end
end

function ConfigWindowController:quit(e)
	local playerModel = Utility.Peep.getPlayerModel(self:getPeep())

	playerModel:saveLocation()
	Utility.save(self:getPeep())
	playerModel:onLeave()

	self:getGame():getUI():closeInstance(self)
end

function ConfigWindowController:cancel(e)
	self:getGame():getUI():closeInstance(self)
end

return ConfigWindowController
