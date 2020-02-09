--------------------------------------------------------------------------------
-- Resources/Game/Actions/TurnForwardTime.lua
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

local TurnForwardTime = Class(Action)
TurnForwardTime.SCOPES = { ['inventory'] = true, ['equipment'] = true }
TurnForwardTime.FLAGS = { ['item-inventory'] = true }

function TurnForwardTime:perform(state, peep, item)
	if not self:canPerform(state) then
		return false
	end

	if self:transfer(state) then
		local director = peep:getDirector()
		Utility.Time.updateTime(director:getPlayerStorage(peep), 1)
		Action.perform(self, state, peep)
		return true
	end

	return false
end

return TurnForwardTime
