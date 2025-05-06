--------------------------------------------------------------------------------
-- Resources/Game/Maps/Purgatory/Peep.lua
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

local Purgatory = Class(MapScript)

function Purgatory:onLoad(...)
	MapScript.onLoad(self, ...)

	self:silence("playerEnter", MapScript.showPlayerMapInfo)
end

function Purgatory:onRezz(playerPeep)
	local director = self:getDirector()
	local stage = director:getGameInstance():getStage()
	local storage = director:getPlayerStorage(playerPeep):getRoot()
	local spawn = storage:getSection("Spawn")
	if spawn and spawn:get("name") then
		local mapName
		if spawn:get("instance") then
			mapName = "@" .. spawn:get("name")
		else
			mapName = spawn:get("name")
		end

		Utility.move(playerPeep, mapName, Vector(spawn:get("x"), spawn:get("y"), spawn:get("z")))
	else
		Utility.move(playerPeep, "NewGame", "Anchor_Spawn")
	end

	playerPeep:poke('resurrect', {})

	Utility.UI.openInterface(playerPeep, "DramaticText", false, { {
		color = { 1, 1, 1, 1 },
		font = "Resources/Renderers/Widget/Common/Serif/Bold.ttf",
		fontSize = 96,
		textShadow = true,
		align = 'center',
		width = DramaticTextController.CANVAS_WIDTH - 64,
		x = 32,
		y = DramaticTextController.CANVAS_HEIGHT / 2 - 64,
		text = string.format("Welcome back to the Realm, %s.", playerPeep:getName())
	} }, 5)
end

function Purgatory:onPlayerEnter(player)
	local playerPeep = player and player:getActor() and player:getActor():getPeep()
	if not playerPeep then
		return
	end

	self:pushPoke("rezz", playerPeep)
end

function Purgatory:onPlayerLeave(player)
	Log.info("TEK: Welcome back, %s.", player and player:getActor() and player:getActor():getPeep() and player:getActor():getPeep():getName() or "???")
end

return Purgatory
