--------------------------------------------------------------------------------
-- Resources/Game/Actions/Shake.lua
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

local Shake = Class(Action)
Shake.SCOPES = { ['world'] = true, ['world-pvm'] = true, ['world-pvp'] = true }
Shake.FLAGS = { ['item-inventory'] = true, ['item-equipment'] = true }
Shake.QUEUE = {}
Shake.DURATION = 1.0

function Shake:perform(state, player, target)
	if target and self:canPerform(state) then
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
			local wait = WaitCommand(Shake.DURATION, false)
			local drop = CallbackCommand(self.drop, self, state, player, target)
			local perform = CallbackCommand(Action.perform, self, state, player)
			local command = CompositeCommand(true, walk, wait, transfer, perform, drop)

			local queue = player:getCommandQueue()
			return queue:interrupt(command)
		end
	end

	return false
end

function Shake:drop(state, player, target)
	target:poke("shake")
	Log.info("TODO! Add drops.")
end

return Shake
