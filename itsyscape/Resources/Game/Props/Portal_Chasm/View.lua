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

PortalView.EMISSION_STRATEGY_ENABLED = {
	type = "RandomDelayEmissionStrategy",
	count = { 10, 20 },
	delay = { 1 / 30 },
	duration = { math.huge }
}

PortalView.COLOR_FROM = Color(0.9, 0.4, 0.0, 1.0)
PortalView.COLOR_TO = Color(0.0, 0.8, 1.0, 1.0)

PortalView.EMISSION_STRATEGY_DISABLED = {}

PortalView.PARTICLE_SYSTEM_PORTAL = {
	texture = "Resources/Game/Props/Portal_Chasm/Particle.png",
	columns = 4,

	emitters = {
		{
			type = "RadialEmitter",
			radius = { 0, 0 },
			speed = { 2.5, 2.6 },
			zRange = { 0, 0 }
		},
		{
			type = "RandomColorEmitter",
			colors = {
				{ 1.0, 1.0, 1.0, 0.0 },
			}
		},
		{
			type = "RandomLifetimeEmitter",
			age = { 0.5, 0.5 }
		},
		{
			type = "RandomScaleEmitter",
			scale = { 0.5, 0.75 }
		},
		{
			type = "RandomRotationEmitter",
			rotation = { 0, 360 },
			velocity = { 120, 180}
		}
	},

	paths = {
		{
			type = "FadeInOutPath",
			fadeInPercent = { 0.05 },
			fadeOutPercent = { 0.95 },
			tween = { 'sineEaseOut' }
		},
		{
			type = "TextureIndexPath",
			textures = { 1, 4 }
		}
	},

	emissionStrategy = PortalView.EMISSION_STRATEGY_ENABLED
}

PortalView.PARTICLE_SYSTEM_ENERGY = {
	texture = "Resources/Game/Props/Portal_Chasm/Particle.png",
	columns = 4,

	emitters = {
		{
			type = "RadialEmitter",
			radius = { 1.5, 1.6 },
			speed = { 5, 5.25 },
			zRange = { 0, 0 }
		},
		{
			type = "RandomColorEmitter",
			colors = {
				{ 1.0, 1.0, 1.0, 0.0 }
			}
		},
		{
			type = "RandomLifetimeEmitter",
			age = { 0.45, 0.45 }
		},
		{
			type = "RandomScaleEmitter",
			scale = { 0.5, 0.75 }
		},
		{
			type = "RandomRotationEmitter",
			rotation = { 0, 360 },
			velocity = { 120, 180}
		}
	},

	paths = {
		{
			type = "FadeInOutPath",
			fadeInPercent = { 0.05 },
			fadeOutPercent = { 0.95 },
			tween = { 'sineEaseOut' }
		},
		{
			type = "TextureIndexPath",
			textures = { 1, 4 }
		}
	},

	emissionStrategy = PortalView.EMISSION_STRATEGY_ENABLED
}

PortalView.WIDTH = 512
PortalView.HEIGHT = 512

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
		self.portal:getTransform():setLocalScale(Vector(1, 1.5, 1))
		self.portal:setParent(root)

		self.energy = ParticleSceneNode()
		self.energy:initParticleSystemFromDef(PortalView.PARTICLE_SYSTEM_ENERGY, resources)
		self.energy:getTransform():setLocalScale(Vector(1, 1.5, 1))
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

	local colorDelta = math.abs(math.sin(love.timer.getTime() * math.pi))
	local color = PortalView.COLOR_FROM:lerp(PortalView.COLOR_TO, colorDelta)

	if self.energy then
		self.energy:getMaterial():setColor(color)
	end

	selfCamera:setFieldOfView(parentCamera:getFieldOfView())
	selfCamera:setVerticalRotation(parentCamera:getVerticalRotation())
	selfCamera:setHorizontalRotation(parentCamera:getHorizontalRotation())
	selfCamera:setUp(parentCamera:getUp())
	selfCamera:setNear(parentCamera:getNear())
	selfCamera:setFar(parentCamera:getFar())

	local state = self:getProp():getState()
	selfCamera:setDistance(parentCamera:getDistance() + (state.distance or 0))
	selfCamera:setPosition(Vector(unpack(state.absolutePosition or { parentCamera:getPosition():get() })) + Vector(unpack(state.offset or { Vector.ZERO:get() })))

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
