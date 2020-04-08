--------------------------------------------------------------------------------
-- Resources/Game/Actions/Pick.lua
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

local Pick = Class(Action)
Pick.SCOPES = { ['world'] = true, ['world-pvm'] = true, ['world-pvp'] = true }
Pick.FLAGS = { ['item-inventory'] = true, ['item-equipment'] = true }
Pick.QUEUE = {}
Pick.DURATION = 1.0

function Pick:perform(state, player, target)
	local FLAGS = {
		['item-inventory'] = true,
		['item-equipment'] = true
	}

	if target and self:canPerform(state, FLAGS) then
		local i, j, k = Utility.Peep.getTile(target)
		local asCloseAsPossible
		do
			local map = Utility.Peep.getMap(target)
			if map:getTile(i, j):hasFlag('impassable') then
				asCloseAsPossible = true
			else
				asCloseAsPossible = false
			end
		end

		local walk = Utility.Peep.getWalk(player, i, j, k, 1.5, { asCloseAsPossible = asCloseAsPossible })

		if walk then
			local transfer = CallbackCommand(self.transfer, self, state, player)
			local wait = WaitCommand(Pick.DURATION, false)
			local poof = CallbackCommand(Utility.Peep.poof, target)
			local perform = CallbackCommand(Action.perform, self, state, player)
			local command = CompositeCommand(true, walk, wait, transfer, perform, poof)

			local queue = player:getCommandQueue()
			return queue:interrupt(command)
		end
	end

	return false
end

return Pick
