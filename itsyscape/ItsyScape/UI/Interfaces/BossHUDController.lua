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
local CombatStatusBehavior = require "ItsyScape.Peep.Behaviors.CombatStatusBehavior"
local HUDController = require "ItsyScape.UI.Interfaces.HUDController"

local BossHUDController = Class(HUDController)

function BossHUDController:new(peep, director, ...)
	HUDController.new(self, peep, director)

	self.bosses = {}
	do
		local bosses = { n = select('#', ...), ... }
		for i = 1, bosses.n do
			local boss = bosses[i]
			if boss then
				table.insert(self.bosses, boss)
			end
		end
	end

	self.stats = {
		{
			icon = 'Resources/Game/UI/Icons/Skills/Sailing.png',
			text = "Ship's health",
			inColor = { 0.44, 0.78, 0.21, 1.0 },
			outColor = { 0.78, 0.21, 0.21, 1.0 },
			current = 90,
			max = 100
		},

		{
			icon = 'Resources/Game/UI/Icons/Concepts/Rage.png',
			text = "Rage",
			inColor = { 0.78, 0.21, 0.21, 1.0 },
			outColor = { 0.21, 0.67, 0.78, 1.0 },
			current = 4,
			max = 5
		}
	}
end

function BossHUDController:pull()
	local state = HUDController.pull(self)

	state.bigStats = {}
	for i = 1, #self.bosses do
		local peep = self.bosses[i]
		local status = peep:getBehavior(CombatStatusBehavior) or {}

		table.insert(state.bigStats, {
			current = status.currentHitpoints or 100,
			max = status.maximumHitpoints or 100,
			inColor = { 0.44, 0.78, 0.21, 1.0 },
			outColor = { 0.78, 0.21, 0.21, 1.0 },
			text = peep:getName()
		})
	end

	state.littleStats = self.stats

	return state
end

return BossHUDController
