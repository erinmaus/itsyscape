--------------------------------------------------------------------------------
-- Resources/Game/Actions/SailingBuy.lua
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

local SailingBuy = Class(Action)
SailingBuy.SCOPES = { ['sailing'] = true }
SailingBuy.FLAGS = { ['item-inventory'] = true, ['item-noted'] = true, ['item-bank'] = true }

function SailingBuy:perform(state, peep)
	if not self:canPerform(state) or not self:canTransfer(state) then
		return false
	end

	self:transfer(state, peep)
	Action.perform(self, state, peep)

	return true
end

return SailingBuy
