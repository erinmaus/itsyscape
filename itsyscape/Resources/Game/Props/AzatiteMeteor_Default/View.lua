--------------------------------------------------------------------------------
-- Resources/Game/Props/AzatiteMeteor_Default/View.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Color = require "ItsyScape.Graphics.Color"
local Material = require "ItsyScape.Graphics.Material"
local PointLightSceneNode = require "ItsyScape.Graphics.PointLightSceneNode"
local ShaderResource = require "ItsyScape.Graphics.ShaderResource"
local RockView = require "Resources.Game.Props.Common.RockView2"

local AzatiteMeteor = Class(RockView)
AzatiteMeteor.MIN_FLICKER_TIME = 10 / 60
AzatiteMeteor.MAX_FLICKER_TIME = 20 / 60
AzatiteMeteor.MIN_ATTENUATION = 12
AzatiteMeteor.MAX_ATTENUATION = 16
AzatiteMeteor.COLOR = Color(0, 0, 1)

function AzatiteMeteor:new(...)
	RockView.new(self, ...)

	self.flickerTime = 0
end

function AzatiteMeteor:load()
	RockView.load(self)

	local resources = self:getResources()
	local root = self:getRoot()

	self.light = PointLightSceneNode()
	self.light:setParent(root)
	self.light:setColor(self.COLOR)

	resources:queue(
		ShaderResource,
		"Resources/Shaders/SpecularTriplanar",
		function(shader)
			self.shader = shader
		end)

	resources:queueEvent(function()
		local activeNode = self:getActiveNode()
		activeNode:getMaterial():setIsReflectiveOrRefractive(true)
		activeNode:getMaterial():setReflectionPower(10)
		activeNode:getMaterial():setShader(self.shader)
		activeNode:getMaterial():setRoughness(0.5)
		activeNode:getMaterial():send(Material.UNIFORM_FLOAT, "scape_TriplanarScale", -0.75)

		local depletedNode = self:getDepletedNode()
		depletedNode:getMaterial():setIsReflectiveOrRefractive(true)
		depletedNode:getMaterial():setReflectionPower(10)
		depletedNode:getMaterial():setShader(self.shader)
		depletedNode:getMaterial():setRoughness(0.5)
		depletedNode:getMaterial():send(Material.UNIFORM_FLOAT, "scape_TriplanarScale", -0.75)
	end)
end

function AzatiteMeteor:flicker()
	if self.light then
		local state = self:getProp():getState()
		local isDepleted = state and state.resource and state.resource.depleted

		local flickerWidth = self.MAX_FLICKER_TIME - self.MIN_FLICKER_TIME
		self.flickerTime = love.math.random() * flickerWidth + self.MIN_FLICKER_TIME

		local attenuationWidth = self.MAX_ATTENUATION - self.MIN_ATTENUATION
		local attenuation = love.math.random() * attenuationWidth + self.MAX_ATTENUATION
		self.light:setAttenuation(isDepleted and 0 or attenuation)
	end
end

function AzatiteMeteor:getTextureFilename()
	return "Resources/Game/Props/AzatiteMeteor_Default/Texture.png"
end

function AzatiteMeteor:getDepletedTextureFilename()
	return "Resources/Game/Props/AzatiteMeteor_Default/Texture_Depleted.png"
end

function AzatiteMeteor:getModelFilename()
	return "Resources/Game/Props/AzatiteMeteor_Default/Model.lstatic"
end

function AzatiteMeteor:update(delta)
	RockView.update(self, delta)

	self.flickerTime = self.flickerTime - delta
	if self.flickerTime < 0 then
		self:flicker()
	end
end

return AzatiteMeteor
