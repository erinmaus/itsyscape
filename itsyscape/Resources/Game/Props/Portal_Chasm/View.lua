--------------------------------------------------------------------------------
-- Resources/Game/Props/Portal_Chasm/View.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Vector = require "ItsyScape.Common.Math.Vector"
local ParticleSceneNode = require "ItsyScape.Graphics.ParticleSceneNode"
local Color = require "ItsyScape.Graphics.Color"
local PropView = require "ItsyScape.Graphics.PropView"
local Renderer = require "ItsyScape.Graphics.Renderer"
local StaticMeshResource = require "ItsyScape.Graphics.StaticMeshResource"
local ShaderResource = require "ItsyScape.Graphics.ShaderResource"
local TextureResource = require "ItsyScape.Graphics.TextureResource"
local ThirdPersonCamera = require "ItsyScape.Graphics.ThirdPersonCamera"

local PortalView = Class(PropView)

PortalView.PARTICLE_SYSTEM_PORTAL = {
	numParticles = 50,
	texture = "Resources/Game/Props/Portal_Chasm/Blank.png",

	emitters = {
		{
			type = "RadialEmitter",
			radius = { 1, 5 },
			speed = { 0, 0 },
			acceleration = { 0, 0 }
		},
		{
			type = "DirectionalEmitter",
			direction = { 0, 1, 0 },
			speed = { 10, 15 },
		},
		{
			type = "RandomColorEmitter",
			colors = {
				{ 1.0, 1.0, 1.0, 0.0 },
			}
		},
		{
			type = "RandomLifetimeEmitter",
			age = { 1, 1.5 }
		},
		{
			type = "RandomScaleEmitter",
			scale = { 1, 1 }
		},
		{
			type = "RandomRotationEmitter",
			rotation = { 0, 360 }
		}
	},

	paths = {
		{
			type = "FadeInOutPath",
			fadeInPercent = { 0.2 },
			fadeOutPercent = { 0.8 },
			tween = { 'sineEaseOut' }
		},
		{
			type = "TextureIndexPath",
			textures = { 1, 4 }
		}
	},

	emissionStrategy = {
		type = "RandomDelayEmissionStrategy",
		count = { 5, 10 },
		delay = { 0.125 },
		duration = { math.huge }
	}
}

PortalView.PARTICLE_SYSTEM_ENERGY = {
	numParticles = 100,
	texture = "Resources/Game/Props/Portal_Chasm/NorthernLights.png",
	columns = 4,

	emitters = {
		{
			type = "RadialEmitter",
			radius = { 4, 5 },
			speed = { 0, 0 },
			acceleration = { 0, 0 }
		},
		{
			type = "DirectionalEmitter",
			direction = { 0, 1, 0 },
			speed = { 10, 15 },
		},
		{
			type = "RandomColorEmitter",
			colors = {
				{ 1.0, 0.9, 0.5, 0.0 },
				{ 0.2, 0.8, 0.4, 0.0 },
				{ 0.2, 0.8, 0.4, 0.0 },
				{ 0.2, 0.8, 0.4, 0.0 },
			}
		},
		{
			type = "RandomLifetimeEmitter",
			age = { 1, 1.5 }
		},
		{
			type = "RandomScaleEmitter",
			scale = { 0.6, 0.8 }
		},
		{
			type = "RandomRotationEmitter",
			rotation = { 0, 360 }
		}
	},

	paths = {
		{
			type = "FadeInOutPath",
			fadeInPercent = { 0.2 },
			fadeOutPercent = { 0.8 },
			tween = { 'sineEaseOut' }
		},
		{
			type = "TextureIndexPath",
			textures = { 1, 4 }
		}
	},

	emissionStrategy = {
		type = "RandomDelayEmissionStrategy",
		count = { 10, 20 },
		delay = { 0.125 },
		duration = { math.huge }
	}
}

PortalView.WIDTH = 256
PortalView.HEIGHT = 256

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
		ShaderResource,
		"Resources/Shaders/StaticModel_PortalChasm",
		function(shader)
			self.shader = shader
		end)
	resources:queueEvent(function()
		self.portal = ParticleSceneNode()
		self.portal:initParticleSystemFromDef(PortalView.PARTICLE_SYSTEM_PORTAL, resources)
		self.portal:getMaterial():setShader(self.shader)
		self.portal:setParent(root)

		self.energy = ParticleSceneNode()
		self.energy:initParticleSystemFromDef(PortalView.PARTICLE_SYSTEM_ENERGY, resources)
		self.energy:setParent(root)

		self.portal:onWillRender(function(renderer)
			local currentShader = renderer:getCurrentShader()

			local texture = self.renderer:getOutputBuffer():getColor()
			if texture and currentShader:hasUniform("scape_PortalTexture") then
				currentShader:send("scape_PortalTexture", texture)
			end

			local outputBuffer = renderer:getOutputBuffer():getColor()
			if outputBuffer and currentShader:hasUniform("scape_ScreenSize") then
				currentShader:send("scape_ScreenSize", { outputBuffer:getWidth(), outputBuffer:getHeight() })
			end
		end)
	end)
end

function PortalView:tick()
	PropView.tick(self)

	if self.portal then
		local state = self:getProp():getState()
		self.renderer:setClearColor(Color(unpack(state.color or { 0.2, 0.6, 0.8, 1 })))
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
	selfCamera:setPosition(Vector(unpack(state.absolutePosition or { parentCamera:getPosition():get() })))

	do
		local mapSceneNode = gameView:getMapSceneNode(state.layer)
		if mapSceneNode then
			local mapSceneNodeParent = mapSceneNode:getParent()
			mapSceneNode:setParent(nil)

			love.graphics.push('all')
			love.graphics.setScissor()
			selfRenderer:setCamera(selfCamera)
			selfRenderer:draw(mapSceneNode, 0, PortalView.WIDTH, PortalView.HEIGHT)
			love.graphics.pop()

			mapSceneNode:setParent(mapSceneNodeParent)
		end
	end
end

return PortalView
