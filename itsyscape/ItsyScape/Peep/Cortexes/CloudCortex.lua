--------------------------------------------------------------------------------
-- ItsyScape/Peep/Cortexes/CloudCortex.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Vector = require "ItsyScape.Common.Math.Vector"
local Utility = require "ItsyScape.Game.Utility"
local Cortex = require "ItsyScape.Peep.Cortex"
local CloudBehavior = require "ItsyScape.Peep.Behaviors.CloudBehavior"
local MovementBehavior = require "ItsyScape.Peep.Behaviors.MovementBehavior"
local PositionBehavior = require "ItsyScape.Peep.Behaviors.PositionBehavior"
local SkyBehavior = require "ItsyScape.Peep.Behaviors.SkyBehavior"

local CloudCortex = Class(Cortex)

function CloudCortex:new()
	Cortex.new(self)

	self:require(CloudBehavior)
	self:require(MovementBehavior)
	self:require(PositionBehavior)
end

function CloudCortex:update(delta)
	local game = self:getDirector():getGameInstance()
	local finished = {}

	for peep in self:iterate() do
		local movement = peep:getBehavior(MovementBehavior)
		local mapScript = Utility.Peep.getMapScript(peep)
		local map = Utility.Peep.getMap(peep)
		local sky = mapScript and mapScript:getBehavior(SkyBehavior)

		if sky and movement then
			movement.velocity = sky.windDirection * sky.windSpeed


			local position = Utility.Peep.getPosition(peep)
			local delta = position / Vector(
				map:getWidth() * map:getCellSize(),
				1,
				map:getHeight() * map:getCellSize())
			local clampedDelta = delta:clamp(Vector.ZERO, Vector.ONE)
			local alpha = math.min(clampedDelta.x, clampedDelta.y)

			local cloud = peep:getBehavior(CloudBehavior)
			if cloud then
				cloud.alpha = alpha
			end

			if (sky.windDirection.x > 0 and delta.x > 1) or
			   (sky.windDirection.x < 0 and delta.x < 0) or
			   (sky.windDirection.z > 0 and delta.z > 1) or
			   (sky.windDirection.z < 0 and delta.z < 0)
			then
				Utility.Peep.poof(peep)
			end
		end
	end
end

return CloudCortex
