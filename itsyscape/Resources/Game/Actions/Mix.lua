--------------------------------------------------------------------------------
-- Resources/Game/Makes/Mix.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local CallbackCommand = require "ItsyScape.Peep.CallbackCommand"
local CompositeCommand = require "ItsyScape.Peep.CompositeCommand"
local WaitCommand = require "ItsyScape.Peep.WaitCommand"
local Make = require "Resources.Game.Actions.Make"

local Mix = Class(Make)
Mix.SCOPES = { ['craft'] = true }
Mix.FLAGS = {
	['item-inventory'] = true,
	['item-equipment'] = true,
	['item-drop-excess'] = true
}

function Mix:perform(state, player)
	local flags = { ['item-inventory'] = true }

	if self:canPerform(state, flags) then
		local a = WaitCommand(self:getActionDuration(5))
		local b = CallbackCommand(self.make, self, state, player, nil, self:getDynamicCount(state, player))

		local queue = player:getCommandQueue()
		return queue:push(CompositeCommand(nil, a, b))
	end

	return false, "can't perform"
end

return Mix
