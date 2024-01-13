--------------------------------------------------------------------------------
-- Resources/Game/Maps/EmptyRuins_Downtown/Peep.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Utility = require "ItsyScape.Game.Utility"
local Probe = require "ItsyScape.Peep.Probe"
local CombatStatusBehavior = require "ItsyScape.Peep.Behaviors.CombatStatusBehavior"
local Map = require "ItsyScape.Peep.Peeps.Map"

local Mine = Class(Map)

function Mine:onLoad(...)
	Map.onLoad(self, ...)

	self:initBoss()
end

function Mine:initBoss()
	local behemoth = self:getDirector():probe(
		self:getLayerName(),
		Probe.namedMapObject("Behemoth"))[1]

	if not behemoth then
		return
	end

	local function onReceiveAttack()
		Utility.UI.openInterface(
			Utility.Peep.getInstance(self),
			"BossHUD",
			false,
			behemoth)

		behemoth:silence("receiveAttack", onReceiveAttack)
	end

	behemoth:listen("receiveAttack", onReceiveAttack)
end

function Mine:onPlayerEnter(player)
	player:pokeCamera("mapRotationStick")

	local behemoth = self:getDirector():probe(
		self:getLayerName(),
		Probe.namedMapObject("Behemoth"))[1]

	if behemoth then
		local status = behemoth:getBehavior(CombatStatusBehavior)

		if status and not status.dead and status.currentHitpoints < status.maximumHitpoints then
			Utility.UI.openInterface(
				player:getActor():getPeep(),
				"BossHUD",
				false,
				behemoth)
		end
	end
end

function Mine:onPlayerLeave(player)
	player:pokeCamera("mapRotationUnstick")
end

return Mine
