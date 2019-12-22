--------------------------------------------------------------------------------
-- Resources/Game/Actions/Dresser_Search.lua
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

local Dresser_Search = Class(Action)
Dresser_Search.SCOPES = { ['world'] = true, ['world-pvm'] = true, ['world-pvp'] = true }
Dresser_Search.FLAGS = { ['item-inventory'] = true, ['item-equipment'] = true }
Dresser_Search.QUEUE = {}
Dresser_Search.DURATION = 1.0

function Dresser_Search:perform(state, player, target)
	if target and self:canPerform(state, FLAGS) and not target.isOpen then
		local i, j, k = Utility.Peep.getTile(target)
		local walk = Utility.Peep.getWalk(player, i, j, k, 3.5, { asCloseAsPossible = true })

		if walk then
			local transfer = CallbackCommand(self.transfer, self, state, player)
			local wait = WaitCommand(Dresser_Search.DURATION, false)
			local poke = CallbackCommand(target.poke, target, 'search', { action = self:getAction(), target = player })
			local perform = CallbackCommand(Action.perform, self, state, player, { prop = target })
			local command = CompositeCommand(true, walk, transfer, perform, poke, wait)

			local queue = player:getCommandQueue()
			return queue:interrupt(command)
		end
	end

	return false
end

return Dresser_Search
