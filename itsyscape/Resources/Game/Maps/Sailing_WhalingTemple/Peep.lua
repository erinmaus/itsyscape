--------------------------------------------------------------------------------
-- Resources/Game/Maps/Sailing_WhalingTemple/Peep.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Vector = require "ItsyScape.Common.Math.Vector"
local CacheRef = require "ItsyScape.Game.CacheRef"
local Utility = require "ItsyScape.Game.Utility"
local Weapon = require "ItsyScape.Game.Weapon"
local MagicWeapon = require "ItsyScape.Game.MagicWeapon"
local MeleeWeapon = require "ItsyScape.Game.MeleeWeapon"
local RangedWeapon = require "ItsyScape.Game.RangedWeapon"
local Color = require "ItsyScape.Graphics.Color"
local Probe = require "ItsyScape.Peep.Probe"
local Map = require "ItsyScape.Peep.Peeps.Map"
local DisabledBehavior = require "ItsyScape.Peep.Behaviors.DisabledBehavior"
local FollowerBehavior = require "ItsyScape.Peep.Behaviors.FollowerBehavior"
local InstancedBehavior = require "ItsyScape.Peep.Behaviors.InstancedBehavior"
local InventoryBehavior = require "ItsyScape.Peep.Behaviors.InventoryBehavior"
local MashinaBehavior = require "ItsyScape.Peep.Behaviors.MashinaBehavior"
local PlayerBehavior = require "ItsyScape.Peep.Behaviors.PlayerBehavior"
local TeleportalBehavior = require "ItsyScape.Peep.Behaviors.TeleportalBehavior"
local PreTutorialCommon = require "Resources.Game.Peeps.PreTutorial.V2Common"

local WhalingTemple = Class(Map)
WhalingTemple.MIN_LIGHTNING_PERIOD = 4
WhalingTemple.MAX_LIGHTNING_PERIOD = 8

function WhalingTemple:new(resource, name, ...)
	Map.new(self, resource, name or 'WhalingTemple', ...)

	self:onZap()
end

function WhalingTemple:onLoad(filename, args, layer)
	Map.onLoad(self, filename, args, layer)

	Utility.spawnMapAtAnchor(self, "Ship_IsabelleIsland_PortmasterJenkins", "Anchor_Ship", {
		jenkins_state = 2
	})
end

function WhalingTemple:trySpawnRosalind(playerPeep)
	Utility.spawnInstancedMapObjectAtAnchor(self, playerPeep, "Rosalind", "Anchor_Rosalind")
end

function WhalingTemple:onRain()
	local stage = self:getDirector():getGameInstance():getStage()
	stage:forecast(layer, 'Sailing_WhalingTemple_HeavyRain', 'Rain', {
		wind = { 15, 0, 0 },
		heaviness = 1
	})
end

function WhalingTemple:onPlayerEnter(player)
	local playerPeep = player:getActor():getPeep()

	if playerPeep:getState():has("KeyItem", "PreTutorial_SmithedUpAndComingHeroArmor") then
		self:poke("rain")
	end

	self:trySpawnRosalind(playerPeep)
	self:prepareQuest(playerPeep)

	self:pushPoke("preparePlayer", playerPeep)
end

function WhalingTemple:onPreparePlayer(playerPeep)
	if Utility.Quest.isNextStep("PreTutorial", "PreTutorial_ArriveAtTheWhalingTemple", playerPeep) then
		self:makePlayerTalkToPeep(playerPeep, "IsabelleIsland_Port_PortmasterJenkins")
	else
		self:makeRosalindFollowPlayer(playerPeep, true)
	end

	if Utility.Quest.isNextStep("PreTutorial", "PreTutorial_FoundInjuredYendorian", playerPeep) or
	   Utility.Quest.isNextStep("PreTutorial", "PreTutorial_ReasonedWithYendorian", playerPeep) or -- or any other options
	   Utility.Quest.isNextStep("PreTutorial", "PreTutorial_DefeatedInjuredYendorian", playerPeep)
	then
		if Utility.Peep.isInPassage(playerPeep, "Passage_BossArena") then
			playerPeep:addBehavior(DisabledBehavior)
		end

		PreTutorialCommon.makeRosalindTalk(playerPeep, "TalkAboutBoss")
	end
end

function WhalingTemple:prepareQuest(playerPeep)
	Utility.Quest.listenForKeyItemHint(playerPeep, "PreTutorial")

	Utility.Quest.listenForKeyItem(playerPeep, "PreTutorial_FoundTrees", function()
		local trees = self:getDirector():probe(
			self:getLayerName(),
			Probe.resource("Prop", "ShadowTree_Stormy"))

		table.sort(trees, function(a, b)
			local aDistance = (Utility.Peep.getPosition(a) - Utility.Peep.getPosition(playerPeep)):getLengthSquared()
			local bDistance = (Utility.Peep.getPosition(b) - Utility.Peep.getPosition(playerPeep)):getLengthSquared()

			return aDistance < bDistance
		end)

		local tree
		for _, t in ipairs(trees) do
			local treeY = Utility.Peep.getPosition(t).y
			local playerY = Utility.Peep.getPosition(playerPeep).y

			if treeY == playerY then
				tree = t
				break
			end
		end

		if tree then
			local position = Utility.Peep.getPosition(tree)
			local treeTarget = Utility.spawnPropAtPosition(tree, "Target_Default", position.x, position.y, position.z)
			treeTarget = treeTarget and treeTarget:getPeep()

			if treeTarget then
				treeTarget:setTarget(tree, _MOBILE and "Tap the tree to chop it!" or "Click on the tree to chop it!")

				PreTutorialCommon.listenForAction(
					playerPeep,
					"Chop",
					treeTarget,
					"You'll keep chopping the tree until the tree is felled.",
					_MOBILE and "You only need to tap once to chop!" or "You only need to click once to chop!")
			end
		end
	end)

	Utility.Quest.listenForItem(playerPeep, "ShadowLogs", function()
		if not playerPeep:getState():has("KeyItem", "PreTutorial_CraftedWeapon") then
			PreTutorialCommon.makeRosalindTalk(playerPeep, "TalkAboutTrees")
		end
	end)

	local function _craftedWeapon()
		if not playerPeep:getState():has("KeyItem", "PreTutorial_CraftedWeapon") then
			playerPeep:getState():give("KeyItem", "PreTutorial_CraftedWeapon")
			PreTutorialCommon.makeRosalindTalk(playerPeep, "TalkAboutTrees")
		end
	end

	Utility.Quest.listenForItem(playerPeep, "ToyLongsword", _craftedWeapon)
	Utility.Quest.listenForItem(playerPeep, "ToyBoomerang", _craftedWeapon)
	Utility.Quest.listenForItem(playerPeep, "ToyWand", _craftedWeapon)

	Utility.Quest.listenForKeyItem(playerPeep, "PreTutorial_KilledMaggot", function()
		local fish = self:getDirector():probe(
			self:getLayerName(),
			Probe.resource("Prop", "Sardine_Default"))

		table.sort(fish, function(a, b)
			local aDistance = (Utility.Peep.getPosition(a) - Utility.Peep.getPosition(playerPeep)):getLengthSquared()
			local bDistance = (Utility.Peep.getPosition(b) - Utility.Peep.getPosition(playerPeep)):getLengthSquared()

			return aDistance < bDistance
		end)

		fish = fish[1]

		if fish then
			local position = Utility.Peep.getPosition(fish)
			local fishTarget = Utility.spawnPropAtPosition(fish, "Target_Default", position.x, position.y, position.z)
			fishTarget = fishTarget and fishTarget:getPeep()

			if fishTarget then
				fishTarget:setTarget(fish, _MOBILE and "Tap the sardine to fish it!" or "Click on the sardine to fish it!")

				PreTutorialCommon.listenForAction(
					playerPeep,
					"Fish",
					fishTarget,
					"You'll keep fishing for the sardine until you reel it in..",
					_MOBILE and "You only need to tap once to fish!" or "You only need to click once to fish!")
			end
		end

		PreTutorialCommon.makeRosalindTalk(playerPeep, "TalkAboutFish")
	end)

	Utility.Quest.listenForItem(playerPeep, "Sardine", function()
		if not playerPeep:getState():has("KeyItem", "PreTutorial_Fished") then
			playerPeep:getState():give("KeyItem", "PreTutorial_Fished")
			PreTutorialCommon.makeRosalindTalk(playerPeep, "TalkAboutFish")
		end
	end)

	do
		local stage = self:getDirector():getGameInstance():getStage()
		local ground = stage:getGround(self:getLayer())
		local inventory = ground and ground:hasBehavior(InventoryBehavior) and ground:getBehavior(InventoryBehavior).inventory
		if inventory then
			local targets = {}

			local function listenForBaitDrop(item, _, _, _, peep)
				local position = stage:getMap(self:getLayer()):getTileCenter(Utility.Peep.getTile(peep))

				if playerPeep:getState():has("KeyItem", "PreTutorial_Fished") then
					return
				end

				if peep and not peep:hasBehavior(PlayerBehavior) then
					local target = Utility.spawnPropAtPosition(self, "Target_Default", position.x, position.y, position.z)
					target = target and target:getPeep()

					if target then
						target:setTarget("Bait", not _MOBILE and "Click on the loot bag to pick up the bait!" or "Tap on the loot bag to pick up the bait!")
						targets[item:getRef()] = target
					end
				end
			end

			local function listenForBaitTake(item, _, _, peep)
				if targets[item:getRef()] then
					Utility.Peep.poof(targets[item:getRef()])
					targets[item:getRef()] = nil
				end
			end

			inventory.onDropItem:register(listenForBaitDrop)
			inventory.onTakeItem:register(listenForBaitTake)
		end
	end

	if Utility.Quest.isNextStep("PreTutorial", "PreTutorial_FoundInjuredYendorian", playerPeep) or
	   Utility.Quest.isNextStep("PreTutorial", "PreTutorial_ReasonedWithYendorian", playerPeep) or
	   Utility.Quest.isNextStep("PreTutorial", "PreTutorial_DefeatedInjuredYendorian", playerPeep)
	then
		if Utility.Peep.isInPassage(playerPeep, "Passage_BossArena") then
			local playerWeapon = Utility.Peep.getEquippedWeapon(playerPeep)
			playerWeapon = Class.isCompatibleType(playerWeapon, Weapon) and playerWeapon

			local yendorianMapObjectName
			if playerWeapon then
				if Class.isCompatibleType(playerWeapon, MagicWeapon) then
					yendorianMapObjectName = "YendorianSwordfish"
				elseif Class.isCompatibleType(playerWeapon, MeleeWeapon) then
					yendorianMapObjectName = "YendorianBallista"
				elseif Class.isCompatibleType(playerWeapon, RangedWeapon) then
					yendorianMapObjectName = "YendorianMast"
				end
			else
				yendorianMapObjectName = "YendorianBallista"
			end

			local yendorian
			if yendorianMapObjectName then
				yendorian = Utility.spawnMapObjectAtAnchor(self, yendorianMapObjectName, "Anchor_InjuredYendorian")
			end

			if yendorian then
				yendorian = yendorian:getPeep()
				yendorian:listen("finalize", function()
					Utility.Peep.equipXWeapon(yendorian, string.format("%s_Injured", yendorianMapObjectName))
				end)
			end
		end
	end
end

function WhalingTemple:makeRosalindFollowPlayer(playerPeep, teleport)
	local director = self:getDirector()
	local rosalind = director:probe(self:getLayerName(), Probe.resource("Peep", "IsabelleIsland_Rosalind"))[1]
	if not rosalind then
		return
	end

	local _, follower = rosalind:addBehavior(FollowerBehavior)
	follower.playerID = Utility.Peep.getPlayerModel(playerPeep):getID()
	follower.followAcrossMaps = true

	local _, instanced = rosalind:addBehavior(InstancedBehavior)
	instanced.playerID = Utility.Peep.getPlayerModel(playerPeep):getID()

	local mashina = rosalind:getBehavior(MashinaBehavior)
	if mashina then
		mashina.currentState = "follow"
	end

	if teleport then
		Utility.Peep.setPosition(rosalind, Utility.Peep.getPosition(playerPeep) + Vector(0, 0, 0.5))
	end
end

function WhalingTemple:makePlayerTalkToPeep(playerPeep, otherPeepResourceName)
	local director = self:getDirector()
	local otherPeep = director:probe(self:getLayerName(), Probe.resource("Peep", otherPeepResourceName))[1]
	if not otherPeep then
		return
	end

	local otherPeepMapObject = Utility.Peep.getMapObject(otherPeep)
	if not otherPeepMapObject then
		return
	end

	local actions = Utility.getActions(
		game,
		otherPeepMapObject,
		'world')
	for _, action in ipairs(actions) do
		if action.instance:is("talk") then
			return Utility.UI.openInterface(
				playerPeep,
				"DialogBox",
				true,
				action.instance,
				otherPeep)
		end
	end
end

function WhalingTemple:onZap()
	self.lightningTime = love.math.random() * (self.MAX_LIGHTNING_PERIOD - self.MIN_LIGHTNING_PERIOD) + self.MIN_LIGHTNING_PERIOD
end

function WhalingTemple:onBoom()
	local playerPeep = Utility.Peep.getPlayer(self)
	if not playerPeep then
		return
	end

	if playerPeep:getState():has("KeyItem", "PreTutorial_SmithedUpAndComingHeroArmor") then
		return
	end

	local i, j, layer = Utility.Peep.getTile(playerPeep)

	local director = self:getDirector()
	local map = director:getMap(layer)

	i, j = Utility.Map.getRandomTile(map, i, j, 4, false)

	local position = Utility.Map.getAbsoluteTilePosition(director, i, j, layer)

	local stage = director:getGameInstance():getStage()
	stage:fireProjectile("StormLightning", Vector.ZERO, position, layer)
	self:pushPoke(0.5, "splode", position, layer)
end

function WhalingTemple:onSplode(position, layer)
	local stage = self:getDirector():getGameInstance():getStage()
	stage:fireProjectile("CannonSplosion", Vector.ZERO, position, layer)

	local instance = Utility.Peep.getInstance(self)
	for _, player in instance:iteratePlayers() do
		player:pokeCamera("shake", 0.5)
	end
end

function WhalingTemple:updateFireHint()
	local playerPeep = Utility.Peep.getPlayer(self)
	if not playerPeep then
		return
	end

	if playerPeep:getState():has("KeyItem", "PreTutorial_CookedFish") then
		return
	end

	do
		local targets = self:getDirector():probe(
			self:getLayerName(),
			Probe.resource("Prop", "Target_Default"),
			function(peep)
				return peep.target and peep.target:wasPoofed()
			end)

		for _, target in ipairs(targets) do
			Utility.Peep.poof(target)
		end
	end

	local fires = self:getDirector():probe(
		self:getLayerName(),
		Probe.resource("Prop", "ShadowFire"))

	if #fires ~= 1 then
		return
	end

	local fire = fires[1]
	local targets = self:getDirector():probe(
		self:getLayerName(),
		Probe.resource("Prop", "Target_Default"),
		function(peep)
			return peep.target == fire
		end)

	if #targets >= 1 then
		return
	end

	local position = Utility.Peep.getPosition(fire)
	local fireTarget = Utility.spawnPropAtPosition(fire, "Target_Default", position.x, position.y, position.z)
	fireTarget = fireTarget and fireTarget:getPeep()

	if fireTarget then
		fireTarget:setTarget(fire, not _MOBILE and "Click the fire to cook!" or "Tap the fire to cook!")

		local function onCookSardine()
			Utility.Peep.poof(fireTarget)
			playerPeep:getCommandQueue():interrupt()
			playerPeep:getState():give("KeyItem", "PreTutorial_CookedFish")
			PreTutorialCommon.makeRosalindTalk(playerPeep, "TalkAboutFish")
		end

		Utility.Quest.listenForItem(playerPeep, "CookedSardine", onCookSardine)
		Utility.Quest.listenForItem(playerPeep, "BurntSardine", onCookSardine)
	end
end

function WhalingTemple:onOpenMantokPortal()
	local azathoth, layer = Utility.spawnMapAtAnchor(self, "PreTutorial_Mantok", "Anchor_Portal")

	if azathoth then
		azathoth:addBehavior(DisabledBehavior)
		azathoth:listen("ready", function()
			local _, portal = Utility.spawnMapObjectAtAnchor(self, "Portal", "Anchor_Portal")
			local portalPeep = portal and portal:getPeep()
			if portalPeep then
				portalPeep:setColor(Color(0, 0, 0, 1))

				local _, portal = portalPeep:addBehavior(TeleportalBehavior)
				portal.offset = Vector(0, 10, 0)
				portal.distance = 0
				portal.layer = layer
			end
		end)
	end
end

function WhalingTemple:update(director, game)
	Map.update(self, director, game)

	self.lightningTime = self.lightningTime - self:getDirector():getGameInstance():getDelta()
	if self.lightningTime < 0 then
		self:onZap()
		self:onBoom()
	end

	self:updateFireHint()
end

return WhalingTemple
