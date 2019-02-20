--------------------------------------------------------------------------------
-- Resources/Game/Actions/Debug_Ascend.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Action = require "ItsyScape.Peep.Action"

local Activate = Class(Action)
Activate.SCOPES = { ['self'] = true }

function Activate:perform(state, player, target)
	if not self:canPerform(state) or not self:canTransfer(state) then
		return false
	end

	self:transfer(state, player)

	return true
end

return Activate
