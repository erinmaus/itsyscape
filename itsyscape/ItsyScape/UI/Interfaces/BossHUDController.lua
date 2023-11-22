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

	self.bosses = { dead = 0 }
	do
		local bosses = { n = select('#', ...), ... }
		for i = 1, bosses.n do
			local boss = bosses[i]
			if boss then
				table.insert(self.bosses, boss)

				boss:listen('die', self._onDeath, self)
				boss:listen('resurrect', self._onRezz, self)
			end
		end
	end

	peep:listen('travel', function()
		self:poke("close", nil, {})
	end)
end

function BossHUDController:close()
	HUDController.close(self)

	for i = 1, #self.bosses do
		self.bosses[i]:silence('die')
		self.bosses[i]:silence('resurrect')
	end
end

function BossHUDController:_onDeath(boss)
	self.bosses.dead = self.bosses.dead + 1

	if self.bosses.dead >= #self.bosses then
		Log.info(
			"Boss HUD closing for '%s' because all bosses are dead.",
			self:getPeep():getName())
		self:poke("close", nil, {})
	end
end

function BossHUDController:_onRezz(boss)
	self.bosses.dead = self.bosses.dead - 1
end

function BossHUDController:updateStats()
	local stats = {}
	self.stats = {}
	do
		local peepMapScript = Utility.Peep.getMapScript(self:getPeep())
		if peepMapScript then
			local bossStats = peepMapScript:getBehavior(BossStatsBehavior)
			if bossStats then
				for i = 1, #bossStats.stats do
					local bossStat = bossStats.stats[i]
					if not stats[bossStat] and
					   (bossStat:getPeep() == self:getPeep() or not bossStat:getPeep())
					then
						table.insert(self.stats, bossStat:get())
						stats[bossStat] = true
					end
				end
			end
		end
	end
	do
		for i = 1, #self.bosses do
			local peepMapScript = Utility.Peep.getMapScript(self.bosses[i])
			if peepMapScript then
				local bossStats = peepMapScript:getBehavior(BossStatsBehavior)
				if bossStats then
					for i = 1, #bossStats.stats do
						local bossStat = bossStats.stats[i]
						if not stats[bossStat] and
						   (bossStat:getPeep() == self:getPeep() or not bossStat:getPeep())
						then
							table.insert(self.stats, bossStat:get())
							stats[bossStat] = true
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
	do
		local bossesByID = {}
		for i = 1, #self.bosses do
			local resource = Utility.Peep.getResource(self.bosses[i])
			if resource then
				local b = bossesByID[resource.id.value] or {}
				table.insert(b, self.bosses[i])
				bossesByID[resource.id.value] = b
			else
				table.insert(bossesByID, { self.bosses[i] })
			end
		end

		for _, bosses in pairs(bossesByID) do
			local current, maximum, name = 0, 0, nil
			for i = 1, #self.bosses do
				local peep = bosses[i]
				local status = peep:getBehavior(CombatStatusBehavior) or {}
				current = current + (status.currentHitpoints or 0)
				maximum = maximum + (status.maximumHitpoints or 0)
				name = name or peep:getName()
			end

			table.insert(state.bigStats, {
				current = current,
				max = maximum,
				inColor = { 0.44, 0.78, 0.21, 1.0 },
				outColor = { 0.78, 0.21, 0.21, 1.0 },
				text = name
			})
		end
	end

	state.littleStats = self.stats

	return state
end

function BossHUDController:update(delta)
	HUDController.update(self, delta)

	self:updateStats()
end

return BossHUDController
