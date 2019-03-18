--------------------------------------------------------------------------------
-- Resources/Game/Actions/Fire.lua
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
local PropResourceHealthBehavior = require "ItsyScape.Peep.Behaviors.PropResourceHealthBehavior"

local Fire = Class(Action)
Fire.SCOPES = { ['world'] = true, ['world-pvm'] = true, ['world-pvp'] = true }
Fire.FLAGS = { ['item-inventory'] = true, ['item-equipment'] = true }
Fire.DURATION = 0.5

function Fire:perform(state, player, target)
	if target and self:canPerform(state) and self:canTransfer(state) then
		local i, j, k = Utility.Peep.getTile(target)

		local walk = Utility.Peep.getWalk(player, i, j, k, 2, { asCloseAsPossible = true })

		local health = target:getBehavior(PropResourceHealthBehavior)
		if not health then
			return false
		end

		if health.currentProgress ~= health.maxProgress then
			return false
		end

		if walk then
			local transfer = CallbackCommand(self.transfer, self, state, player)
			local wait = WaitCommand(Fire.DURATION, false)
			local fire = CallbackCommand(target.poke, target, 'fire', player)
			local perform = CallbackCommand(Action.perform, self, state, player)
			local command = CompositeCommand(true, walk, wait, transfer, perform, fire)

			local queue = player:getCommandQueue()
			return queue:interrupt(command)
		end
	end

	return false
end

return Fire
