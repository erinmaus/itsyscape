--------------------------------------------------------------------------------
-- Resources/Game/Maps/Rumbridge_Castle/Peep.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Utility = require "ItsyScape.Game.Utility"
local Map = require "ItsyScape.Peep.Peeps.Map"
local InstancedBehavior = require "ItsyScape.Peep.Behaviors.InstancedBehavior"
local Probe = require "ItsyScape.Peep.Probe"

local Castle = Class(Map)

function Castle:new(resource, name, ...)
	Map.new(self, resource, name or 'RumbridgeCastle', ...)

	self:addPoke('continueSuperSupperSaboteur')
end

function Castle:onFinalize(director, game)
	self:initSuperSupperSaboteur()
end

function Castle:initSuperSupperSaboteurInstance(player)
	local isQuestCutscene = self:getArguments() and self:getArguments()["super_supper_saboteur"] ~= nil

	local playerPeep = player:getActor():getPeep()
	if playerPeep:getState():has("KeyItem", "SuperSupperSaboteur_ButlerDied") then
		Log.info("Butler Lear has died for player '%s'; not spawning.", playerPeep:getName())
	else
		local butlerActor = Utility.spawnMapObjectAtAnchor(self, "ButlerLear", "Anchor_ButlerLear", 0)
		local butlerPeep = butlerActor and butlerActor:getPeep()
		if not butlerPeep then
			Log.warn("Couldn't spawn Butler Lear for player '%s'.", playerPeep:getName())
		else
			Log.info("Spawned Butler Lear for player '%s'.", playerPeep:getName())
			local _, instance = butlerPeep:addBehavior(InstancedBehavior)
			instance.playerID = player:getID()
		end
	end

	local quest = Utility.Quest.build("SuperSupperSaboteur", self:getDirector():getGameDB())
	if isQuestCutscene and
	   (Utility.Quest.isNextStep(quest, "SuperSupperSaboteur_ButlerDied", playerPeep) or
	   Utility.Quest.isNextStep(quest, "SuperSupperSaboteur_ButlerInspected", playerPeep))
	then
		Log.info("Buter Lear is dead for player '%s'!", playerPeep:getName())

		local oliverActor = Utility.spawnMapObjectAtAnchor(self, "Oliver", "Anchor_Oliver", 0)
		local oliverPeep = oliverPeep and oliverPeep:getPeep()
		if not oliverPeep then
			Log.warn("Couldn't spawn mysterious dog AKA Oliver for player '%s'.", playerPeep:getName())
		else
			Log.info("Spawned mysterious dog AKA Oliver for player '%s'.", playerPeep:getName())

			local _, instance = oliverPeep:addBehavior(InstancedBehavior)
			instance.playerID = player:getID()
		end
	end

	if not isQuestCutscene and
	   Utility.Quest.isNextStep(quest, "SuperSupperSaboteur_TalkedToGuardCaptain", playerPeep)
	then
		local guardCaptainActor = Utility.spawnMapObjectAtAnchor(self, "GuardCaptain", "Anchor_GuardCaptain", 0)
		local guardCaptainPeep = guardCaptainPeep and guardCaptainPeep:getPeep()

		if not guardCaptainPeep then
			Log.warn("Couldn't spawn guard captain for player '%s'.", playerPeep:getName())
		else
			Log.info("Spawned guard captain for player '%s'.", playerPeep:getName())

			local _, instance = guardCaptainPeep:addBehavior(InstancedBehavior)
			instance.playerID = player:getID()
		end
	end

	if isQuestCutscene then
		local director = self:getDirector()
		local game = director:getGameInstance()
		local gameDB = game:getGameDB()

		local namedMapAction = gameDB:getRecord("NamedMapAction", {
			Name = "StartSuperSupperSaboteurCutscene",
			Map = Utility.Peep.getMapResource(self)
		})

		local chef = director:probe(
			self:getLayerName(),
			Probe.namedMapObject("ChefAllon"))[1]

		local action = Utility.getAction(game, namedMapAction:get("Action"))
		action.instance:perform(playerPeep:getState(), playerPeep, chef)
	end
end

function Castle:onPlayerEnter(player)
	self:initSuperSupperSaboteurInstance(player)
end

function Castle:initSuperSupperSaboteur()
	local director = self:getDirector()

	local chef = director:probe(
		self:getLayerName(),
		Probe.namedMapObject("ChefAllon"))[1]
	if chef then
		chef:listen('acceptQuest', self.onContinueSuperSupperSaboteur, self)
	else
		Log.warn("Chef Allon not found; cannot init quest Super Supper Saboteur.")
	end
end

function Castle:onContinueSuperSupperSaboteur(chef, player)
	local director = self:getDirector()
	local game = director:getGameInstance()
	local gameDB = director:getGameDB()
	local map = Utility.Peep.getMapResource(self)

	local namedMapAction = gameDB:getRecord("NamedMapAction", {
		Name = "StartSuperSupperSaboteur",
		Map = map
	})

	if not namedMapAction then
		Log.warn("Couldn't talk to Chef Allon after starting quest: named map action not found.")
	else
		print(">>> continue", chef:getName(), player:getName())
		local action = Utility.getAction(game, namedMapAction:get("Action"))
		action.instance:perform(player:getState(), player, chef)
	end
end

return Castle
