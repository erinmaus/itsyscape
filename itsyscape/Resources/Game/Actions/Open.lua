--------------------------------------------------------------------------------
-- Resources/Game/Actions/Open.lua
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
local Action = require "ItsyScape.Peep.Action"

local Open = Class(Action)
Open.SCOPES = { ['world'] = true, ['world-pvm'] = true, ['world-pvp'] = true }

function Open:canPerform(state, flags, prop)
	if Action.canPerform(self, state, flags) and Action.canTransfer(self, state, flags) then
		if prop:isType(require "Resources.Game.Peeps.Props.BasicDoor") then
			return not prop:getIsOpen()
		end

		return true
	end

	return false
end

function Open:perform(state, player, prop)
	local flags = { ['item-inventory'] = true }
	if self:canPerform(state, flags, prop) then
		local i, j, k = Utility.Peep.getTile(prop)
		local walk = Utility.Peep.getWalk(player, i, j, k, 1)

		if walk then
			local open = CallbackCommand(function()
				self:transfer(state, player, flags)
				prop:poke('open')
			end)
			local command = CompositeCommand(true, walk, open)

			local queue = player:getCommandQueue()
			queue:interrupt(command)
		end
	end
end

return Open
