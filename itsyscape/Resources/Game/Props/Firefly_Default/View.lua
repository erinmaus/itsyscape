--------------------------------------------------------------------------------
-- Resources/Game/Props/Firefly_Default/Fire.lua
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
local PropView = require "ItsyScape.Graphics.PropView"
local PointLightSceneNode = require "ItsyScape.Graphics.PointLightSceneNode"
local DecorationSceneNode = require "ItsyScape.Graphics.DecorationSceneNode"
local StaticMeshResource = require "ItsyScape.Graphics.StaticMeshResource"

local Firefly = Class(PropView)

Firefly.NUM_FIREFLIES = 12

Firefly.FIREFLY_MIN_SIZE = 0.05
Firefly.FIREFLY_MAX_SIZE = 0.075

Firefly.FIREFLY_MIN_ATTENUATION = 4
Firefly.FIREFLY_MAX_ATTENUATION = 6

Firefly.FIREFLY_ATTENUATION_MIN_OFFSET = 0
Firefly.FIREFLY_ATTENUATION_MAX_OFFSET = 2

Firefly.FIREFLY_MIN_AGE = 3
Firefly.FIREFLY_MAX_AGE = 8

Firefly.FIREFLY_MIN_RADIUS = 2
Firefly.FIREFLY_MAX_RADIUS = 6

Firefly.FIREFLY_MIN_WANDER_RADIUS = 0.5
Firefly.FIREFLY_MAX_WANDER_RADIUS = 1.5

Firefly.FIREFLY_MAIN_ALPHA_MULTIPLIER = 2
Firefly.FIREFLY_MAIN_ALPHA_PERIOD     = math.pi

Firefly.FIREFLY_FLICKER_MIN_MULTIPLIER = 0.5
Firefly.FIREFLY_FLICKER_MAX_MULTIPLIER = 2.5
Firefly.FIREFLY_FLICKER_MIN_OFFSET     = math.pi / 8
Firefly.FIREFLY_FLICKER_MAX_OFFSET     = math.pi * 1.5

Firefly.FIREFLY_MIN_DISTANCE = 5
Firefly.FIREFLY_MAX_DISTANCE = 8

Firefly.COLORS = {
	Color(1, 1, 1, 1)
}

function Firefly:load()
	PropView.load(self)

	self.fireflies = {}

	local resources = self:getResources()

	resources:queue(
		StaticMeshResource,
		"Resources/Game/Props/Firefly_Default/Model.lstatic",
		function(mesh)
			self.mesh = mesh
		end)

	resources:queueEvent(function()
		local whiteTexture = self:getGameView():getWhiteTexture()

		for i = 1, self.NUM_FIREFLIES do
			local sceneNode = DecorationSceneNode()
			sceneNode:fromGroup(self.mesh:getResource(), "sphere")
			sceneNode:getMaterial():setTextures(whiteTexture)
			sceneNode:getMaterial():setIsTranslucent(true)
			sceneNode:getMaterial():setIsFullLit(true)

			local pointLight = PointLightSceneNode()
			pointLight:setParent(sceneNode)
			pointLight:setColor(Color(1))

			table.insert(self.fireflies, {
				dead = true,
				age = love.math.random() * self.FIREFLY_MIN_AGE,
				lifetime = love.math.random() * self.FIREFLY_MIN_AGE,

				scene = {
					mesh = sceneNode,
					light = pointLight
				}
			})

			coroutine.yield()
		end
	end)
end

function Firefly:_random(min, max)
	return love.math.random() * (max - min) + min
end

function Firefly:resetFirefly(firefly)
	local root = self:getRoot()
	local gameView = self:getGameView()
	local camera = gameView:getCamera()
	local position = camera:getPosition()

	local rootParent = root:getParent()
	if rootParent then
		-- Move from world space to local map space relative to this prop
		position = position:inverseTransform(rootParent:getTransform():getGlobalDeltaTransform(0))
	end

	if firefly.dead then
		firefly.dead = false
		firefly.age = 0
		firefly.lifetime = self:_random(self.FIREFLY_MIN_AGE, self.FIREFLY_MAX_AGE)

		local radius = self:_random(self.FIREFLY_MIN_RADIUS, self.FIREFLY_MAX_RADIUS)
		firefly.center = Vector(
			position.x + math.cos(love.math.random() * math.pi * 2) * radius,
			position.y + radius / 2,
			position.z + math.sin(love.math.random() * math.pi * 2) * radius):keep()

		firefly.sinMultiplier = self:_random(self.FIREFLY_FLICKER_MIN_MULTIPLIER, self.FIREFLY_FLICKER_MAX_MULTIPLIER)
		firefly.sinOffset = self:_random(self.FIREFLY_FLICKER_MIN_OFFSET, self.FIREFLY_FLICKER_MAX_OFFSET)

		firefly.cosMultiplier = self:_random(self.FIREFLY_FLICKER_MIN_MULTIPLIER, self.FIREFLY_FLICKER_MAX_MULTIPLIER)
		firefly.cosOffset = self:_random(self.FIREFLY_FLICKER_MIN_OFFSET, self.FIREFLY_FLICKER_MAX_OFFSET)

		firefly.xyzSinMultiplier = Vector(
			self:_random(self.FIREFLY_FLICKER_MIN_MULTIPLIER, self.FIREFLY_FLICKER_MAX_MULTIPLIER),
			self:_random(self.FIREFLY_FLICKER_MIN_MULTIPLIER, self.FIREFLY_FLICKER_MAX_MULTIPLIER),
			self:_random(self.FIREFLY_FLICKER_MIN_MULTIPLIER, self.FIREFLY_FLICKER_MAX_MULTIPLIER)):keep()
		firefly.xyzSinOffset = Vector(
			self:_random(self.FIREFLY_FLICKER_MIN_OFFSET, self.FIREFLY_FLICKER_MAX_OFFSET),
			self:_random(self.FIREFLY_FLICKER_MIN_OFFSET, self.FIREFLY_FLICKER_MAX_OFFSET),
			self:_random(self.FIREFLY_FLICKER_MIN_OFFSET, self.FIREFLY_FLICKER_MAX_OFFSET)):keep()
		firefly.xyzCosMultiplier = Vector(
			self:_random(self.FIREFLY_FLICKER_MIN_MULTIPLIER, self.FIREFLY_FLICKER_MAX_MULTIPLIER),
			self:_random(self.FIREFLY_FLICKER_MIN_MULTIPLIER, self.FIREFLY_FLICKER_MAX_MULTIPLIER),
			self:_random(self.FIREFLY_FLICKER_MIN_MULTIPLIER, self.FIREFLY_FLICKER_MAX_MULTIPLIER)):keep()
		firefly.xyzCosOffset = Vector(
			self:_random(self.FIREFLY_FLICKER_MIN_OFFSET, self.FIREFLY_FLICKER_MAX_OFFSET),
			self:_random(self.FIREFLY_FLICKER_MIN_OFFSET, self.FIREFLY_FLICKER_MAX_OFFSET),
			self:_random(self.FIREFLY_FLICKER_MIN_OFFSET, self.FIREFLY_FLICKER_MAX_OFFSET)):keep()
		firefly.xyzRadius = Vector(
			self:_random(self.FIREFLY_MIN_WANDER_RADIUS, self.FIREFLY_MAX_WANDER_RADIUS),
			self:_random(self.FIREFLY_MIN_WANDER_RADIUS, self.FIREFLY_MAX_WANDER_RADIUS),
			self:_random(self.FIREFLY_MIN_WANDER_RADIUS, self.FIREFLY_MAX_WANDER_RADIUS)):keep()

		firefly.scene.mesh:getTransform():setLocalScale(Vector(self:_random(self.FIREFLY_MIN_SIZE, self.FIREFLY_MAX_SIZE)))

		firefly.color = self.COLORS[love.math.random(#self.COLORS)]
		firefly.attenuation = self:_random(self.FIREFLY_MIN_ATTENUATION, self.FIREFLY_MAX_ATTENUATION)

		self:updateFirefly(firefly, 0)
		firefly.scene.mesh:tick()
	else
		firefly.dead = true
		firefly.age = love.math.random() * self.FIREFLY_MIN_AGE
		firefly.lifetime = love.math.random() * self.FIREFLY_MIN_AGE

		if not firefly.scene.mesh:getParent() == root then
			firefly.scene.mesh:setParent()
		end
	end
end

function Firefly:updateFirefly(firefly, delta)
	local root = self:getRoot()
	local gameView = self:getGameView()
	local camera = gameView:getCamera()
	local position = camera:getPosition()

	local rootParent = root:getParent()
	if rootParent then
		position = position:inverseTransform(rootParent:getTransform():getGlobalDeltaTransform(0))
	end

	firefly.age = firefly.age + delta
	if firefly.dead and firefly.age > firefly.lifetime then
		return false
	end

	if firefly.dead then
		return true
	end

	if not firefly.scene.mesh:getParent() ~= root then
		firefly.scene.mesh:setParent(root)
	end

	local distanceMu = math.max(position:distance(firefly.center) - self.FIREFLY_MIN_DISTANCE, 0) / (self.FIREFLY_MAX_DISTANCE - self.FIREFLY_MIN_DISTANCE)
	local distanceAlpha = 1 - math.clamp(distanceMu)

	local mu = math.min(firefly.age, firefly.lifetime) / firefly.lifetime
	local mainAlpha = math.min(math.sin(mu * math.pi) * self.FIREFLY_MAIN_ALPHA_MULTIPLIER, 1)
	local flickerMu = math.sin(firefly.age * firefly.sinMultiplier + firefly.sinOffset) + math.cos(firefly.age * firefly.cosMultiplier + firefly.cosOffset)
	flickerMu = ((flickerMu / 2) + 1) / 2 -- scale from -2 .. +2 to 0 .. 1

	local attenuation = (firefly.attenuation + math.lerp(self.FIREFLY_ATTENUATION_MIN_OFFSET, self.FIREFLY_ATTENUATION_MAX_OFFSET, flickerMu)) * mainAlpha
	local alpha = mainAlpha * flickerMu * distanceAlpha

	firefly.scene.light:setAttenuation(attenuation)

	local material = firefly.scene.mesh:getMaterial()
	material:setColor(Color(firefly.color.r, firefly.color.g, firefly.color.b, alpha))

	local positionMu = Vector(
		math.sin(mu * math.pi * firefly.xyzSinMultiplier.x + firefly.xyzSinOffset.x) + math.cos(mu * math.pi * firefly.xyzCosMultiplier.x + firefly.xyzCosOffset.x),
		math.sin(mu * math.pi * firefly.xyzSinMultiplier.y + firefly.xyzSinOffset.y) + math.cos(mu * math.pi * firefly.xyzCosMultiplier.y + firefly.xyzCosOffset.y),
		math.sin(mu * math.pi * firefly.xyzSinMultiplier.z + firefly.xyzSinOffset.z) + math.cos(mu * math.pi * firefly.xyzCosMultiplier.z + firefly.xyzCosOffset.z))
	positionMu = ((positionMu / Vector(2)) + Vector(1)) / Vector(2) -- again, scale from -2 .. +2 to 0 .. 1
	local relativePosition = Vector(
		math.sin(positionMu.x * math.pi * 2) * firefly.xyzRadius.x,
		math.sin(positionMu.y * math.pi * 2) * firefly.xyzRadius.y,
		math.sin(positionMu.z * math.pi * 2) * firefly.xyzRadius.z)

	local transform = firefly.scene.mesh:getTransform()
	transform:setLocalTranslation(relativePosition + firefly.center)

	return firefly.age < firefly.lifetime and distanceMu <= 1
end

function Firefly:update(delta)
	PropView.update(self, delta)

	for _, firefly in ipairs(self.fireflies) do
		if not self:updateFirefly(firefly, delta) then
			self:resetFirefly(firefly)
		end
	end
end

return Firefly
