--------------------------------------------------------------------------------
-- Resources/Game/Actions/TurnForwardTimeSecond.lua
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

local TurnForwardTimeSecond = Class(Action)
TurnForwardTimeSecond.SCOPES = { ['inventory'] = true, ['equipment'] = true }
TurnForwardTimeSecond.FLAGS = { ['item-inventory'] = true }

function TurnForwardTimeSecond:perform(state, peep, item)
	if not self:canPerform(state) then
		return false
	end

	if self:transfer(state, peep) then
		local director = peep:getDirector()
		Utility.Time.updateTime(director:getPlayerStorage(peep):getRoot(), 0, 5 * 60)

		Action.perform(self, state, peep)
		return true
	end

	return false
end

return TurnForwardTimeSecond
