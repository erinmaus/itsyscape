--------------------------------------------------------------------------------
-- Resources/Game/Props/FishingCursor/View.lua
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
local PointLightSceneNode = require "ItsyScape.Graphics.PointLightSceneNode"
local PropView = require "ItsyScape.Graphics.PropView"
local QuadSceneNode = require "ItsyScape.Graphics.QuadSceneNode"
local TextureResource = require "ItsyScape.Graphics.TextureResource"

local FishingCursor = Class(PropView)
FishingCursor.CANVAS_SIZE  = 128
FishingCursor.LINE_WIDTH   = 8
FishingCursor.RADIUS_FUDGE = 16
FishingCursor.RADIUS       = (FishingCursor.CANVAS_SIZE - FishingCursor.RADIUS_FUDGE - FishingCursor.LINE_WIDTH) / 3

function FishingCursor:load()
	PropView.load(self)

	self.previousColor = Color(0, 0, 0, 0)
	self.currentColor = Color(0, 0, 0, 0)

	self.quad = QuadSceneNode()
	self.quad:getTransform():setLocalTranslation(Vector(0, 0.25, 0))
	self.quad:getTransform():setLocalRotation(Quaternion.X_90)
	self.quad:setParent(self:getRoot())

	self.canvas = love.graphics.newCanvas(self.CANVAS_SIZE, self.CANVAS_SIZE)
	self.texture = TextureResource(self.canvas)
	self.quad:getMaterial():setTextures(self.texture)
	self.quad:getMaterial():setIsFullLit(true)
	self.quad:getMaterial():setIsTranslucent(true)
	self.quad:getMaterial():setZBias(1000)
end

function FishingCursor:getIsStatic()
	return false
end

function FishingCursor:remove()
	PropView.remove(self)

	self.quad:setParent(nil)
end

do
	local color = Color()
	function FishingCursor:_drawCursor()
		love.graphics.push("all")

		self.previousColor:lerp(self.currentColor, _APP:getFrameDelta(), color)

		love.graphics.setCanvas(self.canvas)
		love.graphics.clear(0, 0, 0, 0)
		love.graphics.setColor(color:get())

		love.graphics.setLineWidth(self.LINE_WIDTH)
		love.graphics.circle('line', self.canvas:getWidth() / 2, self.canvas:getHeight() / 2, self.RADIUS)

		love.graphics.line(self.LINE_WIDTH, self.LINE_WIDTH, self.canvas:getWidth() - self.LINE_WIDTH, self.canvas:getHeight() - self.LINE_WIDTH)
		love.graphics.line(self.canvas:getWidth() - self.LINE_WIDTH, self.LINE_WIDTH, self.LINE_WIDTH, self.canvas:getHeight() - self.LINE_WIDTH)

		local fudge = math.sin(love.timer.getTime() * math.pi / 4) * self.RADIUS_FUDGE
		love.graphics.setLineWidth(self.LINE_WIDTH / 2)
		love.graphics.circle('line', self.canvas:getWidth() / 2, self.canvas:getHeight() / 2, self.RADIUS + fudge)

		love.graphics.pop()
	end
end

do
	local COLOR = { 0, 0, 0, 0 }
	local color = Color()

	function FishingCursor:_updateColor()
		color:from(unpack(self:getProp():getState().color or COLOR))

		if self.previousColor ~= color then
			self.previousColor:lerp(self.currentColor, _APP:getFrameDelta(), self.previousColor)
			self.currentColor:from(color:get())
		end
	end
end

function FishingCursor:update(delta)
	PropView.update(self, delta)

	self:_updateColor()
	self:_drawCursor()
end

return FishingCursor
