--------------------------------------------------------------------------------
-- Resources/Game/Actions/Bank.lua
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
local OpenInterfaceCommand = require "ItsyScape.UI.OpenInterfaceCommand"
local Action = require "ItsyScape.Peep.Action"

local Bank = Class(Action)
Bank.SCOPES = { ['world'] = true, ['world-pvm'] = true, ['world-pvp'] = true }

function Bank:perform(state, player, target)
	local FLAGS = {
		['item-inventory'] = true,
		['item-equipment'] = true
	}

	if target and self:canPerform(state, FLAGS) then
		local i, j, k = Utility.Peep.getTile(target)
		local walk = Utility.Peep.getWalk(player, i, j, k, 1, { asCloseAsPossible = false })

		if walk then
			local open = OpenInterfaceCommand("Bank", true)
			local perform = CallbackCommand(Action.perform, self, state, player)
			local command = CompositeCommand(true, walk, open, perform)

			local queue = player:getCommandQueue()
			return queue:interrupt(command)
		end
	end

	return false
end

return Bank
