--------------------------------------------------------------------------------
-- ItsyScape/Game/Dialog/SpeakerPacket.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Packet = require "ItsyScape.Game.Dialog.Packet"

local SpeakerPacket = Class(Packet)
function SpeakerPacket:new(executor, speaker)
	Packet.new(self, executor)
	self.speaker = speaker
end

function SpeakerPacket:getSpeaker()
	return self.speaker
end

function SpeakerPacket:step()
	return self:getDialog():next()
end

return SpeakerPacket
