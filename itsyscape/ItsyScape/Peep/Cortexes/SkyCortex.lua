--------------------------------------------------------------------------------
-- ItsyScape/Peep/Cortexes/SkyCortex.lua
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
local Probe = require "ItsyScape.Peep.Probe"
local CloudBehavior = require "ItsyScape.Peep.Behaviors.CloudBehavior"
local MovementBehavior = require "ItsyScape.Peep.Behaviors.MovementBehavior"
local PositionBehavior = require "ItsyScape.Peep.Behaviors.PositionBehavior"
local SkyBehavior = require "ItsyScape.Peep.Behaviors.SkyBehavior"

local SkyCortex = Class(Cortex)

function SkyCortex:new()
	Cortex.new(self)

	self:require(SkyBehavior)
end

function SkyCortex:update(delta)
	local game = self:getDirector():getGameInstance()
	local finished = {}

	for peep in self:iterate() do
		local sky = peep:getBehavior(SkyBehavior)
		if sky then
			local layer = Utility.Peep.getLayer(peep)
			local map = Utility.Peep.getMap(peep)

			local minClouds = math.ceil(sky.cloudiness * math.max(map:getWidth(), map:getHeight()))
			local currentClouds = self:getDirector():probe(
				peep:getLayerName(),
				Probe.layer(layer),
				Probe.resource("Prop", sky.cloudPropType))

			if minClouds > #currentClouds then
				local minY = sky.troposphereEnd / 2
				local maxY = sky.troposphereEnd

				for i = #currentClouds + 1, minClouds do
					local y = love.math.random(minY, maxY)
					local x, z
					if #currentClouds == 0 then
						x = love.math.random(-map:getWidth() * map:getCellSize(), map:getWidth() * map:getCellSize())
						z = love.math.random(-map:getHeight() * map:getCellSize(), map:getHeight() * map:getCellSize())
					else
						local direction = -sky.windDirection

						if math.abs(direction.x) > 0 then
							local centerX = math.sign(direction.x) * map:getWidth() / 2 * map:getCellSize()
							local centerOffset = math.sqrt(math.max(map:getWidth(), map:getHeight()) * map:getCellSize() / 2)
							x = centerX + math.sign(direction.x) * (centerOffset + love.math.random(map:getWidth() * map:getCellSize() / 2))
						else
							x = love.math.random(1, map:getWidth() * 2)
						end

						if math.abs(direction.z) > 0 then
							local centerZ = math.sign(direction.z) * map:getHeight() / 2 * map:getCellSize()
							local centerOffset = math.sqrt(math.max(map:getWidth(), map:getHeight()) * map:getCellSize() / 2)
							z = centerZ + math.sign(direction.z) * (centerOffset + love.math.random(map:getWidth() * map:getCellSize() / 2))
						else
							z = love.math.random(1, map:getHeight() * 2)
						end
					end

					Utility.spawnPropAtPosition(peep, sky.cloudPropType, x, y, z, map:getCellSize())
				end
			end
		end
	end
end

return SkyCortex
