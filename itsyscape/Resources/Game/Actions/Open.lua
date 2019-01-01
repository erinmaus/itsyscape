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
local WaitCommand = require "ItsyScape.Peep.WaitCommand"
local CompositeCommand = require "ItsyScape.Peep.CompositeCommand"
local Action = require "ItsyScape.Peep.Action"

local Open = Class(Action)
Open.SCOPES = { ['world'] = true, ['world-pvm'] = true, ['world-pvp'] = true }

function Open:canPerform(state, flags, prop)
	if Action.canPerform(self, state, flags) and Action.canTransfer(self, state, flags) then
		if prop:isType(require "Resources.Game.Peeps.Props.BasicDoor") then
			return true
		end

		return true
	end

	return false
end

function Open:perform(state, player, prop, channel)
	local flags = { ['item-inventory'] = true }
	if self:canPerform(state, flags, prop) then
		if prop:isType(require "Resources.Game.Peeps.Props.BasicDoor") then
			if prop:getIsOpen() then
				return true
			end
		end

		local i, j, k = Utility.Peep.getTile(prop)
		local walk = Utility.Peep.getWalk(player, i, j, k, 1, { canUseObjects = true })

		if walk then
			local open = CallbackCommand(function()
				self:transfer(state, player, flags)
				prop:poke('open')
			end)
			local wait = WaitCommand(1)
			local perform = CallbackCommand(Action.perform, self, state, player)
			local command = CompositeCommand(true, walk, open, wait)

			local queue = player:getCommandQueue(channel)
			return queue:push(command)
		else
			print 'no walk'
		end
	end

	return false
end

return Open
