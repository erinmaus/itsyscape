--------------------------------------------------------------------------------
-- Resources/Game/Props/Anvil_Default2/View.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Color = require "ItsyScape.Graphics.Color"
local DecorationSceneNode = require "ItsyScape.Graphics.DecorationSceneNode"
local PropView = require "ItsyScape.Graphics.PropView"
local ShaderResource = require "ItsyScape.Graphics.ShaderResource"
local StaticMeshResource = require "ItsyScape.Graphics.StaticMeshResource"
local TextureResource = require "ItsyScape.Graphics.TextureResource"

local AnvilView = Class(PropView)

function AnvilView:load()
	PropView.load(self)

	local resources = self:getResources()
	local root = self:getRoot()

	resources:queue(
		ShaderResource,
		"Resources/Shaders/SpecularTriplanar",
		function(shader)
			self.shader = shader
		end)
	resources:queue(
		StaticMeshResource,
		"Resources/Game/Props/Anvil_Default2/Model.lstatic",
		function(mesh)
			self.mesh = mesh
		end)
	resources:queue(
		TextureResource,
		"Resources/Game/Props/Anvil_Default2/Texture.png",
		function(texture)
			self.anvilTexture = texture
		end)
	resources:queue(
		TextureResource,
		"Resources/Game/Props/Anvil_Default2/Tools.png",
		function(texture)
			self.toolsTexture = texture
		end)
	resources:queueEvent(function()
		self.anvil = DecorationSceneNode()
		self.anvil:fromGroup(self.mesh:getResource(), "anvil")

		local anvilMaterial = self.anvil:getMaterial()
		anvilMaterial:setColor(Color(0.4))
		anvilMaterial:setTextures(self.anvilTexture)
		anvilMaterial:setShader(self.shader)
		anvilMaterial:send(anvilMaterial.UNIFORM_FLOAT, "scape_TriplanarScale", -0.5)
		self.anvil:setParent(root)

		self.tools = DecorationSceneNode()
		self.tools:fromGroup(self.mesh:getResource(), "tools")
		self.tools:getMaterial():setTextures(self.toolsTexture)
		self.tools:setParent(root)
	end)
end

return AnvilView
