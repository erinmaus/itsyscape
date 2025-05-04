--------------------------------------------------------------------------------
-- Resources/Game/Props/FurnaceIsabelle/View.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local FireView = require "Resources.Game.Props.Common.FireView"
local DecorationSceneNode = require "ItsyScape.Graphics.DecorationSceneNode"
local StaticMeshResource = require "ItsyScape.Graphics.StaticMeshResource"
local TextureResource = require "ItsyScape.Graphics.TextureResource"

local FurnaceIsabelle = Class(FireView)
FurnaceIsabelle.SCALE = 2.5
FurnaceIsabelle.HAS_CUSTOM_MODEL = true

function FurnaceIsabelle:load()
	FireView.load(self)

	local resources = self:getResources()
	local root = self:getRoot()

	resources:queue(
		StaticMeshResource,
		"Resources/Game/Props/Furnace_Isabelle/Model.lstatic",
		function(mesh)
			self.furnaceMesh = mesh
		end)
	resources:queue(
		TextureResource,
		"Resources/Game/Props/Furnace_Isabelle/Texture.png",
		function(texture)
			self.furnaceTexture = texture
		end)
	resources:queueEvent(function()
		self.furnaceDecoration = DecorationSceneNode()
		self.furnaceDecoration:fromGroup(self.furnaceMesh:getResource(), "furnace")
		self.furnaceDecoration:getMaterial():setTextures(self.furnaceTexture)
		self.furnaceDecoration:setParent(root)
	end)
end

return FurnaceIsabelle
