--------------------------------------------------------------------------------
-- Resources/Game/Props/AzatiteMeteor_Default/View.lua
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
local Material = require "ItsyScape.Graphics.Material"
local ParticleSceneNode = require "ItsyScape.Graphics.ParticleSceneNode"
local ShaderResource = require "ItsyScape.Graphics.ShaderResource"
local TextureResource = require "ItsyScape.Graphics.TextureResource"
local RockView = require "Resources.Game.Props.Common.RockView2"
local FlickerGreeble = require "Resources.Game.Props.Common.Greeble.FlickerGreeble"

local AzatiteMeteor = Class(RockView)

AzatiteMeteor.GRAVITY_XZ_SPEED = 0.25

AzatiteMeteor.ROCK_COLOR = Color.fromHexString("6b6789")
AzatiteMeteor.FOG_COLOR  = Color.fromHexString("339d80")

AzatiteMeteor.FOG_PARTICLE_SYSTEM = {
	texture = "Resources/Game/Props/AzatiteMeteor_Default/Fog.png",
	numParticles = 400,
	columns = 2,
	rows = 2,
	soft = true,

	emitters = {
		{
			type = "RadialEmitter",
			radius = { 0.25, 1 },
			yRange = { 0, 0 },
			position = { 0, 0.5, 0 },
			speed = { 1, 1.05 },
			normal = { true }
		},
		{
			type = "RandomLifetimeEmitter",
			lifetime = { 4, 4 }
		},
		{
			type = "RandomColorEmitter",
			colors = {
				{ AzatiteMeteor.FOG_COLOR.r, AzatiteMeteor.FOG_COLOR.g, AzatiteMeteor.FOG_COLOR.b, 0.0 }
			}
		},
		{
			type = "RandomScaleEmitter",
			scale = { 1.5, 2 }
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

	paths = {
		{
			type = "FadeInOutPath",
			fadeInPercent = { 0.1 },
			fadeOutPercent = { 0.9 },
			tween = { 'sineEaseOut' }
		},
		{
			type = "GravityPath",
			gravity = { 0, -0.01, 0 }
		},
	},

	emissionStrategy = {
		type = "RandomDelayEmissionStrategy",
		count = { 2, 4 },
		delay = { 1 / 20 },
		duration = { math.huge }
	}
}


function AzatiteMeteor:new(...)
	RockView.new(self, ...)

	self:addGreeble(FlickerGreeble, {
		MIN_FLICKER_TIME = 10 / 60,
		MAX_FLICKER_TIME = 20 / 60,
		MIN_ATTENUATION = 12,
		MAX_ATTENUATION = 16,
		COLORS = {
			Color(0, 1, 0, 1)
		}
	})
end

function AzatiteMeteor:load()
	RockView.load(self)

	local resources = self:getResources()
	local root = self:getRoot()

	local particles = ParticleSceneNode()
	particles:getMaterial():setIsFullLit(false)
	particles:initParticleSystemFromDef(self.FOG_PARTICLE_SYSTEM, resources)
	particles:setParent(root)

	local material = particles:getMaterial()
	material:setShader(self.particleShader)
	material:setIsZWriteDisabled(true)
	material:setOutlineThreshold(-1)

	resources:queue(
		ShaderResource,
		"Resources/Shaders/SpecularTriplanar",
		function(shader)
			self.metalShader = shader
		end)

	resources:queueEvent(function()
		local activeNode = self:getActiveNode()
		activeNode:getMaterial():setIsReflectiveOrRefractive(true)
		activeNode:getMaterial():setReflectionPower(10)
		activeNode:getMaterial():setShader(self.metalShader)
		activeNode:getMaterial():setRoughness(0.5)
		activeNode:getMaterial():send(Material.UNIFORM_FLOAT, "scape_TriplanarScale", -0.75)
		activeNode:getMaterial():setColor(self.ROCK_COLOR)

		local depletedNode = self:getDepletedNode()
		depletedNode:getMaterial():setIsReflectiveOrRefractive(true)
		depletedNode:getMaterial():setReflectionPower(10)
		depletedNode:getMaterial():setShader(self.metalShader)
		depletedNode:getMaterial():setRoughness(0.5)
		depletedNode:getMaterial():send(Material.UNIFORM_FLOAT, "scape_TriplanarScale", -0.75)
		depletedNode:getMaterial():setColor(self.ROCK_COLOR)
	end)
end

function AzatiteMeteor:getTextureFilename()
	return "Resources/Game/Props/AzatiteMeteor_Default/Texture.png"
end

function AzatiteMeteor:getDepletedTextureFilename()
	return "Resources/Game/Props/AzatiteMeteor_Default/Texture_Depleted.png"
end

function AzatiteMeteor:getModelFilename()
	return "Resources/Game/Props/AzatiteMeteor_Default/Model.lstatic"
end

return AzatiteMeteor
