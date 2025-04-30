--------------------------------------------------------------------------------
-- Resources/Game/Props/WoodworkingBench_Isabelle/View.lua
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
local SceneNode = require "ItsyScape.Graphics.SceneNode"
local ShaderResource = require "ItsyScape.Graphics.ShaderResource"
local StaticMeshResource = require "ItsyScape.Graphics.StaticMeshResource"
local TextureResource = require "ItsyScape.Graphics.TextureResource"

local BenchView = Class(PropView)

function BenchView:load()
	PropView.load(self)

	local resources = self:getResources()
	local root = self:getRoot()

	resources:queue(
		StaticMeshResource,
		"Resources/Game/Props/WoodworkingBench_Isabelle/Model.lstatic",
		function(mesh)
			self.mesh = mesh
		end)
	resources:queue(
		TextureResource,
		"Resources/Game/Props/WoodworkingBench_Isabelle/Texture.png",
		function(texture)
			self.benchTexture = texture
		end)
	resources:queue(
		TextureResource,
		"Resources/Game/Props/WoodworkingBench_Isabelle/Tools.png",
		function(texture)
			self.toolsTexture = texture
		end)
	resources:queueEvent(function()
		self.bench = DecorationSceneNode()
		self.bench:fromGroup(self.mesh:getResource(), "bench")
		self.bench:getMaterial():setTextures(self.benchTexture)
		self.bench:setParent(root)

		self.tools = DecorationSceneNode()
		self.tools:fromGroup(self.mesh:getResource(), "tools")
		self.tools:getMaterial():setTextures(self.toolsTexture)
		self.tools:setParent(root)
	end)
	resources:queue(
		ShaderResource,
		"Resources/Shaders/VelvetStaticModel",
		function(shader)
			self.bench:getMaterial():setShader(shader)
		end)
end

return BenchView
