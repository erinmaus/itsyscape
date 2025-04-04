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
local Vector = require "ItsyScape.Common.Math.Vector"
local Utility = require "ItsyScape.Game.Utility"
local Weapon = require "ItsyScape.Game.Weapon"
local Sailing = require "ItsyScape.Game.Skills.Sailing"
local Color = require "ItsyScape.Graphics.Color"
local CallbackCommand = require "ItsyScape.Peep.CallbackCommand"
local Probe = require "ItsyScape.Peep.Probe"
local CombatStatusBehavior = require "ItsyScape.Peep.Behaviors.CombatStatusBehavior"
local OceanBehavior = require "ItsyScape.Peep.Behaviors.OceanBehavior"
local FollowerBehavior = require "ItsyScape.Peep.Behaviors.FollowerBehavior"
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

Island.CLASS_DUMMY = {
	[Weapon.STYLE_MAGIC] = "TutorialDummy_Wizard", 
	[Weapon.STYLE_ARCHERY] = "TutorialDummy_Archer", 
	[Weapon.STYLE_MELEE] = "TutorialDummy_Melee", 
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

function Island:_doTalkToPeep(playerPeep, otherPeepName, callback, entryPoint)
	local success, dialog = Utility.Peep.dialog(playerPeep, "Talk", otherPeepName, entryPoint)
	if success then
		Utility.Peep.disable(playerPeep)

		if callback then
			dialog.onClose:register(callback)
		end

		dialog.onClose:register(function()
			Utility.Peep.enable(playerPeep)
		end)
	else
		if callback then
			callback()
		end
	end

	return success
end

function Island:talkToPeep(playerPeep, otherPeepName, callback, entryPoint)
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

		local i, j, k = Utility.Peep.getTile(playerPeep)
		if Utility.Peep.walk(otherPeep, i, j, k, 3, { asCloseAsPossible = false }) then
			otherPeep:getCommandQueue():push(CallbackCommand(self._doTalkToPeep, self, playerPeep, otherPeepName, wrappedCallback, entryPoint))
			return true
		end
	end

	return self:_doTalkToPeep(playerPeep, otherPeepName, wrappedCallback, entryPoint)
end

function Island:onInitScoutTutorial(playerPeep)
	TutorialCommon.listenForAttack(playerPeep)
end

function Island:onFinishPreparingTutorial(playerPeep)
	self.playersInTutorial[playerPeep] = true

	if not Utility.Quest.didStep("Tutorial", "Tutorial_EquippedItems", playerPeep) then
		self:_giveTutorialRequiredItems(playerPeep)

		self:talkToPeep(playerPeep, "Orlando", function(_, orlando)
			if not Utility.Quest.didStep("Tutorial", "Tutorial_GatheredItems", playerPeep) then
				Utility.spawnInstancedMapGroup(playerPeep, "Tutorial_DroppedItems")
			end

			Utility.UI.openGroup(playerPeep, "WORLD")
			TutorialCommon.showBasicControlsHint(playerPeep)

			Utility.Peep.setMashinaState(orlando, "tutorial-look-away-from-player")
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

		if not scout then
			Utility.Peep.disable(playerPeep)
			self:talkToPeep(playerPeep, "Orlando", function(_, orlando)
				Utility.Peep.enable(playerPeep)
			end)
		end
	elseif Utility.Quest.isNextStep("Tutorial", "Tutorial_Combat", playerPeep) then
		Utility.Peep.disable(playerPeep)
		self:talkToPeep(playerPeep, "Orlando", function(_, orlando)
			Utility.Peep.enable(playerPeep)
			Utility.Peep.setMashinaState(orlando, false)
		end, "quest_tutorial_combat.start")
	end
end

function Island:getCompanion(playerPeep, namedMapObject)
	return self:getDirector():probe(
		self:getLayerName(),
		Probe.namedMapObject(namedMapObject),
		Probe.instance(Utility.Peep.getPlayerModel(playerPeep)))[1]
end

function Island:initCompanion(playerPeep, companion)
	local peep = self:getCompanion(playerPeep, companion)

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
		return
	end

	if Utility.Text.getDialogVariable(playerPeep, "VizierRockKnight", "quest_tutorial_main_knight_commander_tagged_along") == true then
		self:teleportCompanion(playerPeep, "KnightCommander")

		if Utility.Quest.isNextStep("Tutorial", "Tutorial_FishedLightningStormfish", playerPeep) or
		   Utility.Quest.isNextStep("Tutorial", "Tutorial_CookedLightningStormfish", playerPeep)
		then
			Utility.Peep.setMashinaState(self:getCompanion(playerPeep, "KnightCommander"), "tutorial-stand-guard")
		end
	end

	self:teleportCompanion(playerPeep, "Orlando")
	if Utility.Quest.isNextStep("Tutorial", "Tutorial_CookedLightningStormfish", playerPeep) then
		Utility.Peep.setMashinaState(self:getCompanion(playerPeep, "Orlando"), "tutorial-chop")
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

	if not Utility.Quest.didStart("Tutorial", playerPeep) then
		self:saveTutorialLocation(playerPeep, "Anchor_Spawn")
	end

	Utility.spawnInstancedMapGroup(playerPeep, "Tutorial_Team")
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
		self.playersInTutorial[playerPeep] = nil
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
	TutorialCommon.showEatHint(playerPeep)
end

function Island:onShowOffensiveRiteHint(playerPeep)
	TutorialCommon.showAttackHint(playerPeep)
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

	if Utility.Peep.isInPassage(playerPeep, "Passage_Scout") then
		self:transitionTutorial(playerPeep, "Tutorial_FoundScout")
		self:saveTutorialLocation(playerPeep, "Anchor_EncounterYendorianScout")

		Utility.Peep.disable(playerPeep)
		self:talkToPeep(playerPeep, "Orlando", function()
			Utility.Peep.enable(playerPeep)
		end)
	end
end

function Island:updateTutorialEncounterScoutStep(playerPeep)
	local scout = self:getDirector():probe(
		self:getLayerName(),
		Probe.namedMapObject("YendorianScout"),
		Probe.instance(Utility.Peep.getPlayerModel(playerPeep)))[1]

	if scout and not Utility.Peep.canAttack(scout) and Utility.Peep.isEnabled(playerPeep) then
		Utility.Peep.disable(playerPeep)

		self:talkToPeep(playerPeep, "Orlando", function(playerPeep, orlando)
			Utility.Peep.enable(playerPeep)

			self:transitionTutorial(playerPeep, "Tutorial_DefeatedScout")
			self:saveTutorialLocation(playerPeep, "Anchor_DefeatYendorianScout")
		end, "quest_tutorial_main_scout_argument")
	end
end

function Island:updateTutorialFindYenderhoundsStep(playerPeep)
	if Utility.Peep.isInPassage(playerPeep, "Passage_Yenderhounds") then
		self:transitionTutorial(playerPeep, "Tutorial_FoundYenderhounds")

		Utility.Peep.disable(playerPeep)
		self:talkToPeep(playerPeep, "Orlando", function()
			Utility.Peep.enable(playerPeep)
			self:saveTutorialLocation(playerPeep, "Anchor_EncounterYenderhounds")
		end, "quest_tutorial_main_find_yenderhounds.spotted")
	end
end

function Island:updateTutorialEncounterYenderhoundsStep(playerPeep)
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

		local stormfish = playerPeep:getState():count("Item", "CookedLightningStormfish", { ["item-inventory"] = true })
		local status = playerPeep:getBehavior(CombatStatusBehavior)
		local hitpointsRatio = status and (status.currentHitpoints / status.maximumHitpoints)

		local stitch
		if stormfish >= 3 and hitpointsRatio > 0.75 then
			stitch = "good_scenario"
		elseif stormfish <= 1 and hitpointsRatio < 0.25 then
			stitch = "worst_scenario"
		else
			stitch = "bad_scenario"
		end

		local knot = string.format("quest_tutorial_main_defeat_yenderhounds.%s", stitch)
		self:talkToPeep(playerPeep, "Orlando", function()
			Utility.Peep.enable(playerPeep)
			self:transitionTutorial(playerPeep, "Tutorial_DefeatedYenderhounds")
		end, knot)
	end
end

function Island:updateTutorialFishStormfishStep(playerPeep)
	local count = playerPeep:getState():count("Item", "LightningStormfish", { ["item-inventory"] = true })

	if count >= 5 and Utility.Peep.isEnabled(playerPeep) then
		Utility.Peep.disable(playerPeep)

		self:talkToPeep(playerPeep, "Orlando", function(_, orlando)
			Utility.Peep.enable(playerPeep)

			Utility.Peep.setMashinaState(orlando, "tutorial-chop")

			self:transitionTutorial(playerPeep, "Tutorial_FishedLightningStormfish")
		end, "quest_tutorial_main_fish.done_fishing")
	end
end

function Island:updateTutorialCookStormfishStep(playerPeep)
	local count = playerPeep:getState():count("Item", "CookedLightningStormfish", { ["item-inventory"] = true })

	local _, groundFish = TutorialCommon.hasPeepDroppedItems(playerPeep, "^CookedLightningStormfish$")
	count = count + #groundFish

	if count >= 5 and Utility.Peep.isEnabled(playerPeep) then
		Utility.Peep.disable(playerPeep)

		self:talkToPeep(playerPeep, "Orlando", function(_, orlando)
			Utility.Peep.enable(playerPeep)

			self:transitionTutorial(playerPeep, "Tutorial_CookedLightningStormfish")
		end, "quest_tutorial_cook_fish.done_cooking")
	end
end

function Island:onPlaceTutorialDummy(playerPeep)
	local class = Utility.Text.getDialogVariable(playerPeep, "Orlando", "quest_tutorial_main_starting_player_class")

	local orlando = self:getCompanion(playerPeep, "Orlando")
	Utility.Peep.setMashinaState(orlando, false)

	local x, y, z = Utility.Map.getAnchorPosition(
		self:getDirector():getGameInstance(),
		Utility.Peep.getMapResource(self),
		"Anchor_Orlando_PlaceDummy")

	local orlandoWalk = Utility.Peep.queueWalk(
		orlando,
		x, z, Utility.Peep.getLayer(playerPeep),
		0,
		{ asCloseAsPossible = true, isPosition = true })

	orlandoWalk:register(function(s)
		orlando:getCommandQueue():push(CallbackCommand(function()
			Utility.Peep.setFacing(orlando, 1)
			Utility.Peep.playAnimation(
				orlando,
				"x-tutorial",
				100,
				"Human_ActionGive_1")

			local dummyPeepID = self.CLASS_DUMMY[class] or self.CLASS_DUMMY[Weapon.STYLE_MAGIC]
			local dummyActor = Utility.spawnActorAtPosition(orlando, dummyPeepID, x, y, z)
			local dummyPeep = dummyActor:getPeep()

			Utility.Peep.makeInstanced(dummyPeep, playerPeep)
			Utility.Peep.teleportCompanion(dummyPeep, orlando)
			Utility.Peep.setFacing(dummyPeep, -1)
			Utility.Peep.setMashinaState(dummyPeep, "tutorial-yield")

			Utility.Peep.disable(playerPeep)
			self:talkToPeep(playerPeep, "Orlando", function()
				Utility.Peep.enable(playerPeep)
				Utility.Peep.setMashinaState(orlando, "tutorial-follow-player")
			end, "quest_tutorial_combat.attack_dummy")

			Utility.Peep.setMashinaState(
				self:getCompanion(playerPeep, "KnightCommander"),
				"tutorial-follow-player")
		end))
	end)

	Utility.Peep.disable(playerPeep)
	local playerWalk = Utility.Peep.queueWalk(
		playerPeep,
		x, z, Utility.Peep.getLayer(playerPeep),
		2.5,
		{ asCloseAsPossible = false, isPosition = true, isCutscene = true })
	playerWalk:register(function(s)
		if s then
			playerPeep:getCommandQueue():push(CallbackCommand(Utility.Peep.enable, playerPeep))
		else
			Utility.Peep.enable(playerPeep)
		end
	end)
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
