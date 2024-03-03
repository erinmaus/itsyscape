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
local Probe = require "ItsyScape.Peep.Probe"
local Map = require "ItsyScape.Peep.Peeps.Map"
local MashinaBehavior = require "ItsyScape.Peep.Behaviors.MashinaBehavior"
local FollowerBehavior = require "ItsyScape.Peep.Behaviors.FollowerBehavior"
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

	local stage = self:getDirector():getGameInstance():getStage()
	stage:forecast(layer, 'Sailing_WhalingTemple_HeavyRain', 'Rain', {
		wind = { 15, 0, 0 },
		heaviness = 1
	})

	Utility.spawnMapAtAnchor(self, "Ship_IsabelleIsland_PortmasterJenkins", "Anchor_Ship", {
		jenkins_state = 2
	})
end

function WhalingTemple:onPlayerEnter(player)
	local playerPeep = player:getActor():getPeep()

	if Utility.Quest.isNextStep("PreTutorial", "PreTutorial_ArriveAtTheWhalingTemple", playerPeep) then
		self:makePlayerTalkToPeep(playerPeep, "IsabelleIsland_Port_PortmasterJenkins")
	else
		self:makeRosalindFollowPlayer(playerPeep, true)
	end

	self:prepareQuest(playerPeep)
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
		PreTutorialCommon.makeRosalindTalk(playerPeep, "TalkAboutTrees")
	end)

	Utility.Quest.listenForItem(playerPeep, "ToyLongsword", function()
		playerPeep:getState():give("KeyItem", "PreTutorial_CraftedWeapon")
		PreTutorialCommon.makeRosalindTalk(playerPeep, "TalkAboutTrees")
	end)

	Utility.Quest.listenForItem(playerPeep, "ToyBoomerang", function()
		playerPeep:getState():give("KeyItem", "PreTutorial_CraftedWeapon")
		PreTutorialCommon.makeRosalindTalk(playerPeep, "TalkAboutTrees")
	end)

	Utility.Quest.listenForItem(playerPeep, "ToyWand", function()
		playerPeep:getState():give("KeyItem", "PreTutorial_CraftedWeapon")
		PreTutorialCommon.makeRosalindTalk(playerPeep, "TalkAboutTrees")
	end)

	Utility.Quest.listenForKeyItem(playerPeep, "PreTutorial_KilledMaggot", function()
		PreTutorialCommon.makeRosalindTalk(playerPeep, "TalkAboutFish")
	end)
end

function WhalingTemple:makeRosalindFollowPlayer(playerPeep, teleport)
	local director = self:getDirector()
	local rosalind = director:probe(self:getLayerName(), Probe.resource("Peep", "IsabelleIsland_Rosalind"))[1]
	if not rosalind then
		return
	end

	local _, follower = rosalind:addBehavior(FollowerBehavior)
	follower.playerID = Utility.Peep.getPlayerModel(playerPeep):getID()

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

function WhalingTemple:onBoom(ship)
	local player = Utility.Peep.getPlayer(self)
	if not player then
		return
	end

	local i, j, layer = Utility.Peep.getTile(player)

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

function WhalingTemple:update(director, game)
	Map.update(self, director, game)

	self.lightningTime = self.lightningTime - self:getDirector():getGameInstance():getDelta()
	if self.lightningTime < 0 then
		self:onZap()
		self:onBoom()
	end
end

return WhalingTemple
