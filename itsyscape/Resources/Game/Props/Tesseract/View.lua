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
	"Tesseract_Unpowered",
	"Tesseract_Powered"
}

Tesseract.GROUP_POWERED_TRANSITION   = 2
Tesseract.GROUP_UNPOWERED_TRANSITION = 1

Tesseract.MAX_SCALE = 1
Tesseract.TRANSITION_STEP = 2
Tesseract.ALPHA_STEP = 1

function Tesseract:load(...)
	PropView.load(self, ...)

	local resources = self:getResources()
	local root = self:getRoot()

	self.decorationUnpowered = DecorationSceneNode()
	self.decorationPowered = DecorationSceneNode()

	self.groupIndex = 1

	resources:queue(
		LayerTextureResource,
		"Resources/Game/Props/Tesseract/Texture_Unpowered.lua",
		function(texture)
			self.textureUnpowered = texture
			self.textureUnpowered:getResource():setWrap('repeat')
		end)
	resources:queue(
		LayerTextureResource,
		"Resources/Game/Props/Tesseract/Texture.lua",
		function(texture)
			self.texturePowered = texture
			self.texturePowered:getResource():setWrap('repeat')
		end)
	resources:queue(
		StaticMeshResource,
		"Resources/Game/Props/Tesseract/Model.lstatic",
		function(mesh)
			self.mesh = mesh

			self.decorationUnpowered:fromGroup(mesh:getResource(), Tesseract.GROUPS[self.groupIndex])
			self.decorationUnpowered:getMaterial():setIsTranslucent(true)
			self.decorationUnpowered:getMaterial():setTextures(self.textureUnpowered)

			self.decorationPowered:fromGroup(mesh:getResource(), Tesseract.GROUPS[self.groupIndex])
			self.decorationPowered:getMaterial():setIsTranslucent(true)
			self.decorationPowered:getMaterial():setTextures(self.texturePowered)
		end)
	resources:queue(
		ShaderResource,
		"Resources/Shaders/StaticModel_Volume",
		function(shader)
			self.decorationUnpowered:getMaterial():setShader(shader)
			self.decorationUnpowered:setParent(root)

			self.decorationUnpowered:onWillRender(function(renderer)
				local shader = renderer:getCurrentShader()
				if shader:hasUniform("scape_NumLayers") then
					shader:send("scape_NumLayers", self.textureUnpowered:getLayerCount())
				end
			end)

			self.decorationPowered:getMaterial():setShader(shader)
			self.decorationPowered:setParent(root)

			self.decorationPowered:onWillRender(function(renderer)
				local shader = renderer:getCurrentShader()
				if shader:hasUniform("scape_NumLayers") then
					shader:send("scape_NumLayers", self.textureUnpowered:getLayerCount())
				end
			end)
		end)
	resources:queueEvent(function()
		self.isPoweredOn = self:getIsPoweredOn()
		if self.isPoweredOn then
			self.groupIndex = Tesseract.GROUP_POWERED_TRANSITION
		else
			self.groupIndex = Tesseract.GROUP_UNPOWERED_TRANSITION
		end

		self.time = Tesseract.TRANSITION_STEP
		self.isTransitioning = false
	end)
end

function Tesseract:getIsPoweredOn()
	local state = self:getProp():getState()

	-- Marshal to boolean
	if state.isPoweredOn then
		return true
	else
		return false
	end
end


function Tesseract:tick()
	PropView.tick(self)

	local isPoweredOn = self:getIsPoweredOn()
	if isPoweredOn ~= self.isPoweredOn then
		if isPoweredOn then
			self.groupIndex = Tesseract.GROUP_POWERED_TRANSITION
		else
			self.groupIndex = Tesseract.GROUP_UNPOWERED_TRANSITION
		end

		self.isPoweredOn = isPoweredOn
		self.isTransitioning = true
		self.time = 0
	end
end

function Tesseract:update(delta)
	PropView.update(self, delta)

	if self.mesh then
		self.time = (self.time or 0) + delta
		if self.time > Tesseract.TRANSITION_STEP then	
			self.time = Tesseract.TRANSITION_STEP
			self.isTransitioning = false
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

		local positionA, positionB
		if model1Index == 1 then
			positionA = Vector.UNIT_Y * 4
			positionB = -Vector.UNIT_Y
		else
			positionA = -Vector.UNIT_Y
			positionB = Vector.UNIT_Y * 4
		end

		local delta = self.time / Tesseract.TRANSITION_STEP
		local scaleDelta = delta
		local alphaDelta = math.min(self.time, Tesseract.ALPHA_STEP) / Tesseract.ALPHA_STEP
		if model1Index == Tesseract.GROUP_POWERED_TRANSITION then
			alphaDelta = 1 - alphaDelta
			scaleDelta = 1 - scaleDelta
		end

		self.decorationUnpowered:fromLerp(
			self.mesh:getResource(),
			Tesseract.GROUPS[model1Index],
			Tesseract.GROUPS[model2Index],
			Tween.sineEaseOut(delta))
		self.decorationUnpowered:getMaterial():setColor(Color(1, 1, 1, 1 - alphaDelta))

		self.decorationPowered:fromLerp(
			self.mesh:getResource(),
			Tesseract.GROUPS[model1Index],
			Tesseract.GROUPS[model2Index],
			Tween.sineEaseOut(delta))
		self.decorationPowered:getMaterial():setColor(Color(1, 1, 1, alphaDelta))

		local position = positionA:lerp(positionB, Tween.sineEaseOut(delta))
		self.decorationPowered:getTransform():setLocalTranslation(position)
		self.decorationUnpowered:getTransform():setLocalTranslation(position)

		local scale = scaleDelta * Tesseract.MAX_SCALE * Vector.ONE
		self.decorationPowered:getTransform():setLocalScale(Vector.ONE + scale)
		self.decorationUnpowered:getTransform():setLocalScale(Vector.ONE + scale)
	end
end

function Tesseract:getIsStatic()
	return false
end

return Tesseract
