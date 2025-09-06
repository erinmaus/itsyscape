--------------------------------------------------------------------------------
-- Resources/Game/Props/Common/RockView3.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Tween = require "ItsyScape.Common.Math.Tween"
local MathCommon = require "ItsyScape.Common.Math.Common"
local Quaternion = require "ItsyScape.Common.Math.Quaternion"
local Vector = require "ItsyScape.Common.Math.Vector"
local Color = require "ItsyScape.Graphics.Color"
local Decoration = require "ItsyScape.Graphics.Decoration"
local DecorationSceneNode = require "ItsyScape.Graphics.DecorationSceneNode"
local ParticleSceneNode = require "ItsyScape.Graphics.ParticleSceneNode"
local PropView = require "ItsyScape.Graphics.PropView"
local SceneNode = require "ItsyScape.Graphics.SceneNode"
local ShaderResource = require "ItsyScape.Graphics.ShaderResource"
local StaticMeshResource = require "ItsyScape.Graphics.StaticMeshResource"
local TextureResource = require "ItsyScape.Graphics.TextureResource"

local RockView = Class(PropView)

RockView.SHAKE_TIME_SECONDS          = 0.25
RockView.SHAKE_TIME_INTERVAL_SECONDS = 0.05
RockView.SHAKE_MIN_DISTANCE          = 0.05
RockView.SHAKE_MAX_DISTANCE          = 0.1

RockView.ROCK_DEPLETED_DARKEN_PERCENT = 0.25

RockView.FADE_TIME_SECONDS = 0.5

RockView.MIN_PARTICLES_DEPLETED = 150
RockView.MAX_PARTICLES_DEPLETED = 200

RockView.MIN_PARTICLES_HIT = 50
RockView.MAX_PARTICLES_HIT = 75

RockView.DUST_PARTICLE_COLOR = Color.fromHexString("e3b468")

function RockView:new(...)
	PropView.new(self, ...)
end

function RockView:getOreTextureFilename()
	return Class.ABSTRACT()
end

function RockView:getRockTextureFilename()
	return Class.ABSTRACT()
end

function RockView:getOreModelFilename()
	return "Resources/Game/Props/Common/Rock/Rock4.lstatic", "ore"
end

function RockView:getRockModelFilename()
	return "Resources/Game/Props/Common/Rock/Rock4.lstatic", "rock"
end

function RockView:getParticleSystem()
	return {
		texture = "Resources/Game/Props/Common/Rock/Dust.png",
		numParticles = 250,
		columns = 2,
		rows = 2,

		emitters = {
			{
				type = "RadialEmitter",
				radius = { 0, 0.5 },
				speed = { 2, 3 },
				normal = { true }
			},
			{
				type = "RandomColorEmitter",
				colors = {
					{ self.DUST_PARTICLE_COLOR.r, self.DUST_PARTICLE_COLOR.g, self.DUST_PARTICLE_COLOR.b, 0 } 
				}
			},
			{
				type = "RandomLifetimeEmitter",
				lifetime = { 0.5, 0.75 }
			},
			{
				type = "RandomScaleEmitter",
				scale = { 0.2, 0.4 }
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
end

function RockView:load()
	PropView.load(self)

	local resources = self:getResources()
	local root = self:getRoot()

	self.proxyRoot = SceneNode()
	self.proxyRoot:setParent(root)

	resources:queue(
		ShaderResource,
		"Resources/Shaders/SpecularTriplanar",
		function(shader)
			self.rockShader = shader
		end)

	resources:queue(
		ShaderResource,
		"Resources/Shaders/SpecularStaticModel",
		function(shader)
			self.oreShader = shader
		end)

	resources:queueEvent(function()
		local node = ParticleSceneNode()
		node:initParticleSystemFromDef(self:getParticleSystem(), resources)
		node:setParent(root)
		node:getTransform():setLocalTranslation(Vector(0, 1, 0))

		local material = node:getMaterial()
		material:setIsZWriteDisabled(true)
		material:setIsFullLit(false)
		material:setColor(Color(1))
		material:setOutlineThreshold(-1)

		self.dustNode = node
	end)

	resources:queue(
		ShaderResource,
		"Resources/Shaders/SoftParticles",
		function(shader)
			self.dustNode:getMaterial():setShader(shader)
		end)

	resources:queue(
		StaticMeshResource,
		self:getRockModelFilename(),
		function(mesh)
			self.rockMesh = mesh:getResource()
		end)

	resources:queue(
		StaticMeshResource,
		self:getOreModelFilename(),
		function(mesh)
			self.oreMesh = mesh:getResource()
		end)

	resources:queue(
		TextureResource,
		self:getOreTextureFilename(),
		function(texture)
			self.oreTexture = texture
		end)

	resources:queue(
		TextureResource,
		self:getRockTextureFilename(),
		function(texture)
			self.rockTexture = texture
		end)

	resources:queueEvent(function()
		local _, rockGroup = self:getRockModelFilename()

		local node = DecorationSceneNode()
		node:fromGroup(self.oreMesh, rockGroup)
		node:setParent(self.proxyRoot)

		local material = node:getMaterial()
		material:setTextures(self.rockTexture)
		material:setShader(self.rockShader)
		material:setOutlineThreshold(-0.01)

		material:send(material.UNIFORM_FLOAT, "scape_TriplanarScale", -0.5)
		material:send(material.UNIFORM_FLOAT, "scape_TriplanarOffset", 0)
		material:send(material.UNIFORM_FLOAT, "scape_TriplanarExponent", 0)
		material:send(material.UNIFORM_FLOAT, "scape_SpecularWeight", 1)

		self.rockNode = node
	end)

	resources:queueEvent(function()
		local _, oreGroup = self:getOreModelFilename()

		local node = DecorationSceneNode()
		node:fromGroup(self.oreMesh, oreGroup)
		node:setParent(self.proxyRoot)

		local material = node:getMaterial()
		material:setTextures(self.oreTexture)
		material:setShader(self.oreShader)
		material:setOutlineThreshold(0.5)

		self.oreNode = node
	end)

	local state = self:getProp():getState()
	if state.resource then
		self.progress = state.resource.progress or 0
		self.depleted = state.resource.depleted

		if self.depleted then
			self:deplete(self.FADE_TIME_SECONDS)
		else
			self:spawn(self.FADE_TIME_SECONDS)
		end
	else
		self.progress = 0
		self:spawn(self.FADE_TIME_SECONDS)
	end

	self:hit(self.SHAKE_TIME_SECONDS)
end

function RockView:deplete(time)
	self.isDepleted = true
	self.depleteTime = math.max(self.FADE_TIME_SECONDS - (time or 0), self.FADE_TIME_SECONDS)

	if self.dustNode then
		self.dustNode:emit(love.math.random(self.MIN_PARTICLES_DEPLETED, self.MAX_PARTICLES_DEPLETED))
	end
end

function RockView:spawn(time)
	self.isDepleted = false
	self.depleteTime = math.max(self.FADE_TIME_SECONDS - (time or 0), self.FADE_TIME_SECONDS)
end

function RockView:hit(time)
	self.shakeInterval = 0
	self.shakeTime = math.max(self.SHAKE_TIME_SECONDS - (time or 0), self.SHAKE_TIME_SECONDS)
	self.isShaking = self.shakeTime > 0

	if self.progress > 0 and self.isShaking and self.dustNode then
		self.dustNode:emit(love.math.random(self.MIN_PARTICLES_HIT, self.MAX_PARTICLES_HIT))
	end
end

function RockView:tick()
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
			if r.progress > self.progress then
				self:hit(self.shakeTime)
			end

			self.progress = r.progress
		end

		if r.depleted ~= self.depleted then
			self.depleted = r.depleted

			if self.depleted then
				self:deplete(self.depleteTime)
			else
				self:spawn(self.depleteTime)
			end
		end
	end
end

function RockView:updateDeplete(delta)
	self.depleteTime = math.max(self.depleteTime - delta, 0)

	local alpha
	if self.isDepleted then
		alpha = self.depleteTime / self.FADE_TIME_SECONDS
	else
		alpha = 1 - (self.depleteTime / self.FADE_TIME_SECONDS)
	end
	alpha = Tween.sineEaseOut(alpha)

	if self.oreNode then
		self.oreNode:getMaterial():setColor(Color(1, 1, 1, alpha))
	end

	if self.rockNode then
		local c = alpha * self.ROCK_DEPLETED_DARKEN_PERCENT + (1 - self.ROCK_DEPLETED_DARKEN_PERCENT)
		self.rockNode:getMaterial():setColor(Color(c, c, c, 1))
	end
end

function RockView:updateHit(delta)
	self.shakeTime = math.max(self.shakeTime - delta, 0)
	self.shakeInterval = math.max(self.shakeInterval - delta, 0)

	if self.shakeTime > 0 then
		if self.shakeInterval <= 0 then
			self.shakeInterval = self.SHAKE_TIME_INTERVAL_SECONDS
			self.proxyRoot:getTransform():setLocalTranslation(Vector(
				love.math.random() * (self.SHAKE_MAX_DISTANCE - self.SHAKE_MIN_DISTANCE) + self.SHAKE_MIN_DISTANCE,
				0,
				love.math.random() * (self.SHAKE_MAX_DISTANCE - self.SHAKE_MIN_DISTANCE) + self.SHAKE_MIN_DISTANCE))
		end
	elseif self.isShaking then
		self.isShaking = false
		self.proxyRoot:getTransform():setLocalTranslation(Vector.ZERO)
	end
end

function RockView:update(delta)
	PropView.update(self, delta)

	self:updateDeplete(delta)
	self:updateHit(delta)
end

return RockView
