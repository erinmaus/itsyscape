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
local Sailing = require "ItsyScape.Game.Skills.Sailing"
local Color = require "ItsyScape.Graphics.Color"
local Probe = require "ItsyScape.Peep.Probe"
local OceanBehavior = require "ItsyScape.Peep.Behaviors.OceanBehavior"
local DisabledBehavior = require "ItsyScape.Peep.Behaviors.DisabledBehavior"
local MapScript = require "ItsyScape.Peep.Peeps.Map"

local Island = Class(MapScript)

function Island:new(resource, name, ...)
	MapScript.new(self, resource, name or "Sailing_HumanityEdge", ...)

	self:addBehavior(OceanBehavior)
	self:silence("playerEnter", MapScript.showPlayerMapInfo)
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

function Island:_dropPlayerInventory(playerPeep)
	local stage = playerPeep:getDirector():getGameInstance():getStage()

	local itemsToDrop = Utility.Peep.getInventory(playerPeep)
	for _, item in ipairs(itemsToDrop) do
		stage:dropItem(item)
	end
end

function Island:onFinishPreparingTutorial(playerPeep)
	if not Utility.Quest.didStart("Tutorial", playerPeep) then
		self:_dropPlayerInventory(playerPeep)

		local success, dialog = Utility.Peep.dialog(playerPeep, "Talk", "Orlando")
		if success then
			Utility.Peep.disable(playerPeep)

			dialog.onClose:register(function()
				Utility.UI.openGroup(playerPeep, "WORLD")
				Utility.Peep.enable(playerPeep)
			end)
		end
	end
end

function Island:prepareTutorial(playerPeep, arguments)
	if not playerPeep then
		return
	end

	if Utility.Quest.didComplete("Tutorial", playerPeep) then
		return
	end

	Utility.spawnInstancedMapGroup(playerPeep, "Team")

	if arguments and arguments.class then
		Utility.Text.setDialogVariable(playerPeep, "Orlando", "quest_tutorial_main_starting_player_class", arguments.class)
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

	player:pokeCamera("lockPosition")
end

return Island
