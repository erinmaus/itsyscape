--------------------------------------------------------------------------------
-- ItsyScape/UI/Interfaces/PlayerConfig.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Callback = require "ItsyScape.Common.Callback"
local Class = require "ItsyScape.Common.Class"
local PlayerTab = require "ItsyScape.UI.Interfaces.PlayerTab"
local ConfigGamepadContentTab = require "ItsyScape.UI.Interfaces.Components.ConfigGamepadContentTab"

local PlayerConfig = Class(PlayerTab)

function PlayerConfig:new(id, index, ui)
	PlayerTab.new(self, id, index, ui)

	self.content = ConfigGamepadContentTab(self)
	self:addChild(self.content)
end

function PlayerConfig:tick()
	PlayerTab.tick(self)

	self.content:refresh(self:getState())
end

return PlayerConfig
