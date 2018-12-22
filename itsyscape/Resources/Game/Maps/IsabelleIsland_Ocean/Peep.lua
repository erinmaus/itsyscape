--------------------------------------------------------------------------------
-- Resources/Game/Maps/IsabelleIsland_Ocean/Peep.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local BossStat = require "ItsyScape.Game.BossStat"
local Utility = require "ItsyScape.Game.Utility"
local Map = require "ItsyScape.Peep.Peeps.Map"
local BossStatsBehavior = require "ItsyScape.Peep.Behaviors.BossStatsBehavior"

local Ocean = Class(Map)

function Ocean:new(resource, name, ...)
	Map.new(self, resource, name or 'Ocean', ...)

	self:addBehavior(BossStatsBehavior)
end

function Ocean:onFinalize(...)
	self.squidRageStat = BossStat({
		icon = 'Resources/Game/UI/Icons/Concepts/Rage.png',
		text = "Squid's rage",
		inColor = { 0.78, 0.21, 0.21, 1.0 },
		outColor = { 0.21, 0.67, 0.78, 1.0 },
		current = 0,
		max = 5
	})

	local stats = self:getBehavior(BossStatsBehavior)
	table.insert(stats.stats, self.squidRageStat)
end

function Ocean:onSquidEnraged()
	self.squidRageStat.currentValue = math.min(
		self.squidRageStat.currentValue + 1,
		self.squidRageStat.maxValue)
end

function Ocean:onIsabelleIsland_Ocean_PlugLeak()
	Log.info("Plugged!")
end

return Ocean
