--------------------------------------------------------------------------------
-- Resources/Game/Props/Target_Default/View.lua
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
local Color = require "ItsyScape.Graphics.Color"
local PointLightSceneNode = require "ItsyScape.Graphics.PointLightSceneNode"
local PropView = require "ItsyScape.Graphics.PropView"
local StaticMeshResource = require "ItsyScape.Graphics.StaticMeshResource"
local TextureResource = require "ItsyScape.Graphics.TextureResource"
local QuadSceneNode = require "ItsyScape.Graphics.QuadSceneNode"

local TargetView = Class(PropView)
TargetView.CANVAS_SIZE  = 128
TargetView.LINE_WIDTH   = 8
TargetView.RADIUS_FUDGE = 16
TargetView.RADIUS       = (TargetView.CANVAS_SIZE - TargetView.RADIUS_FUDGE - TargetView.LINE_WIDTH) / 3

function TargetView:new(prop, gameView)
	PropView.new(self, prop, gameView)
end

function TargetView:load()
	PropView.load(self)

	local resources = self:getResources()
	local root = self:getRoot()

	self.quad = QuadSceneNode()
	self.quad:getTransform():setLocalScale(Vector(2))
	self.quad:getTransform():setLocalTranslation(Vector(0, 0.125, 0))
	self.quad:getTransform():setLocalRotation(Quaternion.X_90)
	self.quad:setParent(root)

	self.light = PointLightSceneNode()
	self.light:setAttenuation(8)
	self.light:getTransform():setLocalTranslation(Vector(0, 4, 0))
	self.light:setColor(Color(1, 1, 0, 1))
	self.light:setParent(root)

	self.canvas = love.graphics.newCanvas(TargetView.CANVAS_SIZE, TargetView.CANVAS_SIZE)
	self.texture = TextureResource(self.canvas)
	self.quad:getMaterial():setTextures(self.texture)
	self.quad:getMaterial():setIsFullLit(true)
end

function TargetView:getIsStatic()
	return false
end

function TargetView:remove()
	PropView.remove(self)

	if self.sprite then
		self:getGameView():getSpriteManager():poof(self.sprite)
	end
end

function TargetView:tick()
	PropView.tick(self)

	if not self.sprite then
		self.sprite = self:getGameView():getSpriteManager():add(
			"TargetHint",
			self:getRoot(),
			Vector(unpack(self:getProp():getState().offset or { 0, 2, 0 })),
			self:getProp())
	end
end

function TargetView:update(delta)
	PropView.update(self, delta)

	love.graphics.push("all")

	love.graphics.setCanvas(self.canvas)
	love.graphics.clear(0, 0, 0, 0)
	love.graphics.setColor(1, 1, 0, 1)

	love.graphics.setLineWidth(TargetView.LINE_WIDTH)
	love.graphics.circle('line', self.canvas:getWidth() / 2, self.canvas:getHeight() / 2, TargetView.RADIUS)

	local fudge = math.sin(love.timer.getTime() * math.pi / 4) * TargetView.RADIUS_FUDGE
	love.graphics.setLineWidth(TargetView.LINE_WIDTH / 2)
	love.graphics.circle('line', self.canvas:getWidth() / 2, self.canvas:getHeight() / 2, TargetView.RADIUS + fudge)

	love.graphics.pop()
end

return TargetView
