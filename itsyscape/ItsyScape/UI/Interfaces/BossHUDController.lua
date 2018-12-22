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
local BossStatsBehavior = require "ItsyScape.Peep.Behaviors.BossStatsBehavior"
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

				boss:listen('poof', function()
					self:poke("close", nil, {})
				end)
			end
		end
	end

	peep:listen('travel', function()
		self:poke("close", nil, {})
	end)

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
			current = 4,
			max = 5
		}
	}
end

function BossHUDController:update(...)
	HUDController.update(self, ...)

	self.stats = {}
	do
		local peepMapScript = Utility.Peep.getMapScript(self:getPeep())
		if peepMapScript then
			local bossStats = peepMapScript:getBehavior(BossStatsBehavior)
			if bossStats then
				for i = 1, #bossStats.stats do
					table.insert(self.stats, bossStats.stats[i]:get())
				end
			end
		end
	end
	do
		local stats = {}
		for i = 1, #self.bosses do
			local peepMapScript = Utility.Peep.getMapScript(self.bosses[i])
			if peepMapScript then
				local bossStats = peepMapScript:getBehavior(BossStatsBehavior)
				if bossStats then
					for i = 1, #bossStats.stats do
						if not stats[bossStats.stats[i]] then
							table.insert(self.stats, bossStats.stats[i]:get())
							stats[bossStats.stats[i]] = true
						end
					end
				end
			end
		end
	end
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
