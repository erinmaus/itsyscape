--------------------------------------------------------------------------------
-- Resources/Game/Props/Power_Bomb_Default/View.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Vector = require "ItsyScape.Common.Math.Vector"
local Tween = require "ItsyScape.Common.Math.Tween"
local Color = require "ItsyScape.Graphics.Color"
local DecorationSceneNode = require "ItsyScape.Graphics.DecorationSceneNode"
local PointLightSceneNode = require "ItsyScape.Graphics.PointLightSceneNode"
local PropView = require "ItsyScape.Graphics.PropView"
local StaticMeshResource = require "ItsyScape.Graphics.StaticMeshResource"
local TextureResource = require "ItsyScape.Graphics.TextureResource"

local BombView = Class(PropView)
BombView.FALL_DURATION = 0.5
BombView.FALL_HEIGHT   = 4
BombView.FADE_DURATION = 0.5
BombView.LIGHT_RADIUS  = 8
BombView.LIGHT_COLOR   = Color(0.6, 0.6, 0.3, 1.0)

function BombView:new(prop, gameView)
	PropView.new(self, prop, gameView)

	self.duration = 0
end

function BombView:load()
	PropView.load(self)

	local resources = self:getResources()
	local root = self:getRoot()

	resources:queue(
		StaticMeshResource,
		"Resources/Game/Props/Power_Bomb_Default/Bomb.lstatic",
		function(mesh)
			self.mesh = mesh
		end)
	resources:queue(
		TextureResource,
		"Resources/Game/Props/Power_Bomb_Default/Texture.png",
		function(texture)
			self.texture = texture
		end)
	resources:queueEvent(function()
		self.decoration = DecorationSceneNode()
		self.decoration:fromGroup(self.mesh:getResource(), "Bomb")
		self.decoration:getMaterial():setTextures(self.texture)
		self.decoration:setParent(root)

		self.light = PointLightSceneNode()
		self.light:setColor(BombView.LIGHT_COLOR)
		self.light:setParent(root)
	end)
end

function BombView:remove()
	PropView.remove(self)

	if self.progressBar then
		self:getGameView():getSpriteManager():poof(self.progressBar)
	end
end

function BombView:tick()
	PropView.tick(self)

	local state = self:getProp():getState()
	if state.resource then
		local r = state.resource
		if r.progress > 0 and r.progress < 100 and (not self.progressBar or not self.progressBar:getIsSpawned()) then
			self.progressBar = self:getGameView():getSpriteManager():add(
				"ResourceProgressBar",
				self:getRoot(),
				Vector(0, 0.5, 0),
				self:getProp())
		end

		if self.light then
			local radiusDelta = r.progress / 100
			self.light:setAttenuation(radiusDelta * BombView.LIGHT_RADIUS + 1)
		end

		if r.progress >= 100 then
			self.decoration:getTransform():setLocalScale(Vector(0))
		elseif r.progress >= 80 then
			self.decoration:getTransform():setLocalScale(Vector(2.0))
		end
	end

	local fallDelta = math.min(self.duration / BombView.FALL_DURATION, 1)
	local fallMu = Tween.sineEaseIn(1 - fallDelta)
	local position = Vector(0, BombView.FALL_HEIGHT * fallMu, 0)
	if self.decoration then
		self.decoration:getTransform():setLocalTranslation(position)
	end

	local fadeDelta = math.min(self.duration / BombView.FADE_DURATION, 1)
	local fadeMu = Tween.sineEaseIn(fadeDelta)
	if self.decoration then
		self.decoration:getMaterial():setColor(Color(1, 1, 1, fadeMu))
	end
end

function BombView:update(delta)
	self.duration = self.duration + delta
end

return BombView
