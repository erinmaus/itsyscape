--------------------------------------------------------------------------------
-- Resources/Game/Props/HexLabs_JakkenstoneShardAnalyzer_Common/View.lua
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

local Center = Class(PropView)

function Center:getModelNode()
	return self.decoration
end

function Center:load()
	PropView.load(self)

	local resources = self:getResources()
	local root = self:getRoot()

	self.glass = DecorationSceneNode()
	self.shard = DecorationSceneNode()

	resources:queue(
		TextureResource,
		"Resources/Game/Props/HexLabs_JakkenstoneShardAnalyzer_Common/Texture.png",
		function(texture)
			self.texture = texture
		end)
	resources:queue(
		StaticMeshResource,
		"Resources/Game/Props/HexLabs_JakkenstoneShardAnalyzer/Model.lstatic",
		function(mesh)
			self.glass:fromGroup(mesh:getResource(), "Glass")
			self.glass:getMaterial():setTextures(self.texture)
			self.glass:getMaterial():setIsTranslucent(true)
			self.glass:getMaterial():setIsFullLit(true)
			self.glass:getMaterial():setIsZWriteDisabled(true)
			self.glass:setParent(root)

			self.shard:fromGroup(mesh:getResource(), "Solid")
			self.shard:getMaterial():setTextures(self.texture)
			self.shard:setParent(root)
		end)
end

return Center
