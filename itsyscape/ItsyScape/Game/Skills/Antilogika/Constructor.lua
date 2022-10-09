--------------------------------------------------------------------------------
-- ItsyScape/Game/Skills/Antilogika/Constructor.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Utility = require "ItsyScape.Game.Utility"

local Constructor = Class()
Constructor.DEFAULT_CONFIG = {}

function Constructor:new(cell, config)
	self.cell = cell
	self.config = config or self.DEFAULT_CONFIG
end

function Constructor:getCell()
	return self.cell
end

function Constructor:getConfig()
	return self.config
end

function Constructor:getRNG()
	return self.cell:getRNG()
end

function Constructor:choose(values)
	local rng = self:getRNG()

	local maxWeight = 0
	for i = 1, #values do
		maxWeight = maxWeight + values[i].weight
	end

	local value = values[1]
	local currentWeight = 0
	if value then
		currentWeight = value.weight
	end

	local roll = rng:random(0, maxWeight)
	for i = 2, #values do
		if currentWeight > roll then
			break
		end

		value = values[i]
		currentWeight = currentWeight + value.weight
	end

	return value
end

function Constructor:placeProp(map, mapScript, position, props)
	local prop = self:choose(props)

	if prop then
		Utility.spawnPropAtPosition(
			mapScript,
			prop.resource,
			position.x,
			position.y,
			position.z,
			0)
	end
end

function Constructor:place(map, mapScript)
	-- Nothing.
end

return Constructor
