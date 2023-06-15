--------------------------------------------------------------------------------
-- Resources/Game/Actions/Debug_Ascend.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Curve = require "ItsyScape.Game.Curve"
local Mapp = require "ItsyScape.GameDB.Mapp"
local Action = require "ItsyScape.Peep.Action"
local StatsBehavior = require "ItsyScape.Peep.Behaviors.StatsBehavior"

local DebugAscend = Class(Action)
DebugAscend.SCOPES = { ['inventory'] = true, ['equipment'] = true }

function DebugAscend:perform(state, peep, item)
	local stats = peep:getBehavior(StatsBehavior)
	if stats and stats.stats then
		stats = stats.stats
		for skill in stats:iterate() do
			skill:setXP(Curve.XP_CURVE(99))
			skill:setLevelBoost(21)
		end
	end

	Action.perform(self, state, peep)

	return true
end

return DebugAscend
