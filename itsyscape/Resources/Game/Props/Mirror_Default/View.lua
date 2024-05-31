--------------------------------------------------------------------------------
-- Resources/Game/Props/Mirror_Default/View.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Vector = require "ItsyScape.Common.Math.Vector"
local Quaternion = require "ItsyScape.Common.Math.Quaternion"
local DecorationSceneNode = require "ItsyScape.Graphics.DecorationSceneNode"
local Color = require "ItsyScape.Graphics.Color"
local PropView = require "ItsyScape.Graphics.PropView"
local Renderer = require "ItsyScape.Graphics.Renderer"
local StaticMeshResource = require "ItsyScape.Graphics.StaticMeshResource"
local ShaderResource = require "ItsyScape.Graphics.ShaderResource"
local TextureResource = require "ItsyScape.Graphics.TextureResource"
local ThirdPersonCamera = require "ItsyScape.Graphics.ThirdPersonCamera"
local FogSceneNode = require "ItsyScape.Graphics.FogSceneNode"

local MirrorView = Class(PropView)
MirrorView.WIDTH = 256
MirrorView.HEIGHT = 512

function MirrorView:new(prop, gameView)
	PropView.new(self, prop, gameView)
end

function MirrorView:load()
	PropView.load(self)

	local resources = self:getResources()
	local root = self:getRoot()

	local renderer = Renderer(true)
	self.renderer = renderer
	self.camera = ThirdPersonCamera()

	resources:queue(
		StaticMeshResource,
		"Resources/Game/Props/Mirror_Default/Mirror.lstatic",
		function(mesh)
			self.mesh = mesh
		end)
	resources:queue(
		TextureResource,
		"Resources/Game/Props/Mirror_Default/Mirror.png",
		function(texture)
			self.mirrorTexture = texture
		end)
	resources:queue(
		TextureResource,
		"Resources/Game/Props/Mirror_Default/Reflection.png",
		function(texture)
			self.reflectionTexture = texture
		end)
	resources:queueEvent(function()
		self.mirrorNode = DecorationSceneNode()
		self.mirrorNode:fromGroup(self.mesh:getResource(), "Mirror")
		self.mirrorNode:getMaterial():setTextures(self.mirrorTexture)
		self.mirrorNode:setParent(root)

		self.reflectionNode = DecorationSceneNode()
		self.reflectionNode:fromGroup(self.mesh:getResource(), "Reflection")
		self.reflectionNode:getMaterial():setTextures(self.reflectionTexture)
		self.reflectionNode:setParent(root)

		self.reflectionNode:onWillRender(function(renderer)
			local texture = self.renderer:getOutputBuffer():getColor()
			if not texture then
				return
			end
		
			local shader = renderer:getCurrentShader()
			if shader:hasUniform("scape_ReflectionTexture") then
				texture:setFilter('linear', 'linear')
				shader:send("scape_ReflectionTexture", texture)
			end

			if shader:hasUniform("scape_TextureSize") then
				shader:send("scape_TextureSize", { love.graphics.getWidth(), love.graphics.getHeight() })
			end
		end)

		resources:queue(
			ShaderResource,
			"Resources/Shaders/StaticModel_Mirror",
			function(shader)
				self.reflectionNode:getMaterial():setShader(shader)
			end)
	end)
end

function MirrorView:update(delta)
	PropView.update(self, delta)

	local gameView = self:getGameView()

	local parentRenderer = gameView:getRenderer()
	local selfRenderer = self.renderer
	local parentCamera = parentRenderer:getCamera()
	local selfCamera = self.camera

	local rootTransform = self:getRoot():getTransform()
	local rootPosition = Vector(rootTransform:getGlobalTransform():transformPoint(0, 1.5, 0))
	local rootRotation = rootTransform:getLocalRotation()

	selfCamera:mirror(parentCamera, rootPosition, rootRotation, Vector.UNIT_Z)
	selfCamera:setWidth(MirrorView.WIDTH)
	selfCamera:setHeight(MirrorView.HEIGHT)
	selfCamera:setDistance(5)

	do
		if self.mirrorNode then self.mirrorNode:setParent(nil) end
		if self.reflectionNode then self.reflectionNode:setParent(nil) end

		local scene = gameView:getScene()

		love.graphics.push('all')
		love.graphics.setScissor()
		love.graphics.setFrontFaceWinding("cw")
		selfRenderer:setCamera(selfCamera)
		selfRenderer:draw(gameView:getScene(), 0, width, MirrorView.HEIGHT)
		love.graphics.pop()
		
		if self.mirrorNode then self.mirrorNode:setParent(self:getRoot()) end
		if self.reflectionNode then self.reflectionNode:setParent(self:getRoot()) end
	end
end

return MirrorView
