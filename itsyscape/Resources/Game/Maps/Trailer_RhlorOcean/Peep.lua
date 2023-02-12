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
local Quaternion = require "ItsyScape.Common.Math.Quaternion"
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
	Utility.UI.closeAll(player)
	Utility.Map.playCutscene(self, "Trailer_RhlorOcean_Cthulhu", "StandardCutscene", player)
end

function Ocean:onLightningZap(anchor)
	if not self.cthulhu then
		return
	end

	local game = self:getDirector():getGameInstance()
	local cthulhuPosition = Utility.Peep.getPosition(self.cthulhu:getPeep())
	local radius = love.math.random(10, 15)
	local x = love.math.random() * 2 - 1
	local z = love.math.random() * 2 - 1
	local position = Vector(x, 0, z):getNormal() * radius + cthulhuPosition

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

	self.cthulhu:getPeep():listen('finalize', function(peep)
		Utility.UI.openInterface(
			Utility.Peep.getInstance(self),
			"BossHUD",
			false,
			peep)
	end)
end

function Ocean:onFirePiratesCannons()
	if not self.pirateShip then
		return
	end

	local pirateShipLayer = Utility.Peep.getLayer(self.pirateShip)
	local hits = self:getDirector():probe(self:getLayerName(), function(peep)
		local peepLayer = Utility.Peep.getLayer(peep)
		if peepLayer ~= pirateShipLayer then
			return false
		end

		local resource = Utility.Peep.getResource(peep)
		if not resource or resource.name ~= "Sailing_IronCannon_Default" then
			return false
		end

		local rotation = Utility.Peep.getRotation(peep)
		if rotation == Quaternion.IDENTITY then
			return false
		end

		return true
	end)

	for i = 1, #hits do
		local cannon = hits[i]
		cannon:poke('fire')
	end
end

return Ocean
