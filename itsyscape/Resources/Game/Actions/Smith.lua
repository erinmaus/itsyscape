--------------------------------------------------------------------------------
-- Resources/Game/Makes/Smith.lua
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

local Smith = Class(Make)
Smith.SCOPES = { ['craft'] = true }

function Smith:perform(state, player, prop)
	local flags = { ['item-inventory'] = true }

	if self:canPerform(state, flags) then
		local a = CallbackCommand(self.make, self, state, player)
		local b = CallbackCommand(self.smith, self, player, prop)
		local c = WaitCommand(self:getActionDuration())

		local queue = player:getCommandQueue()
		return queue:push(CompositeCommand(nil, a, b, c))
	end

	return false, "can't perform"
end

function Smith:smith(player, prop)
	if prop then
		prop:poke("smith", { peep = player, action = self })
		self:spawnCraftedItem(player, prop)
	end
end

return Smith
