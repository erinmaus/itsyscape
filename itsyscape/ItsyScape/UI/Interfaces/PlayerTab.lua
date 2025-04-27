--------------------------------------------------------------------------------
-- ItsyScape/UI/Interfaces/PlayerTab.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Callback = require "ItsyScape.Common.Callback"
local Class = require "ItsyScape.Common.Class"
local Interface = require "ItsyScape.UI.Interface"
local Panel = require "ItsyScape.UI.Panel"
local PanelStyle = require "ItsyScape.UI.PanelStyle"
local Ribbon = require "ItsyScape.UI.Interfaces.Ribbon"
local GamepadContentTab = require "ItsyScape.UI.Interfaces.Components.GamepadContentTab"

local PlayerTab = Class(Interface)
PlayerTab.WIDTH = GamepadContentTab.WIDTH
PlayerTab.HEIGHT = GamepadContentTab.HEIGHT
PlayerTab.PANEL_STYLE = {
	image = "Resources/Game/UI/Panels/SideRibbonContent.png"
}

function PlayerTab:new(id, index, ui)
	Interface.new(self, id, index, ui)

	local panel = Panel()
	panel:setStyle(self.PANEL_STYLE, PanelStyle)
	panel:setSize(PlayerTab.WIDTH, PlayerTab.HEIGHT)
	self:addChild(panel)

	self:setSize(PlayerTab.WIDTH, PlayerTab.HEIGHT)
	self:performLayout()
end

function PlayerTab:attach()
	Interface.attach(self)
	self:tick()
end

function PlayerTab:performLayout()
	local width, height = love.graphics.getScaledMode()
	self:setPosition(
		width - PlayerTab.WIDTH - Ribbon.BUTTON_SIZE - Ribbon.PADDING * 2,
		height - PlayerTab.HEIGHT)
end

return PlayerTab
