--------------------------------------------------------------------------------
-- Resources/Game/Props/Common/FishView.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Vector = require "ItsyScape.Common.Math.Vector"
local Quaternion = require "ItsyScape.Common.Math.Quaternion"
local DecorationSceneNode = require "ItsyScape.Graphics.DecorationSceneNode"
local PropView = require "ItsyScape.Graphics.PropView"
local StaticMeshResource = require "ItsyScape.Graphics.StaticMeshResource"
local TextureResource = require "ItsyScape.Graphics.TextureResource"

local FishView = Class(PropView)
FishView.RADIUS = 1
FishView.START_OFFSET = 100

function FishView:new(prop, gameView)
	PropView.new(self, prop, gameView)

	self.depleted = false
	self.previousProgress = 0

	self.time = math.random() * self.START_OFFSET
end

function FishView:getTextureFilename()
	return Class.ABSTRACT()
end

function FishView:getModelFilename()
	return "Resources/Game/Props/Common/Fish/Model.lstatic"
end

function FishView:load()
	PropView.load(self)

	local resources = self:getResources()
	local root = self:getRoot()

	self.decoration = DecorationSceneNode()
	self.decoration:getMaterial():setIsTranslucent(true)

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
			self.decoration:fromGroup(mesh:getResource(), "Fish")
			self.decoration:getMaterial():setTextures(self.texture)
			self.decoration:setParent(root)
		end)
end

function FishView:remove()
	PropView.remove(self)

	if self.progressBar then
		self:getGameView():getSpriteManager():poof(self.progressBar)
	end
end

function FishView:tick()
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

		if r.depleted ~= self.depleted then
			self.depleted = r.depleted
			if self.depleted then
				self.decoration:setParent(nil)
			else
				self.decoration:setParent(self:getRoot())
			end
		end
	end
end

function FishView:update(delta)
	PropView.update(self, delta)

	local state = self:getProp():getState()
	local scale = state.size or 1

	self.time = self.time + delta

	local rotation
	do
		local xWobble = math.sin(self.time * math.pi * 2) * math.pi / 4
		local xRotation = Quaternion.fromAxisAngle(Vector.UNIT_Y, xWobble)
		local yRotation = Quaternion.fromAxisAngle(Vector.UNIT_Y, self.time * math.pi / 2)

		rotation = yRotation * xRotation
	end

	local translation
	do
		local x = math.sin(self.time * math.pi / 2) * scale * self.RADIUS - 1
		local z = math.cos(self.time * math.pi / 2) * scale * self.RADIUS - 1
		translation = Vector(x, 0, z)
	end

	local scale = Vector.ONE * scale

	local root = self.decoration
	root:getTransform():setLocalTranslation(translation)
	root:getTransform():setLocalRotation(rotation)
	root:getTransform():setLocalScale(scale)
end

return FishView
