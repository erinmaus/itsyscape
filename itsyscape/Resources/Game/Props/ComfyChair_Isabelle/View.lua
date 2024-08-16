--------------------------------------------------------------------------------
-- Resources/Game/Props/ComfyChair_Isabelle/View.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Vector = require "ItsyScape.Common.Math.Vector"
local SimpleStaticView = require "Resources.Game.Props.Common.SimpleStaticView"
local ShaderResource = require "ItsyScape.Graphics.ShaderResource"
local TextureResource = require "ItsyScape.Graphics.TextureResource"

local Chair = Class(SimpleStaticView)

function Chair:getTextureFilename()
	return "Resources/Game/Props/ComfyChair_Isabelle/Chair.png"
end

function Chair:getModelFilename()
	return "Resources/Game/Props/ComfyChair_Isabelle/Chair.lstatic", "chair"
end

function Chair:load()
	SimpleStaticView.load(self)

	local resources = self:getResources()
	resources:queue(
		TextureResource,
		"Resources/Game/Props/ComfyChair_Isabelle/Chair_Specular.png",
		function(texture)
			self.specularTexture = texture

			local diffuse = self:getModelNode():getMaterial():getTexture(1)
			self:getModelNode():getMaterial():setTextures(diffuse, self.specularTexture)
		end)
	resources:queue(
		ShaderResource,
		"Resources/Shaders/VelvetStaticModel",
		function(shader)
			self:getModelNode():getMaterial():setShader(shader)
		end)
	resources:queueEvent(function()
		local node = self:getModelNode()
		node:onWillRender(function(renderer)
			local shader = renderer:getCurrentShader()
			if shader and shader:hasUniform("scape_SpecularTexture") then
				shader:send("scape_SpecularTexture", self.specularTexture:getResource())
			end
		end)
	end)
end

return Chair
