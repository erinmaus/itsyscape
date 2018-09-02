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

	local i, j, k = Utility.Peep.getTile(target)
	local walk = Utility.Peep.getWalk(player, i, j, k, 1)
	local interface = OpenInterfaceCommand("DialogBox", true, self:getAction())
	local command = CompositeCommand(true, walk, interface)

	if player:getCommandQueue():interrupt(command) then
		return true
	end
end

return Talk
