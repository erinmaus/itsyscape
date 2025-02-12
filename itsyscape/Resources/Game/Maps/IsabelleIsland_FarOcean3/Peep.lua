--------------------------------------------------------------------------------
-- Resources/Game/Maps/IsabelleIsland_FarOcean3/Peep.lua
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
local Sailing = require "ItsyScape.Game.Skills.Sailing"
local Color = require "ItsyScape.Graphics.Color"
local Probe = require "ItsyScape.Peep.Probe"
local CombatStatusBehavior = require "ItsyScape.Peep.Behaviors.CombatStatusBehavior"
local CombatTargetBehavior = require "ItsyScape.Peep.Behaviors.CombatTargetBehavior"
local DisabledBehavior = require "ItsyScape.Peep.Behaviors.DisabledBehavior"
local OceanBehavior = require "ItsyScape.Peep.Behaviors.OceanBehavior"
local PositionBehavior = require "ItsyScape.Peep.Behaviors.PositionBehavior"
local WhirlpoolBehavior = require "ItsyScape.Peep.Behaviors.WhirlpoolBehavior"
local Map = require "ItsyScape.Peep.Peeps.Map"

local Ocean = Class(Map)
Ocean.MIN_LIGHTNING_PERIOD = 4
Ocean.MAX_LIGHTNING_PERIOD = 5

function Ocean:new(resource, name, ...)
	Map.new(self, resource, name or "IsabelleIsland_FarOcean3", ...)

	self:addBehavior(OceanBehavior)

	--self:silence("playerEnter", Map.showPlayerMapInfo)
end

function Ocean:onLoad(...)
	Map.onLoad(self, ...)

	Utility.Map.spawnMap(self, "Test123_Storm", Vector.ZERO, { isLayer = true })
	Utility.spawnMapAtAnchor(self, "Sailing_ParadoxGatesArchipelago_Island1", "Island1")

	local layer, ship = Utility.Map.spawnMap(self, "Test_Ship", Vector(32, 8, 32))
	Utility.Peep.setLayer(ship, self:getLayer())

	self.exquisitor = ship

	local exquisitorCustomizations = Sailing.Ship.getNPCCustomizations(
		self:getDirector():getGameInstance(),
		"NPC_Isabelle_Exquisitor")
	self.exquisitor:pushPoke("customize", exquisitorCustomizations)

	-- local exquisitor = gameDB:getResource("NPC_Isabelle_Exquisitor", "SailingShip")
	-- local _, ship = Utility.Map.spawnMap(
	-- 	self,
	-- 	"Test_Ship",
	-- 	self:getLayer(),
	-- 	1,
	-- 	1,
	-- 	0)
	-- ship:pushPoke("customize", exquisitor)

	-- self.exquisitor = exquisitor

	local stage = self:getDirector():getGameInstance():getStage()
	do
		local layer, mapScript = stage:loadMapResource(Utility.Peep.getInstance(self), "Sailing_Sector")
		mapScript:addBehavior(PositionBehavior)

		Utility.Peep.setPosition(mapScript, Vector(-32, 0, -32))

		stage:forecast(layer, "IsabelleIsland_FarOcean2_HeavyRain", "Rain", {
			wind = { -15, 0, 0 },
			gravity = { 0, -50, 0 },
			heaviness = 1 / 2,
			color = { Color.fromHexString("aaeeff", 0.8):get() },
			size = 1 / 32
		})
	end
end

function Ocean:onPlayerEnter(player)
	player:pokeCamera("mapRotationStick")

	self:pushPoke("placePlayer", player:getActor():getPeep(), "Anchor_Captain", self.exquisitor)
end

function Ocean:onPlayerLeave(player)
	if player then
		player:pokeCamera("mapRotationUnstick")
	end
end

function Ocean:onPlacePlayer(playerPeep, anchor, ship)
	if not ship then
		return
	end

	local layer = ship:getLayer()
	Utility.Peep.setLayer(playerPeep, layer)

	local map = Utility.Peep.getResource(ship)
	local game = self:getDirector():getGameInstance()
	local x, y, z, localLayer = Utility.Map.getAnchorPosition(game, map, anchor)

	Utility.Peep.setPosition(playerPeep, Vector(x, y, z))
	Utility.Peep.setLocalLayer(playerPeep, localLayer, ship)
end

function Ocean:onZap()
	self.lightningTime = love.math.random() * (self.MAX_LIGHTNING_PERIOD - self.MIN_LIGHTNING_PERIOD) + self.MIN_LIGHTNING_PERIOD
end

function Ocean:onBoom(ship)
	ship = ship or self.exquisitor
	if not ship then
		return
	end

	local director = self:getDirector()
	local map = director:getMap(ship:getLayer())
	if not map then
		return
	end

	local i = love.math.random(1, map:getWidth())
	local j = love.math.random(1, map:getHeight())

	local position = Utility.Map.getAbsoluteTilePosition(director, i, j, ship:getLayer())

	local stage = director:getGameInstance():getStage()
	stage:fireProjectile("StormLightning", Vector.ZERO, position, ship:getLayer())
	stage:fireProjectile("CannonSplosion", Vector.ZERO, position, ship:getLayer())
	ship:poke("rock")

	if ship == self.exquisitor then
		local player = Utility.Peep.getPlayerModel(self)
		player:pokeCamera("shake", 0.5)
	end
end

function Ocean:update(...)
	Map.update(self, ...)

	self.lightningTime = (self.lightningTime or 0) - self:getDirector():getGameInstance():getDelta()
	if self.lightningTime < 0 then
		self:onZap()
		self:onBoom()
	end
end

return Ocean
