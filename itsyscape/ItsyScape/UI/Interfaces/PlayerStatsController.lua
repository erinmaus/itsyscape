--------------------------------------------------------------------------------
-- ItsyScape/UI/PlayerStatsController.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Mapp = require "ItsyScape.GameDB.Mapp"
local Utility = require "ItsyScape.Game.Utility"
local Controller = require "ItsyScape.UI.Controller"
local StatsBehavior = require "ItsyScape.Peep.Behaviors.StatsBehavior"

local PlayerStatsController = Class(Controller)

function PlayerStatsController:new(peep, director)
	Controller.new(self, peep, director)
end

function PlayerStatsController:poke(actionID, actionIndex, e)
	Controller.poke(self, actionID, actionIndex, e)
end

function PlayerStatsController:pull()
	local stats = self:getPeep():getBehavior(StatsBehavior)

	local result = { skills = {} }
	if stats and stats.stats then
		stats = stats.stats

		for skill in stats:iterate() do
			table.insert(result.skills, {
				name = skill:getName(),
				xp = skill:getXP(),
				workingLevel = skill:getWorkingLevel(),
				baseLevel = skill:getBaseLevel(),
			})
		end
	end

	return result
end

return PlayerStatsController
