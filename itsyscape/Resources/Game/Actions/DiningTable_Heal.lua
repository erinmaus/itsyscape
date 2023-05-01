--------------------------------------------------------------------------------
-- Resources/Game/Actions/DiningTable_Heal.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Utility = require "ItsyScape.Game.Utility"
local CompositeCommand = require "ItsyScape.Peep.CompositeCommand"
local CallbackCommand = require "ItsyScape.Peep.CallbackCommand"
local WaitCommand = require "ItsyScape.Peep.WaitCommand"
local Action = require "ItsyScape.Peep.Action"

local DiningTable_Heal = Class(Action)
DiningTable_Heal.SCOPES = { ['world'] = true, ['world-pvm'] = true, ['world-pvp'] = true }
DiningTable_Heal.FLAGS = { ['item-inventory'] = true, ['item-equipment'] = true }
DiningTable_Heal.QUEUE = {}
DiningTable_Heal.DURATION = 1.0

function DiningTable_Heal:perform(state, player, target)
	if target and self:canPerform(state, FLAGS) then
		local i, j, k = Utility.Peep.getTileAnchor(target)
		local walk = Utility.Peep.getWalk(player, i, j, k, 2.5, { asCloseAsPossible = true })

		if walk then
			local transfer = CallbackCommand(self.transfer, self, state, player)
			local wait = WaitCommand(DiningTable_Heal.DURATION, false)
			local poke = CallbackCommand(target.poke, target, 'eat', { action = self:getAction(), target = player })
			local perform = CallbackCommand(Action.perform, self, state, player, { prop = target })
			local command = CompositeCommand(true, walk, transfer, perform, poke, wait)

			local queue = player:getCommandQueue()
			return queue:interrupt(command)
		end
	end

	return false
end

return DiningTable_Heal
