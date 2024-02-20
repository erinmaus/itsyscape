--------------------------------------------------------------------------------
-- Resources/Game/Maps/NewGame/Peep.lua
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
local MapScript = require "ItsyScape.Peep.Peeps.Map"
local DisabledBehavior = require "ItsyScape.Peep.Behaviors.DisabledBehavior"
local DramaticTextController = require "ItsyScape.UI.Interfaces.DramaticTextController"

local NewGame = Class(MapScript)
NewGame.SISTINE_LOCATION = Vector(-48, -32, -48)

function NewGame:onLoad(...)
	MapScript.onLoad(self, ...)

	self:silence("playerEnter", MapScript.showPlayerMapInfo)

	Utility.Map.spawnMap(
		self,
		"EmptyRuins_SistineOfTheSimulacrum_Outside",
		NewGame.SISTINE_LOCATION)
end

function NewGame:onPlayerEnter(player)
	local playerPeep = player:getActor():getPeep()
	playerPeep:addBehavior(DisabledBehavior)

	player:changeCamera("StandardCutscene")
	player:pokeCamera("targetActor", player:getActor():getID())
	player:pokeCamera("zoom", 100, 0)
	player:pokeCamera("verticalRotate", -math.pi / 2 + math.pi / 8, 0)

	Utility.UI.closeAll(playerPeep)
	Utility.UI.openInterface(playerPeep, "CharacterCustomization", true, function()
		local stage = self:getDirector():getGameInstance():getStage()

		Utility.UI.openInterface(playerPeep, "CutsceneTransition", false)
		Utility.UI.openInterface(playerPeep, "DramaticText", false, { {
			color = { 1, 1, 1, 1 },
			font = "Resources/Renderers/Widget/Common/Serif/Bold.ttf",
			fontSize = 96,
			textShadow = true,
			align = 'center',
			width = DramaticTextController.CANVAS_WIDTH - 64,
			x = 32,
			y = DramaticTextController.CANVAS_HEIGHT / 2 - 64,
			text = string.format("Welcome to the Realm, %s.", playerPeep:getName())
		} }, 4)

		stage:movePeep(
			playerPeep,
			"@EmptyRuins_Downtown?cutscene=1,mute=1",
			"Anchor_Spawn")
		-- stage:movePeep(
		-- 	playerPeep,
		-- 	"@IsabelleIsland_FarOcean2",
		-- 	"Anchor_Spawn")
	end)
end

function NewGame:onPlayerLeave(player)
	player:changeCamera("Default")
end

return NewGame
