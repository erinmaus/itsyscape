--------------------------------------------------------------------------------
-- Resources/Game/Props/Art_Rage_Case/View.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Vector = require "ItsyScape.Common.Math.Vector"
local DecorationSceneNode = require "ItsyScape.Graphics.DecorationSceneNode"
local Color = require "ItsyScape.Graphics.Color"
local PointLightSceneNode = require "ItsyScape.Graphics.PointLightSceneNode"
local PropView = require "ItsyScape.Graphics.PropView"
local StaticMeshResource = require "ItsyScape.Graphics.StaticMeshResource"
local ShaderResource = require "ItsyScape.Graphics.ShaderResource"
local TextureResource = require "ItsyScape.Graphics.TextureResource"
local ShaderResource = require "ItsyScape.Graphics.ShaderResource"
local VideoResource = require "ItsyScape.Graphics.VideoResource"

local Case = Class(PropView)

function Case:new(prop, gameView)
	PropView.new(self, prop, gameView)
end

function Case:load()
	PropView.load(self)

	local resources = self:getResources()
	local root = self:getRoot()

	resources:queue(
		StaticMeshResource,
		"Resources/Game/Props/Art_Rage_Case/Model.lstatic",
		function(mesh)
			self.mesh = mesh
		end)
	resources:queue(
		TextureResource,
		"Resources/Game/Props/Art_Rage_Case/Texture.png",
		function(texture)
			self.caseTexture = texture
		end)
	resources:queue(
		TextureResource,
		"Resources/Game/Props/Art_Rage_Case/Panel.png",
		function(texture)
			self.panelTexture = texture
		end)
	resources:queue(
		ShaderResource,
		"Resources/Shaders/Triplanar",
		function(shader)
			self.shader = shader
		end)
	resources:queueEvent(function()
		self.case = DecorationSceneNode()
		self.case:fromGroup(self.mesh:getResource(), "tower")
		self.case:getMaterial():setTextures(self.caseTexture)
		self.case:getMaterial():setShader(self.shader)
		self.case:getMaterial():setOutlineThreshold(0.1)
		self.case:setParent(root)

		self.panel = DecorationSceneNode()
		self.panel:fromGroup(self.mesh:getResource(), "tower.panel")
		self.panel:getMaterial():setTextures(self.panelTexture)
		self.panel:setParent(root)

		self.powerLight = PointLightSceneNode()
		self.powerLight:getTransform():setLocalTranslation(Vector(0.28, 0.7, 1.01))
		self.powerLight:getMaterial():setColor(Color(0, 1, 0, 1))
		self.powerLight:setAttenuation(1)

		self.diskLight = PointLightSceneNode()
		self.diskLight:getTransform():setLocalTranslation(Vector(0.35, 0.7, 1.01))
		self.diskLight:getMaterial():setColor(Color(1, 0.5, 0, 1))
		self.diskLight:setAttenuation(1)

		self.cdLight = PointLightSceneNode()
		self.cdLight:getTransform():setLocalTranslation(Vector(0.2, 1.56, 0.93))
		self.cdLight:getMaterial():setColor(Color(0, 1, 0, 1))
		self.cdLight:setAttenuation(1)

		self.isReady = true
	end)
end
return Case
