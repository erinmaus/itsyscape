--------------------------------------------------------------------------------
-- Resources/Game/Props/Bookshelf_Default/View.lua
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
local SimpleStaticView = require "Resources.Game.Props.Common.SimpleStaticView"
local StaticMeshResource = require "ItsyScape.Graphics.StaticMeshResource"
local TextureResource = require "ItsyScape.Graphics.TextureResource"

local Bookshelf = Class(SimpleStaticView)
Bookshelf.TEXTURES = 3

function Bookshelf:new(...)
	SimpleStaticView.new(self, ...)

	self.spawned = false
end

function Bookshelf:tick()
	if not self.spawned then
		local root = self:getRoot()
		local position = self:getProp():getPosition()

		-- These numbers took a bit of tweaking to get right.
		local value = love.math.noise(position.x / 4, position.y / 4, position.z / 4)
		local index = math.min(math.floor(value * 5), 3)
		
		local resources = self:getResources()
		local root = self:getRoot()

		self.books = DecorationSceneNode()

		resources:queue(
			TextureResource,
			string.format("Resources/Game/Props/Bookshelf_Default/Books%d.png", index),
			function(texture)
				self.booksTexture = texture
			end)
		resources:queue(
			StaticMeshResource,
			self:getModelFilename(),
			function(mesh)
				self.books:fromGroup(mesh:getResource(), "ShelfItems")
				self.books:getMaterial():setTextures(self.booksTexture)
				self.books:setParent(root)
			end)

		self.spawned = true
	end

	SimpleStaticView.tick(self)
end

function Bookshelf:getTextureFilename()
	return "Resources/Game/Props/Shelf_Common/Texture.png"
end

function Bookshelf:getModelFilename()
	return "Resources/Game/Props/Shelf_Common/Model.lstatic", "Shelf"
end

return Bookshelf
