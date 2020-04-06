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
local PropView = require "ItsyScape.Graphics.PropView"
local StaticMeshResource = require "ItsyScape.Graphics.StaticMeshResource"
local TextureResource = require "ItsyScape.Graphics.TextureResource"

local BombView = Class(PropView)
BombView.FALL_DURATION = 0.5
BombView.FALL_HEIGHT   = 4
BombView.FADE_DURATION = 0.5

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
		"Resources/Game/Props/Coconut_Default/Model.lstatic",
		function(mesh)
			self.mesh = mesh
		end)
	resources:queue(
		TextureResource,
		"Resources/Game/Props/Coconut_Default/Texture.png",
		function(texture)
			self.texture = texture
		end)
	resources:queueEvent(function()
		self.decoration = DecorationSceneNode()
		self.decoration:fromGroup(self.mesh:getResource(), "Coconut")
		self.decoration:getMaterial():setTextures(self.texture)
		self.decoration:setParent(root)
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
