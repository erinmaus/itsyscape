--------------------------------------------------------------------------------
-- Resources/Game/Props/YendorianGravestone_Common/View.lua
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
local LayerTextureResource = require "ItsyScape.Graphics.LayerTextureResource"
local PropView = require "ItsyScape.Graphics.PropView"
local ShaderResource = require "ItsyScape.Graphics.ShaderResource"
local StaticMeshResource = require "ItsyScape.Graphics.StaticMeshResource"

local YendorianGravestone = Class(PropView)

function YendorianGravestone:getGroup()
	return Class.ABSTRACT()
end

function YendorianGravestone:load()
	PropView.load(self)

	local resources = self:getResources()
	local root = self:getRoot()

	self.node = DecorationSceneNode()

	resources:queue(
		LayerTextureResource,
		"Resources/Game/Props/YendorianGravestone_Common/Texture.lua",
		function(texture)
			self.texture = texture
		end)
	resources:queue(
		StaticMeshResource,
		"Resources/Game/Props/YendorianGravestone_Common/Gravestones.lstatic",
		function(mesh)
			self.node:fromGroup(mesh:getResource(), self:getGroup())
			self.node:setParent(root)
		end)
	resources:queue(
		ShaderResource,
		"Resources/Shaders/MultiTriplanar",
		function(shader)
			local material = self.node:getMaterial()
			material:setShader(shader)
			material:setTextures(self.texture)
			material:setOutlineThreshold(-0.005)

			self.node:onWillRender(function(renderer)
				local currentShader = renderer:getCurrentShader()
				if not currentShader then
					return
				end

				if currentShader:hasUniform("scape_TriplanarScale") then
					currentShader:send("scape_TriplanarScale", 0, -0.25, -0.5)
				end

				if currentShader:hasUniform("scape_NumLayers") then
					currentShader:send("scape_NumLayers", 3)
				end
			end)
		end)
end

return YendorianGravestone
