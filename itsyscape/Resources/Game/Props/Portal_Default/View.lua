--------------------------------------------------------------------------------
-- Resources/Game/Props/Portal_Default/View.lua
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

local PortalView = Class(PropView)
PortalView.WIDTH = 256
PortalView.HEIGHT = 128

function PortalView:new(prop, gameView)
	PropView.new(self, prop, gameView)
end

function PortalView:load()
	PropView.load(self)

	local resources = self:getResources()
	local root = self:getRoot()

	local renderer = Renderer(true)
	self.renderer = renderer
	self.camera = ThirdPersonCamera()

	resources:queue(
		StaticMeshResource,
		"Resources/Game/Props/Portal_Default/Model.lstatic",
		function(mesh)
			self.mesh = mesh
		end)
	resources:queue(
		TextureResource,
		"Resources/Game/Props/Portal_Default/Texture.png",
		function(texture)
			self.texture = texture
		end)
	resources:queueEvent(function()
		self.smoke = DecorationSceneNode()
		self.smoke:fromGroup(self.mesh:getResource(), "PortalSmoke")
		self.smoke:getMaterial():setTextures(self.texture)
		self.smoke:setParent(root)

		self.portal = DecorationSceneNode()
		self.portal:fromGroup(self.mesh:getResource(), "PortalScry")
		self.portal:getMaterial():setTextures(self.texture)
		self.portal:setParent(root)

		self.portal:onWillRender(function(renderer)
			local texture = self.renderer:getOutputBuffer():getColor()
			if not texture then
				return
			end

			local shader = renderer:getCurrentShader()
			if shader:hasUniform("scape_PortalTexture") then
				texture:setFilter('linear', 'linear')
				shader:send("scape_PortalTexture", texture)
			end
		end)

		resources:queue(
			ShaderResource,
			"Resources/Shaders/StaticModel_PortalSmoke",
			function(shader)
				self.smoke:getMaterial():setShader(shader)
			end)

		resources:queue(
			ShaderResource,
			"Resources/Shaders/StaticModel_PortalScry",
			function(shader)
				self.portal:getMaterial():setShader(shader)
			end)
	end)
end

function PortalView:tick()
	PropView.tick(self)

	if self.smoke then
		local state = self:getProp():getState()
		self.smoke:getMaterial():setColor(Color(unpack(state.color or { 0.2, 0.6, 0.8, 1 })))
	end
end

function PortalView:update(delta)
	PropView.update(self, delta)

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
	selfCamera:setDistance(parentCamera:getDistance())

	local state = self:getProp():getState()
	selfCamera:setPosition(Vector(unpack(state.position or { parentCamera:getPosition():get() })))

	do
		love.graphics.push('all')
		love.graphics.setScissor()
		selfRenderer:setCamera(selfCamera)
		selfRenderer:draw(gameView:getScene(), 0, PortalView.WIDTH, PortalView.HEIGHT)
		love.graphics.pop()
	end
end

return PortalView
