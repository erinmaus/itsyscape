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
		["PlayerSpells"] = true,
		["PlayerPrayers"] = true,
		["Nominomicon"] = true,
		["QuitGameWindow"] = true
	}

	self.buttons = {
		["Nominomicon"] = true,
		["QuitGameWindow"] = true
	}

	self.blocking = {
		["Nominomicon"] = true,
		["QuitGameWindow"] = false
	}

	self.currentTab = false
end

function RibbonController:poke(actionID, actionIndex, e)
	if actionID == "open" then
		self:openTab(e)
	elseif actionID == "close" then
		self:closeTab(e)
	elseif actionID == "hide" then
		self:hide(e)
	elseif actionID == "show" then
		self:show(e)
	else
		Controller.poke(self, actionID, actionIndex, e)
	end
end

function RibbonController:openTab(e)
	assert(type(e.tab) == "string", "tab must be string")
	assert(self.tabs[e.tab], "tab not permitted")

	if self.hidden then
		return
	end

	local ui = self:getDirector():getGameInstance():getUI()
	if self.currentInterfaceID and self.currentInterfaceIndex then
		ui:close(self.currentInterfaceID, self.currentInterfaceIndex)
	end

	local isButton = self.buttons[e.tab] or false
	if not isButton then
		self.currentInterfaceID, self.currentInterfaceIndex = ui:open(self:getPeep(), e.tab)
		self.currentTab = e.tab
	else
		if self.blocking[e.tab] then
			ui:openBlockingInterface(self:getPeep(), e.tab)
		else
			ui:open(self:getPeep(), e.tab)
		end

		self.currentInterfaceID, self.currentInterfaceIndex = nil, nil
		self.currentTab = nil
	end

	ui:sendPoke(self, "activate", nil, { self.currentInterfaceID, isButton })

end

function RibbonController:closeTab(e)
	local ui = self:getDirector():getGameInstance():getUI()
	if self.currentInterfaceID and self.currentInterfaceIndex then
		ui:close(self.currentInterfaceID, self.currentInterfaceIndex)
	end

	self.currentInterfaceID = false
	self.currentInterfaceIndex = false
	self.currentTab = false

	ui:sendPoke(self, "activate", nil, { nil })
end

function RibbonController:hide(e)
	local currentTab = self.currentTab
	self:closeTab(e)

	self.previousTab = currentTab
	self.hidden = true
end

function RibbonController:show(e)
	self.hidden = false
	if self.previousTab then
		self:openTab({ tab = self.previousTab })
		self.previousTab = nil
	end
end

return RibbonController
