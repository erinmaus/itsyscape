--------------------------------------------------------------------------------
-- Resources/Game/Maps/TitleScreen_RuinsOfRhysilk/Peep.lua
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
local Probe = require "ItsyScape.Peep.Probe"

local TitleScreen = Class(Map)
TitleScreen.RUINS_LOCATION = Vector(-48, 0, -48)

function TitleScreen:new(resource, name, ...)
	Map.new(self, resource, name or 'TitleScreen_EmptyRuins', ...)
end

function TitleScreen:onLoad(filename, args, layer)
	Map.onLoad(self, filename, args, layer)

	local _, map = Utility.Map.spawnMap(
		self,
		"Sailing_RuinsOfRhysilk",
		TitleScreen.RUINS_LOCATION)
	map:listen("finalize", function()
		local director = self:getDirector()
		local fog = director:probe(self:getLayerName(), Probe.namedMapObject("Light_Fog1"))[1]
		if fog then
			fog:setNearDistance(40)
			fog:setFarDistance(60)
		end
	end)

	self:pushPoke("initTitleScreen")
end

function TitleScreen:onInitTitleScreen()
	local player = Utility.Peep.getPlayerModel(self)
	player:changeCamera("StandardCutscene")
	player:pokeCamera("targetActor", player:getActor():getID())
	player:pokeCamera("zoom", 50, 0)
	player:pokeCamera("verticalRotate", -math.pi / 2 + math.pi / 4, 0)
end

return TitleScreen
