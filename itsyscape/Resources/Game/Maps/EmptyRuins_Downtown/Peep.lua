--------------------------------------------------------------------------------
-- Resources/Game/Maps/EmptyRuins_Downtown/Peep.lua
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
local CombatStatusBehavior = require "ItsyScape.Peep.Behaviors.CombatStatusBehavior"
local PositionBehavior = require "ItsyScape.Peep.Behaviors.PositionBehavior"

local Downtown = Class(Map)
Downtown.SISTINE_LOCATION = Vector(0, 0, -128)

function Downtown:new(resource, name, ...)
	Map.new(self, resource, name or 'EmptyRuins_Downtown', ...)
end

function Downtown:onLoad(filename, args, layer)
	Map.onLoad(self, filename, args, layer)

	local stage = self:getDirector():getGameInstance():getStage()
	stage:forecast(layer, 'EmptyRuins_Downtown_Bubbles', 'Fungal', {
		gravity = { 0, 3, 0 },
		wind = { 0, 0, 0 },
		colors = {
			{ 0.0, 0.0, 0.0, 1.0 },
			{ 0.0, 0.0, 0.0, 1.0 },
			{ 0.7, 0.8, 0.2, 1.0 },
			{ 0.4, 0.2, 0.8, 1.0 }
		},
		minHeight = -10,
		maxHeight = 0,
		ceiling = 20,
		heaviness = 0.5
	})

	local sistineLayer, sistineScript = Utility.Map.spawnMap(
		self, "EmptyRuins_SistineOfTheSimulacrum_Outside", Downtown.SISTINE_LOCATION, { isLayer = true })
	self.sistineLayer = sistineLayer

	self:initTrailerBattlefield()
end

Downtown.TRAILER_ENEMIES = {
	"Tinkerer",
	"Tinkerer",
	"GoryMass",
	"PrestigiousAncientSkeleton",
	"PrestigiousAncientSkeleton",
	"PrestigiousMummy",
	"PrestigiousMummy"
}

Downtown.TRAILER_HEROES = {
	"CinematicTrailer1_Warrior",
	"CinematicTrailer1_Wizard",
	"CinematicTrailer1_Archer"
}

Downtown.TRAILER_HERO_OFFSET = Vector(4196, 5599, 3923)
Downtown.TRAILER_ENEMY_OFFSET = Vector(6099, 2056, 2547)
Downtown.TRAILER_FUDGE = 34.44931573
Downtown.ENEMY_SPAWN_CHANCE = 0.25
Downtown.HERO_SPAWN_CHANCE = 0.5

function Downtown:initTrailerBattlefield()
	local function actionCallback(action)
		if action == "released" then
			local player = Utility.Peep.getPlayer(self)
			local i, j = Utility.Peep.getTile(player)

			local position = player:getBehavior(PositionBehavior)
			if position.layer == self:getLayer() then
				self:spawnEnemy(i, j)
			end
		end
	end

	local function openCallback()
		return not self:wasPoofed()
	end

	Utility.UI.openInterface(
		Utility.Peep.getPlayer(self),
		"KeyboardAction",
		false,
		"DEBUG_TRIGGER_1", actionCallback, openCallback)

	local function actionCallback(action)
		if action == "released" then
			local player = Utility.Peep.getPlayer(self)
			local position = player:getBehavior(PositionBehavior)

			if position.layer == self.sistineLayer then
				position.layer = self:getLayer()
			else
				position.layer = self.sistineLayer
			end

			position.position.y = 10
		end
	end

	local function openCallback()
		return not self:wasPoofed()
	end

	Utility.UI.openInterface(
		Utility.Peep.getPlayer(self),
		"KeyboardAction",
		false,
		"DEBUG_TRIGGER_2", actionCallback, openCallback)
end

function Downtown:spawnEnemy(i, j)
	local map = Utility.Peep.getMap(Utility.Peep.getPlayer(self))
	local center = map:getTileCenter(i, j) + Vector.UNIT_Y

	local enemyIndex
	do
		local fudgedCenter = center * Downtown.TRAILER_FUDGE + Downtown.TRAILER_ENEMY_OFFSET
		local enemyNoise = love.math.noise(fudgedCenter:get())
		enemyIndex = math.ceil(enemyNoise * #Downtown.TRAILER_ENEMIES)
	end

	local enemy = Downtown.TRAILER_ENEMIES[enemyIndex]
	local actor = Utility.spawnActorAtPosition(self, enemy, center:get())
	actor:getPeep():listen('finalize', function(peep)
		local status = peep:getBehavior(CombatStatusBehavior)
		status.currentHitpoints = math.huge
		status.maxHitpoints = math.huge
		status.maxChaseDistance = math.huge
	end)

	local enemyPeep = actor:getPeep()
	self:trySpawnHero(enemyPeep, i - 1, j)
	self:trySpawnHero(enemyPeep, i + 1, j)
	self:trySpawnHero(enemyPeep, i, j - 1)
	self:trySpawnHero(enemyPeep, i, j + 1)
end

function Downtown:trySpawnHero(enemy, i, j)
	local map = Utility.Peep.getMap(Utility.Peep.getPlayer(self))
	if i < 1 or j < 1 or i > map:getWidth() or j > map:getHeight() then
		return
	end

	local center = map:getTileCenter(i, j)
	local noise
	do
		local fudgedCenter = center * Downtown.TRAILER_FUDGE
		noise = love.math.noise(fudgedCenter:get())
	end

	if noise < Downtown.HERO_SPAWN_CHANCE then
		self:spawnHero(enemy, i, j)
	end
end

function Downtown:spawnHero(enemy, i, j)
	local map = Utility.Peep.getMap(Utility.Peep.getPlayer(self))
	local center = map:getTileCenter(i, j)

	local heroIndex
	do
		local fudgedCenter = center * Downtown.TRAILER_FUDGE + Downtown.TRAILER_HERO_OFFSET
		local heroNoise = love.math.noise(fudgedCenter:get())
		heroIndex = math.ceil(heroNoise * #Downtown.TRAILER_HEROES)
	end

	local hero = Downtown.TRAILER_HEROES[heroIndex]
	local actor = Utility.spawnActorAtPosition(self, hero, center:get())
	actor:getPeep():listen('finalize', function(peep)
		Utility.Peep.attack(peep, enemy)
	end)
end

return Downtown
