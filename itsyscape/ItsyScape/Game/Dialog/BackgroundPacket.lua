--------------------------------------------------------------------------------
-- ItsyScape/Game/Dialog/BackgroundPacket.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Packet = require "ItsyScape.Game.Dialog.Packet"

local BackgroundPacket = Class(Packet)
function BackgroundPacket:new(dialog, color)
	Packet.new(self, dialog)
	self.color = color
end

function BackgroundPacket:getBackground()
	return self.color
end

function BackgroundPacket:step()
	return self:getDialog():next()
end

return BackgroundPacket
