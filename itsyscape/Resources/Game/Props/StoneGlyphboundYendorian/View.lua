--------------------------------------------------------------------------------
-- Resources/Game/Props/StoneGlyphboundYendorian/View.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local MathCommon = require "ItsyScape.Common.Math.Common"
local Quaternion = require "ItsyScape.Common.Math.Quaternion"
local Tween = require "ItsyScape.Common.Math.Tween"
local Vector = require "ItsyScape.Common.Math.Vector"
local Utility = require "ItsyScape.Game.Utility"
local Color = require "ItsyScape.Graphics.Color"
local ParticleSceneNode = require "ItsyScape.Graphics.ParticleSceneNode"
local PropView = require "ItsyScape.Graphics.PropView"
local SceneNode = require "ItsyScape.Graphics.SceneNode"
local DecorationSceneNode = require "ItsyScape.Graphics.DecorationSceneNode"
local SceneTemplateResource = require "ItsyScape.Graphics.SceneTemplateResource"
local StaticMeshResource = require "ItsyScape.Graphics.StaticMeshResource"
local TextureResource = require "ItsyScape.Graphics.TextureResource"
local MapCurve = require "ItsyScape.World.MapCurve"

local YendorianView = Class(PropView)

YendorianView.DUST_PARTICLE_COLOR = Color.fromHexString("e3b468")

function YendorianView:load()
	PropView.load(self)

	local resources = self:getResources()
	local root = self:getRoot()

	self.stoneRoot = SceneNode()
	self.stoneRoot:setParent(root)
	self.stoneRoot:getTransform():setLocalScale(Vector(1.5))

	resources:queue(
		StaticMeshResource,
		"Resources/Game/Props/StoneGlyphboundYendorian/Model.lstatic",
		function(mesh)
			self.mesh = mesh:getResource()
		end)

	resources:queue(
		TextureResource,
		"Resources/Game/Props/StoneGlyphboundYendorian/Texture.png",
		function(texture)
			self.texture = texture
		end)

	resources:queue(
		SceneTemplateResource,
		"Resources/Game/Props/StoneGlyphboundYendorian/Model.lscene",
		function(scene)
			self.scene = scene:getResource()
		end)

	self.yendorianNodes = {}
	resources:queueEvent(function()
			for name, node in self.scene:iterate() do
				local rotation = Quaternion.IDENTITY
				local translation = MathCommon.decomposeTransform(node:getLocalTransform())
				translation = (-Quaternion.X_90):transformVector(translation)

				if self.mesh:hasGroup(name) then
					local decoration = DecorationSceneNode()
					decoration:fromGroup(self.mesh, name)
					decoration:setParent(self.stoneRoot)

					local material = decoration:getMaterial()
					material:setTextures(self.texture)
					material:setOutlineThreshold(0.5)

					local transform = decoration:getTransform()
					transform:setLocalTranslation(translation)
					transform:setLocalRotation(rotation)

					local particles = ParticleSceneNode()
					particles:setParent(self.stoneRoot)

					table.insert(self.yendorianNodes, {
						name = name,
						model = decoration,
						particles = particles,
						position = translation,
						rotation = rotation
					})
				end
			end
		end)
end

function YendorianView:getParticleSystem(duration)
	return {
		texture = "Resources/Game/Props/Common/Rock/Dust.png",
		numParticles = 250,
		columns = 2,
		rows = 2,

		emitters = {
			{
				type = "RadialEmitter",
				radius = { 0.5, 0.75 },
				speed = { 2, 3 }
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
			delay = { 1 / 10 },
			duration = { duration }
		}
	}
end

function YendorianView:explode()
	local i, j, layer = self:getProp():getTile()
	local map = self:getGameView():getMap(layer)

	for _, node in ipairs(self.yendorianNodes) do
		local parentTransform = self:getRoot():getTransform():getLocalTransform()
		local startPosition = node.position:transform(parentTransform)

		local s, t = Utility.Map.getRandomTile(map, i, j, 4, true)
		local endPosition = map:getTileCenter(s, t)

		local centerPosition = startPosition:lerp(endPosition, 0.5) + Vector(0, love.math.random(5, 10), 0)

		node.currentTime = 0
		node.maxTime = 1 + love.math.random()
		node.curve = MapCurve(nil, {
			positions = {
				{ startPosition:get() },
				{ centerPosition:get() },
				{ endPosition:get() }
			}
		})
		node.axis = Vector(
			(love.math.random() - 0.5) * 2,
			(love.math.random() - 0.5) * 2,
			(love.math.random() - 0.5) * 2):getNormal()

		node.currentPosition = node.position
		node.currentRotation = node.rotation

		node.particles:initParticleSystemFromDef(self:getParticleSystem(node.maxTime), self:getResources())
	end
end

function YendorianView:tick()
	PropView.tick(self)

	local state = self:getProp():getState()
	if state.exploded ~= self.exploded then
		if not self.exploded then
			self:explode()
		end

		self.exploded = state.exploded
	end
end

function YendorianView:updateNode(node, delta)
	node.currentTime = node.currentTime + delta
	local delta = Tween.sineEaseOut(math.clamp(node.currentTime / node.maxTime))
	local position = node.curve:evaluatePosition(delta)

	local rotation = node.currentRotation
	if node.currentTime < node.maxTime then
		rotation = rotation * Quaternion.fromAxisAngle(node.axis, math.pi / 8 * delta)
	end

	local parentTransform = self:getRoot():getTransform():getLocalTransform()
	position = position:inverseTransform(parentTransform)

	local transform = node.model:getTransform()
	transform:setLocalTranslation(position)
	transform:setLocalRotation(rotation:getNormal())
	transform:tick(1)

	node.currentRotation = rotation
	node.currentPosition = position

	node.particles:updateLocalPosition(position)
end

function YendorianView:update(delta)
	PropView.update(self, delta)

	if self.exploded then
		for _, node in ipairs(self.yendorianNodes) do
			self:updateNode(node, delta)
		end
	end
end

return YendorianView
