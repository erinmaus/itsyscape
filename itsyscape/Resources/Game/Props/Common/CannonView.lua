--------------------------------------------------------------------------------
-- Resources/Game/Props/Common/CannonView.lua
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
local PropView = require "ItsyScape.Graphics.PropView"
local StaticMeshResource = require "ItsyScape.Graphics.StaticMeshResource"
local TextureResource = require "ItsyScape.Graphics.TextureResource"

local CannonView = Class(PropView)

function CannonView:new(prop, gameView)
	PropView.new(self, prop, gameView)

	self.fired = false
	self.previousProgress = 0
end

function CannonView:getTextureFilename()
	return Class.ABSTRACT()
end

function CannonView:load()
	PropView.load(self)

	local resources = self:getResources()
	local root = self:getRoot()

	self.cannon = DecorationSceneNode()
	self.carriage = DecorationSceneNode()

	resources:queue(
		TextureResource,
		self:getTextureFilename(),
		function(texture)
			self.texture = texture
		end)
	resources:queue(
		StaticMeshResource,
		"Resources/Game/Props/Common/Cannon/Model.lstatic",
		function(mesh)
			self.cannon:fromGroup(mesh:getResource(), "Cannon")
			self.cannon:getMaterial():setTextures(self.texture)
			self.cannon:setParent(root)
		end)
	resources:queue(
		StaticMeshResource,
		"Resources/Game/Props/Common/Cannon/Model.lstatic",
		function(mesh)
			self.carriage:fromGroup(mesh:getResource(), "Carriage")
			self.carriage:getMaterial():setTextures(self.texture)
			self.carriage:setParent(root)
		end)
end

function CannonView:remove()
	PropView.remove(self)

	if self.progressBar then
		self:getGameView():getSpriteManager():poof(self.progressBar)
	end
end

function CannonView:tick()
	PropView.tick(self)

	local state = self:getProp():getState()
	if state.resource then
		local r = state.resource
		if r.progress > 0 and r.progress < 100 and (not self.progressBar or not self.progressBar:getIsSpawned()) then
			self.progressBar = self:getGameView():getSpriteManager():add(
				"ResourceProgressBar",
				self:getRoot(),
				Vector(0, 2.5, 0),
				self:getProp())
		end
	end
end

return CannonView
