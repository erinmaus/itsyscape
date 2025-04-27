--------------------------------------------------------------------------------
-- ItsyScape/UI/Interfaces/PlayerEquipment.lua
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
local EquipmentGamepadContentTab = require "ItsyScape.UI.Interfaces.Components.EquipmentGamepadContentTab"

local PlayerEquipment = Class(PlayerTab)

function PlayerEquipment:new(id, index, ui)
	PlayerTab.new(self, id, index, ui)

	self.content = EquipmentGamepadContentTab(self)
	self:addChild(self.content)
end

function PlayerEquipment:tick()
	PlayerTab.tick(self)

	self.content:refresh(self:getState())
end

return PlayerEquipment
