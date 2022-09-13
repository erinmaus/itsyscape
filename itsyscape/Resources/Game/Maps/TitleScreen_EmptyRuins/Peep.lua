--------------------------------------------------------------------------------
-- Resources/Game/Maps/TitleScreen_EmptyRuins/Peep.lua
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
local Map = require "ItsyScape.Peep.Peeps.Map"

local TitleScreen = Class(Map)
TitleScreen.SISTINE_LOCATION = Vector(-48, -32, -48)

function TitleScreen:new(resource, name, ...)
	Map.new(self, resource, name or 'TitleScreen_EmptyRuins', ...)
end

function TitleScreen:onLoad(filename, args, layer)
	Map.onLoad(self, filename, args, layer)

	Utility.Map.spawnMap(
		self,
		"EmptyRuins_SistineOfTheSimulacrum_Outside",
		TitleScreen.SISTINE_LOCATION)
end

function TitleScreen:onPlayerEnter(player)
	self:pushPoke("initTitleScreen", player)
end

function TitleScreen:onInitTitleScreen(player)
	if player:getActor() then
		player:changeCamera("StandardCutscene")
		player:pokeCamera("targetActor", player:getActor():getID())
		player:pokeCamera("zoom", 100, 0)
		player:pokeCamera("verticalRotate", -math.pi / 2 + math.pi / 4, 0)
	end
end

return TitleScreen
