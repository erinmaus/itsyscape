--------------------------------------------------------------------------------
-- ItsyScape/Game/Dialog/InputPacket.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Packet = require "ItsyScape.Game.Dialog.Packet"

local InputPacket = Class(Packet)
function InputPacket:new(executor, question)
	Packet.new(self, executor)
	self.question = question
end

function InputPacket:getQuestion()
	return self.question
end

function InputPacket:step(value)
	return self:getDialog():next(value)
end

return InputPacket
