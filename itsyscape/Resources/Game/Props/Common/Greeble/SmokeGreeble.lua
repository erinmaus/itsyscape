--------------------------------------------------------------------------------
-- Resources/Game/Props/Common/Greeble/SmokeGreeble.lua
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
local Color = require "ItsyScape.Graphics.Color"
local ParticleSceneNode = require "ItsyScape.Graphics.ParticleSceneNode"
local Greeble = require "Resources.Game.Props.Common.Greeble"

local SmokeGreeble = Class(Greeble)

SmokeGreeble.SMOKE_SCALE  = Vector(1):keep()
SmokeGreeble.SMOKE_OFFSET = Vector(0):keep()

SmokeGreeble.SMOKE_SPEED = 0.2

SmokeGreeble.SMOKE_HEIGHT = 1

SmokeGreeble.SMOKE_COLORS = {
	Color(0.2, 0.2, 0.2),
	Color(0.2, 0.2, 0.2),
	Color(0.2, 0.2, 0.2),
	Color(0.3, 0.3, 0.3),
	Color(0.1, 0.1, 0.1),
}

function SmokeGreeble:_updateDirection(direction, speed)
	local position, layer = self.prop:getPosition()
	local windDirection, windSpeed, windPattern = self:getGameView():getWind(layer)

	local windDelta = self:getGameView():getRenderer():getTime() * windSpeed + position:getLength() * windSpeed
	windDelta = math.sin(windDelta / windPattern.x) * math.sin(windDelta / windPattern.y) * math.sin(windDelta / windPattern.z)
	local windMu = (windDelta + 1) / 2

	local fireDirection = Vector(windDelta * windDirection.x, 1, windDelta * windDirection.z):getNormal()

	local currentWindRotation = Quaternion()
	local targetWindRotation = Quaternion.lookAt(Vector(0), fireDirection, Vector.UNIT_Y)
	local normal = currentWindRotation:slerp(targetWindRotation, windMu):transformVector(Vector.UNIT_Y)

	direction.speed[1] = windSpeed / 3 * speed
	direction.speed[2] = windSpeed / 3 * speed
	direction.direction[1] = normal.x
	direction.direction[2] = normal.y
	direction.direction[3] = normal.z
end

function SmokeGreeble:_getSmokeParticleDefinition()
	self._smokeParticleDefinition = self._smokeParticleDefinition or {
		numParticles = 25,
		texture = "Resources/Game/Props/Common/Particle_Smoke.png",
		columns = 4,

		emitters = {
			{
				type = "RadialEmitter",
				radius = { 0, 0.125 },
				position = { 0, 2, 0 },
				yRange = { 0, 0 },
				lifetime = { 0.5, 3 },
				normal = { true }
			},
			{
				type = "DirectionalEmitter",
				direction = { 0, 1, 0 },
				speed = { 0.75, 1 },
			},
			{
				type = "RandomColorEmitter",
				colors = self:getSmokeColors()
			},
			{
				type = "RandomScaleEmitter",
				scale = { 0.4, 0.5 }
			},
			{
				type = "RandomRotationEmitter",
				rotation = { 0, 360 },
				velocity = { 60, 120 }
			}
		},

		paths = {
			{
				type = "FadeInOutPath",
				fadeInPercent = { 0.2 },
				fadeOutPercent = { 0.8 },
				tween = { 'sineEaseOut' }
			},
			{
				type = "TextureIndexPath",
				textures = { 1, 4 }
			}
		},

		emissionStrategy = {
			type = "RandomDelayEmissionStrategy",
			count = { 2, 5 },
			delay = { 1 / 10 }
		}
	}

	self:_updateDirection(self._smokeParticleDefinition.emitters[2], self.SMOKE_SPEED)
	self._smokeParticleDefinition.emitters[1].position[1] = self._smokeParticleDefinition.emitters[2].direction[1] * self.SMOKE_HEIGHT
	self._smokeParticleDefinition.emitters[1].position[2] = self._smokeParticleDefinition.emitters[2].direction[2] * self.SMOKE_HEIGHT
	self._smokeParticleDefinition.emitters[1].position[3] = self._smokeParticleDefinition.emitters[2].direction[3] * self.SMOKE_HEIGHT

	return self._smokeParticleDefinition
end

function SmokeGreeble:getSmokeColors()
	local r = {}
	for _, color in ipairs(self.SMOKE_COLORS) do
		table.insert(r, { color.r, color.g, color.b, 0 })
	end

	return r
end

function SmokeGreeble:load()
	Greeble.load(self)

	local resources = self:getResources()
	local root = self:getRoot()

	resources:queueEvent(function()
		self.smoke = ParticleSceneNode()
		self.smoke:getMaterial():setIsFullLit(false)
		self.smoke:initParticleSystemFromDef(self:_getSmokeParticleDefinition(), resources)
		self.smoke:setParent(root)
		self.smoke:getTransform():setLocalScale(self.SMOKE_SCALE)
		self.smoke:getTransform():setLocalTranslation(self.SMOKE_OFFSET)
	end)
end

function SmokeGreeble:update(delta)
	Greeble.update(self, delta)

	if self.smoke then
		self.smoke:initEmittersFromDef(self:_getSmokeParticleDefinition().emitters)
	end
end

return SmokeGreeble
