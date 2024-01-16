--------------------------------------------------------------------------------
-- Resources/Game/Props/BehemothSkin/View.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Vector = require "ItsyScape.Common.Math.Vector"
local LayerTextureResource = require "ItsyScape.Graphics.LayerTextureResource"
local PropView = require "ItsyScape.Graphics.PropView"
local ShaderResource = require "ItsyScape.Graphics.ShaderResource"
local TextureResource = require "ItsyScape.Graphics.TextureResource"
local NoiseBuilder = require "ItsyScape.Game.Skills.Antilogika.NoiseBuilder"

local BehemothSkin = Class(PropView)
BehemothSkin.SHADER = ShaderResource()
do
	BehemothSkin.SHADER:loadFromFile("Resources/Shaders/BehemothModel")
end

BehemothSkin.BLEND_TEXTURE_SIZE = 32

function BehemothSkin:load()
	PropView.load(self)

	local resources = self:getResources()

	resources:queue(
		LayerTextureResource,
		"Resources/Game/Skins/Behemoth/BehemothSkinStoneTexture.lua",
		function(texture)
			self.diffuseStoneTexture = texture
			self.diffuseStoneTexture:getResource():setWrap("repeat")
		end)

	resources:queue(
		LayerTextureResource,
		"Resources/Game/Skins/Behemoth/BehemothSkinGrassTexture.lua",
		function(texture)
			self.diffuseGrassTexture = texture
			self.diffuseGrassTexture:getResource():setWrap("repeat")
		end)

	resources:queue(
		LayerTextureResource,
		"Resources/Game/Skins/Behemoth/BehemothSkinDirtTexture.lua",
		function(texture)
			self.diffuseDirtTexture = texture
			self.diffuseDirtTexture:getResource():setWrap("repeat")
		end)

	resources:queueEvent(
		function()
			self.areTexturesLoaded = true
		end)
end

function BehemothSkin:getActorView()
	local state = self:getProp():getState()
	local actorID = state.actorID
	if not actorID then
		return nil
	end

	local actor = self:getGameView():getActorByID(actorID)
	if not actor then
		return nil
	end

	local actorView = self:getGameView():getActor(actor)
	if not actorView then
		return nil
	end

	return actorView
end

function BehemothSkin:getBlendTexture(delta)
	local behemoth = self:getActorView()
	if not behemoth then
		return
	end

	local transform = behemoth:getSceneNode():getTransform():getGlobalDeltaTransform(delta)
	local position = Vector(transform:transformPoint(0, 0, 0))

	if self.internalPosition ~= position then
		self.internalPosition = position

		local noise = NoiseBuilder.TERRAIN()
		noise = noise { offset = self.internalPosition / Vector(10) }

		local noiseImageData = noise:sampleTestImage(BehemothSkin.BLEND_TEXTURE_SIZE, BehemothSkin.BLEND_TEXTURE_SIZE)
		local noiseImage = love.graphics.newImage(noiseImageData)

		self.internalBlendTexture = TextureResource(noiseImage)
	end

	return self.internalBlendTexture
end

function BehemothSkin:apply(texture, skins)
	for _, skin in ipairs(skins or {}) do
		if skin.sceneNode then
			skin.sceneNode:getMaterial():setShader(BehemothSkin.SHADER)
			skin.sceneNode:getMaterial():setTextures(texture)

			skin.sceneNode:onWillRender(function(renderer, delta)
				local blend = self:getBlendTexture(delta)

				local shader = renderer:getCurrentShader()
				if shader:hasUniform("scape_BlendTexture") and
				   blend and blend:getIsReady()
				then
					blend:getResource():setFilter('linear', 'linear')
					shader:send("scape_BlendTexture", blend:getResource())
				end

				if shader:hasUniform("scape_NumLayers") and
					texture and texture:getIsReady()
				then
					shader:send("scape_NumLayers", texture:getLayerCount())
				end
			end)

			return true
		end
	end

	return false
end

function BehemothSkin:tick()
	PropView.tick(self)

	if not self.areTexturesLoaded then
		return
	end

	if self.appliedShader then
		return
	end

	local behemoth = self:getActorView()
	if not behemoth then
		return
	end

	self:apply(self.diffuseStoneTexture, behemoth:getSkins("stone"))
	self:apply(self.diffuseGrassTexture, behemoth:getSkins("grass"))
	self:apply(self.diffuseDirtTexture, behemoth:getSkins("dirt"))

	self.appliedShader = true
end

function BehemothSkin:update(delta)
	PropView.update(self, delta)
end

return BehemothSkin
