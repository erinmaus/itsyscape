--------------------------------------------------------------------------------
-- ItsyScape/Resources/Game/Projectiles/Power_Decapitate/Projectile.lua
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
local Projectile = require "ItsyScape.Graphics.Projectile"
local ParticleSceneNode = require "ItsyScape.Graphics.ParticleSceneNode"
local DecorationMaterial = require "ItsyScape.Graphics.DecorationMaterial"
local DecorationSceneNode = require "ItsyScape.Graphics.DecorationSceneNode"
local Material = require "ItsyScape.Graphics.Material"
local StaticMeshResource = require "ItsyScape.Graphics.StaticMeshResource"

local Decapitate = Class(Projectile)

Decapitate.SPLOSION_MATERIAL = DecorationMaterial({
	shader = "Resources/Shaders/WarpedAlphaCutoff",
	texture = "Resources/Game/Projectiles/Power_Decapitate/Splosion.png",

	properties = {
		isFullLit = true,
		isTranslucent = true,
		glassThickness = 1,
		color = "cc3333"
	}
})

Decapitate.PARTICLE_SYSTEM = function(direction)
	return {
		numParticles = 200,
		texture = "Resources/Game/Projectiles/Power_Decapitate/Particle.png",
		columns = 4,

		emitters = {
			{
				type = "RadialEmitter",
				radius = { 0, 0.25 },
				acceleration = { 0, 0 }
			},
			{
				type = "DirectionalEmitter",
				speed = { 8, 12 },
				direction = { direction:get() }
			},
			{
				type = "RandomColorEmitter",
				colors = {
					{ 0.8, 0.2, 0.2, 0.0 },
					{ 1.0, 0.2, 0.2, 0.0 },
					{ 0.5, 0.1, 0.1, 0.0 }
				}
			},
			{
				type = "RandomLifetimeEmitter",
				age = { 0.5, 1 }
			},
			{
				type = "RandomScaleEmitter",
				scale = { 0.75, 1.0 }
			},
			{
				type = "RandomRotationEmitter",
				rotation = { 0, 360 }
			}
		},

		paths = {
			{
				type = "FadeInOutPath",
				fadeInPercent = { 0.1 },
				fadeOutPercent = { 0.9 },
				tween = { 'sineEaseOut' }
			},
			{
				type = "TextureIndexPath",
				textures = { 1, 4 }
			}
		},

		emissionStrategy = {
			type = "RandomDelayEmissionStrategy",
			count = { 5, 10 },
			delay = { 1 / 30 },
			duration = { 0.5 }
		}
	}
end

Decapitate.DURATION = 2

Decapitate.FROM_SCALE = Vector(0.5)
Decapitate.TO_SCALE   = Vector(8)

function Decapitate:getHeadPosition()
	local headPosition
	do
		local gameView = self:getGameView()
		local actorView = gameView:getActor(self:getDestination())
		if actorView then
			headPosition = actorView:getBoneWorldPosition("head", Vector.UNIT_Y)
		else
			headPosition = self:getTargetPosition(self:getDestination())
		end
	end

	return headPosition
end

function Decapitate:load()
	Projectile.load(self)

	local resources = self:getResources()
	local root = self:getRoot()

	local headPosition = self:getHeadPosition()
	local spawnPosition = self:getTargetPosition(self:getSource())
	local direction = spawnPosition:direction(headPosition)

	self.particleSystem = ParticleSceneNode()
	self.particleSystem:setParent(root)
	self.particleSystem:initParticleSystemFromDef(Decapitate.PARTICLE_SYSTEM(direction), resources)

	local model = resources:queue(
		StaticMeshResource,
		"Resources/Game/Projectiles/Power_Decapitate/Splosion.lstatic",
		function(mesh)
			self.splosionSceneNode = DecorationSceneNode()
			self.splosionSceneNode:fromGroup(mesh:getResource(), "splosion")
			self.splosionSceneNode:setParent(root)

			self.SPLOSION_MATERIAL:apply(self.splosionSceneNode, resources)
		end)
end

function Decapitate:getDuration()
	return Decapitate.DURATION
end

function Decapitate:update(elapsed)
	Projectile.update(self, elapsed)

	local headPosition
	do
		local gameView = self:getGameView()
		local actorView = gameView:getActor(self:getDestination())
		if actorView then
			headPosition = actorView:getBoneWorldPosition("head", Vector.UNIT_Y)
		else
			headPosition = self:getTargetPosition(self:getDestination())
		end
	end

	if self.splosionSceneNode then
		local delta = Tween.sineEaseOut(math.clamp(self:getDelta()))

		local transform = self.splosionSceneNode:getTransform()
		transform:setLocalScale(self.FROM_SCALE:lerp(self.TO_SCALE, delta))

		local material = self.splosionSceneNode:getMaterial()
		material:send(Material.UNIFORM_FLOAT, "scape_AlphaCutoff", delta)
		material:setAlpha(math.clamp(math.sin(delta * math.pi) * 2))
	end

	local root = self:getRoot()
	root:getTransform():setLocalTranslation(headPosition)

	self:ready()
end

return Decapitate
