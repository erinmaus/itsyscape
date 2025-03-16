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
NewGame.SISTINE_LOCATION = Vector(-64, -16, -64)

function NewGame:onLoad(...)
	MapScript.onLoad(self, ...)

	self:silence("playerEnter", MapScript.showPlayerMapInfo)

	-- Utility.Map.spawnMap(
	-- 	self,
	-- 	"IsabelleIsland_FoggyForest2",
	-- 	NewGame.SISTINE_LOCATION)
end

function NewGame:onPlayerEnter(player)
	local playerPeep = player:getActor():getPeep()
	playerPeep:addBehavior(DisabledBehavior)

	player:changeCamera("StandardCutscene")
	player:pokeCamera("targetActor", player:getActor():getID())
	player:pokeCamera("zoom", 100, 0)
	player:pokeCamera("verticalRotate", -math.pi / 8, 0)

	Utility.UI.closeAll(playerPeep)
	Utility.UI.openInterface(playerPeep, "DemoNewPlayer", true, function()
		self:movePeep()
	end)
end

function NewGame:onPlayerLeave(player)
	player:changeCamera("Default")
end

return NewGame
