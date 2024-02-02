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
local Vector = require "ItsyScape.Common.Math.Vector"
local Utility = require "ItsyScape.Game.Utility"
local Map = require "ItsyScape.Peep.Peeps.Map"
local Probe = require "ItsyScape.Peep.Probe"
local CombatStatusBehavior = require "ItsyScape.Peep.Behaviors.CombatStatusBehavior"
local PositionBehavior = require "ItsyScape.Peep.Behaviors.PositionBehavior"
local TeleportalBehavior = require "ItsyScape.Peep.Behaviors.TeleportalBehavior"

local Downtown = Class(Map)
Downtown.SISTINE_LOCATION = Vector(0, 0, -128)

Downtown.NUM_SKIRMISHES = 10

Downtown.MIN_EMPTY_KING_SOLDIERS = 1
Downtown.MAX_EMPTY_KING_SOLDIERS = 4

Downtown.EMPTY_KING_SOLDIERS = {
	"Tinkerer",
	"Tinkerer",
	"GoryMass",
	"PrestigiousAncientSkeleton",
	"PrestigiousAncientSkeleton",
	"PrestigiousMummy",
	"PrestigiousMummy"
}

Downtown.YENDORIAN_SOLDIERS = {
	"Yendorian_Ballista",
	"Yendorian_Mast",
	"Yendorian_Swordfish"
}

function Downtown:new(resource, name, ...)
	Map.new(self, resource, name or 'EmptyRuins_Downtown', ...)
end

function Downtown:onLoad(filename, args, layer)
	Map.onLoad(self, filename, args, layer)

	local stage = self:getDirector():getGameInstance():getStage()
	stage:forecast(layer, 'EmptyRuins_Downtown_Bubbles', 'Fungal', {
		gravity = { 0, 3, 0 },
		wind = { 0, 0, 0 },
		colors = {
			{ 0.0, 0.0, 0.0, 1.0 },
			{ 0.0, 0.0, 0.0, 1.0 },
			{ 0.7, 0.8, 0.2, 1.0 },
			{ 0.4, 0.2, 0.8, 1.0 }
		},
		minHeight = -10,
		maxHeight = 0,
		ceiling = 20,
		heaviness = 0.5
	})

	local sistineLayer, sistineScript = Utility.Map.spawnMap(
		self, "EmptyRuins_SistineOfTheSimulacrum_Outside", Downtown.SISTINE_LOCATION, { isLayer = true })
	self.sistineLayer = sistineLayer

	Utility.Map.spawnMap(self, "EmptyRuins_Downtown_Floor2", Vector(0, 4, 0), { isLayer = true })
	Utility.Map.spawnMap(self, "EmptyRuins_Downtown_Floor3", Vector(0, 7, 0), { isLayer = true })
end

function Downtown:onPlayerEnter(player)
	self:prepareDebugCutscene(player:getActor():getPeep())
end

function Downtown:prepareDebugCutscene(player)
	local function actionCallback(action)
		if action == "pressed" then
			self:pushPoke('startWar', player)
		end
	end

	local function openCallback()
		return not self:wasPoofed()
	end

	Utility.UI.openInterface(
		player,
		"KeyboardAction",
		false,
		"DEBUG_TRIGGER_1", actionCallback, openCallback)
end

function Downtown:onStartWar(player)
	local map = self:getDirector():getMap(self:getLayer())
	if not map then
		return
	end

	local rng = love.math.newRandomGenerator()

	for _ = 1, self.NUM_SKIRMISHES do
		local i, j = Utility.Map.getRandomTile(map, 1, 1, math.huge, false, rng, { 'impassable', 'blocking', 'door', 'building' })
		if not (i and j) then
			break
		end

		local position = map:getTileCenter(i, j)
		local yendorianActor = Utility.spawnActorAtPosition(
			self,
			self.YENDORIAN_SOLDIERS[rng:random(#self.YENDORIAN_SOLDIERS)],
			position:get())

		map:getTile(i, j):setRuntimeFlag("blocking")

		for k = 1, love.math.random(self.MIN_EMPTY_KING_SOLDIERS, self.MAX_EMPTY_KING_SOLDIERS) do
			local soldierI, soldierJ = Utility.Map.getRandomTile(map, i, j, 3, true, rng)
			if not soldierI and soldierJ then
				break
			end

			local soldierActor = Utility.spawnActorAtPosition(
				self,
				self.EMPTY_KING_SOLDIERS[rng:random(#self.EMPTY_KING_SOLDIERS)],
				position:get())

			self:pushPoke(love.math.random() * 5, "engageSoldiers", soldierActor:getPeep(), yendorianActor:getPeep())
		end
	end
end

function Downtown:onEngageSoldiers(a, b)
	if a:getIsReady() and b:getIsReady() then
		Utility.Peep.attack(a, b)
	else
		self:pushPoke(love.math.random() * 5, "engageSoldiers", a, b)
	end
end

return Downtown
