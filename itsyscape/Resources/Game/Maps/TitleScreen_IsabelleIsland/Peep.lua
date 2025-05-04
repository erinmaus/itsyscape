--------------------------------------------------------------------------------
-- Resources/Game/Maps/TitleScreen_IsabelleIsland/Peep.lua
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
local Probe = require "ItsyScape.Peep.Probe"
local Map = require "ItsyScape.Peep.Peeps.Map"

local TitleScreen = Class(Map)
TitleScreen.LOCATION = Vector(-32, 0, -32)

function TitleScreen:new(resource, name, ...)
	Map.new(self, resource, name or 'TitleScreen_IsabelleIsland', ...)
end

function TitleScreen:onLoad(filename, args, layer)
	Map.onLoad(self, filename, args, layer)

	Utility.Map.spawnMap(
		self,
		"IsabelleIsland_FoggyForest2",
		TitleScreen.LOCATION)
end

function TitleScreen:onPlayerEnter(player)
	self:pushPoke("initTitleScreen", player)
end

function TitleScreen:onInitTitleScreen(player)
	local director = self:getDirector()
	local fog = director:probe(self:getLayerName(), Probe.namedMapObject("Light_Fog"))[1]
	if fog then
		fog:setNearDistance(80)
		fog:setFarDistance(140)
		fog:setFollowEye()
	end

	if player:getActor() then
		player:changeCamera("StandardCutscene")
		player:pokeCamera("targetActor", player:getActor():getID())
		player:pokeCamera("translate", Vector(0, 15, 0))
		player:pokeCamera("zoom", 80, 0)
		player:pokeCamera("horizontalRotate", -math.pi / 16)
		player:pokeCamera("verticalRotate", math.pi / 8, 0)
	end
end

return TitleScreen
