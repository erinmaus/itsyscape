--------------------------------------------------------------------------------
-- ItsyScape/Game/Skills/Antilogika/PropConstructor.lua
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

local PropConstructor = Class(Constructor)
PropConstructor.DEFAULT_CONFIG = {
	min = 20,
	max = 40,
	props = {
		{
			resource = "CommonTree_Default",
			weight = 1000
		}
	},
	relaxIterations = 5
}

function PropConstructor:place(map, mapScript)
	local rng = self:getRNG()
	local config = self:getConfig()
	local numProps = rng:random(
		config.min or PropConstructor.DEFAULT_CONFIG.min,
		config.max or PropConstructor.DEFAULT_CONFIG.max)

	local points = NVoronoiPointsBuffer(numProps)
	for treeIndex = 1, numProps do
		local i = rng:random(1, map:getWidth())
		local j = rng:random(2, map:getHeight())

		points:set(treeIndex - 1, i, j)
	end

	for i = 1, config.relaxIterations or PropConstructor.DEFAULT_CONFIG.relaxIterations do
		local diagram = NVoronoiDiagram(points)
		points = diagram:relax()
	end

	for treeIndex = 1, numProps do
		local i, j = points:get(treeIndex - 1)

		if i >= 1 and i <= map:getWidth() and
		   j >= 1 and j <= map:getHeight()
		then
			local position = map:getTileCenter(i, j)
			self:placeProp(map, mapScript, position, config.props or PropConstructor.DEFAULT_CONFIG.props)
		end
	end
end

return PropConstructor
