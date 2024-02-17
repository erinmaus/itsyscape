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
local Sailing = require "ItsyScape.Game.Skills.Sailing"
local Probe = require "ItsyScape.Peep.Probe"
local PositionBehavior = require "ItsyScape.Peep.Behaviors.PositionBehavior"
local OceanBehavior = require "ItsyScape.Peep.Behaviors.OceanBehavior"
local MashinaBehavior = require "ItsyScape.Peep.Behaviors.MashinaBehavior"
local DisabledBehavior = require "ItsyScape.Peep.Behaviors.DisabledBehavior"
local Map = require "ItsyScape.Peep.Peeps.Map"

local Ocean = Class(Map)
Ocean.MIN_LIGHTNING_PERIOD = 4
Ocean.MAX_LIGHTNING_PERIOD = 5

Ocean.STATE_NONE            = 0
Ocean.STATE_CANNON_TUTORIAL = 1

function Ocean:new(resource, name, ...)
	Map.new(self, resource, name or "IsabelleIsland_FarOcean2", ...)

	self:onZap()
	self:silence("playerEnter", Map.showPlayerMapInfo)

	self.currentTutorialState = Ocean.STATE_NONE
	self.cannonTargets = {}
end

function Ocean:onLoad(...)
	Map.onLoad(self, ...)

	local _, deadPrincess = Utility.Map.spawnShip(
		self,
		"Ship_IsabelleIsland_Pirate",
		self:getLayer(),
		32,
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

	local _, ocean = self:addBehavior(OceanBehavior)
	ocean.weatherBobScale = 1.5
	ocean.weatherRockRange = math.pi / 16
	ocean.weatherRockMultiplier = math.pi / 2

	local stage = self:getDirector():getGameInstance():getStage()
	local index = 0
	for i = -1, 1 do
		for j = -1, 1 do
			local layer, mapScript = stage:loadMapResource(Utility.Peep.getInstance(self), "Sailing_Sector")
			mapScript:addBehavior(PositionBehavior)

			Utility.Peep.setPosition(mapScript, Vector(i * 64 * 2, 0, j * 64 * 2))

			index = index + 1
			stage:forecast(layer, string.format("IsabelleIsland_FarOcean2_HeavyRain%d", index), "Rain", {
				wind = { -15, 0, 0 },
				heaviness = 1 / 8
			})
		end
	end
end

function Ocean:onPlayerEnter(player)
	self:pushPoke("placePlayer", player:getActor():getPeep(), "Anchor_Spawn", self.soakedLog)
end

function Ocean:onPlayerLeave(player)
	player:pokeCamera("lockRotation")
end

function Ocean:onPlacePlayer(playerPeep, anchor, ship)
	do
		local state = playerPeep:getState()
		local FLAGS = { ["item-inventory"] = true }
		state:give("Item", "IronCannonball", 100, FLAGS)
	end

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

	self:showCameraTutorial(playerPeep)
end

function Ocean:onEngage(peepResourceName, mashinaState)
	local peep = self:getDirector():probe(self:getLayerName(), Probe.resource("Peep", peepResourceName))[1]
	local peepMashina = peep and peep:getBehavior(MashinaBehavior)
	if peepMashina then
		peepMashina.currentState = mashinaState
	end
end

function Ocean:onZap()
	self.lightningTime = love.math.random() * (self.MAX_LIGHTNING_PERIOD - self.MIN_LIGHTNING_PERIOD) + self.MIN_LIGHTNING_PERIOD
end

function Ocean:onBoom(ship)
	ship = ship or ({ self.soakedLog, self.deadPrincess })[love.math.random(2)]

	local director = self:getDirector()
	local map = director:getMap(ship:getLayer())
	local i = love.math.random(1, map:getWidth())
	local j = love.math.random(1, map:getHeight())
	local position = Utility.Map.getAbsoluteTilePosition(director, i, j, ship:getLayer())

	local stage = director:getGameInstance():getStage()
	stage:fireProjectile("StormLightning", Vector.ZERO, position, ship:getLayer())
	stage:fireProjectile("CannonSplosion", Vector.ZERO, position, ship:getLayer())
	ship:poke("rock")

	if ship == self.soakedLog then
		local player = Utility.Peep.getPlayerModel(self)
		player:pokeCamera("shake", 0.5)
	end
end

function Ocean:showCameraTutorial(playerPeep)
	local moveTime, zoomTime

	local playerModel = Utility.Peep.getPlayerModel(playerPeep)
	playerModel:pokeCamera("unlockRotation")

	local DURATION = 4
	local TUTORIAL = {
		{
			position = "up",
			id = "root",
			message = _MOBILE and "Use a pinching gesture to zoom in and out." or "Click the left mouse button and drag up or down to zoom in and out.\nYou can also use the middle scroll wheel.",
			open = function(target)
				return function()
					if not zoomTime then
						self:showCameraZoomTutorial(playerPeep, DURATION)
					end

					zoomTime = zoomTime or love.timer.getTime()
					return love.timer.getTime() > zoomTime + DURATION
				end
			end,
		},
		{
			position = "up",
			id = "root",
			message = _MOBILE and "Tap and drag on the screen to move the camera." or "Click the left mouse button and drag around the mouse to move the camera.\nYou can also use the middle mouse button to click and drag.",
			open = function(target)
				return function()
					if not moveTime then
						self:showCameraMoveTutorial(playerPeep, DURATION)
					end

					moveTime = moveTime or love.timer.getTime()
					return love.timer.getTime() > moveTime + DURATION
				end
			end,
		}
	}

	Utility.UI.tutorial(playerPeep, TUTORIAL, function()
		self.currentTutorialState = Ocean.STATE_CANNON_TUTORIAL
	end)
end

function Ocean:showCameraZoomTutorial(playerPeep, duration)
	local playerModel = Utility.Peep.getPlayerModel(playerPeep)
	if playerModel then
		playerModel:pokeCamera("showScroll", {
			0.0, 0.5,
			0.0, 1.0,
			0.0, 0.5
		}, duration)
	end
end

function Ocean:showCameraMoveTutorial(playerPeep, duration)
	local playerModel = Utility.Peep.getPlayerModel(playerPeep)
	if playerModel then
		playerModel:pokeCamera("showMove", {
			0.5,          0.5 - 1 / 16,
			0.5 - 1 / 16, 0.5,
			0.5 - 2 / 16, 0.5 - 1 / 16,
			0.5 - 1 / 16, 0.5,
			0.5,          0.5 - 1 / 16
		}, duration)
	end
end

function Ocean:updateCannonTutorial()
	local position = Sailing.getShipTarget(self.soakedLog, self.deadPrincess)
	local normal = Sailing.getShipDirectionNormal(self.deadPrincess)
	local cannonProbe = Sailing.probeShipCannons(self.soakedLog, position, normal)

	local playerPosition = Utility.Peep.getPosition(Utility.Peep.getPlayer(self))
	table.sort(cannonProbe, function(a, b)
		local positionA = Utility.Peep.getPosition(a.peep)
		local positionB = Utility.Peep.getPosition(b.peep)
		local distanceA = (positionA - playerPosition):getLengthSquared()
		local distanceB = (positionB - playerPosition):getLengthSquared()

		return distanceA < distanceB
	end)

	local foundClosest = false
	for _, p in ipairs(cannonProbe) do
		local t = self.cannonTargets[p.peep]

		local isTarget = false
		local message

		if p.isSameSide then
			isTarget = true

			if p.canFire then
				message = _MOBILE and "Tap the cannon to fire!" or "Click the cannon to fire!"
			else
				message = "Wait for Cap'n Raven's ship to approach before firing!"
			end
		end

		if isTarget and not foundClosest then
			foundClosest = true

			if not t then
				local position = Utility.Peep.getPosition(p.peep)
				t = Utility.spawnPropAtPosition(p.peep, "Target_Default", position.x, position.y, position.z)

				if t then
					t = t:getPeep()
					self.cannonTargets[p.peep] = t
				end
			end

			if t then
				t:setTarget(p.peep, message)
			end
		else
			if t then
				Utility.Peep.poof(t)
				self.cannonTargets[p.peep] = nil
			end
		end
	end
end

function Ocean:updateTutorial()
	if self.currentTutorialState == Ocean.STATE_CANNON_TUTORIAL then
		self:updateCannonTutorial()
	end
end

function Ocean:update(...)
	Map.update(self, ...)

	self.lightningTime = self.lightningTime - self:getDirector():getGameInstance():getDelta()
	if self.lightningTime < 0 then
		self:onZap()
		self:onBoom()
	end

	self:updateTutorial()
end

return Ocean
