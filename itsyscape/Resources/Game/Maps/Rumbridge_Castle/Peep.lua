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
local Vector = require "ItsyScape.Common.Math.Vector"
local Utility = require "ItsyScape.Game.Utility"
local Map = require "ItsyScape.Peep.Peeps.Map"
local InstancedBehavior = require "ItsyScape.Peep.Behaviors.InstancedBehavior"
local Probe = require "ItsyScape.Peep.Probe"

local Castle = Class(Map)
Castle.PARTY_PEEPS = 15

Castle.PARTY_MAX_RADIUS_I = 4
Castle.PARTY_MIN_RADIUS_I = 2

Castle.PARTY_MIN_RADIUS_J = 1
Castle.PARTY_MAX_RADIUS_J = 2

function Castle:new(resource, name, ...)
	Map.new(self, resource, name or 'RumbridgeCastle', ...)
end

function Castle:openAllDoors()
	local hits = self:getDirector():probe(
		self:getLayerName(),
		Probe.resource("Prop", "Door_RumbridgeCastle"))

	for _, hit in ipairs(hits) do
		hit:poke('open')
	end
end

function Castle:incrementSuperSupperSaboteurDialogTick()
	local tick = self.currentDialogTick or 1
	self.currentDialogTick = tick + 1

	return tick
end

function Castle:spawnSuperSupperSaboteurParty(player, earl)
	local map = Utility.Peep.getMapResource(self)
	local center = Vector(
		Utility.Map.getAnchorPosition(self:getDirector():getGameInstance(), map, "Anchor_EarlReddick"))

	local taken = {}
	for i = 1, Castle.PARTY_PEEPS do
		local offsetI, offsetJ

		local isTaken = false
		repeat
			offsetI = love.math.random(Castle.PARTY_MIN_RADIUS_I, Castle.PARTY_MAX_RADIUS_I)
			if love.math.random(2) % 2 == 0 then
				offsetI = -offsetI
			end

			offsetJ = love.math.random(Castle.PARTY_MIN_RADIUS_J, Castle.PARTY_MAX_RADIUS_J)
			if love.math.random(2) % 2 == 0 then
				offsetJ = -offsetJ
			end

			for _, t in ipairs(taken) do
				local i, j = unpack(taken)

				if i == offsetI and j == offsetJ then
					isTaken = true
					break
				end
			end
		until not isTaken

		table.insert(taken, { offsetI, offsetJ })

		local layer = Utility.Peep.getLayer(earl)
		local _, i, j = self:getDirector():getMap(layer):getTileAt(center.x, center.z)
		i = i + offsetI
		j = j + offsetJ

		if self:getDirector():getMap(layer):getTile(i, j):getIsPassable() then
			local position = Utility.Map.getTilePosition(self:getDirector(), i, j, layer)

			local actor = Utility.spawnActorAtPosition(self, "RandomHuman", position.x, position.y, position.z, 0.25)
			local actorPeep = actor and actor:getPeep()

			if actorPeep then
				local _, instance = actorPeep:addBehavior(InstancedBehavior)
				instance.playerID = player:getID()

				actorPeep:listen("finalize", function()
					Utility.Peep.face(actorPeep, earl)
				end)
			end
		end
	end
end

function Castle:onPlaySuperSupperSaboteurCutscene(player, cutsceneName)
	local playerPeep = player:getActor():getPeep()

	Log.info("Playing cutscene '%s' for player '%s'.", cutsceneName, playerPeep:getName())

	local cutscene = Utility.Map.playCutscene(self, cutsceneName, "StandardCutscene", playerPeep)
	cutscene:listen('done', function()
		playerPeep:getState():give("KeyItem", "SuperSupperSaboteur_Complete")
		Utility.Quest.complete("SuperSupperSaboteur", playerPeep)

		local stage = self:getDirector():getGameInstance():getStage()
		stage:movePeep(playerPeep, "Rumbridge_Castle", Utility.Peep.getPosition(playerPeep))

		Utility.UI.openGroup(playerPeep, Utility.UI.Groups.WORLD)
	end)
end

function Castle:onPerformSupperSaboteurNamedAction(player, namedMapAction)
	local playerPeep = player:getActor():getPeep()
	local director = self:getDirector()
	local game = director:getGameInstance()
	local gameDB = game:getGameDB()

	local namedMapAction = gameDB:getRecord("NamedMapAction", {
		Name = namedMapAction,
		Map = Utility.Peep.getMapResource(self)
	})

	local chef = director:probe(
		self:getLayerName(),
		Probe.namedMapObject("ChefAllon"),
		Probe.instance(player))[1]
	if not chef then
		Log.warn("Couldn't find Chef Allon for player '%s'.", playerPeep:getName())
	end

	local action = Utility.getAction(game, namedMapAction:get("Action"))
	action.instance:perform(playerPeep:getState(), playerPeep, chef)
end

function Castle:initSuperSupperSaboteurInstance(player)
	local playerPeep = player:getActor():getPeep()

	local temporaryStorage = Utility.Peep.getTemporaryStorage(playerPeep):getSection("SuperSupperSaboteur")
	local performNamedMapAction = temporaryStorage:get("performNamedAction")
	temporaryStorage:set("performNamedAction", nil)

	local isQuestCutscene = self:getArguments() and self:getArguments()["super_supper_saboteur"] ~= nil

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
		Log.info("Butler Lear is dead for player '%s'!", playerPeep:getName())

		local oliverActor = Utility.spawnMapObjectAtAnchor(self, "Oliver", "Anchor_Oliver", 0)
		local oliverPeep = oliverActor and oliverActor:getPeep()
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
		local guardCaptainPeep = guardCaptainActor and guardCaptainActor:getPeep()

		if not guardCaptainPeep then
			Log.warn("Couldn't spawn guard captain for player '%s'.", playerPeep:getName())
		else
			Log.info("Spawned guard captain for player '%s'.", playerPeep:getName())

			local _, instance = guardCaptainPeep:addBehavior(InstancedBehavior)
			instance.playerID = player:getID()
		end

		if performNamedMapAction then
			self:pushPoke('performSupperSaboteurNamedAction', player, namedMapAction)
		end
	end

	if isQuestCutscene then
		self:openAllDoors()

		if Utility.Quest.isNextStep(quest, "SuperSupperSaboteur_Complete", playerPeep) then
			local earlActor = Utility.spawnMapObjectAtAnchor(self, "EarlReddick", "Anchor_EarlReddick", 0)
			local earlPeep = earlActor and earlActor:getPeep()
			if not earlPeep then
				Log.warn("Couldn't spawn Earl Reddick for player '%s'.", playerPeep:getName())
			else
				Log.info("Spawned Earl Reddick for player '%s'.", playerPeep:getName())

				local _, instance = earlPeep:addBehavior(InstancedBehavior)
				instance.playerID = player:getID()
			end

			local guardActor = Utility.spawnMapObjectAtAnchor(self, "GuardCaptain", "Anchor_EarlReddick_Guard", 0)
			local guardPeep = guardActor and guardActor:getPeep()
			if not earlPeep then
				Log.warn("Couldn't spawn Guard Captain for player '%s'.", playerPeep:getName())
			else
				Log.info("Spawned Guard Captain for player '%s'.", playerPeep:getName())

				local _, instance = earlPeep:addBehavior(InstancedBehavior)
				instance.playerID = player:getID()
			end

			self:spawnSuperSupperSaboteurParty(player, earlPeep)

			Utility.UI.closeAll(playerPeep)

			local isGoingToDie = playerPeep:getState():has("KeyItem", "SuperSupperSaboteur_LitKursedCandle")
			local isLyraInJail = playerPeep:getState():has("KeyItem", "SuperSupperSaboteur_BetrayedLyra") or
			                     playerPeep:getState():has("KeyItem", "SuperSupperSaboteur_TurnedInLyra")

			local cutsceneName
			if isGoingToDie then
				if isLyraInJail then
					cutsceneName = "Rumbridge_Castle_EarlReddickDies_DoubleCross"
				else
					cutsceneName = "Rumbridge_Castle_EarlReddickDies"
				end
			else
				cutsceneName = "Rumbridge_Castle_EarlReddickLives"
			end

			self:pushPoke('playSuperSupperSaboteurCutscene', player, cutsceneName)
		else
			self:pushPoke('performSupperSaboteurNamedAction', player, "StartSuperSupperSaboteurCutscene")
		end
	end
end

function Castle:onPlayerEnter(player)
	self:trySpawnChef(player)
	self:initSuperSupperSaboteurInstance(player)
end

function Castle:trySpawnChef(player)
	local playerPeep = player:getActor():getPeep()
	local isQuestComplete = playerPeep:getState():has("Quest", "SuperSupperSaboteur")
	local isLyraInJail = playerPeep:getState():has("KeyItem", "SuperSupperSaboteur_BetrayedLyra") or
	                     playerPeep:getState():has("KeyItem", "SuperSupperSaboteur_TurnedInLyra")
    local playerLitKursedCandle = playerPeep:getState():has("KeyItem", "SuperSupperSaboteur_LitKursedCandle")
    local isInJail = not isLyraInJail and playerLitKursedCandle and isQuestComplete

    if isInJail then
    	Log.info("Chef Allon is in jail for player '%s'; not spawning in kitchen.", playerPeep:getName())
    	return
    end

	local gameDB = self:getDirector():getGameDB()
	local chefResource = gameDB:getResource("ChefAllon", "Peep")
	if not chefResource then
		Log.warn(
			"Couldn't get resource in Rumbridge Dungeon (Chef = %s).",
			Log.boolean(chefResource))
		return
	end

	local chefActor = Utility.spawnMapObjectAtAnchor(self, "ChefAllon", "Anchor_ChefAllon", 0)
	local _, instance = chefActor:getPeep():addBehavior(InstancedBehavior)
	instance.playerID = player:getID()

	Log.info("Spawned Chef Allon in kitchen for player '%s'.", playerPeep:getName())

	self:initSuperSupperSaboteur(chefActor:getPeep())
end

function Castle:initSuperSupperSaboteur(chef)
	local director = self:getDirector()

	if chef then
		chef:listen('acceptQuest', self.onContinueSuperSupperSaboteur, self)
	else
		Log.warn("Chef Allon not found; cannot init quest Super Supper Saboteur.")
	end
end

function Castle:onContinueSuperSupperSaboteur(player)
	self:pushPoke(
		'performSupperSaboteurNamedAction',
		Utility.Peep.getPlayerModel(player),
		"StartSuperSupperSaboteur")
end

return Castle
