--------------------------------------------------------------------------------
-- Resources/Game/Actions/Pet.lua
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

local Pet = Class(Action)
Pet.SCOPES = { ['world'] = true, ['world-pvm'] = true, ['world-pvp'] = true }
Pet.FLAGS = { ['item-inventory'] = true, ['item-equipment'] = true }
Pet.DURATION = 0.5

function Pet:perform(state, player, target)
	if target and self:canPerform(state) then
		local i, j, k = Utility.Peep.getTile(target)
		local walk = Utility.Peep.getWalk(player, i, j, k, 1.5, { asCloseAsPossible = false })

		if walk then
			local transfer = CallbackCommand(self.transfer, self, state, player)
			local wait = WaitCommand(Pet.DURATION, false)
			local perform = CallbackCommand(Action.perform, self, state, player)
			local command = CompositeCommand(true, walk, transfer, perform, wait)

			local queue = player:getCommandQueue()
			return queue:interrupt(command)
		end
	end

	return false
end

return Pet
