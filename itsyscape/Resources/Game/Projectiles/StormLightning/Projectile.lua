--------------------------------------------------------------------------------
-- ItsyScape/Resources/Game/Projectiles/StormLightning/Projectile.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Vector = require "ItsyScape.Common.Math.Vector"
local CacheRef = require "ItsyScape.Game.CacheRef"
local Actor = require "ItsyScape.Game.Model.Actor"
local Color = require "ItsyScape.Graphics.Color"
local Projectile = require "ItsyScape.Graphics.Projectile"
local AmbientLightSceneNode = require "ItsyScape.Graphics.AmbientLightSceneNode"
local LightBeamSceneNode = require "ItsyScape.Graphics.LightBeamSceneNode"

local Lightning = Class(Projectile)

Lightning.DURATION = 0.75
Lightning.MAX_AMBIENCE = 0.5
Lightning.SPAWN_OFFSET = Vector.UNIT_Y * 20
Lightning.MIN_SPAWN_RADIUS = 10
Lightning.MAX_SPAWN_RADIUS = 40
Lightning.MAX_SEGMENT_LENGTH = 70 / 1000
Lightning.MIN_SEGMENT_LENGTH = 40 / 1000
Lightning.MAX_JITTER_DISTANCE = 2.5
Lightning.COLOR = Color.fromHexString("00ff00", 1)
Lightning.CLAMP_BOTTOM = true

function Lightning:load()
	Projectile.load(self)

	local resources = self:getResources()
	local root = self:getRoot()

	self.lightning = AmbientLightSceneNode()
	self.lightning:setParent(root)

	self.lightningBeam = LightBeamSceneNode()
	self.lightningBeam:setParent(root)
	self.lightningBeam:setBeamSize(1)
	self.lightningBeam:getMaterial():setIsFullLit(true)
	self.lightningBeam:getMaterial():setIsTranslucent(true)
	self.lightningBeam:getMaterial():setColor(Lightning.COLOR)

	self.fullPath = {}
	self.currentPath = {}
	self.previousNumSegments = 1
	self.zapped = false
end

local function bezier3(a, b, c, delta)
	return (1 - delta) ^ 2 * a + (2 * (1 - delta)) * delta * b + delta ^ 2 * c
end

function Lightning:generatePath(spawn, hit)
	local rng = love.math.newRandomGenerator()

	local a = spawn
	local c = hit
	local b
	do
		local position = Vector(rng:random(), rng:random(), rng:random()):getNormal()
		local length = math.sqrt(rng:random() * (hit - spawn):getLength())
		b = (spawn - hit) + position * length + hit
	end

	local delta = 0
	while delta < 1 do
		local mu = (Lightning.MAX_SEGMENT_LENGTH - Lightning.MIN_SEGMENT_LENGTH) * rng:random() + Lightning.MIN_SEGMENT_LENGTH

		local currentPoint
		do
			currentPoint = bezier3(a, b, c, delta)

			local normal = Vector(rng:random(), rng:random(), rng:random()):getNormal()
			local length = rng:random() * Lightning.MAX_JITTER_DISTANCE * mu / Lightning.MAX_SEGMENT_LENGTH
			local offset = normal * length

			currentPoint = currentPoint + offset
		end

		table.insert(self.fullPath, currentPoint:keep())
		delta = delta + mu
	end
end

function Lightning:updatePath()
	local numSegments = math.min(math.floor(#self.fullPath * self:getDelta() + 10), #self.fullPath)

	for i = self.previousNumSegments + 1, numSegments do
		local a = self.fullPath[i - 1]
		local b = self.fullPath[i]

		table.insert(self.currentPath, {
			a = { a:get() },
			b = { b:get() }
		})
		self.previousNumSegments = self.previousNumSegments + 1
	end

	self.lightningBeam:buildSeamless(self.currentPath)
end

function Lightning:zapTarget()
	local delta = self:getDelta()
	if delta > 0.5 and not self.zapped then
		self.zapped = true
		self:playAnimation(nil, "SFX_LightningStrike")
	end
end

function Lightning:getDuration()
	return Lightning.DURATION
end

function Lightning:tick()
	if not self.spawnPosition then
		self.hitPosition = self:getTargetPosition(self:getDestination())

		local radius = love.math.random() * (Lightning.MAX_SPAWN_RADIUS - Lightning.MIN_SPAWN_RADIUS) + Lightning.MIN_SPAWN_RADIUS
		local angle = love.math.random() * math.pi * 2
		local spawnOffset = Vector(
			math.cos(angle) * radius,
			0,
			math.sin(angle) * radius)

		self.spawnPosition = self:getTargetPosition(self:getDestination()) + Lightning.SPAWN_OFFSET + spawnOffset

		self:generatePath(self.spawnPosition, self.hitPosition)
	end
end

function Lightning:update(elapsed)
	Projectile.update(self, elapsed)

	if self.spawnPosition then
		self.lightning:setAmbience(math.sin(self:getDelta() * math.pi) * 0.25)
		self:updatePath()
		self:zapTarget()

		self:ready()
	end
end

return Lightning
