--------------------------------------------------------------------------------
-- Resources/Peeps/Props/BasicCannonball.lua
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
local Sailing = require "ItsyScape.Game.Skills.Sailing"
local Utility = require "ItsyScape.Game.Utility"
local Probe = require "ItsyScape.Peep.Probe"
local PassableProp = require "Resources.Game.Peeps.Props.PassableProp"

local BasicCannonball = Class(PassableProp)

BasicCannonball.MAX_WATER_DEPTH = 0.5

function BasicCannonball:new(...)
	PassableProp.new(self, ...)

	self:addPoke('launch')
end

function BasicCannonball:onLaunch(path, duration)
	self.currentPath = path
	self.currentDuration = duration
	self.currentTime = 0
	self.isLaunched = true
end

function BasicCannonball:update(director, game)
	PassableProp.update(self, director, game)

	if not self.isLaunched then
		return
	end

	local delta = game:getDelta()
	self.currentTime = math.min(self.currentTime + delta, self.currentDuration)

	local percent = self.currentTime / self.currentDuration
	local currentIndex = math.floor(math.lerp(1, #self.currentPath, math.min(percent, 1)))
	local nextIndex = math.min(currentIndex + 1, #self.currentPath)

	local currentPath = self.currentPath[currentIndex]
	local nextPath = self.currentPath[nextIndex]

	local timestep = nextPath.time - currentPath.time
	local stepDelta = (self.currentTime - currentPath.time) / timestep

	local position = currentPath.position:lerp(nextPath.position, math.clamp(stepDelta))
	Utility.Peep.setPosition(self, position)

	local waterPosition = Sailing.Ocean.getPositionRotation(self)
	if position.y < waterPosition.y - self.MAX_WATER_DEPTH then
		local stage = game:getStage()
		stage:fireProjectile("CannonballSplash", Vector.ZERO, Utility.Peep.getAbsolutePosition(self) + Vector(0, 2, 0), Utility.Peep.getLayer(self))

		Utility.Peep.poof(self)
	end
end

function BasicCannonball:getPropState()
	return {
		time = self.currentTime,
		duration = self.currentDuration
	}
end

return BasicCannonball
