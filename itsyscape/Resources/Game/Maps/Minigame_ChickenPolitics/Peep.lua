--------------------------------------------------------------------------------
-- Resources/Game/Maps/Rumbridge_Port/Peep.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Ray = require "ItsyScape.Common.Math.Ray"
local Vector = require "ItsyScape.Common.Math.Vector"
local CacheRef = require "ItsyScape.Game.CacheRef"
local Score = require "ItsyScape.Game.Score"
local Utility = require "ItsyScape.Game.Utility"
local AttackPoke = require "ItsyScape.Peep.AttackPoke"
local Probe = require "ItsyScape.Peep.Probe"
local Map = require "ItsyScape.Peep.Peeps.Map"
local DisabledBehavior = require "ItsyScape.Peep.Behaviors.DisabledBehavior"
local ActorReferenceBehavior = require "ItsyScape.Peep.Behaviors.ActorReferenceBehavior"
local MovementBehavior = require "ItsyScape.Peep.Behaviors.MovementBehavior"
local ScoreBehavior = require "ItsyScape.Peep.Behaviors.ScoreBehavior"
local SizeBehavior = require "ItsyScape.Peep.Behaviors.SizeBehavior"

local Minigame = Class(Map)
Minigame.MIN_TICK = 1
Minigame.MAX_TICK = 10
Minigame.SPAWN_ELEVATION = 15
Minigame.MAX_DASH_DURATION = 3
Minigame.INIT_CHICKEN_COUNT = 3
Minigame.DURATION_SECONDS = 60
Minigame.WARNING_SECONDS = 10

function Minigame:new(...)
	Map.new(self, ...)

	self:addBehavior(ScoreBehavior)

	self:addPoke('start')
	self:addPoke('stop')
end

function Minigame:onLoad(...)
	Map.onLoad(self, ...)

	self.hasStarted = false
	self.isDone = false
	self.isFinishing = false
	self.isDashing = false
	self.dashDuration = 0
	self.isPreppingDash = false
	self.prepDashStart = 0
	self.score = Score({
		text = "Score",
		icon = "Resources/Game/Items/Feather/Icon.png",
		current = 0,
		precision = 4
	})
	self.multiplier = Score({
		text = "Multiplier",
		icon = "Resources/Game/UI/Icons/Concepts/Star.png",
		current = 0,
		precision = 1
	})

	local score = self:getBehavior(ScoreBehavior)
	table.insert(score.scores, self.score)
	table.insert(score.scores, self.multiplier)
end

function Minigame:onStart()
	local function actionCallback(action)
		self:onPlayerDash(action)
	end

	local function openCallback()
		return not self:wasPoofed()
	end

	Utility.UI.openInterface(
		Utility.Peep.getPlayer(self),
		"KeyboardAction",
		false,
		"MINIGAME_DASH", actionCallback, openCallback)

	local player = Utility.Peep.getPlayer(self)
	player:addBehavior(DisabledBehavior)

	local function finishCallback()
		player:removeBehavior(DisabledBehavior)

		self.hasStarted = true
		for i = 1, Minigame.INIT_CHICKEN_COUNT do
			self:spawnChicken()
		end

		self.startTime = love.timer.getTime()
	end

	Utility.UI.openInterface(
		player,
		"Countdown",
		false,
		3, finishCallback, "TACKLE!")
	Utility.UI.openInterface(
		player,
		"ScoreHUD",
		false)
end

function Minigame:onStop()
	self.isDone = true
end

function Minigame:spawnChicken()
	local map = self:getDirector():getMap(self:getLayer())

	local center
	repeat
		local testI = math.random(1, map:getWidth())
		local testJ = math.random(1, map:getHeight())
		local tile = map:getTile(testI, testJ)

		if not tile:hasFlag('building') and not tile:hasFlag('impassable') then
			center = map:getTileCenter(testI, testJ)
		end
	until center
	center = center + Vector.UNIT_Y * Minigame.SPAWN_ELEVATION

	local gameDB = self:getDirector():getGameDB()
	local resource = gameDB:getResource("Chicken_Haru", "Peep")

	Utility.spawnActorAtPosition(self, resource, center:get())

	self.nextTick = math.random(Minigame.MIN_TICK, Minigame.MAX_TICK)
end

function Minigame:startPlayerDash()
	local player = Utility.Peep.getPlayer(self)
	player:addBehavior(DisabledBehavior)

	local movement = player:getBehavior(MovementBehavior)
	local direction
	do
		direction = movement.velocity:getNormal()
		if direction:getLength() == 0 then
			direction = Vector(movement.facing, 0, 0)
		end
	end
	movement.additionalVelocity = direction * 8

	local actor = player:getBehavior(ActorReferenceBehavior)
	if actor and actor.actor then
		actor = actor.actor

		local runAnimation = CacheRef(
			"ItsyScape.Graphics.AnimationResource",
			"Resources/Game/Animations/Human_Run_Crazy_1/Script.lua")
		actor:playAnimation(
			'minigame-chicken-dash',
			math.huge,
			runAnimation,
			true)
	end

	local dashDuration = love.timer.getTime() - self.prepDashStart

	self.isDashing = true
	self.dashDuration = math.max(dashDuration, Minigame.MAX_DASH_DURATION) / 2
	self.dashStrength = math.min(math.floor(6 ^ (dashDuration + 0.5) + 5), 20)
	self.collisions = {}
end

function Minigame:stopPlayerDash()
	local player = Utility.Peep.getPlayer(self)
	player:removeBehavior(DisabledBehavior)

	local actor = player:getBehavior(ActorReferenceBehavior)
	if actor and actor.actor then
		actor = actor.actor
		actor:playAnimation(
			'minigame-chicken-dash',
			false,
			nil,
			true)
	end

	local movement = player:getBehavior(MovementBehavior)
	movement.additionalVelocity = Vector.ZERO
end

function Minigame:onPlayerDash(action)
	if not self.isDashing and self.hasStarted and not self.isDone then
		if self.isPreppingDashing and action == 'released' then
			self.isPreppingDashing = false

			self:startPlayerDash()
		elseif not self.isPreppingDashing and action == 'pressed' then
			self.isPreppingDashing = true
			self.prepDashStart = love.timer.getTime()
		end
	end
end

function Minigame:updateDash(director, delta)
	local player = Utility.Peep.getPlayer(self)
	local playerPosition = Utility.Peep.getAbsolutePosition(player)

	self.dashDuration = self.dashDuration - delta
	if self.dashDuration < 0 then
		self.isDashing = false
		self:stopPlayerDash()
		self.multiplier:set({
			current = 0
		})
		return
	end

	local targetResourceID
	do
		local gameDB = director:getGameDB()
		local resource = gameDB:getResource("Chicken_Haru", "Peep")
		targetResourceID = resource.id.value
	end

	local hits = director:probe(self:getLayerName(), function(peep)
		if self.collisions[peep] then
			return false
		end

		local resource = Utility.Peep.getResource(peep)
		if not resource or resource.id.value ~= targetResourceID then
			return false
		end

		local position = Utility.Peep.getAbsolutePosition(peep)
		local size = peep:getBehavior(SizeBehavior)
		if not size then
			return false
		else
			size = size.size
		end
	
		local min = position - Vector(size.x / 2, 0, size.z / 2)
		local max = position + Vector(size.x / 2, size.y, size.z / 2)

		local insideX = playerPosition.x >= min.x and playerPosition.x <= max.x
		local insideY = playerPosition.y >= min.y and playerPosition.y <= max.y
		local insideZ = playerPosition.z >= min.z and playerPosition.z <= max.z

		return insideX and insideY and insideZ
	end)

	local poke = AttackPoke({
		weaponType = 'dash',
		damage = self.dashStrength,
		aggressor = player
	})
	director:broadcast(hits, 'receiveAttack', poke)

	for i = 1, #hits do
		self.collisions[hits[i]] = true
	end

	self.multiplier:set({
		current = self.multiplier:get().current + #hits
	})

	local multiplier = self.multiplier:get().current
	local score = self.score:get().current

	self.score:set({
		current = score + #hits * multiplier * self.dashStrength
	})
end 

function Minigame:update(director, game)
	Map.update(self, director, game)

	self.nextTick = (self.nextTick or 0) - game:getDelta()
	if self.nextTick <= 0 and self.hasStarted and not self.isDone then
		self:spawnChicken()
	end

	if self.isDashing then
		self:updateDash(director, game:getDelta())
	end

	if self.hasStarted and not self.isDone then
		local time = love.timer.getTime() - self.startTime

		if time >= Minigame.DURATION_SECONDS - Minigame.WARNING_SECONDS and
		   not self.isFinishing
		then
			self.isFinishing = true
			Utility.UI.openInterface(
				Utility.Peep.getPlayer(self),
				"Countdown",
				false,
				Minigame.WARNING_SECONDS, nil, "CEASEFIRE!")
		end

		if time >= Minigame.DURATION_SECONDS then
			self.isDone = true
		end
	end
end

return Minigame
