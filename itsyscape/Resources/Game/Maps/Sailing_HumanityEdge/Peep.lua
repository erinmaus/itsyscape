--------------------------------------------------------------------------------
-- Resources/Game/Maps/Sailing_HumanityEdge/Peep.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Quaternion = require "ItsyScape.Common.Math.Quaternion"
local Vector = require "ItsyScape.Common.Math.Vector"
local Utility = require "ItsyScape.Game.Utility"
local Weapon = require "ItsyScape.Game.Weapon"
local Sailing = require "ItsyScape.Game.Skills.Sailing"
local Color = require "ItsyScape.Graphics.Color"
local CallbackCommand = require "ItsyScape.Peep.CallbackCommand"
local CompositeCommand = require "ItsyScape.Peep.CompositeCommand"
local Probe = require "ItsyScape.Peep.Probe"
local WaitCommand = require "ItsyScape.Peep.WaitCommand"
local AggressiveBehavior = require "ItsyScape.Peep.Behaviors.AggressiveBehavior"
local CombatStatusBehavior = require "ItsyScape.Peep.Behaviors.CombatStatusBehavior"
local FollowerBehavior = require "ItsyScape.Peep.Behaviors.FollowerBehavior"
local ImmortalBehavior = require "ItsyScape.Peep.Behaviors.ImmortalBehavior"
local OceanBehavior = require "ItsyScape.Peep.Behaviors.OceanBehavior"
local MapOffsetBehavior = require "ItsyScape.Peep.Behaviors.MapOffsetBehavior"
local TeamBehavior = require "ItsyScape.Peep.Behaviors.TeamBehavior"
local TeamsBehavior = require "ItsyScape.Peep.Behaviors.TeamsBehavior"
local ShipMovementBehavior = require "ItsyScape.Peep.Behaviors.ShipMovementBehavior"
local MapScript = require "ItsyScape.Peep.Peeps.Map"
local TutorialCommon = require "Resources.Game.Peeps.Tutorial.Common"

local Island = Class(MapScript)

Island.ALL_INVENTORY = {
	{ id = "IsabelliumGloves", count = 1 },
	{ id = "IsabelliumBoots", count = 1 },
	{ id = "IsabelliumHelmet", count = 1 },
	{ id = "IsabelliumPlatebody", count = 1 },
	{ id = "CookedLightningStormfish", count = 4 }
}

Island.CLASS_INVENTORY = {
	[Weapon.STYLE_MAGIC] = {
		{ id = "IsabelliumStaff", count = 1 },
		{ id = "AirRune", count = 1 },
		{ id = "FireRune", count = 1 }
	},

	[Weapon.STYLE_ARCHERY] = {
		{ id = "IsabelliumLongbow", count = 1 }
	},

	[Weapon.STYLE_MELEE] = {
		{ id = "IsabelliumZweihander", count = 1 }
	}
}

Island.FISHING_INVENTORY = {
	{ id = "SpindlyFishingRod", count = 1 },
	{ id = "WaterWorm", count = 150 }
}

function Island:new(resource, name, ...)
	MapScript.new(self, resource, name or "Sailing_HumanityEdge", ...)

	local _, ocean = self:addBehavior(OceanBehavior)
	self:silence("playerEnter", MapScript.showPlayerMapInfo)

	self.playersInTutorial = {}
end

function Island:onLoad(...)
	MapScript.onLoad(self, ...)

	Utility.Map.spawnMap(self, "Test123_Storm", Vector.ZERO, { isLayer = true })

	local stage = self:getDirector():getGameInstance():getStage()
	stage:forecast(self:getLayer(), "Sailing_HumanityEdge_Rain", "Rain", {
		wind = { -15, 0, 0 },
		gravity = { 0, -50, 0 },
		heaviness = 1 / 2,
		color = { Color.fromHexString("aaeeff", 0.8):get() },
		size = 1 / 32
	})
end

function Island:_giveItems(playerPeep, items)
	local hasFlags = {
		["item-equipment"] = true,
		["item-inventory"] = true
	}

	local giveFlags = {
		["item-inventory"] = true,
		["item-drop-excess"] = true
	}

	local hasItemsOnGround, groundInventory = TutorialCommon.hasPeepDroppedItems(playerPeep)
	local playerPeepState = playerPeep:getState()
	for _, item in ipairs(items) do
		local count = playerPeepState:count("Item", item.id, hasFlags)
		for _, groundItem in ipairs(groundInventory) do
			if groundItem:getID() == item.id then
				count = count + groundItem:getCount()
			end
		end

		if count < item.count then
			playerPeepState:give("Item", item.id, item.count - count, giveFlags)
		end
	end
end

function Island:_giveTutorialRequiredItems(playerPeep)
	local class = Utility.Text.getDialogVariable(playerPeep, "Orlando", "quest_tutorial_main_starting_player_class")
	self:_giveItems(playerPeep, self.ALL_INVENTORY)
	self:_giveItems(playerPeep, self.CLASS_INVENTORY[class] or self.CLASS_INVENTORY[Weapon.STYLE_MAGIC])

	if Utility.Quest.didStep("Tutorial", "Tutorial_DefeatedYenderhounds", playerPeep) then
		self:_giveItems(playerPeep, self.FISHING_INVENTORY)
	end
end

function Island:_dropPlayerInventory(playerPeep)
	local stage = playerPeep:getDirector():getGameInstance():getStage()

	local itemsToDrop = Utility.Peep.getInventory(playerPeep)
	for _, item in ipairs(itemsToDrop) do
		stage:dropItem(item, item:getCount(), playerPeep)
	end
end

function Island:doTalkToPeep(playerPeep, otherPeepName, callback, entryPoint, enabled)
	local success, dialog = Utility.Peep.dialog(playerPeep, "Talk", otherPeepName, entryPoint)
	if success then
		if not enabled then
			Utility.Peep.disable(playerPeep)

			dialog.onClose:register(function()
				Utility.Peep.enable(playerPeep)
			end)
		end

		if callback then
			dialog.onClose:register(callback)
		end
	else
		if callback then
			callback()
		end
	end

	return success
end

function Island:talkToPeep(playerPeep, otherPeepName, callback, entryPoint, enabled)
	local otherPeep = self:getCompanion(playerPeep, otherPeepName)

	local function wrappedCallback()
		local mashinaState = Utility.Peep.getMashinaState(otherPeep)
		if not mashinaState then
			Utility.Peep.setMashinaState(otherPeep, "tutorial-follow-player")
		end

		if callback then
			callback(playerPeep, otherPeep)
		end
	end

	if otherPeep then
		Utility.Peep.setMashinaState(otherPeep, false)
		Utility.Combat.disengage(otherPeep)
		otherPeep:getCommandQueue():interrupt()

		local i, j, k = Utility.Peep.getTile(playerPeep)
		if Utility.Peep.walk(otherPeep, i, j, k, 3, { asCloseAsPossible = false }) then
			otherPeep:getCommandQueue():push(CallbackCommand(self.doTalkToPeep, self, playerPeep, otherPeepName, wrappedCallback, entryPoint))
			return true
		end
	end

	return self:doTalkToPeep(playerPeep, otherPeepName, wrappedCallback, entryPoint, enabled)
end

function Island:onInitScoutTutorial(playerPeep)
	TutorialCommon.listenForAttack(playerPeep)
end

function Island:onPlayFoundScoutCutscene(playerPeep)
	Utility.Peep.disable(playerPeep)
	Utility.UI.closeAll(playerPeep)

	local cutscene = Utility.Map.playCutscene(self, "Sailing_HumanityEdge_FoundScout", "StandardCutscene", playerPeep)
	cutscene:listen("done", self.onFinishCutscene, self, playerPeep, function()
		self:transitionTutorial(playerPeep, "Tutorial_FoundScout")
		self:saveTutorialLocation(playerPeep, "Anchor_EncounterYendorianScout")

		Utility.Peep.disable(playerPeep)
		self:talkToPeep(playerPeep, "Orlando", function()
			Utility.Peep.enable(playerPeep)
		end)
	end)
end

function Island:onPlayFlareCutscene(playerPeep)
	Utility.UI.closeAll(playerPeep)

	local cutscene = Utility.Map.playCutscene(self, "Sailing_HumanityEdge_Flare", "StandardCutscene", playerPeep)
	cutscene:listen("done", self.onFinishCutscene, self, playerPeep, function()
		Utility.Peep.disable(playerPeep)
		self:talkToPeep(playerPeep, "Orlando", function(playerPeep, orlando)
			Utility.Peep.enable(playerPeep)

			self:transitionTutorial(playerPeep, "Tutorial_DefeatedScout")
			self:saveTutorialLocation(playerPeep, "Anchor_DefeatYendorianScout")
		end, "quest_tutorial_main_scout_argument")
	end)
end

function Island:onPlayFoundYenderhoundsCutscene(playerPeep)
	Utility.Peep.disable(playerPeep)
	Utility.UI.closeAll(playerPeep)

	local cutscene = Utility.Map.playCutscene(self, "Sailing_HumanityEdge_FoundYenderhounds", "StandardCutscene", playerPeep)
	cutscene:listen("done", self.onFinishCutscene, self, playerPeep, function()
		Utility.Peep.disable(playerPeep)
		self:talkToPeep(playerPeep, "Orlando", function()
			Utility.Peep.enable(playerPeep)
			self:transitionTutorial(playerPeep, "Tutorial_FoundYenderhounds")
			self:saveTutorialLocation(playerPeep, "Anchor_EncounterYenderhounds")
		end, "quest_tutorial_main_find_yenderhounds.spotted")
	end)
end

function Island:onPlayFoundPiratesCutscene(playerPeep)
	Utility.Peep.disable(playerPeep)
	Utility.Combat.disengage(playerPeep)

	self:talkToPeep(playerPeep, "Orlando", function(playerPeep, orlando)
		Utility.UI.closeAll(playerPeep)

		-- In case the player quits during the middle of the cutscene.
		playerPeep:getState():give("KeyItem", "Tutorial_FoundYendorians")

		local cutscene = Utility.Map.playCutscene(self, "Sailing_HumanityEdge_Peak", "StandardCutscene", playerPeep)
		cutscene:listen("done", self.onFinishCutscene, self, playerPeep, function()
			Utility.Peep.enable(playerPeep)

			self:transitionTutorial(playerPeep, "Tutorial_FoundYendorians")
			self:saveTutorialLocation(playerPeep, "Anchor_VsPirates")
		end, "quest_tutorial_main_scout_argument")
	end)
end

function Island:onPlaySummonKeelhaulerCutscene(playerPeep)
	local stage = self:getDirector():getGameInstance():getStage()
	stage:playMusic(self:getLayer(), "main", "BossFight1")

	Utility.UI.closeAll(playerPeep)
	Utility.Peep.disable(playerPeep)

	self:doTalkToPeep(playerPeep, "CapnRaven", function()
		local cutscene = Utility.Map.playCutscene(self, "Sailing_HumanityEdge_SummonKeelhauler", "StandardCutscene", playerPeep)
		cutscene:listen("done", self.onFinishCutscene, self, playerPeep, nil)
	end, "quest_tutorial_summon_keelhauler")
end

function Island:onSummonKeelhauler(playerPeep)
	local peeps = Utility.spawnInstancedMapGroup(playerPeep, "Tutorial_Keelhauler")

	for _, peep in ipairs(peeps) do
		local resource = Utility.Peep.getResource(peep)
		if resource and resource.name == "Keelhauler" then
			peep:listen("finalize", function()
				Utility.Peep.playAnimation(peep, "x-cutscene", 100, "Keelhauler_Summon")
				Utility.Peep.applyEffect(peep, "Favored", true)
			end)

			peep:listen("die", function()
				self:poke("keelhaulerDie", playerPeep)
			end)
		end
	end
end

function Island:onKnightsAttackPirates(playerPeep)
	local knights = self:getCompanions(playerPeep, "Tutorial_TeamKnights")
	local pirates = self:getCompanions(playerPeep, "Tutorial_BattlePirates")

	local remainingPirates = {}
	for i = 1, #knights do
		local pirate
		if #pirates == 0 then
			pirate = remainingPirates[love.math.random(#remainingPirates)]
		else
			pirate = table.remove(pirates, love.math.random(#pirates))
			table.insert(remainingPirates, pirate)
		end

		Utility.Peep.attack(knights[i], pirate, math.huge)
	end

	local knightCommander = self:getCompanion(playerPeep, "KnightCommander")
	Utility.Peep.attack(knightCommander, remainingPirates[1], math.huge)
end

function Island:onKeelhaulerDie(playerPeep)
	local pirate1 = self:getCompanion(playerPeep, "Battle_ShipPirate1")
	Utility.Peep.setMashinaState(pirate1, false)

	local pirate2 = self:getCompanion(playerPeep, "Battle_ShipPirate2")
	Utility.Peep.setMashinaState(pirate2, false)

	local center = Vector(Utility.Map.getAnchorPosition(
		self:getDirector():getGameInstance(),
		Utility.Peep.getMapResource(self),
		"Anchor_KnightCommander_EngagePirates"))

	local orlando = self:getCompanion(playerPeep, "Orlando")
	Utility.Peep.setMashinaState(orlando, false)

	local knightCommander = self:getCompanion(playerPeep, "KnightCommander")
	Utility.Peep.setPosition(knightCommander, center)
	Utility.Peep.setMashinaState(knightCommander, false)

	local companions = self:getCompanions(playerPeep, "Tutorial_TeamKnights")
	for i, companion in ipairs(companions) do
		local angle = (i - 1) / #companions * math.pi * 2
		local offset = Vector(math.cos(angle) * 8, 0, math.sin(angle) * 8)
		Utility.Peep.setPosition(companion, center + offset)
		Utility.Peep.setMashinaState(companion, false)
		companion:getCommandQueue():interrupt()
	end

	Utility.Peep.disable(playerPeep)
	local cutscene = Utility.Map.playCutscene(self, "Sailing_HumanityEdge_DefeatedKeelhauler", "StandardCutscene", playerPeep)
	cutscene:listen("done", self.onFinishCutscene, self, playerPeep, function()

		Utility.Peep.disable(playerPeep)
		self:talkToPeep(playerPeep, "Orlando", function()
			Utility.Peep.enable(playerPeep)
		end, _ITSYREALM_DEMO and "quest_tutorial_main_finish_demo" or nil)
	end)
end

function Island:onAttackKeelhauler(playerPeep)
	local keelhauler = self:getCompanion(playerPeep, "Keelhauler")
	local orlando = self:getCompanion(playerPeep, "Orlando")

	Utility.Peep.attack(keelhauler, orlando, math.huge)
	Utility.Peep.attack(orlando, keelhauler, math.huge)
	Utility.Peep.applyCooldown(keelhauler)

	Utility.Peep.setMashinaState(keelhauler, "attack-phase-2")
end

function Island:onFinishCutscene(playerPeep, func)
	Utility.Peep.enable(playerPeep)
	Utility.UI.openGroup(playerPeep, Utility.UI.Groups.WORLD)

	if func then
		func()
	end
end

function Island:prepareTutorialPiratePeeps(playerPeep, piratePeeps)
	local class = Utility.Text.getDialogVariable(playerPeep, "Orlando", "quest_tutorial_main_starting_player_class")

	local statBoost1, statBoost2, statBoostSalt
	if class == Weapon.STYLE_ARCHERY then
		statBoost1 = "Archery"
		statBoost2 = "Dexterity"
		statBoostSalt = "DexterousSeaSalt"
	elseif class == Weapon.STYLE_MELEE then
		statBoost1 = "Attack"
		statBoost2 = "Strength"
		statBoostSalt = "WarriorSeaSalt"
	else
		statBoost1 = "Magic"
		statBoost2 = "Wisdom"
		statBoostSalt = "SageSeaSalt"
	end

	local userdata = {
		ItemIngredientsUserdata = {
			{ value = 1, resource = "AllPurposeFlour" },
			{ value = 1, resource = "Butter" },
			{ value = 1, resource = statBoostSalt },
			{ value = 1, resource = "Shrimp" },
			{ value = 1, resource = "SeaBass" },
			{ value = 1, resource = "BlackmeltBass" }
		},

		ItemHealingUserdata = {
			hitpoints = 34
		},

		ItemStatBoostUserdata = {
			[statBoost1] = 7,
			[statBoost2] = 7
		}
	}

	for _, ingredient in ipairs(userdata.ItemIngredientsUserdata) do
		local resource = self:getDirector():getGameDB():getResource(ingredient.resource, "Item")
		local name = Utility.getName(resource, self:getDirector():getGameDB())
		ingredient.name = name or ("*" .. resource.name)
	end

	local numPirates = 0
	local deadNumPirates = 0

	for _, peep in ipairs(piratePeeps) do
		local resource = Utility.Peep.getResource(peep)
		if resource.name == "Pirate_BlackTentacle" then
			numPirates = numPirates + 1

			peep:listen("finalize", function()
				Utility.Item.spawnInPeepInventory(peep, "FishPie", 3, false, userdata)

				peep:listen("die", function()
					deadNumPirates = deadNumPirates + 1
					if deadNumPirates >= numPirates then
						self:pushPoke("playSummonKeelhaulerCutscene", playerPeep)
					end

					local items = Utility.Item.getItemsInPeepInventory(peep)
					local stage = peep:getDirector():getGameInstance():getStage()

					for _, item in ipairs(items) do
						stage:dropItem(item, item:getCount(), peep)
					end
				end)
			end)
		end
	end
end

function Island:prepareTutorialPirateShipPeeps(playerPeep)
	local deadPrincess = self:getDirector():probe(
		self:getLayerName(),
		Probe.resource("Map", "Test_Ship"),
		Probe.instance(Utility.Peep.getPlayerModel(playerPeep)))[1]

	if not deadPrincess then
		Log.warn("Couldn't prep pirate ship peeps.")
		return
	end

	local PIRATES = {
		"Battle_ShipPirate1",
		"Battle_ShipPirate2"
	}

	local ANCHORS = {
		"Anchor_Port_Cannon1",
		"Anchor_Port_Cannon2"
	}

	for index, pirateMapObjectName in ipairs(PIRATES) do
		local pirate = self:getCompanion(playerPeep, pirateMapObjectName)
		if not pirate then
			local mapObject = self:getDirector():getGameDB():getRecord("MapObjectReference", {
				Name = pirateMapObjectName,
				Map = Utility.Peep.getMapResource(self)
			})

			Utility.spawnInstancedMapObjectAtAnchor(deadPrincess, playerPeep, mapObject:get("Resource"), ANCHORS[index])
		end
	end
end

function Island:onFinishDemo(playerPeep)
	if _ITSYREALM_DEMO then
		Utility.move(playerPeep, "@FinishDemo")
	end
end

function Island:onFinishPreparingTutorial(playerPeep)
	self.playersInTutorial[playerPeep] = true

	if not Utility.Quest.didStep("Tutorial", "Tutorial_EquippedItems", playerPeep) then
		self:_giveTutorialRequiredItems(playerPeep)

		self:talkToPeep(playerPeep, "Orlando", function(_, orlando)
			if not Utility.Quest.didStep("Tutorial", "Tutorial_GatheredItems", playerPeep) then
				Utility.spawnInstancedMapGroup(playerPeep, "Tutorial_DroppedItems")
			end

			Utility.UI.openGroup(playerPeep, Utility.UI.Groups.WORLD)
			TutorialCommon.showBasicControlsHint(playerPeep)

			Utility.Peep.setMashinaState(orlando, "tutorial-look-away-from-player")
		end)
	elseif not Utility.Quest.didStep("Tutorial", "Tutorial_FoundScout", playerPeep) then
		self:talkToPeep(playerPeep, "Orlando", function()
			local knightCommander = self:getCompanion(playerPeep, "KnightCommander")
		end)
	end

	if not Utility.Quest.didStep("Tutorial", "Tutorial_DefeatedScout", playerPeep) then
		Utility.spawnInstancedMapGroup(playerPeep, "Tutorial_YendorianScout")
		self:pushPoke("initScoutTutorial", playerPeep)
	elseif not Utility.Quest.didStep("Tutorial", "Tutorial_DefeatedYenderhounds", playerPeep) then
		Utility.spawnInstancedMapGroup(playerPeep, "Tutorial_Yenderhounds")
		self:pushPoke("finishPreparingYenderhounds", playerPeep)

		local scout = self:getDirector():probe(
			self:getLayerName(),
			Probe.namedMapObject("YendorianScout"),
			Probe.instance(Utility.Peep.getPlayerModel(playerPeep)))[1]
	elseif Utility.Quest.isNextStep("Tutorial", "Tutorial_Combat", playerPeep) then
		Utility.Peep.disable(playerPeep)
		self:talkToPeep(playerPeep, "Orlando", function(_, orlando)
			Utility.Peep.enable(playerPeep)
			Utility.Peep.setMashinaState(orlando, false)
		end, "quest_tutorial_combat.start")
	elseif Utility.Quest.isNextStep("Tutorial", "Tutorial_FoundPeak", playerPeep) or
	       Utility.Quest.isNextStep("Tutorial", "Tutorial_FoundYendorians", playerPeep) or
	       Utility.Quest.isNextStep("Tutorial", "Tutorial_DefeatedKeelhauler", playerPeep)
	then
		if Utility.Quest.isNextStep("Tutorial", "Tutorial_FoundPeak", playerPeep) then
			Utility.spawnInstancedMapGroup(playerPeep, "Tutorial_PeakObstacles")
		end

		local piratePeeps = Utility.spawnInstancedMapGroup(playerPeep, "Tutorial_Pirates")
		self:prepareTutorialPiratePeeps(playerPeep, piratePeeps)
		self:prepareTutorialPirateShipPeeps(playerPeep)

		Utility.spawnInstancedMapGroup(playerPeep, "Tutorial_BattleYendorians")
		local piratePeeps = Utility.spawnInstancedMapGroup(playerPeep, "Tutorial_BattlePirates")

		for _, peep in ipairs(piratePeeps) do
			local team = peep:getBehavior(TeamBehavior)

			local playerPeepCharacter = Utility.Peep.getCharacter(playerPeep)
			team.override[playerPeepCharacter.name] = TeamsBehavior.ALLY

			local orlandoCharacter = Utility.Peep.getCharacter(self:getCompanion(playerPeep, "Orlando"))
			team.override[orlandoCharacter.name] = TeamsBehavior.ALLY

			local knightCommanderCharacter = Utility.Peep.getCharacter(self:getCompanion(playerPeep, "KnightCommander"))
			team.override[knightCommanderCharacter.name] = TeamsBehavior.ALLY
		end

		if Utility.Quest.isNextStep("Tutorial", "Tutorial_DefeatedKeelhauler", playerPeep) then
			self:pushPoke("tutorialReachPeak", playerPeep)
		end
	end
end

function Island:getCompanion(playerPeep, namedMapObject)
	return self:getDirector():probe(
		self:getLayerName(),
		Probe.namedMapObject(namedMapObject),
		Probe.instance(Utility.Peep.getPlayerModel(playerPeep)))[1]
end

function Island:getCompanions(playerPeep, mapObjectGroup)
	return self:getDirector():probe(
		self:getLayerName(),
		Probe.mapObjectGroup(mapObjectGroup),
		Probe.instance(Utility.Peep.getPlayerModel(playerPeep)))
end

function Island:initCompanion(playerPeep, companion)
	local peep = self:getCompanion(playerPeep, companion)

	peep:addBehavior(ImmortalBehavior)
	peep:removeBehavior(AggressiveBehavior)

	local player = Utility.Peep.getPlayerModel(playerPeep)
	if peep and player then
		local _, follower = peep:addBehavior(FollowerBehavior)
		follower.playerID = player:getID()
	end
end

function Island:teleportCompanion(playerPeep, companion)
	local peep = self:getCompanion(playerPeep, companion)

	if peep then
		Utility.Peep.teleportCompanion(peep, playerPeep)
		Utility.Peep.face(peep, playerPeep)
		Utility.Peep.setMashinaState(peep, "tutorial-follow-player")
	end
end

function Island:onFinishPreparingTeam(playerPeep)
	self:initCompanion(playerPeep, "KnightCommander")
	self:initCompanion(playerPeep, "Orlando")

	if not Utility.Quest.didStart("Tutorial", playerPeep) then
		Utility.Peep.setMashinaState(self:getCompanion(playerPeep, "KnightCommander"), "tutorial-wait")
		return
	end

	if Utility.Text.getDialogVariable(playerPeep, "VizierRockKnight", "quest_tutorial_main_knight_commander_tagged_along") == true then
		if not Utility.Quest.didStep("Tutorial", "Tutorial_FoundPeak", playerPeep) then
			self:teleportCompanion(playerPeep, "KnightCommander")
		end

		if Utility.Quest.isNextStep("Tutorial", "Tutorial_FishedLightningStormfish", playerPeep) or
		   Utility.Quest.isNextStep("Tutorial", "Tutorial_CookedLightningStormfish", playerPeep)
		then
			Utility.Peep.setMashinaState(self:getCompanion(playerPeep, "KnightCommander"), "tutorial-stand-guard")
		end
	else
		Utility.Peep.setMashinaState(self:getCompanion(playerPeep, "KnightCommander"), "tutorial-wait")
	end

	self:teleportCompanion(playerPeep, "Orlando")
	if Utility.Quest.isNextStep("Tutorial", "Tutorial_CookedLightningStormfish", playerPeep) then
		Utility.Peep.setMashinaState(self:getCompanion(playerPeep, "Orlando"), "tutorial-chop")
		Utility.Peep.setMashinaState(self:getCompanion(playerPeep, "KnightCommander"), "tutorial-follow-player")
	end
end

function Island:onFinishPreparingYenderhounds(playerPeep)
	local hounds = self:getDirector():probe(
		self:getLayerName(),
		Probe.resource("Peep", "Yenderhound"),
		Probe.instance(Utility.Peep.getPlayerModel(playerPeep)))

	for _, hound in ipairs(hounds) do
		Utility.Peep.equipXWeapon(hound, "Tutorial_WeakBite")
	end
end

function Island:transitionTutorial(playerPeep, keyItemID)
	playerPeep:getState():give("KeyItem", keyItemID)
	self:poke("finishPreparingTutorial", playerPeep)
end

function Island:saveTutorialLocation(playerPeep, anchor)
	local director = self:getDirector()
	local game = director:getGameInstance()
	local mapResource = Utility.Peep.getMapResource(playerPeep)

	if not Utility.Map.hasAnchor(game, mapResource, anchor) then
		anchor = "Anchor_Spawn"
	end

	local storage = director:getPlayerStorage(playerPeep)
	local spawnStorage = storage:getRoot():getSection("Spawn")
	local locationStorage = storage:getRoot():getSection("Location")

	local x, y, z = Utility.Map.getAnchorPosition(game, mapResource, anchor)

	spawnStorage:set({
		name = mapResource.name,
		instance = false,
		x = x,
		y = y,
		z = z
	})

	locationStorage:set({
		name = mapResource.name,
		instance = false,
		x = x,
		y = y,
		z = z
	})
end

function Island:prepareTutorial(playerPeep, arguments)
	if not playerPeep then
		return
	end

	if Utility.Quest.didComplete("Tutorial", playerPeep) then
		return
	end

	Utility.Peep.toggleEffect(playerPeep, "Tutorial_SillyClick", true)
	Utility.Peep.toggleEffect(playerPeep, "Tutorial_DoubleAccuracy", true)

	if not Utility.Quest.didStart("Tutorial", playerPeep) then
		self:saveTutorialLocation(playerPeep, "Anchor_Spawn")
		Utility.save(playerPeep)
	end

	do
		local _silence, _gotKeyItem

		_silence = function()
			playerPeep:silence("move", _silence)
			playerPeep:silence("gotKeyItem", _gotKeyItem)
		end

		_gotKeyItem = function(_, keyItemID)
			Log.info("Player '%s' got key item (ID = '%s'), saving.", playerPeep:getName(), keyItemID)
			Utility.save(playerPeep)
		end

		playerPeep:listen("move", _silence)
		playerPeep:listen("gotKeyItem", _gotKeyItem)
	end

	Utility.spawnInstancedMapGroup(playerPeep, "Tutorial_Team")
	Utility.spawnInstancedMapGroup(playerPeep, "Tutorial_TeamKnights")
	Utility.spawnInstancedMapGroup(playerPeep, "Cutscene")
	self:pushPoke("finishPreparingTeam", playerPeep)

	if arguments and arguments.class then
		Utility.Text.setDialogVariable(playerPeep, "Orlando", "quest_tutorial_main_starting_player_class", arguments.class)
	end

	self:_giveTutorialRequiredItems(playerPeep)
	if not Utility.Quest.didStep("Tutorial", "Tutorial_GatheredItems", playerPeep) then
		self:_dropPlayerInventory(playerPeep)
	end

	local cutsceneTransition = Utility.UI.getOpenInterface(playerPeep, "CutsceneTransition")
	if cutsceneTransition and not cutsceneTransition:getIsClosing() then
		cutsceneTransition.onBeginClosing:register(self.onFinishPreparingTutorial, self, playerPeep)
	else
		self:pushPoke("finishPreparingTutorial", playerPeep)
	end

	local pirateShip = Utility.spawnMapAtPosition(self, "Test_Ship", 192, 0, 0, {
		isInstancedToPlayer = true,
		player = Utility.Peep.getPlayerModel(playerPeep)
	})

	local isabellesShip = Utility.spawnMapAtPosition(self, "Test_Ship", 208, 0, 208, {
		isInstancedToPlayer = true,
		player = Utility.Peep.getPlayerModel(playerPeep)
	})

	local yendorianShip = Utility.spawnMapAtPosition(self, "Test_Ship", 128, 0, -16, {
		isInstancedToPlayer = true,
		player = Utility.Peep.getPlayerModel(playerPeep)
	})

	Utility.spawnInstancedMapGroup(playerPeep, "Tutorial_YendorianShip")

	pirateShip:listen("finalize", function()
		pirateShip:getBehavior(ShipMovementBehavior).rotation = Quaternion.IDENTITY:slerp(-Quaternion.Y_90, 0.3):getNormal()
	end)

	isabellesShip:listen("finalize", function()
		isabellesShip:getBehavior(ShipMovementBehavior).rotation = Quaternion.IDENTITY:slerp(Quaternion.Y_90, 0.5):getNormal()
	end)

	yendorianShip:listen("finalize", function()
		local _, offset = yendorianShip:addBehavior(MapOffsetBehavior)
		offset.rotation = offset.rotation * Quaternion.fromEulerXYZ(-math.pi / 4, math.pi / 8, -math.pi / 6)
		offset.offset = offset.offset + Vector(0, -4, 0)
	end)

	Utility.Peep.setLayer(pirateShip, self:getLayer())
	Utility.Peep.setLayer(yendorianShip, self:getLayer())

	local deadPrincess = Sailing.Ship.getNPCCustomizations(
		self:getDirector():getGameInstance(),
		"NPC_BlackTentacles_DeadPrincess")
	pirateShip:pushPoke("customize", deadPrincess)

	local yendorian = Sailing.Ship.getNPCCustomizations(
		self:getDirector():getGameInstance(),
		"NPC_Yendorian")
	yendorianShip:pushPoke("customize", yendorian)

	local exquisitor = Sailing.Ship.getNPCCustomizations(
		self:getDirector():getGameInstance(),
		"NPC_Isabelle_Exquisitor")
	isabellesShip:pushPoke("customize", exquisitor)
	
	Utility.UI.openGroup(playerPeep, Utility.UI.Groups.WORLD)
end

function Island:onPlayerEnter(player, arguments)
	player:pokeCamera("unlockPosition")

	local playerPeep = player:getActor():getPeep()
	self:prepareTutorial(playerPeep, arguments)
end

function Island:onPlayerLeave(player)
	if not player then
		return
	end

	local playerPeep = player:getActor() and player:getActor():getPeep()
	if playerPeep then
		if self.playersInTutorial[playerPeep] then
			self.playersInTutorial[playerPeep] = nil
			Utility.Peep.toggleEffect(playerPeep, "Tutorial_SillyClick", false)
			Utility.Peep.toggleEffect(playerPeep, "Tutorial_DoubleAccuracy", false)
		end
	end

	player:pokeCamera("lockPosition")
end

function Island:onShowDialogUIHint(playerPeep)
	TutorialCommon.showDialogUIHint(playerPeep)
end

function Island:onShowEquipItemsHint(playerPeep)
	TutorialCommon.showEquipHint(playerPeep)
end

function Island:onShowEquipItemsTutorial(playerPeep)
	TutorialCommon.startEquipTutorial(playerPeep)
end

function Island:onShowDropItemTutorial(playerPeep)
	TutorialCommon.showDropItemTutorial(playerPeep)
end

function Island:onShowDropItemTutorial(playerPeep)
	TutorialCommon.showDropItemTutorial(playerPeep)
end

function Island:onShowFishTutorial(playerPeep)
	TutorialCommon.listenForFish(playerPeep)
end

function Island:onShowYieldHint(playerPeep)
	TutorialCommon.showYieldHint(playerPeep)
end

function Island:onShowEatHint(playerPeep)
	local didEat = false
	Utility.Quest.listenForAction(playerPeep, "Item", "CookedLightningStormfish", "Eat", function()
		didEat = true

		self:talkToPeep(playerPeep, "Orlando", nil, "quest_tutorial_main_defeat_yenderhounds.did_eat")
	end)

	TutorialCommon.showEatHint(playerPeep, function()
		if not didEat then
			self:talkToPeep(playerPeep, "Orlando", nil, "quest_tutorial_main_defeat_yenderhounds.needs_to_eat_again")
		end
	end)
end

function Island:onShowOffensiveRiteHint(playerPeep)
	TutorialCommon.showAttackHint(playerPeep)
end

function Island:onShowDeflectHint(playerPeep)
	TutorialCommon.showDeflectHint(playerPeep)
end

function Island:updateBarrier(playerPeep, companion, passage, anchor, dialog)
	if Utility.Peep.isInPassage(playerPeep, passage) and Utility.Peep.isEnabled(playerPeep) then
		Utility.Peep.disable(playerPeep)

		self:doTalkToPeep(playerPeep, companion, function()
			local x, y, z = Utility.Map.getAnchorPosition(
				self:getDirector():getGameInstance(),
				Utility.Peep.getMapResource(self),
				anchor)

			Utility.Peep.setPosition(playerPeep, Vector(x, y, z))

			Utility.Peep.enable(playerPeep)
		end, dialog)
	end
end

function Island:onTutorialReachPeak(playerPeep)
	Utility.moveToAnchor(playerPeep, Utility.Peep.getMapResource(playerPeep), "Anchor_VsPirates")
	Utility.Peep.teleportCompanion(self:getCompanion(playerPeep, "Orlando"), playerPeep)

	self:saveTutorialLocation(playerPeep, "Anchor_VsPirates")

	local shouldEnable = not not Utility.Text.getDialogVariable(playerPeep, "CapnRaven", "quest_tutorial_encountered_capn_raven")
	self:doTalkToPeep(playerPeep, "CapnRaven", function()
		local pirate1 = self:getCompanion(playerPeep, "CapnRaven_PirateBodyGuard1")
		local pirate2 = self:getCompanion(playerPeep, "CapnRaven_PirateBodyGuard2")
		local orlando = self:getCompanion(playerPeep, "Orlando")

		Utility.Peep.attack(pirate1, orlando)
		Utility.Peep.attack(orlando, pirate1)
		Utility.Peep.attack(pirate2, playerPeep)
	end, "quest_tutorial_initial_encounter", shouldEnable)
end

function Island:updateTutorialItemSteps(playerPeep)
	if not Utility.Peep.isInPassage(playerPeep, "Passage_TutorialStart") and
	   Utility.Peep.isEnabled(playerPeep)
	then
		Utility.Peep.disable(playerPeep)

		self:talkToPeep(playerPeep, "Orlando", function()
			Utility.Peep.enable(playerPeep)
		end, "quest_tutorial_main_start_out_of_bounds")

		return false
	end

	return true
end

function Island:updateTutorialGatherItemsStep(playerPeep)
	if not self:updateTutorialItemSteps(playerPeep) then
		return
	end

	local playerPeepHasItemOnGround = TutorialCommon.hasPeepDroppedItems(playerPeep)
	if not playerPeepHasItemOnGround then
		Utility.Peep.poofInstancedMapGroup(playerPeep, "Tutorial_DroppedItems")

		self:transitionTutorial(playerPeep, "Tutorial_GatheredItems")
		self:talkToPeep(playerPeep, "Orlando")
	end
end

function Island:updateTutorialEquipItemsStep(playerPeep)
	if not self:updateTutorialItemSteps(playerPeep) then
		return
	end

	local hasEquippedIsabellium = TutorialCommon.hasPeepEquippedFullIsabellium(playerPeep)
	if hasEquippedIsabellium then
		self:transitionTutorial(playerPeep, "Tutorial_EquippedItems")
		self:talkToPeep(playerPeep, "Orlando", function()
			TutorialCommon.showMovementControlsHint(playerPeep)
		end)
	end
end

function Island:updateTutorialFindScoutStep(playerPeep)
	if Utility.Peep.isInPassage(playerPeep, "Passage_KnightCommander") and
	   Utility.Text.getDialogVariable(playerPeep, "VizierRockKnight", "quest_tutorial_main_knight_commander_tagged_along") ~= true and
	   Utility.Peep.isEnabled(playerPeep)
	then
		Utility.Peep.disable(playerPeep)
		self:talkToPeep(playerPeep, "KnightCommander", function()
			Utility.Peep.enable(playerPeep)
		end)
	end

	if Utility.Peep.isInPassage(playerPeep, "Passage_Scout") and Utility.Peep.isEnabled(playerPeep) then
		self:poke("playFoundScoutCutscene", playerPeep)
	end
end

function Island:updateTutorialEncounterScoutStep(playerPeep)
	self:updateBarrier(playerPeep, "Orlando", "Passage_Barrier1", "Anchor_Barrier1", "quest_tutorial_main_out_of_bounds")
	if not Utility.Peep.isEnabled(playerPeep) then
		return
	end

	local scout = self:getDirector():probe(
		self:getLayerName(),
		Probe.namedMapObject("YendorianScout"),
		Probe.instance(Utility.Peep.getPlayerModel(playerPeep)))[1]

	if scout and not Utility.Peep.canAttack(scout) and Utility.Peep.isEnabled(playerPeep) then		
		local _, prop = Utility.spawnInstancedMapObjectAtAnchor(self, playerPeep, "Flare", "Anchor_Flare")
		if not prop then
			return
		end

		Utility.Peep.disable(playerPeep)
		prop:getPeep():listen("finalize", function()
			self:pushPoke("playFlareCutscene", playerPeep)
		end)
	end
end

function Island:updateTutorialFindYenderhoundsStep(playerPeep)
	if Utility.Peep.isInPassage(playerPeep, "Passage_Yenderhounds") then
		self:transitionTutorial(playerPeep, "Tutorial_FoundYenderhounds")

		self:poke("playFoundYenderhoundsCutscene", playerPeep)
	end
end

function Island:updateTutorialEncounterYenderhoundsStep(playerPeep)
	self:updateBarrier(playerPeep, "Orlando", "Passage_Barrier2", "Anchor_Barrier2", "quest_tutorial_main_out_of_bounds")
	if not Utility.Peep.isEnabled(playerPeep) then
		return
	end

	local hounds = self:getDirector():probe(
		self:getLayerName(),
		Probe.resource("Peep", "Yenderhound"),
		Probe.instance(Utility.Peep.getPlayerModel(playerPeep)))

	local isAlive = false
	for _, hound in ipairs(hounds) do
		if Utility.Peep.canAttack(hound) then
			isAlive = true
			break
		end
	end

	if not isAlive and Utility.Peep.isEnabled(playerPeep) then
		Utility.Peep.disable(playerPeep)

		local stormfishInInventory = playerPeep:getState():count("Item", "CookedLightningStormfish", { ["item-inventory"] = true })
		local _, _, stormfishOnGround = TutorialCommon.hasPeepDroppedItems(playerPeep, "^CookedLightningStormfish$")
		local totalStormfish = stormfishInInventory + stormfishOnGround
		local status = playerPeep:getBehavior(CombatStatusBehavior)

		local stitch
		if totalStormfish >= 4 and (status and status.currentHitpoints < status.maximumHitpoints) then
			stitch = "needs_to_eat"
		else
			stitch = "good_job"
		end

		local knot = string.format("quest_tutorial_main_defeat_yenderhounds.%s", stitch)
		self:talkToPeep(playerPeep, "Orlando", function()
			Utility.Peep.enable(playerPeep)
			self:transitionTutorial(playerPeep, "Tutorial_DefeatedYenderhounds")
		end, knot)
	end
end

function Island:updateTutorialFishStormfishStep(playerPeep)
	self:updateBarrier(playerPeep, "Orlando", "Passage_Barrier2", "Anchor_Barrier2", "quest_tutorial_main_out_of_bounds")
	if not Utility.Peep.isEnabled(playerPeep) then
		return
	end

	local count = playerPeep:getState():count("Item", "LightningStormfish", { ["item-inventory"] = true })

	if count >= 2 and Utility.Peep.isEnabled(playerPeep) then
		Utility.Peep.disable(playerPeep)

		self:talkToPeep(playerPeep, "Orlando", function(_, orlando)
			Utility.Peep.enable(playerPeep)

			self:transitionTutorial(playerPeep, "Tutorial_FishedLightningStormfish")
			Utility.Peep.setMashinaState(orlando, "tutorial-chop")
		end, "quest_tutorial_main_fish.done_fishing")
	end
end

function Island:updateTutorialCookStormfishStep(playerPeep)
	self:updateBarrier(playerPeep, "Orlando", "Passage_Barrier2", "Anchor_Barrier2", "quest_tutorial_main_out_of_bounds")
	if not Utility.Peep.isEnabled(playerPeep) then
		return
	end

	local count = playerPeep:getState():count("Item", "CookedLightningStormfish", { ["item-inventory"] = true })

	local _, _, numGroundFish = TutorialCommon.hasPeepDroppedItems(playerPeep, "^CookedLightningStormfish$")
	count = count + numGroundFish

	if count >= 5 and Utility.Peep.isEnabled(playerPeep) then
		Utility.Peep.disable(playerPeep)

		self:talkToPeep(playerPeep, "Orlando", function(_, orlando)
			Utility.Peep.enable(playerPeep)

			self:transitionTutorial(playerPeep, "Tutorial_CookedLightningStormfish")
			Utility.Peep.setMashinaState(self:getCompanion(playerPeep, "KnightCommander"), "tutorial-follow-player")
		end, "quest_tutorial_cook_fish.done_cooking")
	end
end

function Island:updateTutorialCombatStep(playerPeep)
	self:updateBarrier(playerPeep, "Orlando", "Passage_Barrier2", "Anchor_Barrier2", "quest_tutorial_main_out_of_bounds")
end

function Island:updateTutorialFindPeakStep(playerPeep)
	if Utility.Peep.isInPassage(playerPeep, "Passage_PeakEntrance") and
	   Utility.Peep.isEnabled(playerPeep)
	then
		Utility.Peep.disable(playerPeep)

		local orlando = self:getCompanion(playerPeep, "Orlando")
		local knightCommander = self:getCompanion(playerPeep, "KnightCommander")

		Utility.Peep.setMashinaState(orlando, "tutorial-disengage-follow-player")
		Utility.Peep.setMashinaState(knightCommander, "tutorial-disengage-follow-player")
		Utility.Combat.disengage(orlando)
		Utility.Combat.disengage(knightCommander)

		self:talkToPeep(playerPeep, "Orlando", function()
			Utility.Peep.setMashinaState(self:getCompanion(playerPeep, "Orlando"), "tutorial-follow-player")

			Utility.Peep.enable(playerPeep)

			self:transitionTutorial(playerPeep, "Tutorial_FoundPeak")
			self:saveTutorialLocation(playerPeep, "Anchor_PeakEntrance")
		end, "quest_tutorial_main_found_peak")
	end
end

function Island:updateTutorialFindYendoriansStep(playerPeep)
	if Utility.Peep.isInPassage(playerPeep, "Passage_PeakBlocker") and
	   Utility.Peep.isEnabled(playerPeep)
	then
		Utility.Peep.disable(playerPeep)

		self:talkToPeep(playerPeep, "Orlando", function()
			Utility.Peep.enable(playerPeep)
		end, "quest_tutorial_peak_out_of_bounds")
	end

	if Utility.Peep.isInPassage(playerPeep, "Passage_Peak") and
	   Utility.Peep.isEnabled(playerPeep)
	then
		local orlando = self:getCompanion(playerPeep, "Orlando")
		local knightCommander = self:getCompanion(playerPeep, "KnightCommander")

		Utility.Peep.setMashinaState(orlando, "tutorial-disengage-follow-player")
		Utility.Peep.setMashinaState(knightCommander, "tutorial-disengage-follow-player")
		Utility.Combat.disengage(orlando)
		Utility.Combat.disengage(knightCommander)

		local peakYendorian1 = self:getCompanion(playerPeep, "PeakYendorian1")
		if peakYendorian1 then
			Utility.Peep.setMashinaState(peakYendorian1, false)
			Utility.Combat.disengage(peakYendorian1)
		end

		local peakYendorian2 = self:getCompanion(playerPeep, "PeakYendorian2")
		if peakYendorian2 then
			Utility.Peep.setMashinaState(peakYendorian2, false)
			Utility.Combat.disengage(peakYendorian2)
		end

		self:poke("playFoundPiratesCutscene", playerPeep)
	end
end

function Island:updateTutorialDefeatKeelhaulerStep(playerPeep)
	self:updateBarrier(playerPeep, "Orlando", "Passage_Barrier3", "Anchor_Barrier3", "quest_tutorial_main_out_of_bounds")
	if not Utility.Peep.isEnabled(playerPeep) then
		return
	end
end

function Island:onGunnersEngagePlayer(playerPeep)
	Utility.Peep.disable(playerPeep)
	self:doTalkToPeep(playerPeep, "CapnRaven", function()
		local pirate1 = self:getCompanion(playerPeep, "Battle_ShipPirate1")
		Utility.Peep.setMashinaState(pirate1, "gun-player")

		local pirate2 = self:getCompanion(playerPeep, "Battle_ShipPirate2")
		Utility.Peep.setMashinaState(pirate2, "gun-player")

		Utility.Peep.enable(playerPeep)
	end, "quest_tutorial_fight_keelhauler.enter_phase_4")
end

function Island:onGiveTutorialFishingGear(playerPeep)
	self:_giveItems(playerPeep, self.FISHING_INVENTORY)
end

function Island:updateTutorialPlayer(playerPeep)
	local stage = self:getDirector():getGameInstance():getStage()

	if Utility.Quest.isNextStep("Tutorial", "Tutorial_GatheredItems", playerPeep) then
		self:updateTutorialGatherItemsStep(playerPeep)
	elseif Utility.Quest.isNextStep("Tutorial", "Tutorial_EquippedItems", playerPeep) then
		self:updateTutorialEquipItemsStep(playerPeep)
	elseif Utility.Quest.isNextStep("Tutorial", "Tutorial_FoundScout", playerPeep) then
		self:updateTutorialFindScoutStep(playerPeep)
	elseif Utility.Quest.isNextStep("Tutorial", "Tutorial_DefeatedScout", playerPeep) then
		self:updateTutorialEncounterScoutStep(playerPeep)
	elseif Utility.Quest.isNextStep("Tutorial", "Tutorial_FoundYenderhounds", playerPeep) then
		self:updateTutorialFindYenderhoundsStep(playerPeep)
	elseif Utility.Quest.isNextStep("Tutorial", "Tutorial_DefeatedYenderhounds", playerPeep) then
		self:updateTutorialEncounterYenderhoundsStep(playerPeep)
	elseif Utility.Quest.isNextStep("Tutorial", "Tutorial_FishedLightningStormfish", playerPeep) then
		self:updateTutorialFishStormfishStep(playerPeep)
	elseif Utility.Quest.isNextStep("Tutorial", "Tutorial_CookedLightningStormfish", playerPeep) then
		self:updateTutorialCookStormfishStep(playerPeep)
	elseif Utility.Quest.isNextStep("Tutorial", "Tutorial_FoundPeak", playerPeep) then
		self:updateTutorialFindPeakStep(playerPeep)
	elseif Utility.Quest.isNextStep("Tutorial", "Tutorial_FoundYendorians", playerPeep) then
		self:updateTutorialFindYendoriansStep(playerPeep)
	elseif Utility.Quest.isNextStep("Tutorial", "Tutorial_DefeatedKeelhauler", playerPeep) then
		self:updateTutorialDefeatKeelhaulerStep(playerPeep)
	end
end

function Island:updateTutorialPlayers()
	for playerPeep in pairs(self.playersInTutorial) do
		self:updateTutorialPlayer(playerPeep)
	end
end

function Island:update(director, game)
	MapScript.update(self, director, game)

	self:updateTutorialPlayers()
end

return Island
