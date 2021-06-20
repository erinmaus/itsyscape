--------------------------------------------------------------------------------
-- Resources/Game/Props/TV_HexLabs/View.lua
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
local DefaultCameraController = require "ItsyScape.Graphics.DefaultCameraController"
local PropView = require "ItsyScape.Graphics.PropView"
local Renderer = require "ItsyScape.Graphics.Renderer"
local StaticMeshResource = require "ItsyScape.Graphics.StaticMeshResource"
local ShaderResource = require "ItsyScape.Graphics.ShaderResource"
local TextureResource = require "ItsyScape.Graphics.TextureResource"
local ThirdPersonCamera = require "ItsyScape.Graphics.ThirdPersonCamera"
local VideoResource = require "ItsyScape.Graphics.VideoResource"

local TVView = Class(PropView)
TVView.WIDTH = 256
TVView.HEIGHT = 128

function TVView:new(prop, gameView)
	PropView.new(self, prop, gameView)
end

function TVView:load()
	PropView.load(self)

	local resources = self:getResources()
	local root = self:getRoot()

	local renderer = Renderer(true)
	self.renderer = renderer
	self.camera = ThirdPersonCamera()

	resources:queue(
		StaticMeshResource,
		"Resources/Game/Props/TV_HexLabs/Model.lstatic",
		function(mesh)
			self.mesh = mesh
		end)
	resources:queue(
		TextureResource,
		"Resources/Game/Props/TV_HexLabs/Texture.png",
		function(texture)
			self.texture = texture
		end)
	resources:queue(
		VideoResource,
		"Resources/Game/Videos/Tutorial/Static.ogv",
		function(video)
			self.video = video:getResource()
			self.video:play()
			self.video.onVideoFinished:register(function()
				self.video:rewind()
			end)
		end)
	resources:queueEvent(function()
		self.tv = DecorationSceneNode()
		self.tv:fromGroup(self.mesh:getResource(), "TV")
		self.tv:getMaterial():setTextures(self.texture)
		self.tv:setParent(root)

		self.screen = DecorationSceneNode()
		self.screen:fromGroup(self.mesh:getResource(), "TVScreen")
		self.screen:getMaterial():setTextures(self.texture)
		self.screen:setParent(root)

		self.screen:onWillRender(function(_, delta)
			local texture
			do
				local state = self:getProp():getState()
				if state.isOn then
					texture = self.renderer:getOutputBuffer():getColor()
					texture:setFilter('linear', 'linear') 
				else
					texture = self.video:getSnapshot()
				end
			end

			if not self.screenTexture or self.screenTexture:getResource() ~= texture then
				self.screenTexture = TextureResource(texture)
			end

			self.screen:getMaterial():setTextures(self.screenTexture)
		end)
	end)
end

function TVView:tick()
	PropView.tick(self)

	if self.tv then
		local state = self:getProp():getState()
		self.screen:getMaterial():setColor(Color(unpack(state.color or { 0.2, 0.6, 0.8, 1 })))
	end
end

function TVView:renderTV(delta)
	local gameView = self:getGameView()

	local parentRenderer = gameView:getRenderer()
	local selfRenderer = self.renderer
	local parentCamera = parentRenderer:getCamera()
	local selfCamera = self.camera

	selfCamera:setFieldOfView(parentCamera:getFieldOfView())
	selfCamera:setVerticalRotation(DefaultCameraController.CAMERA_VERTICAL_ROTATION)
	selfCamera:setHorizontalRotation(DefaultCameraController.CAMERA_HORIZONTAL_ROTATION)
	selfCamera:setNear(parentCamera:getNear())
	selfCamera:setFar(parentCamera:getFar())
	selfCamera:setDistance(parentCamera:getDistance())
	selfCamera:setWidth(TVView.WIDTH)
	selfCamera:setHeight(TVView.HEIGHT)

	local state = self:getProp():getState()
	selfCamera:setPosition(Vector(unpack(state.absolutePosition)))

	do
		local mapSceneNode = gameView:getMapSceneNode(state.layer)
		if mapSceneNode then
			local mapSceneNodeParent = mapSceneNode:getParent()
			mapSceneNode:setParent(nil)

			love.graphics.push('all')
			love.graphics.setScissor()
			selfRenderer:setCamera(selfCamera)
			selfRenderer:draw(mapSceneNode, 0, TVView.WIDTH, TVView.HEIGHT)
			love.graphics.pop()

			mapSceneNode:setParent(mapSceneNodeParent)
		end
	end
end

function TVView:update(delta)
	PropView.update(self, delta)
	if self.video then
		self.video:update()
	end

	local state = self:getProp():getState()
	if state.isOn then
		self:renderTV(delta)
	else
		if self.video then
			self.video:makeSnapshot()
		end
	end
end

return TVView
