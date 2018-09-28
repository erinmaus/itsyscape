--------------------------------------------------------------------------------
-- Resources/Peeps/Player/One.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local GroundInventoryProvider = require "ItsyScape.Game.GroundInventoryProvider"
local Peep = require "ItsyScape.Peep.Peep"
local InventoryBehavior = require "ItsyScape.Peep.Behaviors.InventoryBehavior"
local PositionBehavior = require "ItsyScape.Peep.Behaviors.PositionBehavior"

local Ground = Class(Peep)

function Ground:new(...)
	Peep.new(self, 'Ground', ...)

	self:addBehavior(InventoryBehavior)
	self:addBehavior(PositionBehavior)

	local inventory = self:getBehavior(InventoryBehavior)
	inventory.inventory = GroundInventoryProvider(self)
end

function Ground:assign(director, key)
	Peep.assign(self, director, key)

	local inventory = self:getBehavior(InventoryBehavior)
	director:getItemBroker():addProvider(inventory.inventory)
end

return Ground
