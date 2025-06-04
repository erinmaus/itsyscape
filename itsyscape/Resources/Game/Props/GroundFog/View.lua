--------------------------------------------------------------------------------
-- Resources/Game/Props/GroundFog_Default/View.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Vector = require "ItsyScape.Common.Math.Vector"
local Color = require "ItsyScape.Graphics.Color"
local ParticleSceneNode = require "ItsyScape.Graphics.ParticleSceneNode"
local PointLightSceneNode = require "ItsyScape.Graphics.PointLightSceneNode"
local PropView = require "ItsyScape.Graphics.PropView"
local ShaderResource = require "ItsyScape.Graphics.ShaderResource"
local TextureResource = require "ItsyScape.Graphics.TextureResource"

local GroundFog = Class(PropView)

GroundFog.SHADER = ShaderResource()
do
	GroundFog.SHADER:loadFromFile("Resources/Shaders/GroundFog")
end

GroundFog.PARTICLE_SYSTEM = {
	texture = "Resources/Game/Props/GroundFog/Particle.png",
	numParticles = 100000,
	columns = 2,
	rows = 2,

	emitters = {
		{
			type = "RadialEmitter",
			radius = { 0, 4 },
			yRange = { 0, 0 },
			normal = { true }
		},
		{
			type = "RandomColorEmitter",
			colors = {
				{ 1.0, 1.0, 1.0, 0.8 },
				{ 1.0, 1.0, 1.0, 0.8 },
				{ 1.0, 1.0, 1.0, 0.7 },
				{ 1.0, 1.0, 1.0, 0.7 },
				{ 1.0, 1.0, 1.0, 0.6 }
			}
		},
		{
			type = "RandomLifetimeEmitter",
			lifetime = { math.huge }
		},
		{
			type = "RandomScaleEmitter",
			scale = { 2, 3 }
		},
		{
			type = "RandomRotationEmitter",
			rotation = { 0, 360 }
		},
		{
			type = "RandomTextureIndexEmitter",
			textures = { 1, 4 }
		}
	},

	paths = {},

	emissionStrategy = {
		type = "RandomDelayEmissionStrategy",
		count = { 10, 20 },
		delay = { 0 },
		duration = { 0 }
	}
}

function GroundFog:new(prop, gameView)
	PropView.new(self, prop, gameView)

	self.lightning = {}
end

function GroundFog:load()
	PropView.load(self)

	local resources = self:getResources()

	resources:queue(
		TextureResource,
		"Resources/Game/Props/GroundFog/Particle_Blurred.png",
		function(texture)
			self.blurParticle = texture
		end)
end

function GroundFog:_build()
	if self.particles then
		self.particles:setParent(nil)
	end

	local resources = self:getResources()
	local root = self:getRoot()

	self.particles = ParticleSceneNode()
	self.particles:initParticleSystemFromDef(self.PARTICLE_SYSTEM, resources)
	self.particles:setParent(root)

	local material = self.particles:getMaterial()
	material:setShader(GroundFog.SHADER)
	material:setIsZWriteDisabled(true)
	material:setIsFullLit(false)
	material:setColor(Color(1))
	material:setOutlineThreshold(-1)

	local gameView = self:getGameView()
	local _, layer = self.prop:getPosition()

	local gameView = self:getGameView()
	local _, _, canvas = gameView:getMapBumpCanvas(layer)
	material:send(material.UNIFORM_TEXTURE, "scape_BumpCanvas", canvas)

	resources:queueEvent(function()
		local map = self:getGameView():getMap(layer)

		material:send(material.UNIFORM_TEXTURE, "scape_BlurTexture", self.blurParticle:getResource())
		material:send(material.UNIFORM_FLOAT, "scape_MapSize", map:getWidth() * map:getCellSize(), map:getHeight() * map:getCellSize())

		for i = 1, map:getWidth() + 1, 2 do
			for j = 1, map:getHeight() + 1, 2 do
				self.particles:updateLocalPosition(map:getTileCenter(i, j))
				self.particles:emit(love.math.random(5, 10))
			end

			coroutine.yield()
		end
	end)
end

function GroundFog:tick()
	PropView.tick(self)

	local _, layer = self.prop:getPosition()
	if layer ~= self.currentLayer then
		self:_build()
		self.currentLayer = layer
	end
end

return GroundFog
