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

	behemoth:listen("die", self.onBossDie, self)

	local function onReceiveAttack()
		Utility.UI.openInterface(
			Utility.Peep.getInstance(self),
			"BossHUD",
			false,
			behemoth)

		local stage = self:getDirector():getGameInstance():getStage()
		stage:playMusic(self:getLayer(), "main", "BossFight1")

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

function Mine:onBossDie(boss)
	local instance = Utility.Peep.getInstance(self)
	Utility.Peep.notify(instance, "The chest to the north-east has items in it for you!")

	local chest = self:getDirector():probe(
		self:getLayerName(),
		Probe.namedMapObject("DustyChest"))[1]
	if not chest then
		Log.warn("Reward chest not found; cannot reward players!")
	end

	for _, player in instance:iteratePlayers() do
		local playerPeep = player:getActor():getPeep()

		if chest then
			local gameDB = self:getDirector():getGameDB()

			chest:poke('materialize', {
				count = love.math.random(40, 80),
				dropTable = gameDB:getResource("Behemoth_Primary", "DropTable"),
				peep = playerPeep,
				boss = boss,
				chest = chest
			})

			chest:poke('materialize', {
				count = love.math.random(5, 10),
				dropTable = gameDB:getResource("Behemoth_Secondary", "DropTable"),
				peep = playerPeep,
				boss = boss,
				chest = chest
			})

			chest:poke('materialize', {
				count = love.math.random(3, 5),
				dropTable = gameDB:getResource("Behemoth_Tertiary", "DropTable"),
				peep = playerPeep,
				boss = boss,
				chest = chest
			})
		end
	end

	local stage = self:getDirector():getGameInstance():getStage()
	stage:playMusic(self:getLayer(), "main", "PreTutorial")
end

function Mine:onPlayerLeave(player)
	player:pokeCamera("mapRotationUnstick")
end

return Mine
