--------------------------------------------------------------------------------
-- ItsyScape/UI/Interfaces/Components/GamepadContentTab.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Callback = require "ItsyScape.Common.Callback"
local Class = require "ItsyScape.Common.Class"
local Utility = require "ItsyScape.Game.Utility"
local Panel = require "ItsyScape.UI.Panel"

local GamepadContentTab = Class(Panel)
GamepadContentTab.WIDTH = 264
GamepadContentTab.HEIGHT = 456

function GamepadContentTab:new(interface)
	Panel.new(self)

	self.interface = interface
	self.currentState = {}

	self.onWrapFocus = Callback()

	self:setSize(self.WIDTH, self.HEIGHT)
end

function GamepadContentTab:getState()
	return self.currentState
end

function GamepadContentTab:refresh(state)
	self.currentState = state
end

function GamepadContentTab:getInterface()
	return self.interface
end

function GamepadContentTab:getUI()
	return self.interface:getUI()
end

function GamepadContentTab:getUIView()
	return self.interface:getView()
end

function GamepadContentTab:getResources()
	return self.interface:getView():getResources()
end

function GamepadContentTab:getGame()
	return self.interface:getView():getGame()
end

function GamepadContentTab:getGameDB()
	return self.interface:getView():getGame():getGameDB()
end

return GamepadContentTab
