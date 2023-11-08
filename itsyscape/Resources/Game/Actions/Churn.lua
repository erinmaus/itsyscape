--------------------------------------------------------------------------------
-- Resources/Game/Actions/Churn.lua
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

local Churn = Class(Make)
Churn.SCOPES = { ['craft'] = true }

function Churn:perform(state, player, prop)
	if self:canPerform(state) and self:canTransfer(state) then
		local make = CallbackCommand(self.make, self, state, player)
		local churn = CallbackCommand(self.churn, self, prop, player)
		local wait = WaitCommand(self:getActionDuration())

		local queue = player:getCommandQueue()
		return queue:push(CompositeCommand(nil, make, churn, wait))
	end

	return false, "can't perform"
end

function Churn:churn(prop, player)
	if prop then
		prop:poke('churn', player)
	end
end

return Churn
