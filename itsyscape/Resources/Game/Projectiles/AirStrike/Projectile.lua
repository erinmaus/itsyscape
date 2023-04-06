--------------------------------------------------------------------------------
-- ItsyScape/Resources/Game/Projectiles/AirStrike/Projectile.lua
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
local CacheRef = require "ItsyScape.Game.CacheRef"
local Actor = require "ItsyScape.Game.Model.Actor"
local Color = require "ItsyScape.Graphics.Color"
local Projectile = require "ItsyScape.Graphics.Projectile"
local LightBeamSceneNode = require "ItsyScape.Graphics.LightBeamSceneNode"

local AirStrike = Class(Projectile)

AirStrike.SEGMENT_LENGTH  = 1 / 25
AirStrike.RADIUS = 0.5

AirStrike.SPEED = 8

AirStrike.ALPHA_MULTIPLIER = 1.75

function AirStrike:load()
	Projectile.load(self)

	local resources = self:getResources()
	local root = self:getRoot()

	self.airWave = LightBeamSceneNode()
	self.airWave:setParent(root)
	self.airWave:setBeamSize(0.25)
	self.airWave:getMaterial():setIsFullLit(true)
	self.airWave:getMaterial():setColor(Color(1))

	self.fullPath = {}
	self.currentPath = {}
	self.previousNumSegments = 1
end

function AirStrike:generatePath(spawn, hit)
	local crowDistance = (spawn - hit):getLength()
	local totalDistance = 2 * math.pi * AirStrike.RADIUS * (crowDistance / AirStrike.RADIUS)

	local currentDistance = 0
	while currentDistance < totalDistance do
		local delta = currentDistance / crowDistance

		local position = Vector(
			math.cos(delta * math.pi * 2) * (AirStrike.RADIUS),
			math.sin(delta * math.pi * 2) * (AirStrike.RADIUS),
			-currentDistance / totalDistance * crowDistance)
		table.insert(self.fullPath, position)

		currentDistance = currentDistance + AirStrike.SEGMENT_LENGTH
	end
end

function AirStrike:updatePath()
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

	self.airWave:buildSeamless(self.currentPath)
end

function AirStrike:getDuration()
	return self.duration or math.huge
end

function AirStrike:tick()
	if not self.spawnPosition then
		self.hitPosition = self:getTargetPosition(self:getDestination())
		self.spawnPosition = self:getTargetPosition(self:getSource())

		self:generatePath(self.spawnPosition, self.hitPosition)

		self.duration = math.max((self.spawnPosition - self.hitPosition):getLength() / self.SPEED, 0.5)
	end
end

function AirStrike:update(elapsed)
	Projectile.update(self, elapsed)

	if self.spawnPosition and self.hitPosition then
		self:updatePath()

		local delta = self:getDelta()
		local alpha = math.abs(math.sin(delta * math.pi)) * AirStrike.ALPHA_MULTIPLIER
		alpha = math.min(alpha, 1)

		self.airWave:getTransform():setLocalRotation(Quaternion.lookAt(self.spawnPosition, self.hitPosition))
		self.airWave:getTransform():setLocalTranslation(self.spawnPosition)
		self.airWave:getMaterial():setColor(Color(1, 1, 1, alpha))
	end
end

return AirStrike
