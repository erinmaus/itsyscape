--------------------------------------------------------------------------------
-- Resources/Game/Props/ViziersRock_Sewers_WaterDoor/View.lua
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
local ParticleSceneNode = require "ItsyScape.Graphics.ParticleSceneNode"
local PropView = require "ItsyScape.Graphics.PropView"
local StaticMeshResource = require "ItsyScape.Graphics.StaticMeshResource"
local TextureResource = require "ItsyScape.Graphics.TextureResource"

local WaterDoor = Class(PropView)
WaterDoor.PARTICLE_SYSTEM = {
	numParticles = 150,
	texture = "Resources/Game/Props/ViziersRock_Sewers_WaterDoor/Particle.png",
	columns = 4,

	emitters = {
		{
			type = "RadialEmitter",
			radius = { 2.5 },
			position = { 0, 8, 0 }
		},
		{
			type = "DirectionalEmitter",
			direction = { 0, -1, 0 },
			speed = { 8, 8.5 }
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
			lifetime = { 0.5, 0.7 }
		},
		{
			type = "RandomScaleEmitter",
			scale = { 0.8, 1.1 }
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
		count = { 12, 16 },
		delay = { 0.125 },
		duration = { math.huge }
	}
}

function WaterDoor:new(prop, gameView)
	PropView.new(self, prop, gameView)
end

function WaterDoor:load()
	PropView.load(self)

	local resources = self:getResources()
	local root = self:getRoot()

	self.particleSystem = ParticleSceneNode()
	self.particleSystem:setParent(root)
	self.particleSystem:initParticleSystemFromDef(WaterDoor.PARTICLE_SYSTEM, resources)

	resources:queueEvent(function()
		self.emissionStrategy = self.particleSystem:getParticleSystem():getEmissionStrategy()

		local state = self:getProp():getState()
		if state.open then
			self.particleSystem:getParticleSystem():setEmissionStrategy(nil)
		else
			self.particleSystem:getParticleSystem():setEmissionStrategy(self.emissionStrategy)
		end

		self.open = state.open
	end)
end

function WaterDoor:tick()
	PropView.tick(self)

	if not self.particleSystem or not self.particleSystem:getParticleSystem() then
		return
	end

	local state = self:getProp():getState()
	if state.open ~= self.open then
		if state.open then
			self.particleSystem:getParticleSystem():setEmissionStrategy(nil)
		else
			self.particleSystem:getParticleSystem():setEmissionStrategy(self.emissionStrategy)
		end

		self.open = state.open
	end
end

return WaterDoor
