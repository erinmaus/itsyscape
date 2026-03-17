--------------------------------------------------------------------------------
-- Resources/Game/Props/DragonFireball/View.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Vector = require "ItsyScape.Common.Math.Vector"
local Color = require "ItsyScape.Graphics.Color"
local PropView = require "ItsyScape.Graphics.PropView"
local FlameGreeble = require "Resources.Game.Props.Common.Greeble.FlameGreeble"
local FlickerGreeble = require "Resources.Game.Props.Common.Greeble.FlickerGreeble"
local SmokeGreeble = require "Resources.Game.Props.Common.Greeble.SmokeGreeble"

local DragonFireball = Class(PropView)

function DragonFireball:new(...)
	PropView.new(self, ...)

	self.isShot = false
end

function DragonFireball:getIsStatic()
	return false
end

do
	local currentPosition = Vector()
	local direction = Vector()

	function DragonFireball:updateGreeblePositionDirection()
		local transform = self:getRoot():getTransform():getGlobalDeltaTransform(_APP:getPreviousFrameDelta())

		currentPosition:from(0):transform(transform, currentPosition)

		if self.previousPosition then
			self.previousPosition:direction(currentPosition, direction)
		else
			direction:from(0, 0, 1)
		end

		if direction:getLengthSquared() == 0 then
			direction:from(self.previousDirection:get())
		else
			self.previousDirection:from(direction:get())
		end

		self.flameGreeble:updateLocalDirection(direction)
		self.flameGreeble:updateLocalPosition(currentPosition)
		self.smokeGreeble:updateLocalDirection(direction)
		self.smokeGreeble:updateLocalPosition(currentPosition)

		self.previousPosition = (self.previousPosition or Vector()):from(currentPosition:get())
	end
end

function DragonFireball:shoot()
	self.flameGreeble = self:addGreeble(FlameGreeble, {
		ATTACH_TO_ROOT = true,
		PARTICLE_SCALE = 4
	})

	self.flickerGreeble = self:addGreeble(FlickerGreeble, {
		MIN_ATTENUATION = 4,
		MAX_ATTENUATION = 8,
	})

	self.smokeGreeble = self:addGreeble(SmokeGreeble, {
		ATTACH_TO_ROOT = true,
		PARTICLE_SCALE = 4,
		SMOKE_OFFSET = Vector(0, 1.5, 0)
	})

	self.previousPosition = false
	self.previousDirection = Vector(0, 0, 1)
end

function DragonFireball:tick()
	PropView.tick(self)

	local state = self:getProp():getState()
	if not self.isShot and state.isShot then
		self:getRoot():tick()
		self:shoot()

		self.isShot = true
	end
end

function DragonFireball:update(delta)
	PropView.update(self, delta)

	if self.isShot then
		self:updateGreeblePositionDirection()
	end
end

return DragonFireball
