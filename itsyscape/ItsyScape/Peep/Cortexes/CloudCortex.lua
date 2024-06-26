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
			local isOutOfBounds = false
			if math.abs(sky.windDirection.x) > 0 then
				if sky.windDirection.x > 0 then
					isOutOfBounds = isOutOfBounds or position.x > (map:getWidth() + map:getWidth() / 2) * map:getCellSize()
				else
					isOutOfBounds = isOutOfBounds or position.x < -(map:getWidth() / 2 * map:getCellSize())
				end
			end

			if math.abs(sky.windDirection.z) > 0 then
				if sky.windDirection.z > 0 then
					isOutOfBounds = isOutOfBounds or position.z > (map:getHeigt() + map:getHeigt() / 2) * map:getCellSize()
				else
					isOutOfBounds = isOutOfBounds or position.z < -(map:getHeigt() / 2 * map:getCellSize())
				end
			end

			if isOutOfBounds then
				print(">>> cloud out of bounds", position:get())
				Utility.Peep.poof(peep)
			end
		end
	end
end

return CloudCortex
