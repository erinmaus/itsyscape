--------------------------------------------------------------------------------
-- Resources/Game/Actions/Yell.lua
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
local OpenInterfaceCommand = require "ItsyScape.UI.OpenInterfaceCommand"

local Yell = Class(Action)
Yell.SCOPES = { ['world'] = true, ['world-pvm'] = true, ['world-pvp'] = true }

function Yell:perform(state, player, target)
	if not self:canPerform(state) or not self:canTransfer(state) then
		return false
	end

	self:transfer(state, player)

	local interface = OpenInterfaceCommand("DialogBox", true, self:getAction(), target)
	local perform = CallbackCommand(Action.perform, self, state, player)
	local command = CompositeCommand(true, walk, interface, perform)

	return player:getCommandQueue():interrupt(command)
end

return Yell
