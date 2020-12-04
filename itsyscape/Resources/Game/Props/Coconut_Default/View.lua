--------------------------------------------------------------------------------
-- Resources/Game/Props/Coconut_Default/View.lua
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

local CoconutView = Class(PropView)
CoconutView.FALL_DURATION = 0.5
CoconutView.FALL_HEIGHT   = 4
CoconutView.FADE_DURATION = 0.5

function CoconutView:new(prop, gameView)
	PropView.new(self, prop, gameView)

	self.duration = 0
end

function CoconutView:load()
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

function CoconutView:remove()
	PropView.remove(self)

	if self.progressBar then
		self:getGameView():getSpriteManager():poof(self.progressBar)
	end
end

function CoconutView:tick()
	PropView.tick(self)

	local fallDelta = math.min(self.duration / CoconutView.FALL_DURATION, 1)
	local fallMu = Tween.sineEaseIn(1 - fallDelta)
	local position = Vector(0, CoconutView.FALL_HEIGHT * fallMu, 0)
	if self.decoration then
		self.decoration:getTransform():setLocalTranslation(position)
	end

	local fadeDelta = math.min(self.duration / CoconutView.FADE_DURATION, 1)
	local fadeMu = Tween.sineEaseIn(fadeDelta)
	if self.decoration then
		self.decoration:getMaterial():setColor(Color(1, 1, 1, fadeMu))
	end
end

function CoconutView:update(delta)
	self.duration = self.duration + delta
end

return CoconutView
