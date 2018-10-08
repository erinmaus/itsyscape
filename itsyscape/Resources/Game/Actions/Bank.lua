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
local OpenInterfaceCommand = require "ItsyScape.UI.OpenInterfaceCommand"
local Action = require "ItsyScape.Peep.Action"

local Bank = Class(Action)
Bank.SCOPES = { ['world'] = true, ['world-pvm'] = true, ['world-pvp'] = true }

function Bank:perform(state, player, target)
	if target then
		local i, j, k = Utility.Peep.getTile(target)
		local walk = Utility.Peep.getWalk(player, i, j, k, 2)

		if walk then
			local open = OpenInterfaceCommand("Bank", false)
			local command = CompositeCommand(true, walk, open)

			local queue = player:getCommandQueue()
			return queue:interrupt(command)
		end
	end
end

return Bank
