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
local Utility = require "ItsyScape.Game.Utility"
local Probe = require "ItsyScape.Peep.Probe"
local AttackPoke = require "ItsyScape.Peep.AttackPoke"

local BasicCannonball = Class(PassableProp)

BasicCannonball.MAX_WATER_DEPTH = 1

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

function BasicCannonball:_getWaterLevel()
	local game = self:getDirector():getGameInstance()

	local layer = Utility.Peep.getLayer(self)
	local mapScript = Utility.Peep.getInstance(self):getMapScriptByLayer(layer)
	local ocean = mapScript and mapScript:getBehavior(OceanBehavior)

	local windDirection, windSpeed, windPattern = Utility.Map.getWind(game, layer)

	local worldPosition = Utility.Peep.getPosition(self)
	worldPosition = Utility.Map.transformWorldPositionByWave(
		ocean and ocean.time or 0,
		windSpeed * (ocean and ocean.windSpeedMultiplier or 1),
		windDirection,
		windPattern * (ocean and ocean.windPatternMultiplier or Vector(2, 4, 8)),
		Vector(worldPosition.x, -(ocean and ocean.offset or 1), worldPosition.z),
		Vector(worldPosition.x, 0, worldPosition.z))

	return worldPosition.y
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

	local y = self:_getWaterLevel()
	if position.y - self.MAX_WATER_DEPTH <= y then
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
