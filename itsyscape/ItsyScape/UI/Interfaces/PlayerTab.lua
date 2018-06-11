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
local Utility = require "ItsyScape.Game.Utility"
local Interface = require "ItsyScape.UI.Interface"
local Ribbon = require "ItsyScape.UI.Interfaces.Ribbon"

local PlayerTab = Class(Interface)
PlayerTab.WIDTH = 248
PlayerTab.HEIGHT = 428

function PlayerTab:new(id, index, ui)
	Interface.new(self, id, index, ui)

	self:setSize(PlayerTab.WIDTH, PlayerTab.HEIGHT)

	local width, height = love.window.getMode()
	self:setPosition(
		width - PlayerTab.WIDTH,
		height - PlayerTab.HEIGHT - Ribbon.BUTTON_SIZE - Ribbon.PADDING * 2)
end

return PlayerTab
