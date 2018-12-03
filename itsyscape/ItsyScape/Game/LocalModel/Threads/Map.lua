--------------------------------------------------------------------------------
-- ItsyScape/Game/LocalModel/Threads/Map.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Ray = require "ItsyScape.Common.Math.Ray"
local Vector = require "ItsyScape.Common.Math.Vector"
local Map = require "ItsyScape.World.Map"

local MAPS = {}

local m
repeat
	m = love.thread.getChannel('ItsyScape.Map::input'):demand()
	if m.type == 'load' then
		MAPS[m.key] = Map.loadFromString(m.data)
	elseif m.type == 'unload' then
		MAPS[m.key] = nil
	elseif m.type == 'probe' then
		local map = MAPS[m.key]
		if not map then
			love.thread.getChannel('ItsyScape.Map::output'):push({
				type = 'probe',
				id = m.id,
				tiles = {}
			})
		else
			local ray = Ray(Vector(unpack(m.origin)), Vector(unpack(m.direction)))
			local tiles = map:testRay(ray)
			local result = {}
			for i = 1, #tiles do
				local tile = tiles[i]
				local tileI = tile[Map.RAY_TEST_RESULT_I]
				local tileJ = tile[Map.RAY_TEST_RESULT_J]
				local position = tile[Map.RAY_TEST_RESULT_POSITION]

				table.insert(result, {
					i = tileI,
					j = tileJ,
					position = { position.x, position.y, position.z }
				})
			end

			love.thread.getChannel('ItsyScape.Map::output'):push({
				type = 'probe',
				id = m.id,
				tiles = result
			})
		end
	end
until m.type == 'quit'
