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
local CombatStatusBehavior = require "ItsyScape.Peep.Behaviors.CombatStatusBehavior"
local CombatTargetBehavior = require "ItsyScape.Peep.Behaviors.CombatTargetBehavior"
local DisabledBehavior = require "ItsyScape.Peep.Behaviors.DisabledBehavior"
local PositionBehavior = require "ItsyScape.Peep.Behaviors.PositionBehavior"
local OceanBehavior = require "ItsyScape.Peep.Behaviors.OceanBehavior"
local MashinaBehavior = require "ItsyScape.Peep.Behaviors.MashinaBehavior"
local WhirlpoolBehavior = require "ItsyScape.Peep.Behaviors.WhirlpoolBehavior"
local Map = require "ItsyScape.Peep.Peeps.Map"

local Ocean = Class(Map)
Ocean.MIN_LIGHTNING_PERIOD = 4
Ocean.MAX_LIGHTNING_PERIOD = 5

Ocean.STATE_NONE            = 0
Ocean.STATE_CANNON_TUTORIAL = 1
Ocean.STATE_CTHULHU_RISE    = 2
Ocean.STATE_CTHULHU_FLEE    = 3
Ocean.STATE_DONE            = 4

Ocean.MAX_WHIRLPOOL_RADIUS      = 32
Ocean.WHIRLPOOL_GROW_DURATION   = 4

Ocean.MIN_DAMAGE_THRESHOLD   = 20

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
	ocean.offset = 1
	ocean.positionTimeScale = 4
	ocean.textureTimeScale = Vector(math.pi / 4, 1 / 2, 0)

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
	Utility.Quest.listenForKeyItemHint(player, "PreTutorial")

	self:pushPoke("placePlayer", player:getActor():getPeep(), "Anchor_Spawn", self.soakedLog)
end

function Ocean:onPlayerLeave(player)
	player:pokeCamera("lockRotation")
end

function Ocean:onPlacePlayer(playerPeep, anchor, ship)
	local layer = ship:getLayer()
	Utility.Peep.setLayer(playerPeep, layer)

	local map = Utility.Peep.getResource(ship)
	local game = self:getDirector():getGameInstance()
	local x, y, z = Utility.Map.getAnchorPosition(game, map, "Anchor_Spawn")

	Utility.Peep.setPosition(playerPeep, Vector(x, y, z))

	if Utility.Quest.isNextStep("PreTutorial", "PreTutorial_Start", playerPeep) then
		self:pushPoke("playCutscene", playerPeep, "IsabelleIsland_FarOcean2_Intro")
	elseif Utility.Quest.isNextStep("PreTutorial", "PreTutorial_CthulhuRises", playerPeep) then
		self:summonCthulhu()
	else
		playerPeep:removeBehavior(DisabledBehavior)

		Utility.UI.closeAll(playerPeep, nil, { "CutsceneTransition", "DramaticText" })
		Utility.UI.openGroup(playerPeep, Utility.UI.Groups.WORLD)

		-- This usually shouldn't happen...
		playerPeep:getState():give("KeyItem", "PreTutorial_DefendShip")
		game:getStage():movePeep(playerPeep, "Sailing_WhalingTemple", "Anchor_Spawn")
	end
end

function Ocean:onPlayCutscene(playerPeep, cutscene)
	Utility.UI.closeAll(playerPeep, nil, { "CutsceneTransition" })

	playerPeep:addBehavior(DisabledBehavior)
	local cutscene = Utility.Map.playCutscene(self, cutscene, "StandardCutscene", playerPeep)
	cutscene:listen("done", self.onFinishCutscene, self, playerPeep)
end

function Ocean:onFinishCutscene(playerPeep)
	Utility.UI.openGroup(
		playerPeep,
		Utility.UI.Groups.WORLD)

	if self.currentTutorialState == Ocean.STATE_NONE then
		self:showCameraTutorial(playerPeep)
	else
		playerPeep:removeBehavior(DisabledBehavior)
	end

	local playerModel = Utility.Peep.getPlayerModel(playerPeep)
	playerModel:pokeCamera("unlockRotation")
end

function Ocean:onZap()
	self.lightningTime = love.math.random() * (self.MAX_LIGHTNING_PERIOD - self.MIN_LIGHTNING_PERIOD) + self.MIN_LIGHTNING_PERIOD
end

function Ocean:onBoom(ship)
	ship = ship or ({ self.soakedLog, self.deadPrincess })[love.math.random(2)]

	local director = self:getDirector()
	local map = director:getMap(ship:getLayer())

	local i, j
	repeat
		i = love.math.random(1, map:getWidth())
		j = love.math.random(1, map:getHeight())
	until map:getTile(i, j):hasFlag("floor")

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

function Ocean:onCthulhuRises()
	local stage = self:getDirector():getGameInstance():getStage()
	local cthulhu = Utility.spawnMapObjectAtAnchor(self, "Cthulhu", "Anchor_Cthulhu_Spawn")
	cthulhu:getPeep():listen("ready", function()
		stage:fireProjectile(
			"CthulhuSplash",
			Vector.ZERO,
			Utility.Peep.getAbsolutePosition(cthulhu:getPeep()) + Vector(0, self:getBehavior(OceanBehavior).depth, 0),
			self:getLayer())
	end)

	local squid1 = Utility.spawnMapObjectAtAnchor(self, "UndeadSquid", "Anchor_Squid_Spawn1")
	squid1:getPeep():listen("ready", function()
		stage:fireProjectile(
			"CthulhuSplash",
			Vector.ZERO,
			Utility.Peep.getAbsolutePosition(squid1:getPeep()) + Vector(0, self:getBehavior(OceanBehavior).depth, 0),
			self:getLayer())
	end)

	local squid2 = Utility.spawnMapObjectAtAnchor(self, "UndeadSquid", "Anchor_Squid_Spawn2")
	squid2:getPeep():listen("ready", function()
		stage:fireProjectile(
			"CthulhuSplash",
			Vector.ZERO,
			Utility.Peep.getAbsolutePosition(squid2:getPeep()) + Vector(0, self:getBehavior(OceanBehavior).depth, 0),
			self:getLayer())
	end)

	local squid3 = Utility.spawnMapObjectAtAnchor(self, "UndeadSquid", "Anchor_Squid_Spawn3")
	squid3:getPeep():listen("ready", function()
		stage:fireProjectile(
			"CthulhuSplash",
			Vector.ZERO,
			Utility.Peep.getAbsolutePosition(squid3:getPeep()) + Vector(0, self:getBehavior(OceanBehavior).depth, 0),
			self:getLayer())
	end)
end

function Ocean:onFlee()
	self.currentTutorialState = Ocean.STATE_CTHULHU_FLEE
end

function Ocean:showCameraTutorial(playerPeep)
	local moveTime, zoomTime

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

function Ocean:summonCthulhu()
	self.currentTutorialState = Ocean.STATE_CTHULHU_RISE

	local player = Utility.Peep.getPlayer(self)
	if player then
		self:pushPoke("playCutscene", player, "IsabelleIsland_FarOcean2_CthulhuRises")
	end
end

function Ocean:updateCannonTutorial()
	local currentHealth = self.deadPrincess:getCurrentHealth()
	local maxHealth = self.deadPrincess:getMaxHealth()
	local difference = math.max(maxHealth - currentHealth, 0)

	if difference >= Ocean.MIN_DAMAGE_THRESHOLD then
		for k, v in pairs(self.cannonTargets) do
			Utility.Peep.poof(v)
			self.cannonTargets[k] = nil
		end

		self:summonCthulhu()
	end
end

function Ocean:updateCthulhuRise()
	self.whirlpoolTime = self.whirlpoolTime and (self.whirlpoolTime - self:getDirector():getGameInstance():getDelta()) or Ocean.WHIRLPOOL_GROW_DURATION

	local _, whirlpool = self:addBehavior(WhirlpoolBehavior)
	whirlpool.radius = (1 - math.max(self.whirlpoolTime / Ocean.WHIRLPOOL_GROW_DURATION, 0)) * Ocean.MAX_WHIRLPOOL_RADIUS
	whirlpool.holeRadius = whirlpool.radius / 2
	whirlpool.rings = 10
	whirlpool.rotationSpeed = 2.5
	whirlpool.holeSpeed = 0.5
	whirlpool.center = Vector(
		Utility.Map.getAnchorPosition(
			self:getDirector():getGameInstance(),
			Utility.Peep.getMapResource(self),
			"Anchor_Cthulhu_Spawn"))
end

function Ocean:updateCthulhuFlee()
	self:updateCannonTargets()

	local hits = self:getDirector():probe(
		self:getLayerName(),
		Probe.resource("Peep", "IsabelleIsland_Port_UndeadSquid"))

	local isAlive = false
	for _, hit in ipairs(hits) do
		local status = hit:getBehavior(CombatStatusBehavior)
		if not status.dead then
			isAlive = true
			break
		end
	end

	if not isAlive then
		local playerPeep = Utility.Peep.getPlayer(self)
		if playerPeep then
			self:pushPoke("playCutscene", playerPeep, "IsabelleIsland_FarOcean2_SurvivedSquids")
			self.currentTutorialState = Ocean.STATE_DONE
		end
	end
end

function Ocean:updateWhirlpoolPosition()
	local whirlpool = self:getBehavior(WhirlpoolBehavior)
	if not whirlpool then
		return
	end

	local cthulhu = self:getDirector():probe(self:getLayerName(), Probe.resource("Peep", "Cthulhu"))[1]
	if not cthulhu then
		return
	end

	whirlpool.center = Utility.Peep.getPosition(cthulhu)
end

function Ocean:updateCannonTargets()
	if self.currentTutorialState ~= Ocean.STATE_CANNON_TUTORIAL and self.currentTutorialState ~= Ocean.STATE_CTHULHU_FLEE then
		for k, v in pairs(self.cannonTargets) do
			Utility.Peep.poof(v)
			self.cannonTargets[k] = nil
		end

		return
	end

	local playerPeep = Utility.Peep.getPlayer(self)
	if not playerPeep then
		return
	end
	local playerPosition = Utility.Peep.getPosition(playerPeep)

	local leaks = self:getDirector():probe(
		self:getLayerName(),
		Probe.layer(Utility.Peep.getLayer(playerPeep)),
		Probe.resource("Prop", "IsabelleIsland_Port_WaterLeak"))

	table.sort(leaks, function(a, b)
		local positionA = Utility.Peep.getPosition(a)
		local positionB = Utility.Peep.getPosition(b)
		local distanceA = (positionA - playerPosition):getLengthSquared()
		local distanceB = (positionB - playerPosition):getLengthSquared()

		return distanceA < distanceB
	end)

	if #leaks >= 1 then
		local leak = leaks[1]

		for k, v in pairs(self.cannonTargets) do
			if k ~= leak then
				Utility.Peep.poof(v)
				self.cannonTargets[k] = nil
			end
		end

		local t = self.cannonTargets[leak]
		if not t then
			local position = Utility.Peep.getPosition(leak)
			t = Utility.spawnPropAtPosition(leak, "Target_Default", position.x, position.y, position.z)

			if t then
				t = t:getPeep()
				self.cannonTargets[leak] = t
			end
		end

		if t then
			t:setTarget(leak, _MOBILE and "Tap to fix the leak!" or "Click to fix the leak!")
		end

		return
	else
		for k, v in pairs(self.cannonTargets) do
			local resource, resourceType = Utility.Peep.getResource(k)
			if resource and resource.name == "IsabelleIsland_Port_WaterLeak" and resourceType.name == "Prop" then
				Utility.Peep.poof(v)
				self.cannonTargets[k] = nil
			end
		end
	end

	local ironCannonballPile = self:getDirector():probe(
		self:getLayerName(),
		Probe.layer(Utility.Peep.getLayer(playerPeep)),
		Probe.resource("Prop", "ironCannonballPile"))[1]

	if playerPeep:getState():count("Item", "IronCannonball", { ['item-inventory'] = true }) == 0 then
		if ironCannonballPile then
			local t = self.cannonTargets[ironCannonballPile]
			if not t then
				local position = Utility.Peep.getPosition(ironCannonballPile)
				t = Utility.spawnPropAtPosition(ironCannonballPile, "Target_Default", position.x, position.y, position.z)

				if t then
					t = t:getPeep()
					self.cannonTargets[ironCannonballPile] = t
				end
			end

			if t then
				t:setTarget(ironCannonballPile, _MOBILE and "Tap the cannonball pile to grab some cannonballs!" or "Click the cannonball pile to grab some cannonballs!")
			end

			for k, v in pairs(self.cannonTargets) do
				if k ~= ironCannonballPile then
					Utility.Peep.poof(v)
					self.cannonTargets[k] = nil
				end
			end
		end

		return
	else
		if ironCannonballPile then
			local t = self.cannonTargets[ironCannonballPile]
			if t then
				Utility.Peep.poof(t)
				self.cannonTargets[ironCannonballPile] = nil
			end
		end
	end

	local isFightingSquids = false
	local position, normal
	do
		local rosalind = self:getDirector():probe(
			self:getLayerName(),
			Probe.layer(Utility.Peep.getLayer(playerPeep)),
			Probe.resource("Peep", "IsabelleIsland_Rosalind"))[1]

		local target = rosalind:getBehavior(CombatTargetBehavior)
		target = target and target.actor and target.actor:getPeep()
		if target then
			isFightingSquids = true
			position = Utility.Peep.getPosition(target)
		else
			position = Sailing.getShipTarget(self.soakedLog, self.deadPrincess)
			normal = Sailing.getShipDirectionNormal(self.deadPrincess)
		end
	end

	local cannonProbe = Sailing.probeShipCannons(self.soakedLog, position, normal)

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
				if isFightingSquids then
					message = "Wait for the squid to get closer before firing!"
				else
					message = "Wait for Cap'n Raven's ship to approach before firing!"
				end
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
	elseif self.currentTutorialState == Ocean.STATE_CTHULHU_RISE then
		self:updateCthulhuRise()
	elseif self.currentTutorialState == Ocean.STATE_CTHULHU_FLEE then
		self:updateCthulhuFlee()
	end

	self:updateCannonTargets()
	self:updateWhirlpoolPosition()
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
