--------------------------------------------------------------------------------
-- Resources/Game/Actions/SailingUnlock.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Utility = require "ItsyScape.Game.Utility"
local Action = require "ItsyScape.Peep.Action"

local SailingUnlock = Class(Action)
SailingUnlock.SCOPES = { ['sailing'] = true }
SailingUnlock.FLAGS = { ['item-inventory'] = true, ['item-noted'] = true }

function SailingUnlock:perform(state, peep)
	if not self:canPerform(state) or not self:canTransfer(state) then
		return false
	end

	self:transfer(state, peep)
	Action.perform(self, state, peep)

	return true
end

return SailingUnlock
