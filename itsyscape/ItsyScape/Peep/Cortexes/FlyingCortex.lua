--------------------------------------------------------------------------------
-- ItsyScape/Peep/Cortexes/FlyingCortex.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Tween = require "ItsyScape.Common.Math.Tween"
local Utility = require "ItsyScape.Game.Utility"
local Cortex = require "ItsyScape.Peep.Cortex"
local FlyingBehavior = require "ItsyScape.Peep.Behaviors.FlyingBehavior"
local MovementBehavior = require "ItsyScape.Peep.Behaviors.MovementBehavior"

local FlyingCortex = Class(Cortex)

function FlyingCortex:new()
	Cortex.new(self)

	self:require(FlyingBehavior)
	self:require(MovementBehavior)
end

function FlyingCortex:updateCurrentElevation(peep, delta)
	local flying = peep:getBehavior(FlyingBehavior)
	local movement = peep:getBehavior(MovementBehavior)
	if not (flying and movement) then
		return
	end

	if movement.maxSpeed <= 0 then
		return
	end

	if flying.maxElevation <= 0 then
		return
	end

	local secondsToMaxElevation = flying.maxElevation / movement.maxSpeed
	print(">>>", "secondsToMaxElevation", secondsToMaxElevation)

	local secondsToCurrentElevation = flying.currentElevation / movement.maxSpeed
	print(">>>", "secondsToCurrentElevation", secondsToCurrentElevation)

	local currentTime = secondsToCurrentElevation
	print(">>>", "currentTime", currentTime, "delta", delta)

	if flying.isFlying then
		currentTime = currentTime + delta
	else
		currentTime = currentTime - delta
	end
	print(">>>", "currentTime", "after", currentTime)

	local delta = math.clamp(currentTime / secondsToMaxElevation)
	print(">>>", "delta", delta)

	local mu = Tween.linear(delta)
	print(">>>", "mu", mu)


	local nextElevation = mu * flying.maxElevation
	flying.currentElevation = nextElevation
	movement.float = flying.currentElevation
end

function FlyingCortex:update()
	local game = self:getDirector():getGameInstance()
	local delta = game:getDelta()

	for peep in self:iterate() do
		self:updateCurrentElevation(peep, delta)
	end
end

return FlyingCortex
