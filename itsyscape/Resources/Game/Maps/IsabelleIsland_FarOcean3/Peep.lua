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
local Probe = require "ItsyScape.Peep.Probe"
local CombatStatusBehavior = require "ItsyScape.Peep.Behaviors.CombatStatusBehavior"
local CombatTargetBehavior = require "ItsyScape.Peep.Behaviors.CombatTargetBehavior"
local DisabledBehavior = require "ItsyScape.Peep.Behaviors.DisabledBehavior"
local OceanBehavior = require "ItsyScape.Peep.Behaviors.OceanBehavior"
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
	local layer, ship = Utility.Map.spawnMap(self, "Test_Ship", Vector(0, 8, 0))
	Utility.Peep.setLayer(ship, self:getLayer())

	self.exquisitor = ship

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
end

function Ocean:onPlayerEnter(player)
	--self:pushPoke("placePlayer", player:getActor():getPeep(), "Anchor_Spawn", self.exquisitor)
end

function Ocean:onPlayerLeave(player)
	player:pokeCamera("lockRotation")
end

function Ocean:onPlacePlayer(playerPeep, anchor, ship)
	if not ship then
		return
	end

	local layer = ship:getLayer()
	Utility.Peep.setLayer(playerPeep, layer)

	local map = Utility.Peep.getResource(ship)
	local game = self:getDirector():getGameInstance()
	local x, y, z = Utility.Map.getAnchorPosition(game, map, "Anchor_Spawn")

	Utility.Peep.setPosition(playerPeep, Vector(x, y, z))
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
