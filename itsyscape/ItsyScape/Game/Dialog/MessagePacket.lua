--------------------------------------------------------------------------------
-- ItsyScape/Game/Dialog/MessagePacket.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Packet = require "ItsyScape.Game.Dialog.Packet"

local MessagePacket = Class(Packet)
function MessagePacket:new(executor, options)
	Packet.new(self, executor)
	self.message = message
end

function MessagePacket:getMessage()
	return self.message
end

function MessagePacket:step()
	return dialog:next()
end

return MessagePacket
