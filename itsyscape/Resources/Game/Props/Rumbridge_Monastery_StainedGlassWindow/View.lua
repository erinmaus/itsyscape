--------------------------------------------------------------------------------
-- Resources/Game/Props/Rumbridge_Monastery_StainedGlassWindow/View.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Quaternion = require "ItsyScape.Common.Math.Quaternion"
local Vector = require "ItsyScape.Common.Math.Vector"
local AmbientLightSceneNode = require "ItsyScape.Graphics.AmbientLightSceneNode"
local Color = require "ItsyScape.Graphics.Color"
local DecorationSceneNode = require "ItsyScape.Graphics.DecorationSceneNode"
local FogSceneNode = require "ItsyScape.Graphics.FogSceneNode"
local PointLightSceneNode = require "ItsyScape.Graphics.PointLightSceneNode"
local PropView = require "ItsyScape.Graphics.PropView"
local Renderer = require "ItsyScape.Graphics.Renderer"
local SceneNode = require "ItsyScape.Graphics.SceneNode"
local ShaderResource = require "ItsyScape.Graphics.ShaderResource"
local StaticMeshResource = require "ItsyScape.Graphics.StaticMeshResource"
local TextureResource = require "ItsyScape.Graphics.TextureResource"
local ThirdPersonCamera = require "ItsyScape.Graphics.ThirdPersonCamera"
local QuadSceneNode = require "ItsyScape.Graphics.QuadSceneNode"

local Window = Class(PropView)

Window.EYE_OFFSET    = Vector(0, 0, 0)
Window.CROWN_OFFSET  = Vector(0, 0.5, 0)
Window.TARGET_OFFSET = Vector(0, 2, 0)

Window.INNER_CROWN_SCALE = Vector(3)
Window.OUTER_CROWN_SCALE = Vector(4.5)

Window.FOG_FAR_COLOR = Color.fromHexString("5fbcd3")
Window.FOG_NEAR_COLOR  = Color.fromHexString("fff6d5")

Window.POINT_LIGHT_MULTIPLIER = math.pi / 4
Window.POINT_LIGHT_RADIUS     = 4

Window.WIDTH = 256
Window.HEIGHT = 256

function Window:load()
	PropView.load(self)

	local resources = self:getResources()
	local root = self:getRoot()

	self.otherScene = SceneNode()
	self.innerCrown = DecorationSceneNode()
	self.outerCrown = DecorationSceneNode()

	local renderer = Renderer()
	self.renderer = renderer
	self.camera = ThirdPersonCamera()

	resources:queue(
		TextureResource,
		"Resources/Game/Props/Rumbridge_Monastery_StainedGlassWindow/Crown.png",
		function(texture)
			self.crownTexture = texture
		end)
	resources:queue(
		StaticMeshResource,
		"Resources/Game/Props/Rumbridge_Monastery_StainedGlassWindow/Crown.lstatic",
		function(mesh)
			self.innerCrown:fromGroup(mesh:getResource(), "Crown")
			self.innerCrown:getMaterial():setTextures(self.crownTexture)
			self.innerCrown:getTransform():setLocalScale(Window.INNER_CROWN_SCALE)
			self.innerCrown:getTransform():setLocalTranslation(Window.CROWN_OFFSET)
			self.innerCrown:setParent(self.otherScene)

			self.outerCrown:fromGroup(mesh:getResource(), "Crown")
			self.outerCrown:getMaterial():setTextures(self.crownTexture)
			self.outerCrown:getTransform():setLocalScale(Window.OUTER_CROWN_SCALE)
			self.outerCrown:getTransform():setLocalTranslation(Window.CROWN_OFFSET)
			self.outerCrown:setParent(self.otherScene)
		end)
	resources:queueEvent(function()
		self.fogNear = FogSceneNode()
		self.fogNear:setColor(Window.FOG_NEAR_COLOR)
		self.fogNear:setNearDistance(12)
		self.fogNear:setFarDistance(18)
		self.fogNear:setParent(self.otherScene)

		self.fogFar = FogSceneNode()
		self.fogFar:setColor(Window.FOG_FAR_COLOR)
		self.fogFar:setNearDistance(18)
		self.fogFar:setFarDistance(26)
		self.fogFar:setParent(self.otherScene)

		self.pointLight = PointLightSceneNode()
		self.pointLight:setAttenuation(8)
		self.pointLight:setParent(self.otherScene)

		self.ambientLight = AmbientLightSceneNode()
		self.ambientLight:setColor(Window.FOG_FAR_COLOR)
		self.ambientLight:setAmbience(0.4)
		self.ambientLight:setParent(self.otherScene)
	end)

	self.eye = DecorationSceneNode()

	resources:queue(
		TextureResource,
		"Resources/Game/Props/Rumbridge_Monastery_StainedGlassWindow/Eye.png",
		function(texture)
			self.eyeTexture = texture
		end)
	resources:queue(
		StaticMeshResource,
		"Resources/Game/Props/Rumbridge_Monastery_StainedGlassWindow/Eye.lstatic",
		function(mesh)
			self.eye:fromGroup(mesh:getResource(), "Eye")
			self.eye:getMaterial():setTextures(self.eyeTexture)
			self.eye:getTransform():setLocalTranslation(Window.EYE_OFFSET)
			self.eye:setParent(self.otherScene)
		end)

	resources:queue(
		TextureResource,
		"Resources/Game/Props/Rumbridge_Monastery_StainedGlassWindow/Window_Mask.png",
		function(texture)
			self.windowMaskTexture = texture
		end)

	resources:queue(
		TextureResource,
		"Resources/Game/Props/Rumbridge_Monastery_StainedGlassWindow/Window_Shadow.png",
		function(texture)
			self.windowShadowTexture = texture
		end)

	resources:queueEvent(function()
		local function _onWillRender(renderer)
			local texture = self.renderer:getOutputBuffer():getColor()
			if not texture then
				return
			end

			local shader = renderer:getCurrentShader()
			if shader:hasUniform("scape_PortalTexture") then
				texture:setFilter('linear', 'linear')
				shader:send("scape_PortalTexture", texture)
			end
		end

		self.windowQuad = QuadSceneNode()
		self.windowQuad:getMaterial():setTextures(self.windowMaskTexture)
		self.windowQuad:getTransform():setLocalTranslation(Vector(0, 8, -4))
		self.windowQuad:getTransform():setLocalScale(Vector(8, 8, 1))
		self.windowQuad:setParent(root)
		self.windowQuad:onWillRender(_onWillRender)

		self.shadowQuad = QuadSceneNode()
		self.shadowQuad:getMaterial():setTextures(self.windowShadowTexture)
		self.shadowQuad:getMaterial():setIsTranslucent(true)
		self.shadowQuad:getMaterial():setIsZWriteDisabled(true)
		self.shadowQuad:getMaterial():setColor(Color(1, 1, 1, 0.5))
		self.shadowQuad:getTransform():setLocalTranslation(Vector(0, 1 / 8, 4))
		self.shadowQuad:getTransform():setLocalScale(Vector(8, 1, 8))
		self.shadowQuad:getTransform():setLocalRotation(Quaternion.X_90)
		self.shadowQuad:setParent(root)
		self.shadowQuad:onWillRender(_onWillRender)

		resources:queue(
			ShaderResource,
			"Resources/Shaders/StaticModel_PortalScry",
			function(shader)
				self.windowQuad:getMaterial():setShader(shader)
			end)

		resources:queue(
			ShaderResource,
			"Resources/Shaders/StaticModel_PortalScry_AlphaFromMask",
			function(shader)
				self.shadowQuad:getMaterial():setShader(shader)
			end)
	end)
end

function Window:updateCrown(delta)
	local innerCrownRotation = Quaternion.fromAxisAngle(Vector(1, 0.5, 1), math.pi * delta)
	local outerCrownRotation = Quaternion.fromAxisAngle(Vector(-1, 0.5, -1), math.pi * delta)

	local innerCrownTransform = self.innerCrown:getTransform()
	local outerCrownTransform = self.outerCrown:getTransform()

	innerCrownTransform:setLocalRotation(innerCrownTransform:getLocalRotation() * innerCrownRotation)
	outerCrownTransform:setLocalRotation(outerCrownTransform:getLocalRotation() * outerCrownRotation)
end

function Window:updateLighting(delta)
	self.pointLightTime = (self.pointLightTime or 0) + delta

	local x = math.cos(self.pointLightTime * Window.POINT_LIGHT_MULTIPLIER) * Window.POINT_LIGHT_RADIUS
	local z = math.sin(self.pointLightTime * Window.POINT_LIGHT_MULTIPLIER) * Window.POINT_LIGHT_RADIUS

	self.pointLight:getTransform():setLocalTranslation(Vector(x, 1, z))
end

function Window:updateScene()
	local gameView = self:getGameView()

	local parentRenderer = gameView:getRenderer()
	local selfRenderer = self.renderer
	local parentCamera = parentRenderer:getCamera()
	local selfCamera = self.camera

	selfCamera:setFieldOfView(parentCamera:getFieldOfView())
	selfCamera:setVerticalRotation(parentCamera:getVerticalRotation())
	selfCamera:setHorizontalRotation(parentCamera:getHorizontalRotation())
	selfCamera:setNear(parentCamera:getNear())
	selfCamera:setFar(parentCamera:getFar())
	selfCamera:setDistance(20)
	selfCamera:setWidth(Window.WIDTH)
	selfCamera:setHeight(Window.HEIGHT)

	if self.otherScene then
		love.graphics.push('all')
		love.graphics.setScissor()
		selfRenderer:setCamera(selfCamera)
		selfRenderer:draw(self.otherScene, 0, Window.WIDTH, Window.HEIGHT)
		love.graphics.pop()
	end
end

function Window:update(delta)
	PropView.update(self, delta)

	if self.innerCrown and self.outerCrown then
		self:updateCrown(delta)
	end

	if self.pointLight then
		self:updateLighting(delta)
	end

	self:updateScene()
end

function Window:getIsStatic()
	return false
end

return Window
