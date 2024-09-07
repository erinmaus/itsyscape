--------------------------------------------------------------------------------
-- Resources/Game/Props/AncientDriftwood/View.lua
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
local DecorationSceneNode = require "ItsyScape.Graphics.DecorationSceneNode"
local ParticleSceneNode = require "ItsyScape.Graphics.ParticleSceneNode"
local PropView = require "ItsyScape.Graphics.PropView"
local ShaderResource = require "ItsyScape.Graphics.ShaderResource"
local StaticMeshResource = require "ItsyScape.Graphics.StaticMeshResource"
local TextureResource = require "ItsyScape.Graphics.TextureResource"

local AncientDriftwood = Class(PropView)

AncientDriftwood.PARTICLES = {
	texture = "Resources/Game/Props/AncientDriftwood/Particle_Leaf.png",
	columns = 2,
	rows = 3,

	emitters = {
		{
			type = "RadialEmitter",
			radius = { 2, 5 },
			yRange = { 0, 0 },
			normal = { true }
		},
		{
			type = "DirectionalEmitter",
			direction = { -1, 0, -1 },
			speed = { 0.75, 1.0 },
		},
		{
			type = "RandomColorEmitter",
			colors = {
				{ Color.fromHexString("574470", 0):get() },
				{ Color.fromHexString("574470", 0):get() },
				{ Color.fromHexString("4e4470", 0):get() },
				{ Color.fromHexString("5e5287", 0):get() },
			}
		},
		{
			type = "RandomLifetimeEmitter",
			lifetime = { 5, 7 }
		},
		{
			type = "RandomScaleEmitter",
			scale = { 0.4, 0.5 }
		},
		{
			type = "RandomRotationEmitter",
			rotation = { 0, 360 },
			velocity = { 60, 120 }
		},
		{
			type = "RandomTextureIndexEmitter",
			textures = { 1, 6 }
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
			gravity = { 0, -0.25, 0 }
		}
	},

	emissionStrategy = {
		type = "RandomDelayEmissionStrategy",
		count = { 1, 2 },
		delay = { 1 / 8 },
		duration = math.huge
	}
}

function AncientDriftwood:getTextureFilename()
	return "Resources/Game/Props/AncientDriftwood/Tree.png"
end

function AncientDriftwood:getModelFilename()
	return "Resources/Game/Props/AncientDriftwood/Tree.lstatic", "AncientDriftwood"
end

function AncientDriftwood:load()
	PropView.load(self)

	local resources = self:getResources()
	local root = self:getRoot()

	self.leaves = DecorationSceneNode()
	self.tree = DecorationSceneNode()

	resources:queue(
		TextureResource,
		"Resources/Game/Props/AncientDriftwood/Tree.png",
		function(texture)
			self.treeTexture = texture
		end)
	resources:queue(
		TextureResource,
		"Resources/Game/Props/AncientDriftwood/Leaves.png",
		function(texture)
			self.leavesTexture = texture
		end)
	resources:queue(
		StaticMeshResource,
		"Resources/Game/Props/AncientDriftwood/Tree.lstatic",
		function(mesh)
			self.tree:fromGroup(mesh:getResource(), "AncientDriftwood")
			self.tree:getMaterial():setTextures(self.treeTexture)
			self.tree:setParent(root)
		end)
	resources:queue(
		StaticMeshResource,
		"Resources/Game/Props/AncientDriftwood/Leaves.lstatic",
		function(mesh)
			self.leaves:fromGroup(mesh:getResource(), "Leaves")
			self.leaves:getMaterial():setTextures(self.leavesTexture)
			self.leaves:setParent(root)
		end)

	resources:queue(
		ShaderResource,
		"Resources/Shaders/Triplanar",
		function(shader)
			local material = self.tree:getMaterial()
			material:setShader(shader)
			material:setOutlineThreshold(-0.01)
		end)

	resources:queue(
		ShaderResource,
		"Resources/Shaders/BendyLeaf",
		function(shader)
			local material = self.leaves:getMaterial()
			material:setShader(shader)
			material:setOutlineThreshold(-0.005)
			material:setOutlineColor(Color(0.5))

			self.leaves:onWillRender(function(renderer)
				local currentShader = renderer:getCurrentShader()
				if not currentShader then
					return
				end

				if currentShader:hasUniform("scape_BumpHeight") then
					currentShader:send("scape_BumpHeight", 1)
				end

				if currentShader:hasUniform("scape_BumpForce") then
					currentShader:send("scape_BumpForce", 0)
				end

				local _, layer = self:getProp():getPosition()
				local windDirection, windSpeed, windPattern = self:getGameView():getWind(layer)

				if currentShader:hasUniform("scape_WindDirection") then
					currentShader:send("scape_WindDirection", { windDirection:get() })
				end

				if currentShader:hasUniform("scape_WindSpeed") then
					currentShader:send("scape_WindSpeed", windSpeed)
				end

				if currentShader:hasUniform("scape_WindPattern") then
					currentShader:send("scape_WindPattern", { windPattern:get() })
				end

				if currentShader:hasUniform("scape_WindMaxDistance") then
					currentShader:send("scape_WindMaxDistance", 0.25)
				end

				if currentShader:hasUniform("scape_WallHackWindow") then
					currentShader:send("scape_WallHackWindow", { 0, 0, 0, 0 })
				end
			end)
		end)

	self.leafParticles = ParticleSceneNode()
	self.leafParticles:initParticleSystemFromDef(AncientDriftwood.PARTICLES, resources)
	self.leafParticles:getMaterial():setIsFullLit(false)
	self.leafParticles:getTransform():setLocalTranslation(Vector(-2, 10, 2))
	self.leafParticles:setParent(root)
end

return AncientDriftwood
