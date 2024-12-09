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

local MAPS = {}
local TRANSFORMS = {}
local CURVES = {}
local PARENTS = {}

local m
repeat
	m = love.thread.getChannel("ItsyScape.Map::input"):demand()
	if m.type == "load" then
		MAPS[m.key] = Map.loadFromTable(buffer.decode(m.data))
	elseif m.type == "unload" then
		MAPS[m.key] = nil
		TRANSFORMS[m.key] = nil
		PARENTS[m.key] = nil
		CURVES[m.key] = nil
	elseif m.type == "transform" then
		TRANSFORMS[m.key] = m.transform
		PARENTS[m.key] = m.parentKey or nil
	elseif m.type == "bend" then
		local map = MAPS[m.key]
		if map then
			CURVES[m.key] = { MapCurve(map, m.config) }
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

				local ray
				do
					ray = Ray(Vector(unpack(m.origin)), Vector(unpack(m.direction)))
					local origin1 = Vector(transform:inverseTransformPoint(ray.origin:get()))
					local origin2 = Vector(transform:inverseTransformPoint((ray.origin + ray.direction):get()))
					local direction = origin2 - origin1
					ray = Ray(origin1, direction)
				end

				local tiles
				if CURVES[key] then
					tiles = map:testRayWithCurves(ray, CURVES[key])
				else
					tiles = map:testRay(ray)
				end

				for i = 1, #tiles do
					local tile = tiles[i]
					local tileI = tile[Map.RAY_TEST_RESULT_I]
					local tileJ = tile[Map.RAY_TEST_RESULT_J]
					local position = tile[Map.RAY_TEST_RESULT_POSITION]

					table.insert(result, {
						i = tileI,
						j = tileJ,
						layer = key,
						position = { position.x, position.y, position.z }
					})
				end
			end

			print(">>> hits", Log.dump(result))

			love.thread.getChannel("ItsyScape.Map::output"):push({
				type = "probe",
				id = m.id,
				tiles = result
			})
		end
	end
until m.type == "quit"
