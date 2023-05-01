--------------------------------------------------------------------------------
-- Resources/Game/Actions/Pull.lua
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

local Pull = Class(Action)
Pull.SCOPES = { ['world'] = true, ['world-pvm'] = true, ['world-pvp'] = true }
Pull.FLAGS = { ['item-inventory'] = true, ['item-equipment'] = true }
Pull.QUEUE = {}
Pull.DURATION = 1.0

function Pull:perform(state, player, target)
	local FLAGS = {
		['item-inventory'] = true,
		['item-equipment'] = true
	}

	if target and self:canPerform(state, FLAGS) and self:canTransfer(state, FLAGS) then
		local i, j, k = Utility.Peep.getTileAnchor(target)
		local walk = Utility.Peep.getWalk(player, i, j, k, 1.5, { asCloseAsPossible = true })

		if walk then
			local transfer = CallbackCommand(self.transfer, self, state, player)
			local wait = WaitCommand(Pull.DURATION, false)
			local pull = CallbackCommand(self.pull, self, player, target)
			local perform = CallbackCommand(Action.perform, self, state, player)
			local command = CompositeCommand(true, walk, transfer, perform, pull, wait)

			local queue = player:getCommandQueue()
			return queue:interrupt(command)
		end
	end

	return false
end

function Pull:pull(peep, target)
	target:poke('pull', peep)
end

return Pull
