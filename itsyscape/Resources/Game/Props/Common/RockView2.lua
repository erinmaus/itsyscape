--------------------------------------------------------------------------------
-- Resources/Game/Props/Common/RockView2.lua
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
local Tween = require "ItsyScape.Common.Math.Tween"
local Color = require "ItsyScape.Graphics.Color"
local DecorationSceneNode = require "ItsyScape.Graphics.DecorationSceneNode"
local PropView = require "ItsyScape.Graphics.PropView"
local StaticMeshResource = require "ItsyScape.Graphics.StaticMeshResource"
local TextureResource = require "ItsyScape.Graphics.TextureResource"

local RockView = Class(PropView)
RockView.FADE_TIME_SECONDS = 0.25

function RockView:new(prop, gameView)
	PropView.new(self, prop, gameView)

	self.depleted = false
	self.time = 0
end

function RockView:getTextureFilename()
	return "Resources/Game/Props/Common/Rock/Texture_V2.png"
end

function RockView:getDepletedTextureFilename()
	return "Resources/Game/Props/Common/Rock/Texture_V2.png"
end

function RockView:getModelFilename()
	return "Resources/Game/Props/Common/Rock/Model_V2.lstatic"
end

function RockView:load()
	PropView.load(self)

	local resources = self:getResources()
	local root = self:getRoot()

	self.depletedNode = DecorationSceneNode()
	self.activeNode = DecorationSceneNode()

	resources:queue(
		TextureResource,
		self:getDepletedTextureFilename(),
		function(texture)
			self.depletedTexture = texture
		end)
	resources:queue(
		TextureResource,
		self:getTextureFilename(),
		function(texture)
			self.activeNodeTexture = texture
		end)
	resources:queue(
		StaticMeshResource,
		self:getModelFilename(),
		function(mesh)
			self.depletedNode:fromGroup(mesh:getResource(), "CommonRock")
			self.depletedNode:getMaterial():setTextures(self.depletedTexture)
			self.depletedNode:setParent(root)

			self.activeNode:fromGroup(mesh:getResource(), "CommonRock")
			self.activeNode:getMaterial():setTextures(self.activeNodeTexture)
			self.activeNode:getMaterial():setIsTranslucent(true)
			self.activeNode:setParent(root)

			local state = self:getProp():getState()
			state = state and state.resource
			if state then
				if state.depleted then
					self.activeNode:getMaterial():setColor(Color(1, 1, 1, 0))
				else
					self.activeNode:getMaterial():setColor(Color(1, 1, 1, 1))
				end

				self.depletedNode:getMaterial():setColor(Color(1, 1, 1, 1))
				self.depleted = state.depleted
			end
		end)
end

function RockView:remove()
	PropView.remove(self)

	if self.progressBar then
		self:getGameView():getSpriteManager():poof(self.progressBar)
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

		if r.depleted ~= self.depleted then
			self.depleted = r.depleted
			self.time = self.FADE_TIME_SECONDS
		end
	end

	local position = self:getProp():getPosition()
	local value = love.math.noise(position.x / 2, position.y / 2, position.z / 2)
	local rotation = Quaternion.fromAxisAngle(Vector.UNIT_Y, math.pi * value * 2)
	local scale = Vector(Tween.bounceInOut(value * 0.5 + 0.5))

	self.activeNode:getTransform():setLocalRotation(rotation)
	self.activeNode:getTransform():setLocalScale(scale)
	self.depletedNode:getTransform():setLocalRotation(rotation)
	self.depletedNode:getTransform():setLocalScale(scale)
end

function RockView:update(delta)
	PropView.update(self, delta)

	if self.time > 0 then
		self.time = math.max(self.time - delta, 0)

		local alpha = Tween.sineEaseOut(self.time / self.FADE_TIME_SECONDS)

		if self.depleted then
			self.activeNode:getMaterial():setColor(Color(1, 1, 1, alpha))
		else
			self.activeNode:getMaterial():setColor(Color(1, 1, 1, 1 - alpha))
		end
	end
end

return RockView
