--------------------------------------------------------------------------------
-- Resources/Game/Actions/DigUp.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Action = require "ItsyScape.Peep.Action"
local CallbackCommand = require "ItsyScape.Peep.CallbackCommand"
local CompositeCommand = require "ItsyScape.Peep.CompositeCommand"
local WaitCommand = require "ItsyScape.Peep.WaitCommand"

local DigUp = Class(Action)
DigUp.SCOPES = { ['dig'] = true }
DigUp.FLAGS = {
	['item-inventory'] = true,
	['item-equipment'] = true
}

function DigUp:perform(state, player)
	if self:canPerform(state, flags) then
		local make = CallbackCommand(self.transfer, self, state, player)
		local perform = CallbackCommand(Action.perform, self, state, player)

		local queue = player:getCommandQueue()
		return queue:push(make) and queue:push(perform)
	end

	return false, "can't perform"
end

function DigUp:getFailureReason(state, player)
	local reason = Action.getFailureReason(self, state, player)

	table.insert(reason.requirements, {
		type = "Item",
		resource = "IronShovel",
		name = "Shovel",
		count = 1
	})

	return reason
end

return DigUp
