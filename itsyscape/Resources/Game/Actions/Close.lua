--------------------------------------------------------------------------------
-- Resources/Game/Actions/Close.lua
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

local Close = Class(Action)
Close.SCOPES = { ['world'] = true, ['world-pvm'] = true, ['world-pvp'] = true }

function Close:canPerform(state, flags, prop)
	if Action.canPerform(self, state, flags) then
		return true
	end

	return false
end

function Close:perform(state, player, prop, channel)
	if self:canPerform(state, player, prop) then
		if prop:isType(require "Resources.Game.Peeps.Props.BasicDoor") then
			if not prop:getIsOpen() then
				return false
			end
		end

		local i, j, k = Utility.Peep.getTileAnchor(prop, 0, 0)
		local walk = Utility.Peep.getWalk(player, i, j, k, 2, { asCloseAsPossible = false })

		if walk then
			local close = CallbackCommand(function()
				prop:poke('close', player)
			end)
			local perform = CallbackCommand(Action.perform, self, state, player, { prop = prop })
			local command = CompositeCommand(true, walk, close, perform)

			local queue = player:getCommandQueue(channel)
			return queue:push(command)
		else
			return self:failWithMessage(player, "ActionFail_Walk")
		end
	end

	return false
end

return Close
