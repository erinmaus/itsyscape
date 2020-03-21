--------------------------------------------------------------------------------
-- ItsyScape/UI/Interfaces/HUDController.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Utility = require "ItsyScape.Game.Utility"
local CombatStatusBehavior = require "ItsyScape.Peep.Behaviors.CombatStatusBehavior"
local ScoreBehavior = require "ItsyScape.Peep.Behaviors.ScoreBehavior"
local HUDController = require "ItsyScape.UI.Interfaces.HUDController"

local ScoreHUDController = Class(HUDController)

function ScoreHUDController:new(peep, director)
	HUDController.new(self, peep, director)

	peep:listen('travel', function()
		self:poke("close", nil, {})
	end)

	self:updateStats()
end

function ScoreHUDController:updateStats()
	self.scores = {}

	local peepMapScript = Utility.Peep.getMapScript(self:getPeep())
	if peepMapScript then
		local scoreBehavior = peepMapScript:getBehavior(ScoreBehavior)
		if scoreBehavior then
			local scores = {}
			for i = 1, #scoreBehavior.scores do
				if not scores[scoreBehavior.scores[i]] then
					table.insert(self.scores, scoreBehavior.scores[i]:get())
					scores[scoreBehavior.scores[i]] = true
				end
			end
		end
	end
end

function ScoreHUDController:update(...)
	HUDController.update(self, ...)

	self:updateStats()
end

function ScoreHUDController:pull()
	local state = HUDController.pull(self)
	state.scores = {}

	for i = 1, #self.scores do
		table.insert(state.scores, self.scores[i])
	end

	return state
end

return ScoreHUDController
