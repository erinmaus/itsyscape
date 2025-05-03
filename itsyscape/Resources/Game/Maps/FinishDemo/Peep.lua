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
local Utility = require "ItsyScape.Game.Utility"
local MapScript = require "ItsyScape.Peep.Peeps.Map"
local DramaticTextController = require "ItsyScape.UI.Interfaces.DramaticTextController"

local NewGame = Class(MapScript)

function NewGame:onLoad(...)
	MapScript.onLoad(self, ...)

	self:addBehavior(DisabledBehavior)
	self:silence("playerEnter", MapScript.showPlayerMapInfo)
end

function NewGame:onPlayerEnter(player)
	local playerPeep = player:getActor():getPeep()
	Utility.Peep.disable(playerPeep)

	Utility.UI.openInterface(playerPeep, "CutsceneTransition", false, math.huge)
	Utility.UI.openInterface(playerPeep, "DramaticText", false, { {
		color = { 1, 1, 1, 1 },
		font = "Resources/Renderers/Widget/Common/Serif/Bold.ttf",
		fontSize = 96,
		textShadow = true,
		align = 'center',
		width = DramaticTextController.CANVAS_WIDTH - 64,
		x = 32,
		y = DramaticTextController.CANVAS_HEIGHT / 2 - 64,
		text = "Thanks for playing!"
	} }, 5)

	self:pushPoke(6, "endGameForPlayer", player)
end

function NewGame:onEndGameForPlayer(player)
	player:onLeave()
end

return NewGame
