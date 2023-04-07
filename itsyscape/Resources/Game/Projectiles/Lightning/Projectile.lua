--------------------------------------------------------------------------------
-- ItsyScape/Resources/Game/Projectiles/Lightning/Projectile.lua
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

Lightning.DURATION = 1
Lightning.MAX_AMBIENCE = 3
Lightning.SPAWN_OFFSET = Vector.UNIT_Y * 10
Lightning.MAX_SEGMENT_LENGTH = 20 / 1000
Lightning.MIN_SEGMENT_LENGTH = 5 / 1000
Lightning.MAX_JITTER_DISTANCE = 1
Lightning.COLORS = {
	Color.fromHexString("ffcc00", 0.5),
	Color.fromHexString("ffcc00", 0.5),
	Color.fromHexString("ff9900", 0.5),
	Color.fromHexString("ff9900", 0.5),
	Color.fromHexString("00ccff", 0.5)
}

function Lightning:load()
	Projectile.load(self)

	local resources = self:getResources()
	local root = self:getRoot()

	self.lightning = AmbientLightSceneNode()
	self.lightning:setParent(root)

	self.lightningBeam = LightBeamSceneNode()
	self.lightningBeam:setParent(root)
	self.lightningBeam:setBeamSize(0.25)
	self.lightningBeam:getMaterial():setIsFullLit(true)
	self.lightningBeam:getMaterial():setColor(Lightning.COLORS[math.random(#Lightning.COLORS)])

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

		table.insert(self.fullPath, currentPoint)
		delta = delta + mu
	end
end

function Lightning:updatePath()
	local numSegments = math.min(math.floor(#self.fullPath * self:getDelta()) + 1, #self.fullPath)

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
	if delta > 0.5 then
		if not self.zapped then
			local target = self:getDestination()
			if target:isCompatibleType(Actor) then
				local animation = CacheRef(
					"ItsyScape.Graphics.AnimationResource",
					"Resources/Game/Animations/Spell_Lightning_Zap/Script.lua")

				target:onAnimationPlayed('x-spell-lightning', 1, animation)
				self.zapped = true
			end
		end
	end
end

function Lightning:getDuration()
	return Lightning.DURATION
end

function Lightning:tick()
	if not self.spawnPosition then
		self.hitPosition = self:getTargetPosition(self:getDestination())
		self.spawnPosition = self:getTargetPosition(self:getSource()) + Lightning.SPAWN_OFFSET

		self:generatePath(self.spawnPosition, self.hitPosition)
	end
end

function Lightning:update(elapsed)
	Projectile.update(self, elapsed)

	if self.spawnPosition then
		self.lightning:setAmbience(Lightning.MAX_AMBIENCE * self:getDelta())
		self:updatePath()
		self:zapTarget()
	end
end

return Lightning
