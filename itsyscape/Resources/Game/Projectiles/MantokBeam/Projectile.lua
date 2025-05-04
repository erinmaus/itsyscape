--------------------------------------------------------------------------------
-- ItsyScape/Resources/Game/Projectiles/MantokBeam/Projectile.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Quaternion = require "ItsyScape.Common.Math.Quaternion"
local Ray = require "ItsyScape.Common.Math.Ray"
local Tween = require "ItsyScape.Common.Math.Tween"
local Vector = require "ItsyScape.Common.Math.Vector"
local CacheRef = require "ItsyScape.Game.CacheRef"
local Color = require "ItsyScape.Graphics.Color"
local LightBeamSceneNode = require "ItsyScape.Graphics.LightBeamSceneNode"
local Projectile = require "ItsyScape.Graphics.Projectile"

local MantokBeam = Class(Projectile)

MantokBeam.SEGMENT_LENGTH  = 1 / 25
MantokBeam.CIRCLE_RADIUS   = 2
MantokBeam.CIRCLE_DISTANCE = 4
MantokBeam.CIRCLE_SEGMENTS = 20

MantokBeam.CIRCLE_MIN_SCALE = 0.75
MantokBeam.CIRCLE_MAX_SCALE = 1.25

MantokBeam.COLOR_FROM = Color.fromHexString("ff0000")
MantokBeam.COLOR_TO   = Color.fromHexString("ff6600")

MantokBeam.SPEED = 16

MantokBeam.OVERSHOOT_DISTANCE = 16

MantokBeam.BEAM_ALPHA_MULTIPLIER   = 2.5
MantokBeam.CIRCLE_ALPHA_MULTIPLIER = 1.75

function MantokBeam:load()
	Projectile.load(self)

	local resources = self:getResources()
	local root = self:getRoot()

	self.beam = LightBeamSceneNode()
	self.beam:setParent(root)
	self.beam:setBeamSize(1)
	self.beam:getMaterial():setIsFullLit(true)
	self.beam:getMaterial():setColor(self.COLOR_FROM)
	self.beam:setBlendMode('alpha')

	self.circles = {}

	self.fullBeamPath = {}
	self.currentBeamPath = {}
	self.previousNumSegments = 1
end

function MantokBeam:generatePath(ray, length)
	local currentDistance = 0
	while currentDistance < length do
		local delta = currentDistance / length

		local position = ray:project(currentDistance)
		table.insert(self.fullBeamPath, position:keep())

		currentDistance = currentDistance + self.SEGMENT_LENGTH
	end
end

function MantokBeam:generateCircles(ray, length)
	for i = self.CIRCLE_DISTANCE, length - self.CIRCLE_DISTANCE, self.CIRCLE_DISTANCE do
		local circleBeam = self:generateCircle()
		circleBeam:getTransform():setLocalTranslation(ray:project(i))

		local circleDelta = i / length

		table.insert(self.circles, {
			beam = circleBeam,
			delta = circleDelta,
			deltaWidth = 1 / (length / self.CIRCLE_DISTANCE)
		})
	end
end

function MantokBeam:generateCircle()
	local path = {}

	local previousPosition
	for i = 1, self.CIRCLE_SEGMENTS + 1 do
		local delta = i / self.CIRCLE_SEGMENTS
		local position = Vector(
			math.cos(delta * math.pi * 2) * self.CIRCLE_RADIUS,
			math.sin(delta * math.pi * 2) * self.CIRCLE_RADIUS,
			0)

		if previousPosition then
			table.insert(path, {
				a = { previousPosition:get() },
				b = { position:get() }
			})
		end

		previousPosition = position
	end

	local beam = LightBeamSceneNode()
	beam:setBeamSize(0.5)
	beam:buildSeamless(path)
	beam:getMaterial():setIsFullLit(true)
	beam:getMaterial():setColor(self.COLOR_FROM)

	return beam
end

function MantokBeam:updatePath()
	local numSegments = math.min(math.floor(#self.fullBeamPath * self:getDelta()) + 1, #self.fullBeamPath)

	for i = self.previousNumSegments + 1, numSegments do
		local a = self.fullBeamPath[i - 1]
		local b = self.fullBeamPath[i]

		table.insert(self.currentBeamPath, {
			a = { a:get() },
			b = { b:get() }
		})
		self.previousNumSegments = self.previousNumSegments + 1
	end

	self.beam:buildSeamless(self.currentBeamPath)
end

function MantokBeam:getDuration()
	return self.duration or math.huge
end

function MantokBeam:tick()
	if not self.spawnPosition then
		self.spawnPosition = self:getTargetPosition(self:getSource()):keep()
		self.hitPosition = self:getTargetPosition(self:getDestination()):keep()

		local difference = self.hitPosition - self.spawnPosition
		local differenceLength = difference:getLength()
		local direction = difference / (differenceLength > 0 and differenceLength or 1)

		local ray = Ray(self.spawnPosition, direction)

		local length = differenceLength + self.OVERSHOOT_DISTANCE
		self:generatePath(ray, length)
		self:generateCircles(ray, length)

		self.duration = math.max(length / self.SPEED, 1)
	end
end

function MantokBeam:update(elapsed)
	Projectile.update(self, elapsed)

	if self.spawnPosition and self.hitPosition then
		self:updatePath()

		local delta = self:getDelta()
		local alpha = math.abs(math.sin(delta * math.pi)) * self.BEAM_ALPHA_MULTIPLIER
		alpha = math.max(math.min(alpha, 1), 0)

		local root = self:getRoot()

		local rotation = Quaternion.lookAt(
			self.hitPosition * Vector.PLANE_XZ,
			self.spawnPosition * Vector.PLANE_XZ)
		self.beam:getMaterial():setColor(Color(
			self.COLOR_FROM.r,
			self.COLOR_FROM.g,
			self.COLOR_FROM.b,
			alpha))

		for _, circle in ipairs(self.circles) do
			local circleDelta = math.min((delta - circle.delta) / circle.deltaWidth, 1)
			if circleDelta > 0 then
				local circleAlpha = math.abs(math.sin(delta * math.pi)) * self.CIRCLE_ALPHA_MULTIPLIER
				circleAlpha = math.clamp(circleAlpha, 0, 1) * alpha

				local color = self.COLOR_FROM:lerp(self.COLOR_TO, 1 - circleDelta)
				circle.beam:getMaterial():setColor(Color(color.r, color.g, color.b, circleAlpha))
				circle.beam:getTransform():setLocalRotation(rotation)

				local scale = math.lerp(self.CIRCLE_MIN_SCALE, self.CIRCLE_MAX_SCALE, Tween.bounceOut(circleDelta))
				circle.beam:getTransform():setLocalScale(Vector(scale))

				if not circle.beam:getParent() then
					circle.beam:setParent(root)
				end

				circle.beam:tick()
			else
				break
			end
		end

		self:ready()
	end
end

return MantokBeam
