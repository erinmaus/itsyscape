--------------------------------------------------------------------------------
-- Resources/Game/Props/ViziersRock_Sewers_Pipe/View.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Quaternion = require "ItsyScape.Common.Math.Quaternion"
local Vector = require "ItsyScape.Common.Math.Vector"
local DecorationSceneNode = require "ItsyScape.Graphics.DecorationSceneNode"
local Color = require "ItsyScape.Graphics.Color"
local DecorationSceneNode = require "ItsyScape.Graphics.DecorationSceneNode"
local ParticleSceneNode = require "ItsyScape.Graphics.ParticleSceneNode"
local PropView = require "ItsyScape.Graphics.PropView"
local StaticMeshResource = require "ItsyScape.Graphics.StaticMeshResource"
local SimpleStaticView = require "Resources.Game.Props.Common.SimpleStaticView"
local StaticMeshResource = require "ItsyScape.Graphics.StaticMeshResource"
local TextureResource = require "ItsyScape.Graphics.TextureResource"

local Pipe = Class(PropView)
Pipe.MAX_PARTICLES = 6

Pipe.PARTICLE_SYSTEM = {
	numParticles = 50,
	texture = "Resources/Game/Props/ViziersRock_Sewers_Pipe/Particle.png",
	columns = 4,

	emitters = {
		{
			type = "RadialEmitter",
			radius = { 0, 1 },
			yRange = { 0, 0 },
			zRange = { 0, 0 },
			position = { 0, 0.75, 1.75 }
		},
		{
			type = "DirectionalEmitter",
			direction = { 0, -1, 0 },
			speed = { 2, 3 }
		},
		{
			type = "RandomColorEmitter",
			colors = {
				{ Color.fromHexString("B8EBE6"):get() },
				{ Color.fromHexString("5FBCD3"):get() },
				{ Color.fromHexString("5FBCD3"):get() },
				{ Color.fromHexString("5FBCD3"):get() }
			}
		},
		{
			type = "RandomLifetimeEmitter",
			lifetime = { 0.3, 0.4 }
		},
		{
			type = "RandomScaleEmitter",
			scale = { 0.4, 0.6 }
		},
		{
			type = "RandomRotationEmitter",
			rotation = { 0, 360 },
			velocity = { 30, 60 },
			acceleration = { -40, -20 }
		}
	},

	paths = {
		{
			type = "FadeInOutPath",
			fadeInPercent = { 0.1 },
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
		count = { 0, 0 },
		delay = { 1 / 16 },
		duration = { math.huge }
	}
}

function Pipe:new(prop, gameView)
	PropView.new(self, prop, gameView)
end

function Pipe:load()
	PropView.load(self)

	local resources = self:getResources()
	local root = self:getRoot()

	self.particleSystem = ParticleSceneNode()
	self.particleSystem:setParent(root)
	self.particleSystem:initParticleSystemFromDef(Pipe.PARTICLE_SYSTEM, resources)

	self.pipe = DecorationSceneNode()
	self.pipe:setParent(root)

	resources:queue(
		TextureResource,
		"Resources/Game/Props/ViziersRock_Sewers_Pipe/Texture.png",
		function(texture)
			self.texture = texture
		end)

	resources:queue(
		StaticMeshResource,
		"Resources/Game/Props/ViziersRock_Sewers_Pipe/Model.lstatic",
		function(mesh)
			self.pipe:fromGroup(mesh:getResource(), "Pipe")
			self.pipe:getMaterial():setTextures(self.texture)
			self.pipe:setParent(root)
		end)
end

function Pipe:tick()
	PropView.tick(self)

	if not self.particleSystem or not self.particleSystem:getParticleSystem() then
		return
	end

	local position = self:getProp():getPosition()
	local value = love.math.noise(position.x / 2, position.y / 2, position.z / 2)
	local maxParticles = math.max(math.ceil(value * Pipe.MAX_PARTICLES), 0)

	local emissionStrategy = self.particleSystem:getParticleSystem():getEmissionStrategy()
	emissionStrategy:setCount(0, maxParticles)
end

return Pipe
