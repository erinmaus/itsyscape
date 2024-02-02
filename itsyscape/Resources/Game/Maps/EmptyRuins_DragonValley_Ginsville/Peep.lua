--------------------------------------------------------------------------------
-- Resources/Game/Maps/EmptyRuins_DragonValley_Ginsville/Peep.lua
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
local InventoryBehavior = require "ItsyScape.Peep.Behaviors.InventoryBehavior"

local Ginsville = Class(Map)

function Ginsville:new(resource, name, ...)
	Map.new(self, resource, name or 'EmptyRuins_DragonValley_Ginsville', ...)
end

function Ginsville:onLoad(filename, args, layer)
	Map.onLoad(self, filename, args, layer)

	local stage = self:getDirector():getGameInstance():getStage()
	stage:forecast(layer, 'EmptyRuins_DragonValley_Ginsville_Ash', 'Fungal', {
		gravity = { 0, -0.5, 0 },
		wind = { 1, -2, -1 },
		colors = {
			{ 0.1, 0.1, 0.1, 1.0 },
			{ 0.1, 0.1, 0.1, 1.0 },
			{ 0.1, 0.1, 0.1, 1.0 },
			{ 1.0, 0.4, 0.0, 1.0 },
			{ 1.0, 0.5, 0.0, 1.0 },
			{ 0.9, 0.4, 0.0, 0.0 },
		},
		minHeight = 20,
		maxHeight = 25,
		heaviness = 0.5,
		init = true
	})

	self:initBoss()
end

function Ginsville:initBoss()
	local experimentX = self:getDirector():probe(
		self:getLayerName(),
		Probe.namedMapObject("ExperimentX"))[1]
	local tinkerer = self:getDirector():probe(
		self:getLayerName(),
		Probe.namedMapObject("Tinkerer"))[1]

	if not experimentX or not tinkerer then
		return
	end

	local function onDie()
		local stage = self:getDirector():getGameInstance():getStage()
		stage:playMusic(self:getLayer(), "main", "PreTutorial")

		tinkerer:silence("die", onDie)
	end
	tinkerer:listen("die", onDie)

	local function onBoss()
		local stage = self:getDirector():getGameInstance():getStage()
		stage:playMusic(self:getLayer(), "main", "BossFight1")

		experimentX:silence("boss", onBoss)
	end
	experimentX:listen("boss", onBoss)
end

function Ginsville:onPlayerEnter(player)
	self:prepareDebugCutscene(player:getActor():getPeep())
end

function Ginsville:prepareDebugCutscene(player)
	local function actionCallback(action)
		if action == "pressed" then
			self:pushPoke('prepareCutscene', player)
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

function Ginsville:onPrepareCutscene(player)
	do
		local CombatTargetBehavior = require "ItsyScape.Peep.Behaviors.CombatTargetBehavior"
		local MashinaBehavior = require "ItsyScape.Peep.Behaviors.MashinaBehavior"

		local hits = self:getDirector():probe(
			self:getLayerName(),
			function(peep)
				return peep:hasBehavior(MashinaBehavior) or peep:hasBehavior(CombatTargetBehavior)
			end)

		for _, hit in ipairs(hits) do
			hit:removeBehavior(CombatTargetBehavior)
			hit:removeBehavior(MashinaBehavior)

			hit:silence("receiveAttack", Utility.Peep.Attackable.onReceiveAttack)
			hit:silence("receiveAttack", Utility.Peep.Attackable.aggressiveOnReceiveAttack)
		end

		hits = self:getDirector():probe(
			self:getLayerName(),
			Probe.resource("Prop", "PetrifiedSpiderTree_Default"))

		for _, hit in ipairs(hits) do
			local position = Utility.Peep.getPosition(hit)
			Utility.spawnPropAtPosition(self, "OakTree_Default", position:get())

			Utility.Peep.poof(hit)
		end
	end

	Utility.spawnMapObjectAtPosition(self, "Trailer_GoryMass", Vector.ZERO:get())
	Utility.spawnMapObjectAtPosition(self, "Trailer_SurgeonZombi", Vector.ZERO:get())
	Utility.spawnMapObjectAtPosition(self, "Trailer_CameraDolly", Vector.ZERO:get())
	Utility.spawnMapObjectAtPosition(self, "Trailer_FleshyPillar", Vector.ZERO:get())

	self:pushPoke("playCutscene", player)
end

function Ginsville:onPlayCutscene(player)
	Utility.UI.closeAll(player)

	local cutscene = Utility.Map.playCutscene(self, "EmptyRuins_DragonValley_Ginsville_Trailer", "StandardCutscene", player)
	cutscene:listen('done', self.onFinishCutscene, self, player)
end

function Ginsville:onFinishCutscene(player)
	Utility.UI.openGroup(
		player,
		Utility.UI.Groups.WORLD)

	self:prepareDebugCutscene(player)
end

function Ginsville:onDarken(near, far)
	local fog = self:getDirector():probe(
		self:getLayerName(),
		Probe.resource("Prop", "Fog_Default"))

	for _, f in ipairs(fog) do
		f:setNearDistance(near)
		f:setFarDistance(far)
		f:setFollowEye()
	end
end

function Ginsville:onLighten(near, far)
	local fog = self:getDirector():probe(
		self:getLayerName(),
		Probe.resource("Prop", "Fog_Default"))

	for _, f in ipairs(fog) do
		f:setNearDistance(near)
		f:setFarDistance(far)
		f:setFollowTarget()
	end
end

return Ginsville
