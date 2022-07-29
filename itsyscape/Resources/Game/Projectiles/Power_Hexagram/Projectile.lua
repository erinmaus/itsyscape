--------------------------------------------------------------------------------
-- ItsyScape/Resources/Game/Projectiles/Power_Hexagram/Projectile.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Quaternion = require "ItsyScape.Common.Math.Quaternion"
local Tween = require "ItsyScape.Common.Math.Tween"
local Vector = require "ItsyScape.Common.Math.Vector"
local CacheRef = require "ItsyScape.Game.CacheRef"
local Color = require "ItsyScape.Graphics.Color"
local Projectile = require "ItsyScape.Graphics.Projectile"
local PointLightSceneNode = require "ItsyScape.Graphics.PointLightSceneNode"
local LightBeamSceneNode = require "ItsyScape.Graphics.LightBeamSceneNode"

local Hexagram = Class(Projectile)
Hexagram.DURATION = 20

Hexagram.NUM_SEGMENTS = 20
Hexagram.NUM_POINTS   = 6
Hexagram.RADIUS       = 2.5

Hexagram.IN_TIME       = 1
Hexagram.OUT_TIME      = 59
Hexagram.FADE_DURATION = 1

Hexagram.COLOR = Color(1, 0, 0, 0.5)

function Hexagram:attach()
	Projectile.attach(self)
end

function Hexagram:getDuration()
	return Hexagram.DURATION
end

function Hexagram:load()
	Projectile.load(self)

	local root = self:getRoot()

	self.light = PointLightSceneNode()
	self.light:setParent(root)

	self.hexagram = LightBeamSceneNode()
	self.hexagram:setParent(root)
	self.hexagram:setBeamSize(0.5)
	self.hexagram:getMaterial():setIsFullLit(true)
	self.hexagram:getMaterial():setColor(Hexagram.COLOR)
	self.hexagram:getTransform():setLocalTranslation(Vector.UNIT_Y)

	self.previousNumSegments = 1
	self.fullPath = {}
	self.currentPath = {}

	self:generatePath()
end

function Hexagram:generatePath()
	local step = (math.pi * 2) / Hexagram.NUM_POINTS
	local currentPointAngle, nextPointAngle = 0, step

	for i = 1, Hexagram.NUM_POINTS do
		local position1 = Vector(
			math.cos(currentPointAngle) * Hexagram.RADIUS,
			0,
			math.sin(currentPointAngle) * Hexagram.RADIUS)

		local position2 = Vector(
			math.cos(nextPointAngle) * Hexagram.RADIUS,
			0,
			math.sin(nextPointAngle) * Hexagram.RADIUS)

		for j = 1, Hexagram.NUM_SEGMENTS do
			local position = position1:lerp(position2, j / Hexagram.NUM_SEGMENTS)

			table.insert(self.fullPath, position)
		end

		currentPointAngle = currentPointAngle + step
		nextPointAngle = (currentPointAngle + step) % (math.pi * 2)
	end
end

function Hexagram:tick()
	if not self.position then
		self.position = self:getTargetPosition(self:getDestination())
		self:generatePath()
	end
end

function Hexagram:updatePath()
	local delta = math.min(self:getTime() / Hexagram.FADE_DURATION, 1)
	local numSegments = math.min(math.floor(#self.fullPath * delta) + 1, #self.fullPath)

	for i = self.previousNumSegments + 1, numSegments do
		local a = self.fullPath[i - 1]
		local b = self.fullPath[i]

		table.insert(self.currentPath, {
			a = { a:get() },
			b = { b:get() }
		})
		self.previousNumSegments = self.previousNumSegments + 1
	end

	if #self.currentPath > 2 then
		self.hexagram:buildSeamless(self.currentPath)
	end
end

function Hexagram:update(elapsed)
	Projectile.update(self, elapsed)

	if self.position then
		local root = self:getRoot()
		local time = self:getTime()
		local position = self.position

		local delta
		if time < Hexagram.IN_TIME then
			delta = time / Hexagram.FADE_DURATION
		elseif time > Hexagram.OUT_TIME then
			delta = (time - Hexagram.OUT_TIME) / Hexagram.FADE_DURATION
			delta = 1 - delta
		else
			delta = 1
		end

		local alpha = Tween.sineEaseOut(delta)

		local rotation = Quaternion.fromAxisAngle(Vector.UNIT_Y, delta * math.pi * 4)

		local scale
		do
			local min, max = self:getDestination():getBounds()
			local size = max - min
			scale = Vector(math.max(size.x, size.z)) * 2
			position = position - Vector(0, size.y / 2 - 0.25, 0)
		end

		root:getTransform():setLocalTranslation(position)
		root:getTransform():setLocalRotation(rotation)
		root:getTransform():setLocalScale(scale)

		self.light:setColor(Color(1, 0, 0, 1))
		self.light:setAttenuation(alpha * 4 + 12)
		self.light:getTransform():setLocalTranslation(Vector.UNIT_Y * 6)

		self:updatePath()
	end
end

return Hexagram
