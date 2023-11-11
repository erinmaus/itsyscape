--------------------------------------------------------------------------------
-- Resources/Game/Props/MilkOMatic/View.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Vector = require "ItsyScape.Common.Math.Vector"
local Tween = require "ItsyScape.Common.Math.Tween"
local Color = require "ItsyScape.Graphics.Color"
local DecorationSceneNode = require "ItsyScape.Graphics.DecorationSceneNode"
local PropView = require "ItsyScape.Graphics.PropView"
local StaticMeshResource = require "ItsyScape.Graphics.StaticMeshResource"
local TextureResource = require "ItsyScape.Graphics.TextureResource"
local PointLightSceneNode = require "ItsyScape.Graphics.PointLightSceneNode"

local MilkOMatic = Class(PropView)
MilkOMatic.TICK_SECONDS = 0.25
MilkOMatic.MIN_SCALE    = 0.7
MilkOMatic.MAX_SCALE    = 1.3
MilkOMatic.NUM_POINTS   = 10

function MilkOMatic:new(...)
	PropView.new(self, ...)

	self.currentTicks = 0
	self.currentTime = 0

	self:initCurve()
end

function MilkOMatic:load()
	PropView.load(self)

	local resources = self:getResources()
	local root = self:getRoot()

	self.node = DecorationSceneNode()

	resources:queue(
		TextureResource,
		"Resources/Game/Props/MilkOMatic/Texture.png",
		function(texture)
			self.texture = texture
		end)
	resources:queue(
		StaticMeshResource,
		"Resources/Game/Props/MilkOMatic/Model.lstatic",
		function(mesh)
			self.mesh = mesh
			self.node:fromGroup(mesh:getResource(), "MilkOMatic")
			self.node:getMaterial():setTextures(self.texture)
			self.node:setParent(root)
		end)
end

function MilkOMatic:update(delta)
	PropView.update(self, delta)

	local state = self:getProp():getState()
	local ticks = state.ticks or 0

	if ticks > self.currentTicks then
		self.currentTime = self.currentTime + delta

		while self.currentTime > MilkOMatic.TICK_SECONDS do
			self.currentTicks = self.currentTicks + 1
			self.currentTime = self.currentTime - MilkOMatic.TICK_SECONDS

			self:initCurve()
		end

		self.currentTime = math.max(self.currentTime, 0)

		self:animate(math.min(self.currentTime / MilkOMatic.TICK_SECONDS, 1))
	end
end

function MilkOMatic:getPoints()
	local points = { 1, 0 }

	for i = 1, MilkOMatic.NUM_POINTS - 1 do
		local delta = i / MilkOMatic.NUM_POINTS

		table.insert(points, love.math.random() * (MilkOMatic.MAX_SCALE - MilkOMatic.MIN_SCALE) + MilkOMatic.MIN_SCALE)
		table.insert(points, delta)
	end

	table.insert(points, 1) -- x
	table.insert(points, 1) -- y

	return unpack(points)
end

function MilkOMatic:initCurve()
	self.curveX = love.math.newBezierCurve(self:getPoints())
	self.curveY = love.math.newBezierCurve(self:getPoints())
	self.curveZ = love.math.newBezierCurve(self:getPoints())
end

function MilkOMatic:animate(mu)
	mu = math.min(math.max(Tween.sineEaseInOut(mu), 0), 1)

	local scale = Vector(
		self.curveX:evaluate(mu),
		self.curveY:evaluate(mu),
		self.curveZ:evaluate(mu))

	self.node:getTransform():setLocalScale(scale)
end

return MilkOMatic
