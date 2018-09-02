--------------------------------------------------------------------------------
-- ItsyScape/Game/Dialog/Packet.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"

local Packet = Class(Packet)

function Packet:new(dialog)
	self.dialog = dialog
end

function Packet:getDialog()
	return self.dialog
end

function Packet:step()
	Class.ABSTRACT()
end

return Packet
