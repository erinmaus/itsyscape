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
local Probe = require "ItsyScape.Peep.Probe"
local OceanBehavior = require "ItsyScape.Peep.Behaviors.OceanBehavior"
local DisabledBehavior = require "ItsyScape.Peep.Behaviors.DisabledBehavior"
local MapScript = require "ItsyScape.Peep.Peeps.Map"

local Island = Class(MapScript)

Island.ALL_INVENTORY = {
	"IsabelliumGloves",
	"IsabelliumBoots",
	"IsabelliumHelmet",
	"IsabelliumPlatebody",
	"CookedLightningStormfish",
	"CookedLightningStormfish",
	"CookedLightningStormfish",
	"CookedLightningStormfish"
}

Island.CLASS_INVENTORY = {
	[Weapon.STYLE_MAGIC] = {
		"IsabelliumStaff"
	},

	[Weapon.STYLE_ARCHERY] = {
		"IsabelliumLongbow"
	},

	[Weapon.STYLE_MELEE] = {
		"IsabelliumZweihander"
	}
}

function Island:new(resource, name, ...)
	MapScript.new(self, resource, name or "Sailing_HumanityEdge", ...)

	self:addBehavior(OceanBehavior)
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
		["item-inventory"] = true
	}

	local playerPeepState = playerPeep:getState()
	for _, item in ipairs(items) do
		if not playerPeepState:has("Item", item, 1) then
			playerPeepState:give("Item", item, 1, giveFlags)
		end
	end
end

function Island:_dropPlayerInventory(playerPeep, class)
	local class = Utility.Text.getDialogVariable(playerPeep, "Orlando", "quest_tutorial_main_starting_player_class")
	self:_giveItems(playerPeep, self.ALL_INVENTORY)
	self:_giveItems(playerPeep, self.CLASS_INVENTORY[class] or self.CLASS_INVENTORY[Weapon.STYLE_MAGIC])

	local stage = playerPeep:getDirector():getGameInstance():getStage()

	local itemsToDrop = Utility.Peep.getInventory(playerPeep)
	for _, item in ipairs(itemsToDrop) do
		stage:dropItem(item, item:getCount(), playerPeep)
	end
end

function Island:talkToPeep(playerPeep, otherPeepName, callback)
	local success, dialog = Utility.Peep.dialog(playerPeep, "Talk", otherPeepName)
	if success then
		Utility.Peep.disable(playerPeep)

		if callback then
			dialog.onClose:register(callback)
		end

		dialog.onClose:register(function()
			Utility.Peep.enable(playerPeep)
		end)
	end
end

function Island:onFinishPreparingTutorial(playerPeep)
	if not Utility.Quest.didStep("Tutorial", "Tutorial_EquipItems", playerPeep) then
		self:talkToPeep(playerPeep, "Orlando", function()
			Utility.spawnInstancedMapGroup(playerPeep, "Tutorial_DroppedItems")
			Utility.UI.openGroup(playerPeep, "WORLD")
		end)
	end
end

function Island:prepareTutorial(playerPeep, arguments)
	if not playerPeep then
		return
	end

	if Utility.Quest.didComplete("Tutorial", playerPeep) then
		return
	end

	self.playersInTutorial[playerPeep] = true

	Utility.spawnInstancedMapGroup(playerPeep, "Tutorial_Team")

	if arguments and arguments.class then
		Utility.Text.setDialogVariable(playerPeep, "Orlando", "quest_tutorial_main_starting_player_class", arguments.class)
	end

	if not Utility.Quest.didStep("Tutorial", "Tutorial_GatheredItems", playerPeep) then
		self:_dropPlayerInventory(playerPeep)
	end

	local cutsceneTransition = Utility.UI.getOpenInterface(playerPeep, "CutsceneTransition")
	if cutsceneTransition and not cutsceneTransition:getIsClosing() then
		cutsceneTransition.onBeginClosing:register(self.onFinishPreparingTutorial, self, playerPeep)
	else
		self:poke("finishPreparingTutorial", playerPeep)
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

function Island:updateTutorialGatherItemStep(playerPeep)
	local stage = self:getDirector():getGameInstance():getStage()
	local broker = self:getDirector():getItemBroker()

	local layer = Utility.Peep.getLayer(playerPeep)
	local ground = stage:getGround(layer)
	if not ground then
		Log.warnOnce("Cannot update gather item step; no ground for layer '%d' (player = '%s').", layer, playerPeep:getName())
		return
	end

	local inventory = Utility.Peep.getInventory(ground)
	local playerPeepHasItemOnGround = false
	for _, item in ipairs(inventory) do
		local owner = broker:getItemTag(item, "owner")
		if owner == playerPeep then
			playerPeepHasItemOnGround = true
			break
		end
	end

	if not playerPeepHasItemOnGround then
		playerPeep:getState():give("KeyItem", "Tutorial_GatheredItems")
		self:talkToPeep(playerPeep, "Orlando")
	end
end

function Island:updateTutorialPlayer(playerPeep)
	local stage = self:getDirector():getGameInstance():getStage()

	if Utility.Quest.isNextStep("Tutorial", "Tutorial_GatheredItems", playerPeep) then
		self:updateTutorialGatherItemStep(playerPeep)
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
