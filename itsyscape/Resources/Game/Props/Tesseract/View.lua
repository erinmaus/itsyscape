--------------------------------------------------------------------------------
-- Resources/Game/Props/Tesseract_Small_Default/View.lua
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
local PropView = require "ItsyScape.Graphics.PropView"
local LayerTextureResource = require "ItsyScape.Graphics.LayerTextureResource"
local ShaderResource = require "ItsyScape.Graphics.ShaderResource"
local StaticMeshResource = require "ItsyScape.Graphics.StaticMeshResource"

local Tesseract = Class(PropView)

function Tesseract:load(...)
	PropView.load(self, ...)

	local resources = self:getResources()
	local root = self:getRoot()

	self.decoration = DecorationSceneNode()

	resources:queue(
		LayerTextureResource,
		"Resources/Game/Props/Tesseract/Texture.lua",
		function(texture)
			self.texture = texture
		end)
	resources:queue(
		StaticMeshResource,
		"Resources/Game/Props/Tesseract/Model.lstatic",
		function(mesh)
			self.mesh = mesh
			self.decoration:fromGroup(mesh:getResource(), "Tesseract1")
			self.decoration:getMaterial():setTextures(self.texture)
			self.decoration:setParent(root)
		end)
	resources:queue(
		ShaderResource,
		"Resources/Shaders/StaticModel_Volume",
		function(shader)
			self.decoration:getMaterial():setShader(shader)

			self.decoration:onWillRender(function(renderer)
				local shader = renderer:getCurrentShader()
				if shader:hasUniform("scape_NumLayers") then
					shader:send("scape_NumLayers", self.texture:getLayerCount())
				end
			end)
		end)
end

function Tesseract:getIsStatic()
	return false
end

function Tesseract:update(delta)
	PropView.update(self, delta)

	if self.mesh then
		self.time = (self.time or 0) + delta 
		self.decoration:fromLerp(
			self.mesh:getResource(),
			"Tesseract1",
			"Tesseract2",
			math.abs(math.sin(self.time * math.pi)))
	end
end

return Tesseract
