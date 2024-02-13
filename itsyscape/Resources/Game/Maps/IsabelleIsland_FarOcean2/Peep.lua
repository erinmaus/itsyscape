--------------------------------------------------------------------------------
-- Resources/Game/Maps/IsabelleIsland_FarOcean2/Peep.lua
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
	Map.new(self, resource, name or 'IsabelleIsland_FarOcean2', ...)
end

function Ocean:onLoad(...)
	Map.onLoad(self, ...)

	local _, deadPrincess = Utility.Map.spawnShip(
		self,
		"Ship_IsabelleIsland_Pirate",
		self:getLayer(),
		48,
		48,
		2.25,
		{ spawnRaven = true })
	self.deadPrincess = deadPrincess
	Utility.Peep.setLayer(self.deadPrincess, self:getLayer())

	local _, soakedLog = Utility.Map.spawnShip(
		self,
		"Ship_IsabelleIsland_PortmasterJenkins",
		self:getLayer(),
		24,
		32,
		2.25,
		{ jenkins_state = 1 })
	self.soakedLog = soakedLog
	Utility.Peep.setLayer(self.soakedLog, self:getLayer())

	local stage = self:getDirector():getGameInstance():getStage()

	local index = 0
	for i = -1, 1 do
		for j = -1, 1 do
			local layer, mapScript = stage:loadMapResource(Utility.Peep.getInstance(self), "Sailing_Sector")
			Utility.Peep.setPosition(mapScript, Vector(i * 64 * 2, 0, j * 64 * 2))

			index = index + 1
			stage:forecast(layer, string.format('IsabelleIsland_FarOcean2_HeavyRain%d', index), 'Rain', {
				wind = { -15, 0, 0 },
				heaviness = 1 / 32
			})
		end
	end
end

function Ocean:onPlayerEnter(player)
	self:pushPoke("placePlayer", player:getActor():getPeep(), "Anchor_Spawn", self.soakedLog)
end

function Ocean:onPlacePlayer(playerPeep, anchor, ship)
	local layer = ship:getLayer()
	Utility.Peep.setLayer(playerPeep, layer)

	local map = Utility.Peep.getResource(ship)
	local game = self:getDirector():getGameInstance()
	local x, y, z = Utility.Map.getAnchorPosition(game, map, "Anchor_Spawn")

	Utility.Peep.setPosition(playerPeep, Vector(x, y, z))

	self:pushPoke("playCutscene", playerPeep, "IsabelleIsland_FarOcean2_Intro")
end

function Ocean:onPlayCutscene(playerPeep, cutscene)
	Utility.UI.closeAll(playerPeep, nil, { "CutsceneTransition" })

	local cutscene = Utility.Map.playCutscene(self, cutscene, "StandardCutscene", playerPeep)
	cutscene:listen("done", self.onFinishCutscene, self, playerPeep)
end

function Ocean:onFinishCutscene(playerPeep)
	Utility.UI.openGroup(
		playerPeep,
		Utility.UI.Groups.WORLD)
end

function Ocean:onFireCannons(ship)
	local shipLayer = ship:getLayer()

	local hits = self:getDirector():probe(self:getLayerName(), function(peep)
		local peepLayer = Utility.Peep.getLayer(peep)
		if peepLayer ~= shipLayer then
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

	for _, cannon in ipairs(hits) do
		cannon:poke('fire', Utility.Peep.getPlayer(self))
	end
end

return Ocean
