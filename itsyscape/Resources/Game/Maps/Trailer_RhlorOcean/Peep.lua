--------------------------------------------------------------------------------
-- Resources/Game/Maps/Trailer_RhlorOcean/Peep.lua
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

local Ocean = Class(Map)

function Ocean:new(resource, name, ...)
	Map.new(self, resource, name or 'Trailer_RhlorOcean', ...)
end

function Ocean:onLoad(filename, args, layer)
	Map.onLoad(self, filename, args, layer)

	local _, playerShip = Utility.Map.spawnShip(
		self,
		"Ship_IsabelleIsland_PortmasterJenkins",
		layer,
		0, 0,
		2.25)
	self.playerShip = playerShip

	local _, pirateShip = Utility.Map.spawnShip(
		self,
		"Ship_IsabelleIsland_Pirate",
		layer,
		0, 0,
		2.25)
	pirateShip:listen("finalize", function()
		Utility.spawnMapObjectAtAnchor(pirateShip, "CapnRaven", "Anchor_CapnRaven_Spawn", 0)
	end)

	self.pirateShip = pirateShip

	local stage = self:getDirector():getGameInstance():getStage()
	stage:forecast(layer, 'IsabelleIsland_Ocean_HeavyRain', 'Rain', {
		wind = { -15, 0, 0 },
		heaviness = 0.125
	})
end

function Ocean:onPlayerEnter(player)
	self:pushPoke("playCutscene", player:getActor():getPeep())
end

function Ocean:onPlayCutscene(player)
	Utility.Map.playCutscene(self, "Trailer_RhlorOcean_Cthulhu", "StandardCutscene", player)
end

function Ocean:onLightningZap(anchor)
	local game = self:getDirector():getGameInstance()
	local position = Vector(Utility.Map.getAnchorPosition(game, Utility.Peep.getMapResource(self), anchor))

	if self.cthulhu then
		local stage = game:getStage()
		stage:fireProjectile("Lightning", self.cthulhu:getPeep(), position)
	end
end

function Ocean:onSpawnCthulhu(anchor)
	local game = self:getDirector():getGameInstance()
	self.cthulhu = Utility.spawnMapObjectAtAnchor(self, "Cthulhu", anchor, 0)

	if self.playerShip then
		self.playerShip:poke("rock")
	end

	if self.pirateShip then
		self.pirateShip:poke("rock")
	end
end

return Ocean
