--------------------------------------------------------------------------------
-- ItsyScape/Game/PlayerEquipmentStateProvider.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local State = require "ItsyScape.Game.State"
local StateProvider = require "ItsyScape.Game.StateProvider"
local EquipmentBehavior = require "ItsyScape.Peep.Behaviors.EquipmentBehavior"

local PlayerEquipmentStateProvider = Class(StateProvider)

function PlayerEquipmentStateProvider:new(peep)
	local inventory = peep:getBehavior(EquipmentBehavior)
	if equipment and equipment.equipment then
		self.inventory = equipment.equipment
	else
		self.inventory = false
	end

	self.peep = peep
end

function PlayerEquipmentStateProvider:getPriority()
	return State.PRIORITY_IMMEDIATE
end

function PlayerEquipmentStateProvider:has(name, count, flags)
	return count <= self:count(name, flags)
end

function PlayerEquipmentStateProvider:take(name, count, flags)
	return false
end

function PlayerEquipmentStateProvider:give(name, count, flags)
	return false
end

function PlayerEquipmentStateProvider:count(name, flags)
	if not self.inventory then
		return 0
	end

	if not flags['item-equipment'] then
		return 0
	end

	local broker = self.inventory:getBroker()
	local c = 0
	for item in broker:iterateItems(self.inventory) do
		if item:getID() == name and item:isNoted() == false then
			c = c + item:getCount()
		end
	end

	return c
end

return PlayerEquipmentStateProvider
