--------------------------------------------------------------------------------
-- ItsyScape/UI/RibbonController.lua
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

local RibbonController = Class(Controller)

function RibbonController:new(peep, director)
	Controller.new(self, peep, director)

	self.currentInterfaceID = false
	self.currentInterfaceIndex = false

	self.tabs = {
		["PlayerStance"] = true,
		["PlayerInventory"] = true,
		["PlayerEquipment"] = true,
		["PlayerStats"] = true,
	}
end

function RibbonController:poke(actionID, actionIndex, e)
	if actionID == "open" then
		self:openTab(e)
	elseif actionID == "close" then
		self:closeTab(e)
	else
		Controller.poke(self, actionID, actionIndex, e)
	end
end

function RibbonController:openTab(e)
	assert(type(e.tab) == "string", "tab must be string")
	assert(self.tabs[e.tab], "tab not permitted")

	local ui = self:getDirector():getGameInstance():getUI()
	if self.currentInterfaceID and self.currentInterfaceIndex then
		ui:close(self.currentInterfaceID, self.currentInterfaceIndex)
	end

	self.currentInterfaceID, self.currentInterfaceIndex = ui:open(e.tab)
	ui:sendPoke(self, "activate", nil, { self.currentInterfaceID })
end

function RibbonController:closeTab(e)
	local ui = self:getDirector():getGameInstance():getUI()
	if self.currentInterfaceID and self.currentInterfaceIndex then
		ui:close(self.currentInterfaceID, self.currentInterfaceIndex)
	end

	self.currentInterfaceID = false
	self.currentInterfaceIndex = false

	ui:sendPoke(self, "activate", nil, { nil })
end

return RibbonController
