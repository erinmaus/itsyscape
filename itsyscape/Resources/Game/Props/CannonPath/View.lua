--------------------------------------------------------------------------------
-- Resources/Game/Props/CannonPath/View.lua
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
local Color = require "ItsyScape.Graphics.Color"
local LightBeamSceneNode = require "ItsyScape.Graphics.LightBeamSceneNode"
local PointLightSceneNode = require "ItsyScape.Graphics.PointLightSceneNode"
local PropView = require "ItsyScape.Graphics.PropView"
local QuadSceneNode = require "ItsyScape.Graphics.QuadSceneNode"
local TextureResource = require "ItsyScape.Graphics.TextureResource"

local CannonPathView = Class(PropView)
CannonPathView.CANVAS_SIZE  = 128
CannonPathView.LINE_WIDTH   = 8
CannonPathView.RADIUS_FUDGE = 16
CannonPathView.RADIUS       = (CannonPathView.CANVAS_SIZE - CannonPathView.RADIUS_FUDGE - CannonPathView.LINE_WIDTH) / 3

function CannonPathView:new(prop, gameView)
	PropView.new(self, prop, gameView)

	self.lightBeamSceneNode = LightBeamSceneNode()
	self.lightBeamSceneNode:setBeamSize(0.25)
	self.lightBeamSceneNode:getMaterial():setColor(Color(1, 0, 0, 0.75))
	self.lightBeamSceneNode:getMaterial():setIsFullLit(true)
	self.lightBeamSceneNode:getMaterial():setIsShadowCaster(false)

	self.quad = QuadSceneNode()
	self.quad:getTransform():setLocalScale(Vector(2))
	self.quad:getTransform():setLocalTranslation(Vector(0, 0.25, 0))
	self.quad:getTransform():setLocalRotation(Quaternion.X_90)

	self.light = PointLightSceneNode()
	self.light:setAttenuation(8)
	self.light:setColor(Color(1, 0, 0, 1))
	self.light:setParent(quad)

	self.canvas = love.graphics.newCanvas(self.CANVAS_SIZE, self.CANVAS_SIZE)
	self.texture = TextureResource(self.canvas)
	self.quad:getMaterial():setTextures(self.texture)
	self.quad:getMaterial():setIsFullLit(true)
end

function CannonPathView:remove()
	PropView.remove(self)

	self.lightBeamSceneNode:setParent(nil)
	self.quad:setParent(nil)
	self.light:setParent(nil)
end

function CannonPathView:load()
	PropView.load(self)
end

function CannonPathView:tick()
	PropView.tick(self)

	local state = self:getProp():getState()
	self.lightBeamSceneNode:buildSeamless(state.path or {})
	self.lightBeamSceneNode:setParent(self:getGameView():getScene())

	if state.hit then
		self.quad:getTransform():setLocalTranslation(Vector(unpack(state.hit)) + Vector(0, 0.125, 0))
		self.quad:setParent(self:getGameView():getScene())
	else
		self.quad:setParent(nil)
	end
end

function CannonPathView:update(delta)
	PropView.update(self, delta)

	love.graphics.push("all")

	love.graphics.setCanvas(self.canvas)
	love.graphics.clear(0, 0, 0, 0)
	love.graphics.setColor(1, 0, 0, 1)

	love.graphics.setLineWidth(self.LINE_WIDTH)
	love.graphics.circle('line', self.canvas:getWidth() / 2, self.canvas:getHeight() / 2, self.RADIUS)

	love.graphics.line(self.LINE_WIDTH, self.LINE_WIDTH, self.canvas:getWidth() - self.LINE_WIDTH, self.canvas:getHeight() - self.LINE_WIDTH)
	love.graphics.line(self.canvas:getWidth() - self.LINE_WIDTH, self.LINE_WIDTH, self.LINE_WIDTH, self.canvas:getHeight() - self.LINE_WIDTH)

	local fudge = math.sin(love.timer.getTime() * math.pi / 4) * self.RADIUS_FUDGE
	love.graphics.setLineWidth(self.LINE_WIDTH / 2)
	love.graphics.circle('line', self.canvas:getWidth() / 2, self.canvas:getHeight() / 2, self.RADIUS + fudge)

	love.graphics.pop()
end

return CannonPathView
