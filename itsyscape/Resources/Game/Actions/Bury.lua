--------------------------------------------------------------------------------
-- Resources/Game/Actions/Bury.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Equipment = require "ItsyScape.Game.Equipment"
local Action = require "ItsyScape.Peep.Action"
local CallbackCommand = require "ItsyScape.Peep.CallbackCommand"
local WaitCommand = require "ItsyScape.Peep.WaitCommand"

local Bury = Class(Action)
Bury.SCOPES = { ['inventory'] = true }
Bury.QUEUE = {}
Bury.DURATION = 0.5

function Bury:perform(state, player, item)
	local flags = { ['item-equipment'] = true }

	local gameDB = self:getGame():getGameDB()
	if self:canPerform(state, flags) then
		local bury = CallbackCommand(self.transfer, self, player:getState(), player, { ['item-inventory'] = true })
		local perform = CallbackCommand(Action.perform, self, state, player)
		local wait = WaitCommand(Bury.DURATION)

		local queue = player:getCommandQueue(Bury.QUEUE)
		return queue:push(bury) and queue:push(wait) and queue:push(perform)
	end

	return false
end

return Bury
