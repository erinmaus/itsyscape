--------------------------------------------------------------------------------
-- Resources/Game/Actions/Snuff.lua
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
local CallbackCommand = require "ItsyScape.Peep.CallbackCommand"
local CompositeCommand = require "ItsyScape.Peep.CompositeCommand"
local WaitCommand = require "ItsyScape.Peep.WaitCommand"

local Snuff = Class(Action)
Snuff.SCOPES = { ['world'] = true, ['world-pvm'] = true, ['world-pvp'] = true }
Snuff.FLAGS = {
	['item-inventory'] = true,
	['item-equipment'] = true
}

function Snuff:perform(state, peep, prop)
	local gameDB = self:getGame():getGameDB()
	if self:canPerform(state) then
		if not prop:isCompatibleType(require "Resources.Game.Peeps.Props.BasicTorch") then
			return false
		end

		if not prop:getIsLit() then
			return true
		end

		local transfer = CallbackCommand(self.transfer, self, peep:getState(), peep, { ['item-inventory'] = true })
		local wait = WaitCommand(Snuff.DURATION, false)

		local walk
		do
			local i, j, k = Utility.Peep.getTile(prop)
			walk = Utility.Peep.getWalk(peep, i, j + 1, k, 1, { asCloseAsPossible = true }) or
			       Utility.Peep.getWalk(peep, i, j, k, 1, { asCloseAsPossible = true })
		end

		if walk then
			local snuff = CallbackCommand(function()
				if self:transfer(state, peep, flags) then
					prop:poke('snuff')
				end
			end)
			local wait = WaitCommand(1)
			local perform = CallbackCommand(Action.perform, self, state, peep, { prop = prop })
			local command = CompositeCommand(true, walk, transfer, snuff, perform, wait)

			local queue = peep:getCommandQueue()
			return queue:interrupt(command)
		end
	end

	return false
end

return Snuff
