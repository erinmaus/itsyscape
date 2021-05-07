--------------------------------------------------------------------------------
-- ItsyScape/UI/Interfaces/QuitGameWindowController.lua
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

local QuitGameWindowController = Class(Controller)

function QuitGameWindowController:poke(actionID, actionIndex, e)
	if actionID == "confirm" then
		self:confirm(e)
	elseif actionID == "cancel" then
		self:cancel(e)
	else
		Controller.poke(self, actionID, actionIndex, e)
	end
end

function QuitGameWindowController:confirm(e)
	self:getGame():quit()
	self:getGame():getUI():closeInstance(self)
	Log.analytic("END_GAME")
end

function QuitGameWindowController:cancel(e)
	self:getGame():getUI():closeInstance(self)
end

return QuitGameWindowController
