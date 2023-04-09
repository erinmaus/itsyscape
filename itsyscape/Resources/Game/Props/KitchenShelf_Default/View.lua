--------------------------------------------------------------------------------
-- Resources/Game/Props/KitchenShelf_Default/View.lua
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

local KitchenShelf = Class(SimpleStaticView)

function KitchenShelf:new(...)
	SimpleStaticView.new(self, ...)
end

function KitchenShelf:tick()
	local root = self:getRoot()
	local position = self:getProp():getPosition()

	-- These numbers took a bit of tweaking to get right.
	local value = love.math.noise(position.x / 4, position.y / 4, position.z / 4)
	local index = math.min(math.floor(value * 5), 3)

	if self.index ~= index then
		local resources = self:getResources()
		local root = self:getRoot()

		if self.kitchen then
			self.kitchen:setParent(nil)
		end

		self.kitchen = DecorationSceneNode()

		resources:queue(
			TextureResource,
			string.format("Resources/Game/Props/KitchenShelf_Default/PotsAndPans%d.png", index),
			function(texture)
				self.stuffTexture = texture
			end)
		resources:queue(
			StaticMeshResource,
			self:getModelFilename(),
			function(mesh)
				self.kitchen:fromGroup(mesh:getResource(), "ShelfItems")
				self.kitchen:getMaterial():setTextures(self.stuffTexture)
				self.kitchen:setParent(root)
			end)

		self.index = index
	end

	SimpleStaticView.tick(self)
end

function KitchenShelf:getTextureFilename()
	return "Resources/Game/Props/Shelf_Common/Texture.png"
end

function KitchenShelf:getModelFilename()
	return "Resources/Game/Props/Shelf_Common/Model.lstatic", "Shelf"
end

return KitchenShelf
