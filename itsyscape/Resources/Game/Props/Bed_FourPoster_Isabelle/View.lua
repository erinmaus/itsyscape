--------------------------------------------------------------------------------
-- Resources/Game/Props/Bed_FourPoster_Isabelle/View.lua
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
local SceneNode = require "ItsyScape.Graphics.SceneNode"
local ShaderResource = require "ItsyScape.Graphics.ShaderResource"
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
		"Resources/Game/Props/Bed_FourPoster_Isabelle/Model.lstatic",
		function(mesh)
			self.mesh = mesh
		end)
	resources:queue(
		TextureResource,
		"Resources/Game/Props/Bed_FourPoster_Isabelle/Frame.png",
		function(texture)
			self.frameTexture = texture
		end)
	resources:queue(
		TextureResource,
		"Resources/Game/Props/Bed_FourPoster_Isabelle/Mattress.png",
		function(texture)
			self.mattressTexture = texture
		end)
	resources:queue(
		TextureResource,
		"Resources/Game/Props/Bed_FourPoster_Isabelle/Mattress_Specular.png",
		function(texture)
			self.specularTexture = texture
		end)
	resources:queueEvent(function()
		self.frame = DecorationSceneNode()
		self.frame:fromGroup(self.mesh:getResource(), "bed.frame")
		self.frame:getMaterial():setTextures(self.frameTexture)
		self.frame:getMaterial():setOutlineThreshold(0.65)
		self.frame:setParent(root)

		self.mattress = DecorationSceneNode()
		self.mattress:fromGroup(self.mesh:getResource(), "bed.mattress")
		self.mattress:getMaterial():setTextures(self.mattressTexture, self.specularTexture)
		self.mattress:getMaterial():setOutlineThreshold(0.65)
		self.mattress:setParent(root)
		self.mattress:onWillRender(function(renderer)
			local shader = renderer:getCurrentShader()
			if shader and shader:hasUniform("scape_SpecularTexture") then
				shader:send("scape_SpecularTexture", self.specularTexture:getResource())
			end
		end)
	end)
	resources:queue(
		ShaderResource,
		"Resources/Shaders/VelvetStaticModel",
		function(shader)
			self.mattress:getMaterial():setShader(shader)
		end)
end

return DeskView
