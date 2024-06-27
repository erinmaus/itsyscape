--------------------------------------------------------------------------------
-- ItsyScape/Peep/Cortexes/SkyCortex.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local socket = require "socket"
local Class = require "ItsyScape.Common.Class"
local Vector = require "ItsyScape.Common.Math.Vector"
local Utility = require "ItsyScape.Game.Utility"
local Cortex = require "ItsyScape.Peep.Cortex"
local Probe = require "ItsyScape.Peep.Probe"
local CloudBehavior = require "ItsyScape.Peep.Behaviors.CloudBehavior"
local MovementBehavior = require "ItsyScape.Peep.Behaviors.MovementBehavior"
local PositionBehavior = require "ItsyScape.Peep.Behaviors.PositionBehavior"
local SkyBehavior = require "ItsyScape.Peep.Behaviors.SkyBehavior"

local SkyCortex = Class(Cortex)
--SkyCortex.DAY_IN_SECONDS = 20 * 60
--SkyCortex.FACING_X_IN_SECONDS = 30
--SkyCortex.FACING_X_THRESHOLD = math.pi / 4
SkyCortex.DAY_IN_SECONDS = 20
SkyCortex.FACING_X_IN_SECONDS = 1
SkyCortex.FACING_X_THRESHOLD = math.pi / 8
SkyCortex.JITTER_THRESHOLD = 0.9

function SkyCortex:new()
	Cortex.new(self)

	self:require(SkyBehavior)
end

function SkyCortex:getDirectionLightNormal()
	local HALF_DAY_IN_SECONDS = SkyCortex.DAY_IN_SECONDS / 2
	local HALF_FACING_X_IN_SECONDS = SkyCortex.FACING_X_IN_SECONDS / 2

	local seconds = socket.gettime() % SkyCortex.DAY_IN_SECONDS

	local isFacingRight = seconds < HALF_FACING_X_IN_SECONDS or seconds > SkyCortex.DAY_IN_SECONDS - HALF_FACING_X_IN_SECONDS
	local isFacingLeft = seconds > HALF_DAY_IN_SECONDS - HALF_FACING_X_IN_SECONDS and seconds < HALF_DAY_IN_SECONDS + HALF_FACING_X_IN_SECONDS

	local angle
	if isFacingRight then
		if seconds < SkyCortex.FACING_X_IN_SECONDS then
			local delta = seconds / SkyCortex.FACING_X_IN_SECONDS
			angle = delta * SkyCortex.FACING_X_THRESHOLD * 2
		elseif seconds > SkyCortex.DAY_IN_SECONDS - HALF_FACING_X_IN_SECONDS then
			local delta = 1 - (seconds - (SkyCortex.DAY_IN_SECONDS - HALF_FACING_X_IN_SECONDS)) / HALF_FACING_X_IN_SECONDS
			angle = math.pi * 2 - delta * SkyCortex.FACING_X_THRESHOLD / 2
		end
	elseif isFacingLeft then
		local delta = (seconds - (HALF_DAY_IN_SECONDS - HALF_FACING_X_IN_SECONDS)) / SkyCortex.FACING_X_IN_SECONDS
		angle = delta * SkyCortex.FACING_X_THRESHOLD * 2 + (math.pi - SkyCortex.FACING_X_THRESHOLD)
	else
		if seconds < HALF_DAY_IN_SECONDS then
			local delta = (seconds - HALF_FACING_X_IN_SECONDS) / (HALF_DAY_IN_SECONDS - SkyCortex.FACING_X_IN_SECONDS)
			angle = delta * (math.pi - SkyCortex.FACING_X_THRESHOLD * 2) + SkyCortex.FACING_X_THRESHOLD
		else
			local delta = (seconds - HALF_FACING_X_IN_SECONDS - HALF_DAY_IN_SECONDS) / (HALF_DAY_IN_SECONDS - SkyCortex.FACING_X_IN_SECONDS)
			angle = delta * (math.pi - SkyCortex.FACING_X_THRESHOLD * 2) + (math.pi + SkyCortex.FACING_X_THRESHOLD)
		end
	end

	local x, y, z
	do
		x = math.cos(angle)
		y = 0.5
		z = math.sin(angle)
	end

	return Vector(x, y, -z):getNormal()
end

function SkyCortex:getSunAlpha()
	local seconds = socket.gettime() % SkyCortex.DAY_IN_SECONDS
	local delta = seconds / SkyCortex.DAY_IN_SECONDS

	if delta > 0.5 then
		return 0
	else
		return math.min(math.sin(delta / 0.5 * math.pi) * 5, 1)
	end
end

function SkyCortex:getSunNormal()
	local seconds = socket.gettime() % SkyCortex.DAY_IN_SECONDS
	local delta = seconds / SkyCortex.DAY_IN_SECONDS
	local angle = delta * math.pi * 2

	local x, y, z
	do
		x = math.cos(angle)
		y = math.sin(angle)
		z = 0
	end

	return Vector(x, y, z):getNormal()
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

			local instance = Utility.Peep.getInstance(peep)
			local baseLayer = instance:getBaseLayer()
			local sunDirectionalLight = self:getDirector():probe(
				peep:getLayerName(),
				Probe.layer(baseLayer),
				Probe.namedMapObject("Light_Sun"),
				Probe.resource("Prop", "DirectionalLight_Default"))[1]

			if sunDirectionalLight then
				local normal = self:getDirectionLightNormal()
				sunDirectionalLight:setDirection(normal)
			end

			local sun = self:getDirector():probe(
				peep:getLayerName(),
				Probe.layer(layer),
				Probe.resource("Prop", sky.sunPropType))[1]

			if not sun then
				sun = Utility.spawnPropAtPosition(peep, sky.sunPropType, 0, 0, 0)
			else
				local normal = self:getSunNormal()
				local alpha = self:getSunAlpha()

				sky.sunNormal = normal
				sky.sunAlpha = alpha

				local position = normal * sky.sunDistance + Vector(map:getWidth() * map:getCellSize() / 2, 0, 0)
				sky.sunPosition = position

				print(">>> alpha", alpha, "position", position:get())
				Utility.Peep.setPosition(sun, position)
			end
		end
	end
end

return SkyCortex
