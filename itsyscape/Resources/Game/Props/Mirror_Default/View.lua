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
local DecorationSceneNode = require "ItsyScape.Graphics.DecorationSceneNode"
local Color = require "ItsyScape.Graphics.Color"
local PropView = require "ItsyScape.Graphics.PropView"
local Renderer = require "ItsyScape.Graphics.Renderer"
local StaticMeshResource = require "ItsyScape.Graphics.StaticMeshResource"
local ShaderResource = require "ItsyScape.Graphics.ShaderResource"
local TextureResource = require "ItsyScape.Graphics.TextureResource"
local ThirdPersonCamera = require "ItsyScape.Graphics.ThirdPersonCamera"

local MirrorView = Class(PropView)
MirrorView.WIDTH = 128
MirrorView.HEIGHT = 256

MirrorView.Camera = Class(ThirdPersonCamera)
function MirrorView.Camera:new()
	ThirdPersonCamera.new(self)

	self.forward = -Vector.UNIT_Z
end

function MirrorView.Camera:getForward()
	return self.forward
end

function MirrorView.Camera:setForward(value)
	self.forward = value
end

function MirrorView:new(prop, gameView)
	PropView.new(self, prop, gameView)
end

function MirrorView:load()
	PropView.load(self)

	local resources = self:getResources()
	local root = self:getRoot()

	local renderer = Renderer(true)
	self.renderer = renderer
	self.camera = MirrorView.Camera()

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
			local shader = renderer:getCurrentShader()
			if shader:hasUniform("scape_ReflectionTexture") then
				texture:setFilter('linear', 'linear')
				shader:send("scape_ReflectionTexture", texture)
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
	local rootPosition = Vector(rootTransform:getGlobalTransform():transformPoint(0, 0, 0))
	local rootRotation = rootTransform:getLocalRotation()
	local forwardVector = rootRotation:transformVector(Vector.UNIT_Z)
	selfCamera:setForward(forwardVector)
	selfCamera:setPosition(rootPosition - forwardVector + Vector.UNIT_Y)

	selfCamera:setFieldOfView(parentCamera:getFieldOfView())
	selfCamera:setNear(parentCamera:getNear())
	selfCamera:setFar(parentCamera:getFar())
	selfCamera:setDistance(0.1)

	do
		if self.mirrorNode then self.mirrorNode:setParent(nil) end
		if self.reflectionNode then self.reflectionNode:setParent(nil) end

		love.graphics.push('all')
		love.graphics.setScissor()
		selfRenderer:setCamera(selfCamera)
		selfRenderer:draw(gameView:getScene(), 0, MirrorView.WIDTH, MirrorView.HEIGHT)
		love.graphics.pop()
		
		if self.mirrorNode then self.mirrorNode:setParent(self:getRoot()) end
		if self.reflectionNode then self.reflectionNode:setParent(self:getRoot()) end
	end
end

return MirrorView
