--------------------------------------------------------------------------------
-- Resources/Game/Props/YewTree_Default/View.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Vector = require "ItsyScape.Common.Math.Vector"
local TreeView = require "Resources.Game.Props.Common.TreeView"
local ParticleSceneNode = require "ItsyScape.Graphics.ParticleSceneNode"

local YewTreeView = Class(TreeView)
YewTreeView.PARTICLE_SYSTEM = {
	numParticles = 50,
	texture = "Resources/Game/Props/YewTree_Default/Particle.png",
	columns = 1,

	emitters = {
		{
			type = "RadialEmitter",
			radius = { 2.5 },
			yRange = { 0, 0 }
		},
		{
			type = "DirectionalEmitter",
			direction = { 0, -1, 0 },
			speed = { 0.5, 1.5 },
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
			scale = { 0.5, 0.75 }
		},
		{
			type = "RandomRotationEmitter",
			rotation = { 0, 360 },
			speed = { -90, 90 }
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

YewTreeView.EMISSION_STRATEGY = {
	type = "RandomDelayEmissionStrategy",
	count = { 5, 10 },
	delay = { 0.125 },
	duration = { 0.5 }
}

function YewTreeView:getBaseFilename()
	return "Resources/Game/Props/YewTree_Default"
end

function YewTreeView:done()
	local root = self:getRoot()
	local willRender

	willRender = root:onWillRender(function()
		willRender()

		local transform = self.skeleton:getResource():getLocalBoneTransform("trunk", self.transforms)
		local point = Vector(transform:transformPoint(0, 3.5, 0))
		self.particleSystem:updateLocalPosition(point)
	end)
end

function YewTreeView:load()
	TreeView.load(self)
	local resources = self:getResources()
	local root = self:getRoot()

	self.particleSystem = ParticleSceneNode()
	self.particleSystem:setParent(root)
	self.particleSystem:initParticleSystemFromDef(YewTreeView.PARTICLE_SYSTEM, resources)
end

function YewTreeView:update(...)
	TreeView.update(self, ...)

	if self.currentAnimation ~= self.previousAnimation then
		self.previousAnimation = self.currentAnimation

		if self.previousAnimation == TreeView.ANIMATION_CHOPPED or
		   self.previousAnimation == TreeView.ANIMATION_FELLED
		then
			self.particleSystem:initEmissionStrategyFromDef(YewTreeView.EMISSION_STRATEGY)
		end
	end
end

return YewTreeView
