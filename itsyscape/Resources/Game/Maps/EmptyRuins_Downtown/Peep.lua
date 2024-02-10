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
local AttackPoke = require "ItsyScape.Peep.AttackPoke"
local Probe = require "ItsyScape.Peep.Probe"
local ActorReferenceBehavior = require "ItsyScape.Peep.Behaviors.ActorReferenceBehavior"
local CombatStatusBehavior = require "ItsyScape.Peep.Behaviors.CombatStatusBehavior"
local CombatTargetBehavior = require "ItsyScape.Peep.Behaviors.CombatTargetBehavior"
local MashinaBehavior = require "ItsyScape.Peep.Behaviors.MashinaBehavior"
local PositionBehavior = require "ItsyScape.Peep.Behaviors.PositionBehavior"
local TeleportalBehavior = require "ItsyScape.Peep.Behaviors.TeleportalBehavior"

local Downtown = Class(Map)
Downtown.SISTINE_LOCATION = Vector(0, 4, -97)

Downtown.SKIRMISHES = {
	["Anchor_SkirmishBallista"] = {
		yendorian = "Yendorian_Ballista",
		soldiers = {
			"PrestigiousAncientSkeleton",
			"PrestigiousAncientSkeleton",
			"Tinkerer"
		}
	},

	["Anchor_SkirmishSwordfish"] = {
		yendorian = "Yendorian_Swordfish",
		soldiers = {
			"PrestigiousMummy",
			"GoryMass",
			"Tinkerer"
		}
	},

	["Anchor_SkirmishMast"] = {
		yendorian = "Yendorian_Mast",
		soldiers = {
			"GoryMass",
			"Tinkerer",
			"Tinkerer"
		}
	}
}

Downtown.SKIRMISH_DISTANCE = 2.5

function Downtown:new(resource, name, ...)
	Map.new(self, resource, name or "EmptyRuins_Downtown", ...)

	self.cutsceneState = {}
end

function Downtown:onLoad(filename, args, layer)
	Map.onLoad(self, filename, args, layer)

	if args.cutscene then
		self:silence('playerEnter', Map.showPlayerMapInfo)
	end

	local stage = self:getDirector():getGameInstance():getStage()
	stage:forecast(layer, "EmptyRuins_Downtown_Bubbles", "Fungal", {
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
	local playerPeep = player:getActor():getPeep()
	self:prepareDebugCutscene(playerPeep)

	local args = self:getArguments() or {}
	if args.cutscene then
		self:pushPoke("prepareCutscene", playerPeep)
	end
end

function Downtown:onPlayerLeave(player)
	self.cutsceneState[player:getActor():getPeep()] = nil
end

function Downtown:prepareDebugCutscene(player)
	local function actionCallback(action)
		if action == "pressed" then
			self:pushPoke("prepareCutscene", player)
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

function Downtown:onPrepareCutscene(player)
	if not self.cutsceneState[player] then
		self:prepareDowntownCutscene(player)
		self:prepareSistineCutscene(player)
	end

	self:pushPoke("playSistineCutscene", player, "EmptyRuins_SistineOfTheSimulacrum_Outside_Intro")
end

function Downtown:prepareDowntownCutscene(player)
	local state = {}

	local map = Utility.Peep.getMap(self)
	local mapResource = Utility.Peep.getMapResource(self)

	for anchor, info in pairs(self.SKIRMISHES) do
		local skirmish = { soldiers = {} }

		local yendorian = Utility.spawnMapObjectAtAnchor(self, info.yendorian, anchor)
		yendorian = yendorian and yendorian:getPeep()
		skirmish.yendorian = yendorian
		if yendorian then
			yendorian:removeBehavior(MashinaBehavior)
		end

		local position = Vector(Utility.Map.getAnchorPosition(self:getDirector():getGameInstance(), mapResource, anchor))
		for index, soldierMapObjectName in ipairs(info.soldiers) do
			local angle = index / #info.soldiers * math.pi * 2

			local x = math.cos(angle) * self.SKIRMISH_DISTANCE + position.x
			local z = math.sin(angle) * self.SKIRMISH_DISTANCE + position.z
			local y = map:getInterpolatedHeight(x, z)

			local soldier = Utility.spawnMapObjectAtPosition(self, soldierMapObjectName, x, y, z)
			soldier = soldier and soldier:getPeep()

			if soldier then
				soldier:removeBehavior(MashinaBehavior)
				table.insert(skirmish.soldiers, soldier)
			end
		end

		table.insert(state, skirmish)
	end

	self.cutsceneState[player] = state
end

function Downtown:prepareSistineCutscene()
	local instance = Utility.Peep.getInstance(self)
	local sistineMapScript = instance:getMapScriptByMapFilename("EmptyRuins_SistineOfTheSimulacrum_Outside")

	if not sistineMapScript then
		return
	end

	Utility.spawnMapObjectAtPosition(sistineMapScript, "CameraDolly", 0, 0, 0)
	Utility.spawnMapObjectAtAnchor(sistineMapScript, "TheEmptyKing", "Anchor_TheEmptyKing")
	Utility.spawnMapObjectAtAnchor(sistineMapScript, "Gottskrieg", "Anchor_Gottskrieg")
	Utility.spawnMapObjectAtAnchor(sistineMapScript, "Yendor", "Anchor_Yendor")
end

function Downtown:onPlayDowntownCutscene(peep, cutscene)
	Utility.UI.closeAll(peep, nil, { "CutsceneTransition" })

	local cutscene = Utility.Map.playCutscene(self, cutscene, "StandardCutscene")
	cutscene:listen("done", self.onFinishCutscene, self, peep)
end

function Downtown:onPlaySistineCutscene(peep, cutscene)
	local instance = Utility.Peep.getInstance(self)
	local sistineMapScript = instance:getMapScriptByMapFilename("EmptyRuins_SistineOfTheSimulacrum_Outside")

	if not sistineMapScript then
		return
	end

	Utility.UI.closeAll(peep, nil, { "CutsceneTransition" })

	Utility.Map.playCutscene(sistineMapScript, cutscene, "StandardCutscene", peep)
end

function Downtown:onCutsceneAttack(peep)
	for _, state in pairs(self.cutsceneState) do
		for _, skirmish in ipairs(state) do
			if skirmish.yendorian == peep then
				for _, soldier in ipairs(skirmish.soldiers) do
					Utility.Peep.attack(soldier, skirmish.yendorian)
				end

				Utility.Peep.attack(skirmish.yendorian, skirmish.soldiers[#skirmish.soldiers])
			end
		end
	end
end

function Downtown:onCutsceneKill(peep)
	local actor = peep:getBehavior(ActorReferenceBehavior)
	actor = actor and actor.actor

	local hits = self:getDirector():probe(
		self:getLayerName(),
		function(p)
			local target = p:getBehavior(CombatTargetBehavior)
			return target and target.actor == actor
		end)

	table.insert(hits, peep)

	local stage = self:getDirector():getGameInstance():getStage()
	for _, hit in ipairs(hits) do
		hit:poke("hit", AttackPoke({ damage = love.math.random(5000, 10000) }))
		stage:fireProjectile("SnipeSplosion", Vector.ZERO, hit)
	end
end

function Downtown:onFinishCutscene(player)
	Utility.UI.openGroup(
		player,
		Utility.UI.Groups.WORLD)

	self:prepareDebugCutscene(player)
end

return Downtown
