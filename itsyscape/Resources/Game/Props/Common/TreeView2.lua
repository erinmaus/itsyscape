--------------------------------------------------------------------------------
-- Resources/Game/Props/Common/TreeView2.lua
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
local Color = require "ItsyScape.Graphics.Color"
local PropView = require "ItsyScape.Graphics.PropView"
local ModelResource = require "ItsyScape.Graphics.ModelResource"
local ShaderResource = require "ItsyScape.Graphics.ShaderResource"
local SkeletonResource = require "ItsyScape.Graphics.SkeletonResource"
local SkeletonAnimationResource = require "ItsyScape.Graphics.SkeletonAnimationResource"
local ParticleSceneNode = require "ItsyScape.Graphics.ParticleSceneNode"
local TextureResource = require "ItsyScape.Graphics.TextureResource"
local ModelSceneNode = require "ItsyScape.Graphics.ModelSceneNode"

local TreeView = Class(PropView)

TreeView.FELLED_SPAWN_TIME_SECONDS = 0.75

TreeView.CHOP_TIME_SECONDS = 0.5

TreeView.CHOPPED_SPEED_MULTIPLIER    = 0.5
TreeView.CHOPPED_DISTANCE_MULTIPLIER = 0

TreeView.CHOP_MIN_ANGLE = -math.pi / 64
TreeView.CHOP_MAX_ANGLE = math.pi / 64

TreeView.LEAF_RADIUS = 4
TreeView.LEAF_OFFSET = Vector(0, 4, 0)
TreeView.MIN_LEAF_PARTICLES = 10
TreeView.MAX_LEAF_PARTICLES = 20

TreeView.PARTICLE_SYSTEM = function(textureFilename, radius)
	return {
		numParticles = 50,
		texture = textureFilename,
		columns = 1,

		emitters = {
			{
				type = "RadialEmitter",
				radius = { 0, radius },
				yRange = { 0, 0 }
			},
			{
				type = "DirectionalEmitter",
				direction = { 0, -1, 0 },
				speed = { 3, 4 },
			},
			{
				type = "RandomColorEmitter",
				colors = {
					{ 0.5, 0.5, 0.5, 0 }
				}
			},
			{
				type = "RandomLifetimeEmitter",
				lifetime = { 0.4, 0.8 }
			},
			{
				type = "RandomScaleEmitter",
				scale = { 0.5, 0.6 }
			},
			{
				type = "RandomRotationEmitter",
				rotation = { 0, 360 },
				velocity = { -90, 90 }
			}
		},

		paths = {
			{
				type = "FadeInOutPath",
				fadeInPercent = { 0.4 },
				fadeOutPercent = { 0.6 },
				tween = { 'sineEaseOut' }
			}
		}
	}
end

function TreeView:new(prop, gameView)
	PropView.new(self, prop, gameView)

	self.shaken = 0
	self.spawned = false
	self.depleted = false
	self.time = 0
	self._transform = love.math.newTransform()
	self._color = Color(1, 1, 1, 1)

	self.totalChopTime = 0
	self.lastChopTime = 0
	self.chopCount = 0
	self.startChopping = false
	self.stopChopping = false

	self.chopFromRotation = Quaternion()
	self.chopToRotation = Quaternion()
	self.chopCurrentRotation = Quaternion()
end

function TreeView:getBaseModelFilename()
	return Class.ABSTRACT()
end

function TreeView:getBaseTextureFilename()
	return Class.ABSTRACT()
end

function TreeView:getResourcePath(Type, resource)
	if Type == TextureResource then
		return string.format("%s/%s", self:getBaseTextureFilename(), resource)
	elseif Type == ModelResource or Type == SkeletonResource or Type == SkeletonAnimationResource then
		return string.format("%s/%s", self:getBaseModelFilename(), resource)
	else
		error("unknown type")
	end
end

function TreeView:done()
	-- Nothing.
end

function TreeView:getCurrentAnimation()
	return self.animations[self.currentAnimation]
	    or self.animations[TreeView.ANIMATION_IDLE]
end

function TreeView:applyAnimation(time, animation)
	self.transforms:reset()
	animation:computeFilteredTransforms(time, self.transforms)

	local skeleton = self.skeleton:getResource()
	skeleton:applyTransforms(self.transforms)
	skeleton:applyBindPose(self.transforms)
end

function TreeView:load()
	PropView.load(self)

	local resources = self:getResources()
	local root = self:getRoot()

	self.treeNode = ModelSceneNode()
	self.trunkNode = ModelSceneNode()
	self.leavesNode = ModelSceneNode()

	resources:queue(
		SkeletonResource,
		self:getResourcePath(SkeletonResource, "Tree.lskel"),
		function(skeleton)
			self.skeleton = skeleton
			self.transforms = skeleton:getResource():createTransforms()

			resources:queue(
				ModelResource,
				self:getResourcePath(ModelResource, "Tree.lmesh"),
				function(model)
					self.treeModel = model
				end,
				self.skeleton:getResource())
			resources:queue(
				ModelResource,
				self:getResourcePath(ModelResource, "Trunk.lmesh"),
				function(model)
					self.trunkModel = model
				end,
				self.skeleton:getResource())
			resources:queue(
				ModelResource,
				self:getResourcePath(ModelResource, "Leaves.lmesh"),
				function(model)
					self.leavesModel = model
				end,
				self.skeleton:getResource())
			resources:queue(
				SkeletonAnimationResource,
				self:getResourcePath(SkeletonAnimationResource, "Pose.lanim"),
				function(animation)
					self.poseAnimation = animation
				end,
				skeleton:getResource())
			resources:queueEvent(function()
				self.treeNode:setModel(self.treeModel)
				self.treeNode:getMaterial():setShader(self.treeShader)
				self.treeNode:getMaterial():setTextures(self.barkTexture)
				self.treeNode:getMaterial():setOutlineThreshold(-0.01)
				self.treeNode:setParent(root)
				self.treeNode:setTransforms(self.transforms)

				self.trunkNode:setModel(self.trunkModel)
				self.trunkNode:getMaterial():setShader(self.treeShader)
				self.trunkNode:getMaterial():setTextures(self.barkTexture)
				self.trunkNode:getMaterial():setOutlineThreshold(-0.01)
				self.trunkNode:setParent(root)
				self.trunkNode:setTransforms(self.transforms)

				self.leavesNode:setModel(self.leavesModel)
				self.leavesNode:getMaterial():setOutlineColor(Color(0.5))
				self.leavesNode:getMaterial():setShader(self.leavesShader)
				self.leavesNode:getMaterial():setTextures(self.leavesTexture)
				self.leavesNode:getMaterial():setOutlineThreshold(-0.01)
				self.leavesNode:setTransforms(self.transforms)
				if not self:getIsEditor() then
					self.leavesNode:setParent(root)
				end

				local state = self:getProp():getState().resource
				if state then
					self.isDepleted = state.depleted
					self.wasDepleted = state.depleted
					if self.wasDepleted then
						self.time = self.FELLED_SPAWN_TIME_SECONDS
					else
						self.time = 0
					end
				end

				self:done()

				self.spawned = true

				self:_updateNodeUniforms(self.leavesNode)
			end)
		end)
	resources:queue(
		TextureResource,
		self:getResourcePath(TextureResource, "Leaves.png"),
		function(texture)
			self.leavesTexture = texture
		end)
	resources:queue(
		TextureResource,
		self:getResourcePath(TextureResource, "Bark.png"),
		function(texture)
			self.barkTexture = texture
		end)
	resources:queue(
		ShaderResource,
		"Resources/Shaders/TriplanarSkinnedModel",
		function(shader)
			self.treeShader = shader
		end)
	resources:queue(
		ShaderResource,
		"Resources/Shaders/BendyLeafModel",
		function(shader)
			self.leavesShader = shader
		end)
	resources:queueEvent(
		function()
			self.particles = ParticleSceneNode()
			self.particles:setParent(root)

			local textureFilename = self:getResourcePath(TextureResource, "Leaves.png")
			local system = self.PARTICLE_SYSTEM(
				textureFilename,
				self.LEAF_RADIUS)
			self.particles:initParticleSystemFromDef(system, resources)

			local transform = self.particles:getTransform()
			transform:setLocalTranslation(self.LEAF_OFFSET)

			local material = self.particles:getMaterial()
			material:setIsFullLit(false)
			material:setIsZWriteDisabled(false)
			material:setIsShadowCaster(true)
			material:setGlassThickness(0.5)
		end)
end

function TreeView:remove()
	PropView.remove(self)

	if self.progressBar then
		self:getGameView():getSpriteManager():poof(self.progressBar)
	end
end

function TreeView:_updateNodeUniforms(node)
	local _, layer = self:getProp():getPosition()
	local windDirection, windSpeed, windPattern = self:getGameView():getWind(layer)

	local material = node:getMaterial()
	material:send(material.UNIFORM_FLOAT, "scape_BumpForce", 0)
	material:send(material.UNIFORM_FLOAT, "scape_WindDirection", windDirection:get())
	material:send(material.UNIFORM_FLOAT, "scape_WindSpeed", windSpeed)
	material:send(material.UNIFORM_FLOAT, "scape_WindPattern", windPattern:get())
	material:send(material.UNIFORM_FLOAT, "scape_WindMaxDistance", 0.25)
	material:send(material.UNIFORM_FLOAT, "scape_WallHackWindow", 4.0, 4.0, 4.0, 4.0)
	material:send(material.UNIFORM_FLOAT, "scape_WallHackAlpha", 0.0)
end

function TreeView:tick()
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

		if r.chops ~= self.chopCount then
			self.chopCount = r.chops
			self.lastChopTime = 0
			self.startChopping = true
			self.stopChopping = false

			self:startShake()
		end

		if r.depleted ~= self.isDepleted then
			if r.depleted then
				local globalTransform = self:getRoot():getTransform():getGlobalDeltaTransform(_APP:getPreviousFrameDelta())
				local _, globalRotation = MathCommon.decomposeTransform(globalTransform)
				local inverseGlobalRotation = -globalRotation

				if r.felledPosition then
					local xzSelfPosition = self:getProp():getPosition() * Vector.PLANE_XZ
					local xzFelledPosition = Vector(unpack(r.felledPosition)) * Vector.PLANE_XZ
					self.targetRotation = (inverseGlobalRotation * Quaternion.lookAt(xzFelledPosition, xzSelfPosition, Vector.UNIT_Z)):getNormal()
				else
					self.targetRotation = Quaternion.Y_180
				end

			end

			self.wasDepleted = self.isDepleted
			self.isDepleted = r.depleted
			self.time = 0
		end
	end
end

do
	local xRotation = Quaternion()
	local zRotation = Quaternion()
	function TreeView:startShake()
		self.chopFromRotation:from(self.chopCurrentRotation:get())

		Quaternion.fromAxisAngle(Vector.UNIT_X, math.lerp(self.CHOP_MIN_ANGLE, self.CHOP_MAX_ANGLE, love.math.random()), xRotation)
		Quaternion.fromAxisAngle(Vector.UNIT_Z, math.lerp(self.CHOP_MIN_ANGLE, self.CHOP_MAX_ANGLE, love.math.random()), zRotation)
		zRotation:product(xRotation, self.chopToRotation)
		self.chopToRotation:normalize(self.chopToRotation)

		self.particles:emit(love.math.random(self.MIN_LEAF_PARTICLES, self.MAX_LEAF_PARTICLES))
	end
end

function TreeView:stopShake()
	self.chopFromRotation:from(self.chopCurrentRotation:get())
	self.chopToRotation:from(Quaternion.IDENTITY:get())
end

function TreeView:shake()
	local delta = math.clamp(self.lastChopTime / self.CHOP_TIME_SECONDS)
	delta = Tween.sineEaseOut(delta)

	self.chopFromRotation:slerp(self.chopToRotation, delta, self.chopCurrentRotation)
	self.chopCurrentRotation:normalize(self.chopCurrentRotation)
end

function TreeView:update(delta)
	PropView.update(self, delta)

	if self.spawned then
		self.time = math.min(self.time + delta, self.FELLED_SPAWN_TIME_SECONDS)
		local mu = self.time / self.FELLED_SPAWN_TIME_SECONDS

		if self.isDepleted then
			self._color.a = Tween.sineEaseOut(1 - mu)
		else
			self._color.a = Tween.sineEaseOut(mu)
		end

		self.treeNode:getMaterial():setColor(self._color)
		self.leavesNode:getMaterial():setColor(self._color)

		self.transforms:reset()

		self.poseAnimation:getResource():computeFilteredTransforms(0, self.transforms)

		local r = self:getProp():getState().resource
		if self.isDepleted and r and r.felledPosition then
			local currentRotation = Quaternion.IDENTITY:slerp(self.targetRotation, Tween.powerEaseOut(mu, 1.1)):getNormal()
			MathCommon.makeRotationTransform(currentRotation, self._transform)

			self.transforms:applyTransform(
				self.skeleton:getResource():getBoneIndex("tree"),
				self._transform)
		elseif mu < 1 then
			local scale = Tween.sineEaseOut(mu)
			MathCommon.makeScaleTransform(Vector(scale), self._transform)

			self.transforms:applyTransform(
				self.skeleton:getResource():getBoneIndex("tree"),
				self._transform)
		elseif self.startChopping or self.stopChopping then
			self:shake()

			MathCommon.makeRotationTransform(self.chopCurrentRotation, self._transform)
			self.transforms:applyTransform(
				self.skeleton:getResource():getBoneIndex("tree"),
				self._transform)
		end

		self.skeleton:getResource():applyTransforms(self.transforms)
		self.skeleton:getResource():applyBindPose(self.transforms)

		if self.stopChopping or self.startChopping then
			self.totalChopTime = self.totalChopTime + delta
			self.lastChopTime = self.lastChopTime + delta

			if self.stopChopping and self.lastChopTime > self.CHOP_TIME_SECONDS then
				self.lastChopTime = 0
				self.totalChopTime = 0
				self.stopChopping = false
			elseif self.startChopping and self.lastChopTime > self.CHOP_TIME_SECONDS then
				self.totalChopTime = 0
				self.lastChopTime = 0
				self.startChopping = false
				self.stopChopping = true
				self:stopShake()
			end
		end
	end
end

return TreeView
