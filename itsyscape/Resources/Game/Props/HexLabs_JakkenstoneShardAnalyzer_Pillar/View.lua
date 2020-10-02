--------------------------------------------------------------------------------
-- Resources/Game/Props/HexLabs_JakkenstoneShardAnalyzer_Common/View.lua
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
local QuadSceneNode = require "ItsyScape.Graphics.QuadSceneNode"
local PropView = require "ItsyScape.Graphics.PropView"
local ShaderResource = require "ItsyScape.Graphics.ShaderResource"
local StaticMeshResource = require "ItsyScape.Graphics.StaticMeshResource"
local TextureResource = require "ItsyScape.Graphics.TextureResource"

local Pillar = Class(PropView)
Pillar.ENERGY_WAVE_COLOR    = Color(135 / 255, 222 / 255, 208 / 255, 1)
Pillar.ENERGY_WAVE_POSITION = Vector(-5, 11.5, 1)
Pillar.ENERGY_WAVE_SCALE    = Vector(5, 0.5, 1)

Pillar.ENERGY_WAVE_SHADER = ShaderResource()
do
	Pillar.ENERGY_WAVE_SHADER:loadFromFile("Resources/Shaders/HexLabs_EnergyWave")
end

function Pillar:getModelNode()
	return self.decoration
end

function Pillar:load()
	PropView.load(self)

	local resources = self:getResources()
	local root = self:getRoot()

	self.decoration = DecorationSceneNode()
	self.quad = QuadSceneNode()
	self.quad:setParent(root)
	self.quad:getMaterial():setShader(Pillar.ENERGY_WAVE_SHADER)
	self.quad:getMaterial():setIsTranslucent(true)
	self.quad:getMaterial():setIsFullLit(true)
	self.quad:getMaterial():setIsZWriteDisabled(true)
	self.quad:getMaterial():setColor(Pillar.ENERGY_WAVE_COLOR)
	self.quad:getTransform():setLocalTranslation(Pillar.ENERGY_WAVE_POSITION)
	self.quad:getTransform():setLocalScale(Pillar.ENERGY_WAVE_SCALE)

	resources:queue(
		TextureResource,
		"Resources/Game/Props/HexLabs_JakkenstoneShardAnalyzer_Common/Texture.png",
		function(texture)
			self.texture = texture
		end)
	resources:queue(
		StaticMeshResource,
		"Resources/Game/Props/HexLabs_JakkenstoneShardAnalyzer_Pillar/Model.lstatic",
		function(mesh)
			self.decoration:fromGroup(mesh:getResource(), "Pillar")
			self.decoration:getMaterial():setTextures(self.texture)
			self.decoration:setParent(root)
		end)
end

return Pillar
