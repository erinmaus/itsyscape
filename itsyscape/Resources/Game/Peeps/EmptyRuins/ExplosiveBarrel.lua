--------------------------------------------------------------------------------
-- Resources/Game/Peeps/EmptyRuins/ExplosiveBarrel.lua
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
local Utility = require "ItsyScape.Game.Utility"
local Probe = require "ItsyScape.Peep.Probe"
local StaticProp = require "Resources.Game.Peeps.Props.StaticProp"

local ExplosiveBarrel = Class(StaticProp)
ExplosiveBarrel.ROCK_INTERVAL = 0.5

function ExplosiveBarrel:ready(...)
	StaticProp.ready(self, ...)
	self:roll()
end

function ExplosiveBarrel:rock(delta)
	local start = self.startRotation or Quaternion.IDENTITY
	local target = self.targetRotation or Quaternion.IDENTITY

	Utility.Peep.setRotation(self, start:slerp(target, delta))
end

function ExplosiveBarrel:roll()
	self.startRotation = Utility.Peep.getRotation(self)

	local xAngle = math.rad(love.math.random(-45, 45))
	local zAngle = math.rad(love.math.random(-45, 45))
	local xRotation = Quaternion.fromAxisAngle(Vector.UNIT_X, xAngle)
	local zRotation = Quaternion.fromAxisAngle(Vector.UNIT_X, zAngle)

	self.targetRotation = zRotation * xRotation
	self.currentRockTime = self.ROCK_INTERVAL
end

function ExplosiveBarrel:update(director, game)
	StaticProp.update(self, director, game)

	local delta = game:getDelta()

	self.currentRockTime = (self.currentRockTime or 0) - delta
	if self.currentRockTime > 0 then
		local mu = math.min(math.max(self.currentRockTime / ExplosiveBarrel.ROCK_INTERVAL, 1), 0)
		self:rock(mu)
	else
		self:roll()
	end
end

return ExplosiveBarrel
