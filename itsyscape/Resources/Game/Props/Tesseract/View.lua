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
local Tween = require "ItsyScape.Common.Math.Tween"
local Color = require "ItsyScape.Graphics.Color"
local DecorationSceneNode = require "ItsyScape.Graphics.DecorationSceneNode"
local PropView = require "ItsyScape.Graphics.PropView"
local LayerTextureResource = require "ItsyScape.Graphics.LayerTextureResource"
local ShaderResource = require "ItsyScape.Graphics.ShaderResource"
local StaticMeshResource = require "ItsyScape.Graphics.StaticMeshResource"

local Tesseract = Class(PropView)
Tesseract.GROUPS = {
	"Tesseract1",
	"Tesseract2",
	"Tesseract3"
}
Tesseract.MAX_SCALE = 2
Tesseract.STEP = 2

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
			self.groupIndex = 1
			self.decoration:fromGroup(mesh:getResource(), Tesseract.GROUPS[self.groupIndex])
			self.decoration:getMaterial():setIsTranslucent(true)
			self.decoration:getMaterial():setTextures(self.texture)
			self.decoration:setParent(root)
		end)
	resources:queue(
		ShaderResource,
		"Resources/Shaders/StaticModel_Volume",
		function(shader)
			self.decoration:getMaterial():setShader(shader)
			self.decoration:setParent(root)

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
		if self.time > Tesseract.STEP then
			self.groupIndex = self.groupIndex + 1
			if self.groupIndex > #Tesseract.GROUPS then
				self.groupIndex = 1
			end
			self.time = 0
		end

		local model1Index, model2Index
		do
			model1Index = self.groupIndex
			if self.groupIndex >= #Tesseract.GROUPS then
				model2Index = 1
			else
				model2Index = self.groupIndex + 1
			end
		end

		local delta = self.time / Tesseract.STEP
		self.decoration:fromLerp(
			self.mesh:getResource(),
			Tesseract.GROUPS[model1Index],
			Tesseract.GROUPS[model2Index],
			Tween.sineEaseOut(delta))
	end
end

return Tesseract
