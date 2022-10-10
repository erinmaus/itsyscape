--------------------------------------------------------------------------------
-- ItsyScape/Game/Skills/Antilogika/CreepConstructor.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Constructor = require "ItsyScape.Game.Skills.Antilogika.Constructor"
local NVoronoiPointsBuffer = require "nbunny.world.voronoipointsbuffer"
local NVoronoiDiagram = require "nbunny.world.voronoidiagram"

local CreepConstructor = Class(Constructor)
CreepConstructor.DEFAULT_CONFIG = {
	min = 20,
	max = 40,
	actors = {
	},
	relaxIterations = 5
}

function CreepConstructor:place(map, mapScript)
	local rng = self:getRNG()
	local config = self:getConfig()
	local numActors = rng:random(
		config.min or CreepConstructor.DEFAULT_CONFIG.min,
		config.max or CreepConstructor.DEFAULT_CONFIG.max)

	local points = NVoronoiPointsBuffer(numActors)
	for index = 1, numActors do
		local i = rng:random(1, map:getWidth())
		local j = rng:random(2, map:getHeight())

		points:set(index - 1, i, j)
	end

	for i = 1, config.relaxIterations or CreepConstructor.DEFAULT_CONFIG.relaxIterations do
		local diagram = NVoronoiDiagram(points)
		points = diagram:relax()
	end

	for index = 1, numActors do
		local i, j = points:get(index - 1)
		local tile = map:getTile(i, j)

		if i >= 1 and i <= map:getWidth() and
		   j >= 1 and j <= map:getHeight() and
		   tile:getIsPassable({ "impassable", "door", "blocking", "building" })
		then
			local position = map:getTileCenter(i, j)
			self:placeActor(map, mapScript, position, config.actors or CreepConstructor.DEFAULT_CONFIG.actors)
		end
	end
end

return CreepConstructor
