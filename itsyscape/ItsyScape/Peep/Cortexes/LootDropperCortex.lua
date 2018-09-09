--------------------------------------------------------------------------------
-- ItsyScape/Peep/Cortexes/LootDropperCortex.lua
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
local LootDropperBehavior = require "ItsyScape.Peep.Behaviors.LootDropperBehavior"
local MapObjectBehavior = require "ItsyScape.Peep.Behaviors.MapObjectBehavior"
local MappResourceBehavior = require "ItsyScape.Peep.Behaviors.MappResourceBehavior"

local LootDropperCortex = Class(Cortex)

function LootDropperCortex:new()
	Cortex.new(self)

	self:require(LootDropperBehavior)
end

function LootDropperCortex:addPeep(peep)
	Cortex.addPeep(self, peep)

	peep:listen('die', self.onDie, self)
end

function LootDropperCortex:removePeep(peep)
	Cortex.removePeep(self, peep)

	peep:silence('die', self.onDie)
end

function LootDropperCortex:onDie(peep, p)
	local mapObject = peep:getBehavior(MapObjectBehavior)
	local resource = peep:getBehavior(MappResourceBehavior)

	if not mapObject or
	   not mapObject.mapObject or
	   not self:tryDrop(mapObject.mapObject)
	then
		if resource and resource.resource then
			self:tryDrop(peep, resource.resource)
		end
	end
end

function LootDropperCortex:tryDrop(peep, resource)
	if resource then
		local dropCount = 0

		local game = self:getDirector():getGameInstance()
		local actions = Utility.getActions(game, resource)

		for _, action in ipairs(actions) do
			if action.instance:is("Loot") then
				action.instance:perform(peep:getState(), peep)
				dropCount = dropCount + 1
			end
		end

		return dropCount > 0
	end

	return false
end

return LootDropperCortex
