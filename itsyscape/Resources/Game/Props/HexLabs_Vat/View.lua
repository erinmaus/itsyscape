--------------------------------------------------------------------------------
-- Resources/Game/Props/HexLabs_Vat/View.lua
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
local QuadSceneNode = require "ItsyScape.Graphics.QuadSceneNode"
local PropView = require "ItsyScape.Graphics.PropView"
local ShaderResource = require "ItsyScape.Graphics.ShaderResource"
local StaticMeshResource = require "ItsyScape.Graphics.StaticMeshResource"
local TextureResource = require "ItsyScape.Graphics.TextureResource"

local Vat = Class(PropView)

function Vat:load()
	PropView.load(self)

	local resources = self:getResources()
	local root = self:getRoot()

	self.glass = DecorationSceneNode()
	self.panel = DecorationSceneNode()

	resources:queue(
		TextureResource,
		"Resources/Game/Props/HexLabs_Vat/Texture.png",
		function(texture)
			self.texture = texture
		end)
	resources:queue(
		StaticMeshResource,
		"Resources/Game/Props/HexLabs_Vat/Model.lstatic",
		function(mesh)
			self.glass:fromGroup(mesh:getResource(), "Glass")
			self.glass:getMaterial():setTextures(self.texture)
			self.glass:getMaterial():setIsTranslucent(true)
			self.glass:getMaterial():setIsFullLit(true)
			self.glass:getMaterial():setIsZWriteDisabled(true)
			self.glass:setParent(root)

			self.panel:fromGroup(mesh:getResource(), "Solid")
			self.panel:getMaterial():setTextures(self.texture)
			self.panel:setParent(root)
		end)
end

return Vat
