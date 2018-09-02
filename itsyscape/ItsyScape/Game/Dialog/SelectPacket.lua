--------------------------------------------------------------------------------
-- ItsyScape/Game/Dialog/SelectPacket.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Packet = require "ItsyScape.Game.Dialog.Packet"

local SelectPacket = Class(Packet)
function SelectPacket:new(executor, options)
	Packet.new(self, executor)
	self.options = options
end

function SelectPacket:getNumOptions()
	return #self.options
end

function SelectPacket:getOptionAtIndex(index)
	return self.options[index]
end

function SelectPacket:step(index)
	return self:getDialog():next(self.options[index])
end

return SelectPacket
