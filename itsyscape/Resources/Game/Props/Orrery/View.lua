--------------------------------------------------------------------------------
-- Resources/Game/Props/Orrery/View.lua
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
local Color = require "ItsyScape.Graphics.Color"
local DecorationMaterial = require "ItsyScape.Graphics.DecorationMaterial"
local ParticleSceneNode = require "ItsyScape.Graphics.ParticleSceneNode"
local PointLightSceneNode = require "ItsyScape.Graphics.PointLightSceneNode"
local PropView = require "ItsyScape.Graphics.PropView"
local SceneNode = require "ItsyScape.Graphics.SceneNode"
local FlickerGreeble = require "Resources.Game.Props.Common.Greeble.FlickerGreeble"
local StaticGreeble = require "Resources.Game.Props.Common.Greeble.StaticGreeble"

local Orrery = Class(PropView)

Orrery.DAY_IN_SECONDS = 20 * 60

Orrery.PARTICLE_SYSTEM = {
	texture = "Resources/Game/Props/Orrery/Debris.png",
	numParticles = 50,
	columns = 2,
	rows = 2,

	emitters = {
		{
			type = "RadialEmitter",
			radius = { 4.5, 5 },
			speed = { 0, 0 },
			yRange = { 0, 1 / 28 },
			acceleration = { 0, 0 },
			normal = { true },
		},
		{
			type = "RandomColorEmitter",
			colors = {
				{ 1.0, 1.0, 1.0, 1.0 },
				{ 0.8, 0.8, 0.8, 1.0 },
				{ 0.6, 0.6, 0.6, 1.0 },
				{ 0.4, 0.4, 0.4, 1.0 },
			}
		},
		{
			type = "RandomLifetimeEmitter",
			age = { math.huge }
		},
		{
			type = "RandomScaleEmitter",
			scale = { 0.2, 0.4 }
		},
		{
			type = "RandomRotationEmitter",
			rotation = { 0, 360 },
			velocity = { -20, 20 }

		},
		{
			type = "RandomTextureIndexEmitter",
			textures = { 1, 4 }
		}
	},

	paths = {},

	emissionStrategy = {
		type = "RandomDelayEmissionStrategy",
		count = { 10, 10 },
		delay = { 1 / 5 },
		duration = { 1 }
	}
}

function Orrery:new(...)
	PropView.new(self, ...)

	self.planetGreeble = self:addGreeble(StaticGreeble, {
		MESH = "Resources/Game/Props/Orrery/Model.lstatic",
		GROUP = "realm",
		MATERIAL = DecorationMaterial({
			shader = "Resources/Shaders/DetailDecorationSpecularMultiTriplanar",
			texture = "Resources/Game/Props/Orrery/Realm.png",

			uniforms = {
				scape_NumLayers = { "integer", 1 },
				scape_TriplanarScale = { "float", -0.5 },
				scape_TriplanarOffset = { "float", 0 },
				scape_TriplanarExponent = { "float", 0 },
				scape_SpecularWeight = { "float", 0 },
				scape_TriplanarTexture = { "texture", "Resources/Game/Props/Orrery/Metal.lua" },
				scape_TriplanarSpecularTexture = { "texture", "Resources/Game/Props/Orrery/SpecularMetal.lua" },
			},

			properties = {
				color = "ffa100",
				isReflectiveOrRefractive = true
			}
		})
	})

	self.moonGreeble = self:addGreeble(StaticGreeble, {
		MESH = "Resources/Game/Props/Orrery/Model.lstatic",
		GROUP = "moon",
		MATERIAL = DecorationMaterial({
			shader = "Resources/Shaders/DetailDecorationSpecularMultiTriplanar",
			texture = "Resources/Game/Props/Orrery/Moon.png",

			uniforms = {
				scape_NumLayers = { "integer", 1 },
				scape_TriplanarScale = { "float", -0.5 },
				scape_TriplanarOffset = { "float", 0 },
				scape_TriplanarExponent = { "float", 0 },
				scape_SpecularWeight = { "float", 0 },
				scape_TriplanarTexture = { "texture", "Resources/Game/Props/Orrery/Metal.lua" },
				scape_TriplanarSpecularTexture = { "texture", "Resources/Game/Props/Orrery/SpecularMetal.lua" },
			},

			properties = {
				color = "ffa100",
				isReflectiveOrRefractive = true
			}
		})
	})

	self.sunFlickerGreeble = self:addGreeble(FlickerGreeble, {
		MIN_ATTENUATION = 8,
		MAX_ATTENUATION = 12,

		COLORS = {
			Color.fromHexString("ff6600")
		}
	})

	self.sunGreeble = self:addGreeble(StaticGreeble, {
		MESH = "Resources/Game/Props/Orrery/Model.lstatic",
		GROUP = "sun",
		MATERIAL = DecorationMaterial({
			shader = "Resources/Shaders/SpecularTriplanar",
			texture = "Resources/Game/Props/Orrery/Gem.png",

			uniforms = {
				scape_TriplanarScale = { "float", -0.5 },
				scape_TriplanarOffset = { "float", 0 },
				scape_TriplanarExponent = { "float", 0 },
				scape_SpecularWeight = { "float", 0 },
			},

			properties = {
				color = "ff6600",
				alpha = 0.8,
				isTranslucent = true,
				isFullLit = true
			}
		})
	})

	self.moonCoreGreeble = self:addGreeble(StaticGreeble, {
		MESH = "Resources/Game/Props/Orrery/Model.lstatic",
		GROUP = "moon.core",
		MATERIAL = DecorationMaterial({
			shader = "Resources/Shaders/SpecularTriplanar",
			texture = "Resources/Game/Props/Orrery/Gem.png",

			uniforms = {
				scape_TriplanarScale = { "float", -0.5 },
				scape_TriplanarOffset = { "float", 0 },
				scape_TriplanarExponent = { "float", 0 },
				scape_SpecularWeight = { "float", 0 },
			},

			properties = {
				color = "5fd3bc",
				alpha = 0.4,
				isTranslucent = true,
				isFullLit = true
			}
		})
	})

	self.moonFlickerGreeble = self:addGreeble(FlickerGreeble, {
		MIN_ATTENUATION = 8,
		MAX_ATTENUATION = 12,

		COLORS = {
			Color.fromHexString("5fd3bc")
		}
	})
end

function Orrery:load()
	PropView.load(self)

	self.currentSkyColor = Color()
	self.previousSkyColor = false

	local resources = self:getResources()
	local root = self:getRoot()

	self.debris = ParticleSceneNode()
	self.debris:initParticleSystemFromDef(Orrery.PARTICLE_SYSTEM, resources)
	self.debris:getMaterial():setIsZWriteDisabled(false)
	self.debris:getMaterial():setIsFullLit(false)
	self.debris:getMaterial():setIsTranslucent(false)
	self.debris:getMaterial():setColor(Color.fromHexString("ffa100"))
	self.debris:getTransform():setLocalTranslation(Vector(0, 6, 0))
	self.debris:setParent(root)
end

function Orrery:updateDebris(offset)
	local y = Quaternion.fromAxisAngle(Vector.UNIT_Y, offset * (math.pi / 1024))
	local z = Quaternion.fromAxisAngle(Vector.UNIT_Z, math.pi / 3)

	local rotation = (z * y):getNormal()
	self.debris:getTransform():setLocalRotation(rotation)
end

function Orrery:updatePlanet(offset)
	local y = Quaternion.fromAxisAngle(Vector.UNIT_Y, offset / self.DAY_IN_SECONDS)
	local z = Quaternion.fromAxisAngle(Vector.UNIT_Z, math.sin(offset / (self.DAY_IN_SECONDS * 30)) * math.pi / 16)

	local rotation = (z * y):getNormal()
	self.planetGreeble:getRoot():getTransform():setLocalRotation(rotation)
	self.planetGreeble:getRoot():getTransform():setLocalTranslation(Vector(0, 6, 0))
end

function Orrery:updateSunAndMoon(offset)
	local delta = offset / self.DAY_IN_SECONDS / 2
	local angle = offset / self.DAY_IN_SECONDS * math.pi * 2
	local offset = Vector(math.cos(angle), math.sin(angle), 0):getNormal()

	local moonRotation = Quaternion.fromAxisAngle(Vector.UNIT_Y, delta * math.pi * 2)

	local moonPosition = Vector(0, 6, -3) + -offset * 3
	local sunPosition = Vector(0, 6, -3) + offset * 3

	self.moonGreeble:getRoot():getTransform():setLocalTranslation(moonPosition)
	self.moonGreeble:getRoot():getTransform():setLocalRotation(moonRotation)
	self.moonCoreGreeble:getRoot():getTransform():setLocalTranslation(moonPosition)
	self.moonCoreGreeble:getRoot():getTransform():setLocalRotation(moonRotation)
	self.moonFlickerGreeble:getRoot():getTransform():setLocalTranslation(moonPosition)
	self.sunGreeble:getRoot():getTransform():setLocalTranslation(sunPosition)
	self.sunFlickerGreeble:getRoot():getTransform():setLocalTranslation(sunPosition)
end

function Orrery:update(delta)
	PropView.update(self, delta)

	local offset = math.lerp(self.previousOffset or self.currentOffset or 0, self.currentOffset or 0, _APP:getPreviousFrameDelta())

	self:updateDebris(offset)
	self:updatePlanet(offset)
	self:updateSunAndMoon(offset)
end

function Orrery:tick()
	PropView.tick(self)

	local offset = self:getProp():getState().offset
	self.previousOffset = self.currentOffset or offset
	self.currentOffset = offset
end

return Orrery
