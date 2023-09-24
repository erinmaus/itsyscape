--------------------------------------------------------------------------------
-- Resources/Game/Props/Altar_Bastiel1/View.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Vector = require "ItsyScape.Common.Math.Vector"
local DecorationSceneNode = require "ItsyScape.Graphics.DecorationSceneNode"
local PropView = require "ItsyScape.Graphics.PropView"
local StaticMeshResource = require "ItsyScape.Graphics.StaticMeshResource"
local TextureResource = require "ItsyScape.Graphics.TextureResource"

local Altar = Class(PropView)

Altar.OFFSET    = 0.25
Altar.TIME_PI   = math.pi / 4

function Altar:load()
	PropView.load(self)

	local resources = self:getResources()
	local root = self:getRoot()

	self.altar = DecorationSceneNode()
	self.icon = DecorationSceneNode()

	resources:queue(
		TextureResource,
		"Resources/Game/Props/Altar_Bastiel1/Texture.png",
		function(texture)
			self.texture = texture
		end)
	resources:queue(
		StaticMeshResource,
		"Resources/Game/Props/Altar_Bastiel1/Model.lstatic",
		function(mesh)
			self.altar:fromGroup(mesh:getResource(), "Altar")
			self.altar:getMaterial():setTextures(self.texture)
			self.altar:setParent(root)

			self.icon:fromGroup(mesh:getResource(), "Icon")
			self.icon:getMaterial():setTextures(self.texture)
			self.icon:setParent(root)
		end)

	self.time = love.math.random() * math.pi * 2
end

function Altar:update(delta)
	PropView.update(self, delta)

	if self.icon then
		self.time = self.time + delta
		local offset = math.sin(self.time * Altar.TIME_PI) * Altar.OFFSET

		self.icon:getTransform():setLocalTranslation(Vector(0, offset, 0))
	end
end

return Altar
