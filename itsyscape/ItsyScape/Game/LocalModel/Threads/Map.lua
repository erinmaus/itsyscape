--------------------------------------------------------------------------------
-- ItsyScape/Game/LocalModel/Threads/Map.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
require "bootstrap"

local buffer = require "string.buffer"
local Ray = require "ItsyScape.Common.Math.Ray"
local Vector = require "ItsyScape.Common.Math.Vector"
local Map = require "ItsyScape.World.Map"
local MapCurve = require "ItsyScape.World.MapCurve"
local NMap = require "nbunny.optimaus.map"
local NMapCurve = require "nbunny.optimaus.mapcurve"
local NTransformedMap = require "nbunny.optimaus.transformedmap"

local MAPS = {}
local TRANSFORMS = {}
local CURVES = {}
local PARENTS = {}

local NBUNNY_MAPS = {}
local TRANSFORMED_MAPS = {}

local m
repeat
	m = love.thread.getChannel("ItsyScape.Map::input"):demand()
	if m.type == "load" then
		local map = Map.loadFromTable(buffer.decode(m.data))

		MAPS[m.key] = map

		local nbunnyMap = NMap(map:getWidth(), map:getHeight(), map:getCellSize())
		nbunnyMap:update(map)

		NBUNNY_MAPS[m.key] = nbunnyMap
		TRANSFORMED_MAPS[m.key] = nil
	elseif m.type == "unload" then
		MAPS[m.key] = nil
		TRANSFORMS[m.key] = nil
		PARENTS[m.key] = nil
		CURVES[m.key] = nil
		NBUNNY_MAPS[m.key] = nil
		TRANSFORMED_MAPS[m.key] = nil
	elseif m.type == "transform" then
		TRANSFORMS[m.key] = m.transform
		PARENTS[m.key] = m.parentKey or nil
	elseif m.type == "bend" then
		local map = MAPS[m.key]
		if map then
			if m.config then
				CURVES[m.key] = { MapCurve(map, m.config) }
			else
				CURVES[m.key] = nil
			end

			TRANSFORMED_MAPS[m.key] = nil
		end
	elseif m.type == "probe" then
		local maps
		if m.key then
			maps = { [m.key] = MAPS[m.key] }
		else
			maps = MAPS
		end

		if not next(maps) then
			love.thread.getChannel("ItsyScape.Map::output"):push({
				type = "probe",
				id = m.id,
				tiles = {}
			})
		else
			local result = {}
			for key, map in pairs(maps) do
				local transform = love.math.newTransform()

				do
					local transforms = {}

					local parent = key
					while parent do
						local otherTransform = TRANSFORMS[parent]
						if otherTransform then
							table.insert(transforms, 1, otherTransform)
						end

						parent = PARENTS[parent]
					end

					for _, otherTransform in ipairs(transforms) do
						transform = otherTransform * transform
					end
				end

				local origin = Vector(unpack(m.origin))
				local direction = Vector(unpack(m.direction))
				local ray = Ray(origin, direction):inverseTransform(transform)

				local transformedMap = TRANSFORMED_MAPS[key]
				if not transformedMap then
					local curve = CURVES[key] and NMapCurve(CURVES[key][1]:toConfig())
					transformedMap = NTransformedMap(NBUNNY_MAPS[key], curve)

					TRANSFORMED_MAPS[key] = transformedMap
				end

				local tiles = transformedMap:castRay(
					ray.origin.x, ray.origin.y, ray.origin.z,
					ray.direction.x, ray.direction.y, ray.direction.z)

				for _, tile in ipairs(tiles) do
					table.insert(result, {
						i = tile.i,
						j = tile.j,
						layer = key,
						position = { tile.x, tile.y, tile.z }
					})
				end
			end

			love.thread.getChannel("ItsyScape.Map::output"):push({
				type = "probe",
				id = m.id,
				tiles = result
			})
		end
	end
until m.type == "quit"
