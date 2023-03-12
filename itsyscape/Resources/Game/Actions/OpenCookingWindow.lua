--------------------------------------------------------------------------------
-- Resources/Game/Actions/OpenCookingWindow.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Utility = require "ItsyScape.Game.Utility"
local CallbackCommand = require "ItsyScape.Peep.CallbackCommand"
local CompositeCommand = require "ItsyScape.Peep.CompositeCommand"
local OpenInterfaceCommand = require "ItsyScape.UI.OpenInterfaceCommand"
local Action = require "ItsyScape.Peep.Action"

local OpenCookingWindow = Class(Action)
OpenCookingWindow.SCOPES = { ['world'] = true, ['world-pvm'] = true, ['world-pvp'] = true }

function OpenCookingWindow:perform(state, player, prop)
	local i, j, k = Utility.Peep.getTile(prop)
	local walk = Utility.Peep.getWalk(player, i, j, k, 2.5)
	local face = CallbackCommand(Utility.Peep.face, player, prop)

	if walk then
		local open = OpenInterfaceCommand("CookingWindow", true, prop)
		local perform = CallbackCommand(Action.perform, self, state, player)
		local command = CompositeCommand(true, walk, face, open, perform)

		local queue = player:getCommandQueue()
		return queue:interrupt(command)
	end

	return false
end

return OpenCookingWindow
