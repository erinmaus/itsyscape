--------------------------------------------------------------------------------
-- Resources/Game/Props/Brazier_Isabelle/View.lua
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
local StaticMeshResource = require "ItsyScape.Graphics.StaticMeshResource"
local ShaderResource = require "ItsyScape.Graphics.ShaderResource"
local TextureResource = require "ItsyScape.Graphics.TextureResource"
local FireView = require "Resources.Game.Props.Common.FireView"

local Brazier = Class(FireView)
Brazier.SCALE = 2
Brazier.OFFSET = Vector(0, 1, 0):keep()
Brazier.HAS_CUSTOM_MODEL = true

function Brazier:load()
	FireView.load(self)

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
		"Resources/Game/Props/Brazier_Isabelle/Model.lstatic",
		function(mesh)
			self.mesh = mesh
		end)
	resources:queue(
		TextureResource,
		"Resources/Game/Props/Brazier_Isabelle/Texture.png",
		function(texture)
			self.texture = texture
		end)
	resources:queueEvent(function()
		self.brazier = DecorationSceneNode()
		self.brazier:fromGroup(self.mesh:getResource(), "brazier")
		self.brazier:setParent(root)

		local material = self.brazier:getMaterial()
		material:setColor(Color(0.4))
		material:setTextures(self.texture)
		material:setShader(self.shader)
		material:setIsReflectiveOrRefractive(true)
		material:setReflectionPower(10)
		material:send(material.UNIFORM_FLOAT, "scape_TriplanarScale", -0.5)
	end)
end

return Brazier
