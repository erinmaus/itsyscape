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
local Quaternion = require "ItsyScape.Common.Math.Quaternion"
local Vector = require "ItsyScape.Common.Math.Vector"
local Utility = require "ItsyScape.Game.Utility"
local Color = require "ItsyScape.Graphics.Color"
local Cortex = require "ItsyScape.Peep.Cortex"
local Probe = require "ItsyScape.Peep.Probe"
local CloudBehavior = require "ItsyScape.Peep.Behaviors.CloudBehavior"
local MovementBehavior = require "ItsyScape.Peep.Behaviors.MovementBehavior"
local PositionBehavior = require "ItsyScape.Peep.Behaviors.PositionBehavior"
local SkyBehavior = require "ItsyScape.Peep.Behaviors.SkyBehavior"

local SkyCortex = Class(Cortex)
SkyCortex.DAY = 24 * 60 * 60
SkyCortex.DAY_IN_SECONDS = 20 * 60
SkyCortex.FACING_X_IN_SECONDS = 30
--SkyCortex.FACING_X_THRESHOLD = math.pi / 4
--SkyCortex.DAY_IN_SECONDS = 20
--SkyCortex.FACING_X_IN_SECONDS = 1
SkyCortex.FACING_X_THRESHOLD = math.pi / 8
SkyCortex.JITTER_THRESHOLD = 0.9
SkyCortex.OFFSET_TIME_DELTA_IN_SECONDS = 1

function SkyCortex:new()
	Cortex.new(self)

	self:require(SkyBehavior)
end

function SkyCortex:updateSeconds(delta, sky, instance)
	local director = self:getDirector()
	local player = instance:getPartyLeader()
	local playerPeep = player and player:getActor() and player:getActor():getPeep()

	if playerPeep then
		local offset = Utility.Time.getSeconds(director:getPlayerStorage(playerPeep):getRoot())
		offset = offset / SkyCortex.DAY * SkyCortex.DAY_IN_SECONDS

		if offset ~= sky.currentOffsetSeconds then
			if not sky.currentOffsetSeconds then
				sky.currentOffsetSeconds = offset
				sky.startOffsetSeconds = offset
				sky.stopOffsetSeconds = offset
				sky.offsetTimeDelta = 1
			else
				if offset ~= sky.stopOffsetSeconds then
					sky.startOffsetSeconds = sky.currentOffsetSeconds
					sky.stopOffsetSeconds = offset

					sky.offsetTimeDelta = 0
				end
			end
		end
	end

	if sky.offsetTimeDelta < 1 then
		sky.offsetTimeDelta = math.clamp(sky.offsetTimeDelta + (delta / SkyCortex.OFFSET_TIME_DELTA_IN_SECONDS))
		sky.currentOffsetSeconds = math.lerp(sky.startOffsetSeconds, sky.stopOffsetSeconds, sky.offsetTimeDelta)
	end

	if sky.offsetTimeDelta >= 1 then
		sky.startOffsetSeconds = sky.currentOffsetSeconds
		sky.stopOffsetSeconds = sky.currentOffsetSeconds
	end

	return ((sky.currentOffsetSeconds or 0) + socket.gettime()) % SkyCortex.DAY_IN_SECONDS
end

function SkyCortex:getDirectionLightNormal(seconds)
	local HALF_DAY_IN_SECONDS = SkyCortex.DAY_IN_SECONDS / 2
	local HALF_FACING_X_IN_SECONDS = SkyCortex.FACING_X_IN_SECONDS / 2

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

function SkyCortex:getSunAlpha(seconds)
	local delta = seconds / SkyCortex.DAY_IN_SECONDS

	if delta > 0.5 then
		return 0
	else
		return math.min(math.sin(delta / 0.5 * math.pi) * 5, 1)
	end
end

function SkyCortex:getMoonRotation(seconds)
	local delta = seconds / (SkyCortex.DAY_IN_SECONDS / 2)

	return Quaternion.fromAxisAngle(Vector.UNIT_Y, delta * math.pi * 2):getNormal()
end

function SkyCortex:getSunNormal(seconds)
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

function SkyCortex:getSkyColorIndexDelta(seconds, numColors)
	local width = 1 / numColors
	local delta = ((seconds / SkyCortex.DAY_IN_SECONDS) % width) / width
	local mu = math.clamp(math.sin(delta * (math.pi / 2)) * 5)

	local currentIndex = math.floor(seconds / (SkyCortex.DAY_IN_SECONDS / numColors)) + 1

	local nextIndex = currentIndex + 1
	if nextIndex > numColors then
		nextIndex = 1
	end

	return currentIndex, nextIndex, mu
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
				local minY = sky.troposphereEnd / 3
				local maxY = sky.troposphereEnd

				for i = #currentClouds + 1, minClouds do
					local x, z
					if #currentClouds == 0 then
						x = love.math.random(1, map:getWidth() * map:getCellSize())
						z = love.math.random(1, map:getHeight() * map:getCellSize())
					else
						local direction = -sky.windDirection

						if math.abs(direction.x) > 0 then
							local centerX = math.sign(direction.x) * map:getWidth() / 2 * map:getCellSize()
							local centerOffset = math.sqrt(math.max(map:getWidth(), map:getHeight()) * map:getCellSize() / 2)
							x = centerX + math.sign(direction.x) * (centerOffset + love.math.random(map:getWidth() * map:getCellSize() / 2))
						else
							x = love.math.random(1, map:getWidth() * map:getCellSize())
						end

						if math.abs(direction.z) > 0 then
							local centerZ = math.sign(direction.z) * map:getHeight() / 2 * map:getCellSize()
							local centerOffset = math.sqrt(math.max(map:getWidth(), map:getHeight()) * map:getCellSize() / 2)
							z = centerZ + math.sign(direction.z) * (centerOffset + love.math.random(map:getWidth() * map:getCellSize() / 2))
						else
							z = love.math.random(1, map:getHeight() * map:getCellSize())
						end
					end

					local yDelta = math.clamp(z / (map:getHeight() * map:getCellSize()))
					local y = math.sin(yDelta * math.pi) * (maxY - minY) + minY

					Utility.spawnPropAtPosition(peep, sky.cloudPropType, x, y, z, map:getCellSize())
				end
			end

			local instance = Utility.Peep.getInstance(peep)
			local seconds = self:updateSeconds(delta, sky, instance)

			local baseLayer = instance:getBaseLayer()

			local sun = self:getDirector():probe(
				peep:getLayerName(),
				Probe.layer(layer),
				Probe.resource("Prop", sky.sunPropType))[1]

			local moon = self:getDirector():probe(
				peep:getLayerName(),
				Probe.layer(layer),
				Probe.resource("Prop", sky.moonPropType))[1]

			if not sun or not moon then
				if not sun then
					Utility.spawnPropAtPosition(peep, sky.sunPropType, 0, 0, 0)
				end

				if not moon then
					Utility.spawnPropAtPosition(peep, sky.moonPropType, 0, 0, 0)
				end
			else
				local normal = self:getSunNormal(seconds)
				local alpha = self:getSunAlpha(seconds)
				local rotation = self:getMoonRotation(seconds)

				sky.sunNormal = normal
				sky.sunAlpha = alpha
				sky.moonNormal = -normal
				sky.moonAlpha = 1.0 - alpha

				local sunPosition = normal * sky.sunDistance + Vector(map:getWidth() * map:getCellSize() / 2, 0, 0)
				local moonPosition = -normal * sky.moonDistance + Vector(map:getWidth() * map:getCellSize() / 2, 0, 0)
				sky.sunPosition = sunPosition
				sky.moonPosition = moonPosition

				local moonRotation = (sky.moonRotation * rotation):getNormal()

				Utility.Peep.setPosition(sun, sunPosition)
				Utility.Peep.setPosition(moon, moonPosition)
				Utility.Peep.setRotation(moon, moonRotation)
			end

			do
				local previousSkyColors = {
					sky.nightSkyColor,
					sky.daySkyColor,
					sky.daySkyColor,
					sky.daySkyColor,
					sky.daySkyColor,
					sky.daySkyColor,
					sky.nightSkyColor,
					sky.nightSkyColor,
					sky.nightSkyColor,
					sky.nightSkyColor
				}

				local currentSkyColors = {
					sky.dawnSkyColor,
					sky.dawnSkyColor,
					sky.daySkyColor,
					sky.daySkyColor,
					sky.daySkyColor,
					sky.duskSkyColor,
					sky.duskSkyColor,
					sky.nightSkyColor,
					sky.nightSkyColor,
					sky.nightSkyColor
				}

				local ambientColors = {
					sky.dawnAmbientColor,
					sky.dawnAmbientColor,
					sky.dayAmbientColor,
					sky.dayAmbientColor,
					sky.dayAmbientColor,
					sky.duskAmbientColor,
					sky.duskAmbientColor,
					sky.nightAmbientColor,
					sky.nightAmbientColor,
					sky.nightAmbientColor
				}

				local currentIndex, nextIndex, delta = self:getSkyColorIndexDelta(seconds, #currentSkyColors)
				local currentSkyColor = currentSkyColors[currentIndex]:lerp(currentSkyColors[nextIndex], delta)
				local previousSkyColor = previousSkyColors[currentIndex]:lerp(previousSkyColors[nextIndex], delta)
				local ambientColor = ambientColors[currentIndex]:lerp(ambientColors[nextIndex], delta)

				sky.currentSkyColor = currentSkyColor
				sky.previousSkyColor = previousSkyColor
				sky.currentAmbientColor = ambientColor
			end

			local fog = self:getDirector():probe(
				peep:getLayerName(),
				Probe.layer(baseLayer),
				Probe.namedMapObject("Light_Fog"),
				Probe.resource("Prop", "Fog_Default"))[1]
			if fog then
				fog:setColor(sky.currentSkyColor)
			end

			local ambient = self:getDirector():probe(
				peep:getLayerName(),
				Probe.layer(baseLayer),
				Probe.namedMapObject("Light_Ambient"),
				Probe.resource("Prop", "AmbientLight_Default"))[1]
			if ambient then
				ambient:setColor(sky.currentAmbientColor)
				ambient:setAmbience(sky.currentAmbientColor.a)
			end

			local sunDirectionalLight = self:getDirector():probe(
				peep:getLayerName(),
				Probe.layer(baseLayer),
				Probe.namedMapObject("Light_Sun"),
				Probe.resource("Prop", "DirectionalLight_Default"))[1]

			if sunDirectionalLight then
				local normal = self:getDirectionLightNormal(seconds)
				sunDirectionalLight:setColor(Color(sky.currentAmbientColor.a))
				sunDirectionalLight:setDirection(normal)
				sunDirectionalLight:setCastsShadows(true)
			end

			local skyAmbientLight = self:getDirector():probe(
				peep:getLayerName(),
				Probe.layer(layer),
				Probe.resource("Prop", "AmbientLight_Default"))[1]
			
			if not skyAmbientLight then
				Utility.spawnPropAtPosition(peep, "AmbientLight_Default", 0, 0, 0)
			else
				skyAmbientLight:setColor(sky.currentAmbientColor)
				skyAmbientLight:setAmbience(sky.currentAmbientColor.a)
			end
		end
	end
end

return SkyCortex
