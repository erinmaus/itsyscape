--------------------------------------------------------------------------------
-- Resources/Game/Props/Art_Rage_Monitor/View.lua
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

local Monitor = Class(PropView)
Monitor.WIDTH = 1024
Monitor.HEIGHT = 1024

function Monitor:new(prop, gameView)
	PropView.new(self, prop, gameView)
end

function Monitor:load()
	PropView.load(self)

	local resources = self:getResources()
	local root = self:getRoot()

	resources:queue(
		StaticMeshResource,
		"Resources/Game/Props/Art_Rage_Monitor/Model.lstatic",
		function(mesh)
			self.mesh = mesh
		end)
	resources:queue(
		TextureResource,
		"Resources/Game/Props/Art_Rage_Monitor/Texture.png",
		function(texture)
			self.monitorTexture = texture
		end)
	resources:queue(
		TextureResource,
		"Resources/Game/Props/Art_Rage_Monitor/Panel.png",
		function(texture)
			self.panelTexture = texture
		end)
	resources:queue(
		TextureResource,
		"Resources/Game/Props/Art_Rage_Monitor/Screen.png",
		function(texture)
			self.screenTexture = texture
		end)
	resources:queue(
		ShaderResource,
		"Resources/Shaders/Triplanar",
		function(shader)
			self.shader = shader
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
		self.monitor = DecorationSceneNode()
		self.monitor:fromGroup(self.mesh:getResource(), "monitor")
		self.monitor:getMaterial():setTextures(self.monitorTexture)
		self.monitor:getMaterial():setShader(self.shader)
		self.monitor:getMaterial():setOutlineThreshold(0.1)
		self.monitor:setParent(root)

		self.panel = DecorationSceneNode()
		self.panel:fromGroup(self.mesh:getResource(), "monitor.panel")
		self.panel:getMaterial():setTextures(self.panelTexture)
		self.panel:setParent(root)

		self.screen = DecorationSceneNode()
		self.screen:fromGroup(self.mesh:getResource(), "monitor.screen")
		self.screen:setParent(root)

		self.canvas = love.graphics.newCanvas(self.screenTexture:getWidth(), self.screenTexture:getHeight())
		self.canvas:setFilter("linear", "linear")
		self.canvasTexture = TextureResource(self.canvas)
		self.screen:getMaterial():setTextures(self.canvasTexture)

		self.light = PointLightSceneNode()
		self.light:getTransform():setLocalTranslation(Vector(1, 0.1, 1.051))
		self.light:getMaterial():setColor(Color(0, 1, 0, 1))
		self.light:setAttenuation(1)

		self.isReady = true
	end)
end

function Monitor:renderMonitor()
	if not self.isReady then
		return
	end

	local state = self:getProp():getState()
	local video = self.video:makeSnapshot()


	love.graphics.setCanvas(self.canvas)
	if state.isOn then
		love.graphics.draw(
			self.screenTexture:getResource(),
			self.canvas:getWidth() / 2, self.canvas:getHeight() / 2,
			math.pi / 2,
			self.canvas:getWidth() / self.screenTexture:getWidth(),
			self.canvas:getHeight() / self.screenTexture:getHeight(),
			self.canvas:getWidth() / 2,
			self.canvas:getHeight() / 2)
	else
		love.graphics.draw(
			video,
			0, 0,
			0,
			self.canvas:getWidth() / video:getWidth(),
			self.canvas:getHeight() / video:getHeight())
	end
	love.graphics.setCanvas()
end

function Monitor:update(delta)
	PropView.update(self, delta)
	if self.video then
		self.video:update()
	end

	self:renderMonitor()
end

return Monitor
