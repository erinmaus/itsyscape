--------------------------------------------------------------------------------
-- Resources/Game/Props/Common/Shape4DView.lua
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

local Shape4DView = Class(PropView)

Shape4DView.GROUP_TWEEN = Tween.sineEaseOut
Shape4DView.GROUPS = {}

Shape4DView.SCALE_TWEEN = Tween.expEaseInOut
Shape4DView.SCALES = {}

Shape4DView.STEP = 2

Shape4DView.OFFSET_TWEEN = Tween.sineEaseOut
Shape4DView.OFFSETS = {}

function Shape4DView:getTextureFilename()
	return Class.ABSTRACT()
end

function Shape4DView:getModelFilename()
	return Class.ABSTRACT()
end

function Shape4DView:getModelNode()
	return self.decoration
end

function Shape4DView:load()
	PropView.load(self)

	local resources = self:getResources()
	local root = self:getRoot()

	self.decoration = DecorationSceneNode()

	resources:queue(
		LayerTextureResource,
		self:getTextureFilename(),
		function(texture)
			self.texture = texture
			self.texture:getResource():setWrap('repeat')
		end)
	resources:queue(
		StaticMeshResource,
		self:getModelFilename(),
		function(mesh)
			self.mesh = mesh
			self.groupIndex = 1
			self.decoration:fromGroup(mesh:getResource(), self.GROUPS[self.groupIndex])
			self.decoration:getMaterial():setIsTranslucent(true)
			self.decoration:getMaterial():setTextures(self.texture)
		end)
	resources:queue(
		ShaderResource,
		"Resources/Shaders/StaticModel_Volume",
		function(shader)
			self.decoration:getMaterial():setShader(shader)
			self.decoration:setParent(root)

			self.decoration:onWillRender(function(renderer, ...)
				local shader = renderer:getCurrentShader()

				if shader:hasUniform("scape_NumLayers") then
					shader:send("scape_NumLayers", self.texture:getLayerCount())
				end

				if shader:hasUniform("scape_TextureDepthScale") then
					shader:send("scape_TextureDepthScale", 1)
				end

				self:onWillRender(renderer, ...)
			end)
		end)
end

function Shape4DView:onWillRender(...)
	-- Nothing.
end

function Shape4DView:update(delta)
	PropView.update(self, delta)

	if self.mesh then
		self.time = (self.time or 0) + delta
		if self.time > self.STEP then	
			self.groupIndex = self.groupIndex + 1
			if self.groupIndex > #self.GROUPS then
				self.groupIndex = 1
			end

			self.time = 0
		end

		local delta = self.time / self.STEP

		local model1Index, model2Index
		do
			model1Index = self.groupIndex
			if self.groupIndex >= #self.GROUPS then
				model2Index = 1
			else
				model2Index = self.groupIndex + 1
			end
		end

		local scale
		do
			local scale1 = self.SCALES[model1Index]
			local scale2 = self.SCALES[model2Index]
			scale = scale1:lerp(scale2, self.SCALE_TWEEN(delta))
		end

		local offset
		do
			local offset1 = self.OFFSETS[model1Index]
			local offset2 = self.OFFSETS[model2Index]
			offset = offset1:lerp(offset2, self.OFFSET_TWEEN(delta))
		end

		self.decoration:fromLerp(
			self.mesh:getResource(),
			self.GROUPS[model1Index],
			self.GROUPS[model2Index],
			self.GROUP_TWEEN(delta))
		self.decoration:getTransform():setLocalScale(scale)
		self.decoration:getTransform():setLocalTranslation(offset)
	end
end

function Shape4DView:getIsStatic()
	return false
end

return Shape4DView
