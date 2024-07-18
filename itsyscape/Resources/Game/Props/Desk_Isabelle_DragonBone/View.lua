--------------------------------------------------------------------------------
-- Resources/Game/Props/Desk_Isabelle_DragonBone/View.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local DecorationSceneNode = require "ItsyScape.Graphics.DecorationSceneNode"
local PropView = require "ItsyScape.Graphics.PropView"
local StaticMeshResource = require "ItsyScape.Graphics.StaticMeshResource"
local TextureResource = require "ItsyScape.Graphics.TextureResource"

local DeskView = Class(PropView)

function DeskView:new(prop, gameView)
	PropView.new(self, prop, gameView)
end

function DeskView:load()
	PropView.load(self)

	local resources = self:getResources()
	local root = self:getRoot()

	resources:queue(
		StaticMeshResource,
		"Resources/Game/Props/Desk_Isabelle_DragonBone/Model.lstatic",
		function(mesh)
			self.mesh = mesh
		end)
	resources:queue(
		TextureResource,
		"Resources/Game/Props/Desk_Isabelle_DragonBone/Wood.png",
		function(texture)
			self.woodTexture = texture
		end)
	resources:queue(
		TextureResource,
		"Resources/Game/Props/Desk_Isabelle_DragonBone/Bone.png",
		function(texture)
			self.boneTexture = texture
		end)
	resources:queueEvent(function()
		self.bone = DecorationSceneNode()
		self.bone:fromGroup(self.mesh:getResource(), "Bone")
		self.bone:getMaterial():setTextures(self.boneTexture)
		self.bone:getMaterial():setOutlineThreshold(0.5)
		self.bone:setParent(root)

		self.wood = DecorationSceneNode()
		self.wood:fromGroup(self.mesh:getResource(), "Wood")
		self.wood:getMaterial():setTextures(self.woodTexture)
		self.wood:getMaterial():setOutlineThreshold(0.5)
		self.wood:setParent(root)
	end)
end

return DeskView
