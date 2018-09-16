--------------------------------------------------------------------------------
-- Resources/Game/Props/IsabelleIsland_AbandonedMine_Pillar/View.lua
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
local ModelSceneNode = require "ItsyScape.Graphics.ModelSceneNode"
local PropView = require "ItsyScape.Graphics.PropView"
local ModelResource = require "ItsyScape.Graphics.ModelResource"
local SkeletonResource = require "ItsyScape.Graphics.SkeletonResource"
local SkeletonAnimationResource = require "ItsyScape.Graphics.SkeletonAnimationResource"
local TextureResource = require "ItsyScape.Graphics.TextureResource"

local PillarView = Class(PropView)

function PillarView:new(prop, gameView)
	PropView.new(self, prop, gameView)

	self.depleted = false
	self.previousProgress = 0
	self.time = false
end

function PillarView:load()
	PropView.load(self)

	local resources = self:getResources()
	local root = self:getRoot()

	local skeleton = resources:load(
		SkeletonResource,
		"Resources/Game/Props/IsabelleIsland_AbandonedMine_Pillar/Skeleton.lskel")
	local model = resources:load(
		ModelResource,
		"Resources/Game/Props/IsabelleIsland_AbandonedMine_Pillar/Model.lmesh",
		skeleton:getResource())
	local animation = resources:load(
		SkeletonAnimationResource,
		"Resources/Game/Props/IsabelleIsland_AbandonedMine_Pillar/Animation.lanim",
		skeleton:getResource())
	local texture = resources:load(
		TextureResource,
		"Resources/Game/Props/IsabelleIsland_AbandonedMine_Pillar/Texture.png")
	local texture = resources:load(
		TextureResource,
		"Resources/Game/Props/IsabelleIsland_AbandonedMine_Pillar/Texture.png")

	self.node = ModelSceneNode()
	self.node:setModel(model)
	self.node:getMaterial():setTextures(texture)
	self.node:setParent(root)

	self.node:getTransform():setLocalScale(Vector(2))
	self.node:getTransform():setLocalTranslation(Vector(0, 1, 0))

	self.animation = animation
	do
		local transforms = {}
		self.animation:getResource():computeTransforms(0, transforms)
		self.node:setTransforms(transforms)
	end
end

function PillarView:update(delta)
	PropView.update(self, delta)

	local time
	if self.time then
		self.time = math.min(
			self.time + delta,
			self.animation:getResource():getDuration())
		time = self.time
	else
		time = 0
	end

	do
		local transforms = {}
		self.animation:getResource():computeTransforms(time, transforms)
		self.node:setTransforms(transforms)
	end
end

function PillarView:tick()
	PropView.tick(self)

	local state = self:getProp():getState()
	if state.resource then
		local r = state.resource
		if r.progress > 0 and r.progress < 100 and (not self.progressBar or not self.progressBar:getIsSpawned()) then
			self.progressBar = self:getGameView():getSpriteManager():add(
				"ResourceProgressBar",
				self:getRoot(),
				Vector(0, 4, 0),
				self:getProp())
		end

		if r.depleted ~= self.depleted then
			if r.depleted then
				self.time = 0
			else
				self.time = false
			end

			self.depleted = r.depleted
		end
	end
end

return PillarView
