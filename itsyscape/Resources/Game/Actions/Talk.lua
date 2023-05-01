--------------------------------------------------------------------------------
-- Resources/Game/Actions/Talk.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Utility = require "ItsyScape.Game.Utility"
local Mapp = require "ItsyScape.GameDB.Mapp"
local Action = require "ItsyScape.Peep.Action"
local CallbackCommand = require "ItsyScape.Peep.CallbackCommand"
local CompositeCommand = require "ItsyScape.Peep.CompositeCommand"
local OpenInterfaceCommand = require "ItsyScape.UI.OpenInterfaceCommand"

local Talk = Class(Action)
Talk.SCOPES = { ['world'] = true, ['world-pvm'] = true, ['world-pvp'] = true }

function Talk:perform(state, player, target)
	if not self:canPerform(state) then
		return false
	end

	local i, j, k = Utility.Peep.getTileAnchor(target)
	local walk = Utility.Peep.getWalk(player, i, j, k, 1.5, { asCloseAsPossible = false })
	if walk then
		local face = CallbackCommand(Utility.Peep.face, player, target)
		local interface = OpenInterfaceCommand("DialogBox", true, self:getAction(), target)
		local transfer = CallbackCommand(Action.transfer, self, state, player)
		local perform = CallbackCommand(Action.perform, self, state, player)
		local command = CompositeCommand(true, walk, face, interface, transfer, perform)

		return player:getCommandQueue():interrupt(command)
	end

	return false
end

return Talk
