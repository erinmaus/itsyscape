--------------------------------------------------------------------------------
-- Resources/Game/Props/Common/RockView.lua
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

local RockView = Class(PropView)

function RockView:new(prop, gameView)
	PropView.new(self, prop, gameView)

	self.depleted = false
	self.previousProgress = 0
end

function RockView:getTextureFilename()
	return "Resources/Game/Props/Common/Rock/Texture.png"
end

function RockView:load()
	PropView.load(self)

	local resources = self:getResources()
	local root = self:getRoot()

	local mesh = resources:load(
		StaticMeshResource,
		"Resources/Game/Props/Common/Rock/Model.lstatic")
	self.depletedTexture = resources:load(
		TextureResource,
		"Resources/Game/Props/Common/Rock/Texture.png")
	self.texture = resources:load(
		TextureResource,
		self:getTextureFilename())

	self.decoration = DecorationSceneNode()
	self.decoration:fromGroup(mesh:getResource(), "CommonRock")
	self.decoration:getMaterial():setTextures(self.texture)
	self.decoration:setParent(root)
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
			if r.depleted then
				self.decoration:getMaterial():setTextures(self.depletedTexture)
			else
				self.decoration:getMaterial():setTextures(self.texture)
			end

			self.depleted = r.depleted
		end
	end
end

return RockView
