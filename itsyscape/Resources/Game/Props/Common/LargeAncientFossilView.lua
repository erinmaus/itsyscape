--------------------------------------------------------------------------------
-- Resources/Game/Props/Common/LargeAncientFossilView/View.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Vector = require "ItsyScape.Common.Math.Vector"
local Tween = require "ItsyScape.Common.Math.Tween"
local Color = require "ItsyScape.Graphics.Color"
local DecorationSceneNode = require "ItsyScape.Graphics.DecorationSceneNode"
local ParticleSceneNode = require "ItsyScape.Graphics.ParticleSceneNode"
local PropView = require "ItsyScape.Graphics.PropView"
local StaticMeshResource = require "ItsyScape.Graphics.StaticMeshResource"
local ShaderResource = require "ItsyScape.Graphics.ShaderResource"
local TextureResource = require "ItsyScape.Graphics.TextureResource"

local LargeAncientFossil = Class(PropView)
LargeAncientFossil.FADE_TIME_SECONDS = 1

LargeAncientFossil.MIN_PARTICLES_DEPLETED = 150
LargeAncientFossil.MAX_PARTICLES_DEPLETED = 200

LargeAncientFossil.MIN_PARTICLES_MINED = 50
LargeAncientFossil.MAX_PARTICLES_MINED = 75

LargeAncientFossil.PARTICLE_SYSTEM = {
	texture = "Resources/Game/Props/Common/Rock/Dust.png",
	numParticles = 250,
	columns = 2,
	rows = 2,

	emitters = {
		{
			type = "RadialEmitter",
			radius = { 0, 1 },
			speed = { 4, 6 },
			normal = { true }
		},
		{
			type = "RandomColorEmitter",
			colors = {
				{ Color.fromHexString("e3b468", 0):get() } 
			}
		},
		{
			type = "RandomLifetimeEmitter",
			lifetime = { 0.5, 1.5 }
		},
		{
			type = "RandomScaleEmitter",
			scale = { 1, 1.5 }
		},
		{
			type = "RandomRotationEmitter",
			rotation = { 0, 360 },
			velocity = { 360, 720 },
		},
		{
			type = "RandomTextureIndexEmitter",
			textures = { 1, 4 }
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
			type = "GravityPath",
			gravity = { 0, -10, 0 }
		},
	},

	emissionStrategy = {
		type = "RandomDelayEmissionStrategy",
		count = { 10, 20 },
		delay = { 0 },
		duration = { 0 }
	}
}

function LargeAncientFossil:new(prop, gameView)
	PropView.new(self, prop, gameView)

	self.time = 0
end

function LargeAncientFossil:getTextureFilename()
	return Class.ABSTRACT()
end

function LargeAncientFossil:getModelFilename()
	return Class.ABSTRACT()
end

function LargeAncientFossil:load()
	PropView.load(self)

	local resources = self:getResources()
	local root = self:getRoot()

	resources:queueEvent(function()
		self.dust = ParticleSceneNode()
		self.dust:initParticleSystemFromDef(self.PARTICLE_SYSTEM, resources)
		self.dust:setParent(root)
		self.dust:getTransform():setLocalTranslation(Vector(0, 4, 0))

		local material = self.dust:getMaterial()
		material:setIsZWriteDisabled(true)
		material:setIsFullLit(false)
		material:setColor(Color(1))
		material:setOutlineThreshold(-1)

		local state = self:getProp():getState()
		self.progress = state.resource and state.resource.progress or 0
	end)

	resources:queue(
		ShaderResource,
		"Resources/Shaders/SoftParticles",
		function(shader)
			self.dust:getMaterial():setShader(shader)
		end)

	self.decoration = DecorationSceneNode()

	resources:queue(
		TextureResource,
		self:getTextureFilename(),
		function(texture)
			self.texture = texture
		end)
	resources:queue(
		StaticMeshResource,
		self:getModelFilename(),
		function(mesh)
			local _, group = self:getModelFilename()
			self.decoration:fromGroup(mesh:getResource(), group)
			self.decoration:getMaterial():setTextures(self.texture)
			self.decoration:getMaterial():setOutlineThreshold(0.5)
			self.decoration:setParent(root)
		end)
end

function LargeAncientFossil:remove()
	PropView.remove(self)

	if self.progressBar then
		self:getGameView():getSpriteManager():poof(self.progressBar)
	end
end

function LargeAncientFossil:tick()
	PropView.tick(self)

	local state = self:getProp():getState()
	if state.resource then
		local r = state.resource
		if r.progress > 0 and r.progress < 100 and (not self.progressBar or not self.progressBar:getIsSpawned()) then
			self.progressBar = self:getGameView():getSpriteManager():add(
				"ResourceProgressBar",
				self:getRoot(),
				Vector(0, 2, 0),
				self:getProp())
		end

		if r.progress ~= self.progress then
			if self.dust then
				if r.progress == 0 then
					self.dust:emit(love.math.random(self.MIN_PARTICLES_DEPLETED, self.MAX_PARTICLES_DEPLETED))
				else
					self.dust:emit(love.math.random(self.MIN_PARTICLES_MINED, self.MAX_PARTICLES_MINED))
				end
			end

			self.progress = r.progress
		end

		if r.depleted ~= self.depleted then
			self.depleted = r.depleted
			self.time = self.FADE_TIME_SECONDS - self.time
		end
	end
end

function LargeAncientFossil:update(delta)
	PropView.update(self, delta)

	if self.time > 0 then
		self.time = math.max(self.time - delta, 0)

		local alpha = Tween.sineEaseOut(self.time / self.FADE_TIME_SECONDS)
		if self.depleted then
			self.decoration:getMaterial():setColor(Color(1, 1, 1, alpha))
		else
			self.decoration:getMaterial():setColor(Color(1, 1, 1, 1 - alpha))
		end
	end
end

return LargeAncientFossil
