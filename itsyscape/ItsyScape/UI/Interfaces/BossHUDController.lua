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
			end
		end
	end

	peep:listen('travel', function()
		self:poke("close", nil, {})
	end)
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
					if not stats[bossStats.stats[i]] then
						table.insert(self.stats, bossStats.stats[i]:get())
						stats[bossStats.stats[i]] = true
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

function BossHUDController:updateBosses()
	local alive = false
	for i = 1, #self.bosses do
		local peep = self.bosses[i]
		local status = peep:getBehavior(CombatStatusBehavior)
		if not peep:wasPoofed() and status and not status.dead then
			alive = true
			break
		end
	end

	if not alive then
		Log.info(
			"Boss HUD closing for '%s' because all bosses are dead or poofed.",
			self:getPeep():getName())
		self:poke("close", nil, {})
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
	self:updateBosses()
end

return BossHUDController
